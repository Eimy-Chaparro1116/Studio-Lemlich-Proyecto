SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema StudioLemlichDB
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `StudioLemlichDB` DEFAULT CHARACTER SET utf8mb4;
USE `StudioLemlichDB`;

-- -----------------------------------------------------
-- Table ROL
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ROL` (
  `idROL` INT NOT NULL,
  `nombre` VARCHAR(45) NOT NULL,
  `descripcion` VARCHAR(100) NULL,
  PRIMARY KEY (`idROL`)
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table ARTESANA
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ARTESANA` (
  `idARTESANA` INT NOT NULL,
  `nombre_completo` VARCHAR(100) NOT NULL,
  `biografia_corta` VARCHAR(255) NULL,
  PRIMARY KEY (`idARTESANA`)
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table USUARIO (Normalizada)
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `USUARIO` (
  `idUSUARIO` INT NOT NULL,
  `nombre` VARCHAR(50) NOT NULL,
  `apellido` VARCHAR(50) NOT NULL,
  `email` VARCHAR(100) NOT NULL,
  `contraseña` VARCHAR(255) NOT NULL COMMENT 'Contraseña hasheada (bcrypt/argon2)',
  `activo` VARCHAR(15) NOT NULL DEFAULT 'Activo',
  `telefono` VARCHAR(20) NULL,
  `ROL_idROL` INT NOT NULL,
  PRIMARY KEY (`idUSUARIO`),
  UNIQUE INDEX `email_UNIQUE` (`email` ASC),
  INDEX `fk_USUARIO_ROL_idx` (`ROL_idROL` ASC),
  CONSTRAINT `fk_USUARIO_ROL`
    FOREIGN KEY (`ROL_idROL`)
    REFERENCES `ROL` (`idROL`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table CATEGORIA
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CATEGORIA` (
  `idCATEGORIA` INT NOT NULL,
  `nombre` VARCHAR(50) NOT NULL,
  `descripcion` VARCHAR(150) NULL,
  `activo` VARCHAR(10) NOT NULL DEFAULT 'Si',
  PRIMARY KEY (`idCATEGORIA`)
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table PRODUCTO
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `PRODUCTO` (
  `idPRODUCTO` INT NOT NULL,
  `nombre_producto` VARCHAR(100) NOT NULL,
  `descripcion` VARCHAR(255) NULL,
  `precio_base` INT NOT NULL,
  `activo` VARCHAR(10) NOT NULL DEFAULT 'Si',
  `CATEGORIA_idCATEGORIA` INT NOT NULL,
  `ARTESANA_idARTESANA` INT NOT NULL,
  PRIMARY KEY (`idPRODUCTO`),
  INDEX `fk_PRODUCTO_CATEGORIA_idx` (`CATEGORIA_idCATEGORIA` ASC),
  INDEX `fk_PRODUCTO_ARTESANA_idx` (`ARTESANA_idARTESANA` ASC),
  CONSTRAINT `fk_PRODUCTO_CATEGORIA`
    FOREIGN KEY (`CATEGORIA_idCATEGORIA`)
    REFERENCES `CATEGORIA` (`idCATEGORIA`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_PRODUCTO_ARTESANA`
    FOREIGN KEY (`ARTESANA_idARTESANA`)
    REFERENCES `ARTESANA` (`idARTESANA`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table VARIANTE_PRODUCTO
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `VARIANTE_PRODUCTO` (
  `idVARIANTE_PRODUCTO` INT NOT NULL,
  `talla` VARCHAR(10) NOT NULL COMMENT 'S, M, L, XL, Única...',
  `stock` INT NOT NULL DEFAULT 0,
  `PRODUCTO_idPRODUCTO` INT NOT NULL,
  PRIMARY KEY (`idVARIANTE_PRODUCTO`),
  INDEX `fk_VARIANTE_PRODUCTO_PRODUCTO_idx` (`PRODUCTO_idPRODUCTO` ASC),
  CONSTRAINT `fk_VARIANTE_PRODUCTO_PRODUCTO`
    FOREIGN KEY (`PRODUCTO_idPRODUCTO`)
    REFERENCES `PRODUCTO` (`idPRODUCTO`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table DIRECCION
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `DIRECCION` (
  `idDIRECCION` INT NOT NULL,
  `calle` VARCHAR(100) NOT NULL,
  `ciudad` VARCHAR(50) NOT NULL,
  `barrio` VARCHAR(50) NULL,
  `codigo_postal` VARCHAR(20) NULL,
  `telefono_contacto` VARCHAR(20) NULL,
  `USUARIO_idUSUARIO` INT NOT NULL,
  PRIMARY KEY (`idDIRECCION`),
  INDEX `fk_DIRECCION_USUARIO_idx` (`USUARIO_idUSUARIO` ASC),
  CONSTRAINT `fk_DIRECCION_USUARIO`
    FOREIGN KEY (`USUARIO_idUSUARIO`)
    REFERENCES `USUARIO` (`idUSUARIO`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table PEDIDO (columna corregida)
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `PEDIDO` (
  `idPEDIDO` INT NOT NULL,
  `fecha_pedido` DATE NOT NULL,
  `estado` VARCHAR(30) NOT NULL,
  `subtotal` INT NOT NULL,
  `costo_envio` INT NOT NULL DEFAULT 0,
  `observaciones` VARCHAR(255) NULL,
  `USUARIO_idUSUARIO` INT NOT NULL,
  `DIRECCION_idDIRECCION` INT NOT NULL,
  PRIMARY KEY (`idPEDIDO`),
  INDEX `fk_PEDIDO_USUARIO_idx` (`USUARIO_idUSUARIO` ASC),
  INDEX `fk_PEDIDO_DIRECCION_idx` (`DIRECCION_idDIRECCION` ASC),
  CONSTRAINT `fk_PEDIDO_USUARIO`
    FOREIGN KEY (`USUARIO_idUSUARIO`)
    REFERENCES `USUARIO` (`idUSUARIO`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_PEDIDO_DIRECCION`
    FOREIGN KEY (`DIRECCION_idDIRECCION`)
    REFERENCES `DIRECCION` (`idDIRECCION`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table DETALLE_PEDIDO
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `DETALLE_PEDIDO` (
  `idDETALLE_PEDIDO` INT NOT NULL,
  `cantidad` INT NOT NULL,
  `precio_unitario` INT NOT NULL,
  `PEDIDO_idPEDIDO` INT NOT NULL,
  `VARIANTE_PRODUCTO_idVARIANTE_PRODUCTO` INT NOT NULL,
  PRIMARY KEY (`idDETALLE_PEDIDO`),
  INDEX `fk_DETALLE_PEDIDO_PEDIDO_idx` (`PEDIDO_idPEDIDO` ASC),
  INDEX `fk_DETALLE_PEDIDO_VARIANTE_idx` (`VARIANTE_PRODUCTO_idVARIANTE_PRODUCTO` ASC),
  CONSTRAINT `fk_DETALLE_PEDIDO_PEDIDO`
    FOREIGN KEY (`PEDIDO_idPEDIDO`)
    REFERENCES `PEDIDO` (`idPEDIDO`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_DETALLE_PEDIDO_VARIANTE`
    FOREIGN KEY (`VARIANTE_PRODUCTO_idVARIANTE_PRODUCTO`)
    REFERENCES `VARIANTE_PRODUCTO` (`idVARIANTE_PRODUCTO`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table ORDEN_SERVICIO (limpiada)
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ORDEN_SERVICIO` (
  `idORDEN_SERVICIO` INT NOT NULL,
  `descripcion_prenda` VARCHAR(150) NOT NULL,
  `fecha_solicitud` DATE NOT NULL,
  `fecha_entrega_pactada` DATE NULL,
  `estado` VARCHAR(30) NOT NULL,
  `USUARIO_idUSUARIO` INT NOT NULL,
  PRIMARY KEY (`idORDEN_SERVICIO`),
  INDEX `fk_ORDEN_SERVICIO_USUARIO_idx` (`USUARIO_idUSUARIO` ASC),
  CONSTRAINT `fk_ORDEN_SERVICIO_USUARIO`
    FOREIGN KEY (`USUARIO_idUSUARIO`)
    REFERENCES `USUARIO` (`idUSUARIO`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table TIPO_SERVICIO
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `TIPO_SERVICIO` (
  `idTIPO_SERVICIO` INT NOT NULL,
  `nombre_servicio` VARCHAR(50) NOT NULL,
  `descripcion` VARCHAR(150) NULL,
  `precio_base` INT NOT NULL,
  `ORDEN_SERVICIO_idORDEN_SERVICIO` INT NOT NULL,
  PRIMARY KEY (`idTIPO_SERVICIO`),
  INDEX `fk_TIPO_SERVICIO_ORDEN_idx` (`ORDEN_SERVICIO_idORDEN_SERVICIO` ASC),
  CONSTRAINT `fk_TIPO_SERVICIO_ORDEN`
    FOREIGN KEY (`ORDEN_SERVICIO_idORDEN_SERVICIO`)
    REFERENCES `ORDEN_SERVICIO` (`idORDEN_SERVICIO`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table PAGO
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `PAGO` (
  `idPAGO` INT NOT NULL,
  `monto` INT NOT NULL,
  `fecha_pago` DATE NOT NULL,
  `estado` VARCHAR(30) NOT NULL,
  `referencia_externa` VARCHAR(50) NULL,
  `metodo_pago` VARCHAR(30) NOT NULL,
  `PEDIDO_idPEDIDO` INT NOT NULL,
  PRIMARY KEY (`idPAGO`),
  INDEX `fk_PAGO_PEDIDO_idx` (`PEDIDO_idPEDIDO` ASC),
  CONSTRAINT `fk_PAGO_PEDIDO`
    FOREIGN KEY (`PEDIDO_idPEDIDO`)
    REFERENCES `PEDIDO` (`idPEDIDO`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table Favoritos (sin campo redundante)
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Favoritos` (
  `idFavoritos` INT NOT NULL,
  `fecha_agregado` DATE NOT NULL,
  `USUARIO_idUSUARIO` INT NOT NULL,
  `PRODUCTO_idPRODUCTO` INT NOT NULL,
  PRIMARY KEY (`idFavoritos`),
  INDEX `fk_Favoritos_USUARIO_idx` (`USUARIO_idUSUARIO` ASC),
  INDEX `fk_Favoritos_PRODUCTO_idx` (`PRODUCTO_idPRODUCTO` ASC),
  CONSTRAINT `fk_Favoritos_USUARIO`
    FOREIGN KEY (`USUARIO_idUSUARIO`)
    REFERENCES `USUARIO` (`idUSUARIO`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Favoritos_PRODUCTO`
    FOREIGN KEY (`PRODUCTO_idPRODUCTO`)
    REFERENCES `PRODUCTO` (`idPRODUCTO`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE = InnoDB;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;