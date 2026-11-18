USE `StudioLemlichDB`;

-- -----------------------------------------------------
-- 1. ROL
-- -----------------------------------------------------
INSERT INTO `ROL` (`idROL`, `nombre`, `descripcion`) VALUES
(1, 'Admin', 'Control total del sistema'),
(2, 'Cliente', 'Comprador de la tienda');

-- -----------------------------------------------------
-- 2. ARTESANA
-- -----------------------------------------------------
INSERT INTO `ARTESANA` (`idARTESANA`, `nombre_completo`, `biografia_corta`) VALUES
(1, 'María Cifuentes', 'Tejedora en telar tradicional'),
(2, 'Rosa Gómez', 'Especialista en bordados ancestrales'),
(3, 'Luz Tapia', 'Maestra en cestería natural'),
(4, 'Carmen Díaz', 'Elaboración de ruanas en lana virgen'),
(5, 'Ana Mosquera', 'Orfebrería textil y tejidos Wayuu');

-- -----------------------------------------------------
-- 3. USUARIO (nombre + apellido separados)
-- -----------------------------------------------------
INSERT INTO `USUARIO` (`idUSUARIO`, `nombre`, `apellido`, `email`, `contraseña`, `activo`, `telefono`, `ROL_idROL`) VALUES
(1, 'Admin', 'Lemlich', 'admin@mail.com', '$2y$10$e0MYzXyjpJS7PD4m4vK6UeJ5qZ8rN3wX1yA2bC3dE4fG5hI6jK7lM8nO9pQ0', 'Activo', '3001234567', 1),
(2, 'Valentina', 'Ruiz', 'valeria@mail.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Activo', '3109876543', 2),
(3, 'Carlos', 'Pérez', 'carlos@mail.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Activo', '3204567890', 2),
(4, 'Sofía', 'Martínez', 'sofia@mail.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Activo', '3157891234', 2),
(5, 'Mateo', 'Henao', 'mateo@mail.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Activo', '3112345678', 2),
(6, 'Lucía', 'Fernández', 'lucia@mail.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Inactivo', '3189876543', 2);

-- -----------------------------------------------------
-- 4. CATEGORIA
-- -----------------------------------------------------
INSERT INTO `CATEGORIA` (`idCATEGORIA`, `nombre`, `descripcion`, `activo`) VALUES
(1, 'Loungewear', 'Ropa cómoda para el hogar', 'Si'),
(2, 'Utensilios', 'Accesorios y utensilios para el hogar', 'Si'),
(3, 'Ruanas', 'Abrigos y ruanas de lana natural', 'Si'),
(4, 'Accesorios', 'Bolsos, mochilas y carteras artesanales', 'Si');

-- -----------------------------------------------------
-- 5. PRODUCTO
-- -----------------------------------------------------
INSERT INTO `PRODUCTO` (`idPRODUCTO`, `nombre_producto`, `descripcion`, `precio_base`, `activo`, `CATEGORIA_idCATEGORIA`, `ARTESANA_idARTESANA`) VALUES
(1, 'Kimono Artesanal', 'Kimono en algodón orgánico tejido a mano', 180000, 'Si', 1, 1),
(2, 'Camino de Mesa', 'Camino de mesa con bordado ancestral', 95000, 'Si', 2, 2),
(3, 'Cesta Palma', 'Cesta elaborada en palma de iraca', 120000, 'Si', 2, 3),
(4, 'Ruana Boyacense', 'Ruana tradicional en lana virgen', 250000, 'Si', 3, 4),
(5, 'Mochila Wayuu', 'Mochila con diseños geométricos Wayuu', 140000, 'Si', 4, 5),
(6, 'Pantalón Lino', 'Pantalón fresco elaborado en lino natural', 160000, 'Si', 1, 1);

-- -----------------------------------------------------
-- 6. VARIANTE_PRODUCTO (talla ahora es texto)
-- -----------------------------------------------------
INSERT INTO `VARIANTE_PRODUCTO` (`idVARIANTE_PRODUCTO`, `talla`, `stock`, `PRODUCTO_idPRODUCTO`) VALUES
(1, 'S', 8, 1),
(2, 'M', 12, 1),
(3, 'Única', 15, 2),
(4, 'Única', 6, 3),
(5, 'Única', 5, 4),
(6, 'Única', 10, 5),
(7, 'M', 7, 6),
(8, 'L', 9, 6);

