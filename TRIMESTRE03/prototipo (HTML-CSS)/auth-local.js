(() => {
  const USERS_KEY = "studioLemlich:users";
  const ITERATIONS = 310000;

  function obtenerUsuarios() {
    const guardados = localStorage.getItem(USERS_KEY);
    if (!guardados) return [];

    const usuarios = JSON.parse(guardados);
    if (!Array.isArray(usuarios) || usuarios.some((usuario) =>
      !usuario || typeof usuario.email !== "string" ||
      typeof usuario.nombre !== "string" ||
      typeof usuario.salt !== "string" ||
      typeof usuario.hash !== "string"
    )) {
      throw new Error("Los datos de las cuentas guardadas no tienen un formato válido.");
    }
    return usuarios;
  }

  function asegurarCriptografia() {
    if (!window.crypto || !window.crypto.subtle) {
      throw new Error("La verificación segura no está disponible. Abre el sitio con HTTPS o localhost.");
    }
  }

  function aHexadecimal(bytes) {
    return Array.from(new Uint8Array(bytes), (byte) =>
      byte.toString(16).padStart(2, "0")
    ).join("");
  }

  function desdeHexadecimal(texto) {
    if (!/^(?:[0-9a-f]{2})+$/i.test(texto)) {
      throw new Error("Los datos de la cuenta guardada están dañados.");
    }
    return new Uint8Array(texto.match(/.{2}/g).map((byte) => parseInt(byte, 16)));
  }

  async function crearHash(clave, salt) {
    const material = await window.crypto.subtle.importKey(
      "raw",
      new TextEncoder().encode(clave),
      "PBKDF2",
      false,
      ["deriveBits"]
    );
    const hash = await window.crypto.subtle.deriveBits(
      { name: "PBKDF2", salt, iterations: ITERATIONS, hash: "SHA-256" },
      material,
      256
    );
    return aHexadecimal(hash);
  }

  async function registrar({ nombre, correo, clave }) {
    asegurarCriptografia();
    const usuarios = obtenerUsuarios();
    const email = correo.trim().toLowerCase();
    if (usuarios.some((usuario) => usuario.email === email)) {
      throw new Error("Ya existe una cuenta con ese correo.");
    }

    const salt = window.crypto.getRandomValues(new Uint8Array(16));
    usuarios.push({
      nombre: nombre.trim(),
      email,
      salt: aHexadecimal(salt),
      hash: await crearHash(clave, salt),
    });
    localStorage.setItem(USERS_KEY, JSON.stringify(usuarios));
  }

  async function iniciarSesion(correo, clave) {
    asegurarCriptografia();
    const email = correo.trim().toLowerCase();
    const usuario = obtenerUsuarios().find((item) => item.email === email);
    if (!usuario) return false;

    const hash = await crearHash(clave, desdeHexadecimal(usuario.salt));
    return hash === usuario.hash;
  }

  window.authLocal = { obtenerUsuarios, registrar, iniciarSesion };
})();