-- -----------------------------------------------------
-- 7. DIRECCION
-- -----------------------------------------------------
INSERT INTO `DIRECCION` (`idDIRECCION`, `calle`, `ciudad`, `barrio`, `codigo_postal`, `telefono_contacto`, `USUARIO_idUSUARIO`) VALUES
(1, 'Calle 100 # 15-20', 'Bogotá', 'Chicó', '110111', '3109876543', 2),
(2, 'Carrera 43A # 1-50', 'Medellín', 'El Poblado', '050021', '3204567890', 3),
(3, 'Calle 5 # 38-12', 'Cali', 'San Fernando', '760042', '3157891234', 4),
(4, 'Transversal 70 # 22-15', 'Bogotá', 'Modelia', '110931', '3112345678', 5),
(5, 'Calle 85 # 11-48', 'Bogotá', 'Country', '110221', '3001234567', 1),
(6, 'Av Circunvalar # 8-30', 'Pereira', 'Álamos', '660003', '3189876543', 6);

-- -----------------------------------------------------
-- 8. PEDIDO (columna corregida: USUARIO_idUSUARIO)
-- -----------------------------------------------------
INSERT INTO `PEDIDO` (`idPEDIDO`, `fecha_pedido`, `estado`, `subtotal`, `costo_envio`, `observaciones`, `USUARIO_idUSUARIO`, `DIRECCION_idDIRECCION`) VALUES
(1, '2026-05-10', 'Entregado', 180000, 10000, 'Dejar en portería', 2, 1),
(2, '2026-05-12', 'Enviado', 250000, 15000, 'Llamar antes de entregar', 3, 2),
(3, '2026-05-14', 'Pagado', 215000, 10000, 'Empaque para regalo', 4, 3),
(4, '2026-05-15', 'Pendiente', 140000, 10000, 'Ninguna', 5, 4),
(5, '2026-05-16', 'Entregado', 95000, 8000, 'Horario de oficina', 2, 1);

-- -----------------------------------------------------
-- 9. DETALLE_PEDIDO
-- -----------------------------------------------------
INSERT INTO `DETALLE_PEDIDO` (`idDETALLE_PEDIDO`, `cantidad`, `precio_unitario`, `PEDIDO_idPEDIDO`, `VARIANTE_PRODUCTO_idVARIANTE_PRODUCTO`) VALUES
(1, 1, 180000, 1, 2),
(2, 1, 250000, 2, 5),
(3, 1, 120000, 3, 4),
(4, 1, 95000, 3, 3),
(5, 1, 140000, 4, 6),
(6, 1, 95000, 5, 3);

-- -----------------------------------------------------
-- 10. ORDEN_SERVICIO (sin USUARIO_ROL_idROL)
-- -----------------------------------------------------
INSERT INTO `ORDEN_SERVICIO` (`idORDEN_SERVICIO`, `descripcion_prenda`, `fecha_solicitud`, `fecha_entrega_pactada`, `estado`, `USUARIO_idUSUARIO`) VALUES
(1, 'Ajuste de vestido en lino', '2026-05-01', '2026-05-08', 'Entregada', 2),
(2, 'Confección de gabardina', '2026-05-10', '2026-05-25', 'En proceso', 3),
(3, 'Reparación de chaqueta', '2026-05-15', '2026-05-22', 'Recibida', 4);

-- -----------------------------------------------------
-- 11. TIPO_SERVICIO
-- -----------------------------------------------------
INSERT INTO `TIPO_SERVICIO` (`idTIPO_SERVICIO`, `nombre_servicio`, `descripcion`, `precio_base`, `ORDEN_SERVICIO_idORDEN_SERVICIO`) VALUES
(1, 'Entallado', 'Ajuste de medidas de la prenda', 45000, 1),
(2, 'Confección', 'Diseño y confección desde cero', 220000, 2),
(3, 'Restauración', 'Reparación de bordados y tejidos', 60000, 3);

-- -----------------------------------------------------
-- 12. PAGO
-- -----------------------------------------------------
INSERT INTO `PAGO` (`idPAGO`, `monto`, `fecha_pago`, `estado`, `referencia_externa`, `metodo_pago`, `PEDIDO_idPEDIDO`) VALUES
(1, 190000, '2026-05-10', 'Completado', 'NEQ-839201', 'Nequi', 1),
(2, 265000, '2026-05-12', 'Completado', 'WCC-994821', 'Visa', 2),
(3, 225000, '2026-05-14', 'Completado', 'DAV-119283', 'Daviplata', 3),
(4, 150000, '2026-05-15', 'Pendiente', 'PSE-554129', 'PSE', 4),
(5, 103000, '2026-05-16', 'Completado', 'NEQ-773829', 'Nequi', 5);

-- -----------------------------------------------------
-- 13. Favoritos (sin nom_producto_añadido)
-- -----------------------------------------------------
INSERT INTO `Favoritos` (`idFavoritos`, `fecha_agregado`, `USUARIO_idUSUARIO`, `PRODUCTO_idPRODUCTO`) VALUES
(1, '2026-05-05', 2, 1),
(2, '2026-05-06', 2, 4),
(3, '2026-05-11', 3, 5),
(4, '2026-05-12', 4, 2),
(5, '2026-05-15', 5, 3);
