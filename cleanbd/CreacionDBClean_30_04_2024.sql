-- MySQL Script generated by MySQL Workbench
-- Tue Apr 30 15:45:55 2024
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema cleandb
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema cleandb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `cleandb` DEFAULT CHARACTER SET utf8 ;
USE `cleandb` ;

-- -----------------------------------------------------
-- Table `cleandb`.`TipoPersona`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cleandb`.`TipoPersona` (
  `IdTipoPersona` INT NOT NULL AUTO_INCREMENT,
  `Descripcion` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`IdTipoPersona`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `cleandb`.`TipoDocumentacion`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cleandb`.`TipoDocumentacion` (
  `IdTipoDocumentacion` INT NOT NULL AUTO_INCREMENT,
  `Descripcion` VARCHAR(45) NULL,
  PRIMARY KEY (`IdTipoDocumentacion`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `cleandb`.`TipoDomicilio`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cleandb`.`TipoDomicilio` (
  `IdTipoDomicilio` INT NOT NULL AUTO_INCREMENT,
  `Descripcion` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`IdTipoDomicilio`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `cleandb`.`Domicilio`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cleandb`.`Domicilio` (
  `IdDomicilio` INT NOT NULL AUTO_INCREMENT,
  `IdTipoDomicilio` INT NOT NULL,
  `Calle` VARCHAR(45) NOT NULL,
  `Nro` VARCHAR(45) NULL,
  `Piso` VARCHAR(45) NULL,
  PRIMARY KEY (`IdDomicilio`),
  INDEX `fk_Domicilio_TipoDomicilio1_idx` (`IdTipoDomicilio` ASC) VISIBLE,
  CONSTRAINT `fk_Domicilio_TipoDomicilio1`
    FOREIGN KEY (`IdTipoDomicilio`)
    REFERENCES `cleandb`.`TipoDomicilio` (`IdTipoDomicilio`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `cleandb`.`TipoPersonaSistema`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cleandb`.`TipoPersonaSistema` (
  `IdTipoPersonaSistema` INT NOT NULL AUTO_INCREMENT,
  `Descripcion` VARCHAR(45) NOT NULL,
  `FechaBaja` VARCHAR(45) NULL,
  PRIMARY KEY (`IdTipoPersonaSistema`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `cleandb`.`Provincia`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cleandb`.`Provincia` (
  `IdProvincia` INT NOT NULL AUTO_INCREMENT,
  `Detalle` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`IdProvincia`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `cleandb`.`Localidad`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cleandb`.`Localidad` (
  `IdLocalidad` INT NOT NULL AUTO_INCREMENT,
  `IdProvincia` INT NOT NULL,
  `Detalle` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`IdLocalidad`),
  INDEX `fk_Localidad_Provincia1_idx` (`IdProvincia` ASC) VISIBLE,
  CONSTRAINT `fk_Localidad_Provincia1`
    FOREIGN KEY (`IdProvincia`)
    REFERENCES `cleandb`.`Provincia` (`IdProvincia`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `cleandb`.`Persona`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cleandb`.`Persona` (
  `IdPersona` INT NOT NULL AUTO_INCREMENT,
  `IdTipoPersonaSistema` INT NOT NULL,
  `IdTipoPersona` INT NOT NULL,
  `IdDomicilio` INT NOT NULL,
  `IdLocalidad` INT NOT NULL,
  `IdTipoDocumentacion` INT NOT NULL,
  `Documentacion` VARCHAR(45) NOT NULL,
  `Nombre` VARCHAR(45) NOT NULL,
  `Apellido` VARCHAR(45) NOT NULL,
  `Mail` VARCHAR(45) NOT NULL,
  `RazonSocial` VARCHAR(45) NULL,
  `FechaNacimiento` DATE NULL,
  `Telefono` VARCHAR(45) NULL,
  `FechaAlta` DATETIME NOT NULL,
  `FechaBaja` DATETIME NULL,
  PRIMARY KEY (`IdPersona`),
  INDEX `fk_Persona_TipoPersona1_idx` (`IdTipoPersona` ASC) VISIBLE,
  INDEX `fk_Persona_TipoDocumentacion1_idx` (`IdTipoDocumentacion` ASC) VISIBLE,
  INDEX `fk_Persona_Domicilio1_idx` (`IdDomicilio` ASC) VISIBLE,
  INDEX `fk_Persona_TipoPersonaSistema1_idx` (`IdTipoPersonaSistema` ASC) VISIBLE,
  INDEX `fk_Persona_Localidad1_idx` (`IdLocalidad` ASC) VISIBLE,
  CONSTRAINT `fk_Persona_TipoPersona1`
    FOREIGN KEY (`IdTipoPersona`)
    REFERENCES `cleandb`.`TipoPersona` (`IdTipoPersona`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Persona_TipoDocumentacion1`
    FOREIGN KEY (`IdTipoDocumentacion`)
    REFERENCES `cleandb`.`TipoDocumentacion` (`IdTipoDocumentacion`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Persona_Domicilio1`
    FOREIGN KEY (`IdDomicilio`)
    REFERENCES `cleandb`.`Domicilio` (`IdDomicilio`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Persona_TipoPersonaSistema1`
    FOREIGN KEY (`IdTipoPersonaSistema`)
    REFERENCES `cleandb`.`TipoPersonaSistema` (`IdTipoPersonaSistema`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Persona_Localidad1`
    FOREIGN KEY (`IdLocalidad`)
    REFERENCES `cleandb`.`Localidad` (`IdLocalidad`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `cleandb`.`Usuario`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cleandb`.`Usuario` (
  `IdUsuario` INT NOT NULL AUTO_INCREMENT,
  `IdPersona` INT NOT NULL,
  `Usuario` VARCHAR(45) NOT NULL,
  `Clave` VARCHAR(255) NOT NULL,
  `IdUsuarioCarga` VARCHAR(45) NOT NULL,
  `FechaAlta` DATETIME NOT NULL,
  `FechaBaja` DATETIME NULL,
  PRIMARY KEY (`IdUsuario`),
  INDEX `fk_Usuario_Persona1_idx` (`IdPersona` ASC) VISIBLE,
  CONSTRAINT `fk_Usuario_Persona1`
    FOREIGN KEY (`IdPersona`)
    REFERENCES `cleandb`.`Persona` (`IdPersona`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `cleandb`.`TipoRol`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cleandb`.`TipoRol` (
  `IdTipoRol` INT NOT NULL AUTO_INCREMENT,
  `Descripcion` VARCHAR(45) NOT NULL,
  `FechaBaja` VARCHAR(45) NULL,
  PRIMARY KEY (`IdTipoRol`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `cleandb`.`TipoPermiso`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cleandb`.`TipoPermiso` (
  `IdTipoPermiso` INT NOT NULL AUTO_INCREMENT,
  `Detalle` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`IdTipoPermiso`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `cleandb`.`TipoModulo`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cleandb`.`TipoModulo` (
  `IdTipoModulo` INT NOT NULL AUTO_INCREMENT,
  `IdPadre` VARCHAR(10) NOT NULL,
  `Orden` VARCHAR(45) NOT NULL,
  `Detalle` VARCHAR(45) NOT NULL,
  `PathRout` VARCHAR(45) NOT NULL,
  `TipoMenu` INT NOT NULL,
  `TipoIcono` VARCHAR(45) NOT NULL,
  `Icono` MEDIUMBLOB NOT NULL,
  `FechaAlta` DATETIME NOT NULL,
  `FechaBaja` DATETIME NULL,
  PRIMARY KEY (`IdTipoModulo`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `cleandb`.`RolModulo`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cleandb`.`RolModulo` (
  `IdRolModulo` INT NOT NULL AUTO_INCREMENT,
  `IdTipoRol` INT NOT NULL,
  `IdTipoModulo` INT NOT NULL,
  `IdTipoPermiso` INT NOT NULL,
  `FechaBaja` VARCHAR(45) NULL,
  PRIMARY KEY (`IdRolModulo`),
  INDEX `fk_RolModulo_RolTipo1_idx` (`IdTipoRol` ASC) VISIBLE,
  INDEX `fk_RolModulo_TipoModulo1_idx` (`IdTipoModulo` ASC) VISIBLE,
  INDEX `fk_RolModulo_TipoPermiso1_idx` (`IdTipoPermiso` ASC) VISIBLE,
  CONSTRAINT `fk_RolModulo_RolTipo1`
    FOREIGN KEY (`IdTipoRol`)
    REFERENCES `cleandb`.`TipoRol` (`IdTipoRol`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_RolModulo_TipoModulo1`
    FOREIGN KEY (`IdTipoModulo`)
    REFERENCES `cleandb`.`TipoModulo` (`IdTipoModulo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_RolModulo_TipoPermiso1`
    FOREIGN KEY (`IdTipoPermiso`)
    REFERENCES `cleandb`.`TipoPermiso` (`IdTipoPermiso`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `cleandb`.`Sucursal`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cleandb`.`Sucursal` (
  `IdSucursal` INT NOT NULL,
  `IdDomicilio` INT NOT NULL,
  `Descripcion` VARCHAR(45) NOT NULL,
  `IdUsuarioCarga` INT NOT NULL,
  `FechaAlta` DATETIME NOT NULL,
  `FechaBaja` DATETIME NULL,
  PRIMARY KEY (`IdSucursal`),
  INDEX `fk_Sucursal_Usuario1_idx` (`IdUsuarioCarga` ASC) VISIBLE,
  INDEX `fk_Sucursal_Domicilio1_idx` (`IdDomicilio` ASC) VISIBLE,
  CONSTRAINT `fk_Sucursal_Usuario1`
    FOREIGN KEY (`IdUsuarioCarga`)
    REFERENCES `cleandb`.`Usuario` (`IdUsuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Sucursal_Domicilio1`
    FOREIGN KEY (`IdDomicilio`)
    REFERENCES `cleandb`.`Domicilio` (`IdDomicilio`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `cleandb`.`UsuarioPorSucursal`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cleandb`.`UsuarioPorSucursal` (
  `IdUsuarioPorSucursal` INT NOT NULL AUTO_INCREMENT,
  `IdUsuario` INT NOT NULL,
  `IdSucursal` INT NOT NULL,
  `FechaUltModificacion` DATETIME NOT NULL,
  `FechaAlta` DATETIME NOT NULL,
  `FechaBaja` DATETIME NULL,
  PRIMARY KEY (`IdUsuarioPorSucursal`),
  INDEX `fk_UsuarioPorSucursal_Usuario1_idx` (`IdUsuario` ASC) VISIBLE,
  INDEX `fk_UsuarioPorSucursal_Sucursal1_idx` (`IdSucursal` ASC) VISIBLE,
  CONSTRAINT `fk_UsuarioPorSucursal_Usuario1`
    FOREIGN KEY (`IdUsuario`)
    REFERENCES `cleandb`.`Usuario` (`IdUsuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_UsuarioPorSucursal_Sucursal1`
    FOREIGN KEY (`IdSucursal`)
    REFERENCES `cleandb`.`Sucursal` (`IdSucursal`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `cleandb`.`TipoPermisoDetalle`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cleandb`.`TipoPermisoDetalle` (
  `IdTipoPermisoDetalle` INT NOT NULL AUTO_INCREMENT,
  `IdTipoPermiso` INT NOT NULL,
  `Method` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`IdTipoPermisoDetalle`),
  INDEX `fk_TipoPermisoDetalle_TipoPermiso1_idx` (`IdTipoPermiso` ASC) VISIBLE,
  CONSTRAINT `fk_TipoPermisoDetalle_TipoPermiso1`
    FOREIGN KEY (`IdTipoPermiso`)
    REFERENCES `cleandb`.`TipoPermiso` (`IdTipoPermiso`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `cleandb`.`SistemaAPIs`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cleandb`.`SistemaAPIs` (
  `IdSistemaAPIs` INT NOT NULL AUTO_INCREMENT,
  `Detalle` VARCHAR(45) NOT NULL,
  `Method` VARCHAR(45) NOT NULL,
  `Path` VARCHAR(45) NOT NULL,
  `IdUsuarioCarga` INT NOT NULL,
  `FechaAlta` DATETIME NOT NULL,
  `FechaBaja` DATETIME NULL,
  PRIMARY KEY (`IdSistemaAPIs`),
  INDEX `fk_SistemaAPIs_Usuario1_idx` (`IdUsuarioCarga` ASC) VISIBLE,
  CONSTRAINT `fk_SistemaAPIs_Usuario1`
    FOREIGN KEY (`IdUsuarioCarga`)
    REFERENCES `cleandb`.`Usuario` (`IdUsuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `cleandb`.`SistemaModuloAPIs`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cleandb`.`SistemaModuloAPIs` (
  `IdSistemaModuloAPIs` INT NOT NULL AUTO_INCREMENT,
  `IdTipoModulo` INT NOT NULL,
  `IdSistemasAPIs` INT NOT NULL,
  `IdUsuarioCarga` INT NOT NULL,
  `FechaAlta` DATETIME NOT NULL,
  `FechaBaja` DATETIME NULL,
  PRIMARY KEY (`IdSistemaModuloAPIs`),
  INDEX `fk_SistemaModuloAPIs_TipoModulo1_idx` (`IdTipoModulo` ASC) VISIBLE,
  INDEX `fk_SistemaModuloAPIs_SistemaAPIs1_idx` (`IdSistemasAPIs` ASC) VISIBLE,
  INDEX `fk_SistemaModuloAPIs_Usuario1_idx` (`IdUsuarioCarga` ASC) VISIBLE,
  CONSTRAINT `fk_SistemaModuloAPIs_TipoModulo1`
    FOREIGN KEY (`IdTipoModulo`)
    REFERENCES `cleandb`.`TipoModulo` (`IdTipoModulo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_SistemaModuloAPIs_SistemaAPIs1`
    FOREIGN KEY (`IdSistemasAPIs`)
    REFERENCES `cleandb`.`SistemaAPIs` (`IdSistemaAPIs`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_SistemaModuloAPIs_Usuario1`
    FOREIGN KEY (`IdUsuarioCarga`)
    REFERENCES `cleandb`.`Usuario` (`IdUsuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `cleandb`.`TipoProducto`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cleandb`.`TipoProducto` (
  `IdTipoProducto` INT NOT NULL AUTO_INCREMENT,
  `Detalle` VARCHAR(45) NOT NULL,
  `FechaBaja` datetime,
  PRIMARY KEY (`IdTipoProducto`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `cleandb`.`TipoCategoria`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cleandb`.`TipoCategoria` (
  `IdTipoCategoria` INT NOT NULL AUTO_INCREMENT,
  `Descripcion` VARCHAR(255) NOT NULL,
  `FechaAlta` DATETIME NOT NULL,
  `FechaBaja` DATETIME NULL,
  PRIMARY KEY (`IdTipoCategoria`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `cleandb`.`TipoMedida`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cleandb`.`TipoMedida` (
  `IdTipoMedida` INT NOT NULL AUTO_INCREMENT,
  `Detalle` VARCHAR(45) NOT NULL,
  `Abreviatura` VARCHAR(45) NOT NULL,
  `FechaBaja` DATETIME NULL,
  PRIMARY KEY (`IdTipoMedida`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `cleandb`.`Producto`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cleandb`.`Producto` (
  `IdProducto` INT NOT NULL AUTO_INCREMENT,
  `IdTipoMedida` INT NOT NULL,
  `IdTipoCategoria` INT NOT NULL,
  `IdTipoProducto` INT NOT NULL,
  `Codigo` VARCHAR(255) NOT NULL,
  `Nombre` VARCHAR(45) NOT NULL,
  `Marca` VARCHAR(45) NOT NULL,
  `PrecioCosto` DECIMAL(18,2) NOT NULL,
  `Tamaño` DECIMAL(18,2) NOT NULL,
  `CantMinima` INT NOT NULL,
  `CantMaxima` INT NOT NULL,
  `IdUsuarioCarga` INT NOT NULL,
  `FechaAlta` DATETIME NOT NULL,
  `FechaBaja` DATETIME NULL,
  PRIMARY KEY (`IdProducto`),
  INDEX `fk_Producto_TipoCategoria1_idx` (`IdTipoCategoria` ASC) VISIBLE,
  INDEX `fk_Productos_TipoProducto1_idx` (`IdTipoProducto` ASC) VISIBLE,
  INDEX `fk_Productos_TipoMedida1_idx` (`IdTipoMedida` ASC) VISIBLE,
  INDEX `fk_Producto_Usuario1_idx` (`IdUsuarioCarga` ASC) VISIBLE,
  CONSTRAINT `fk_Producto_TipoCategoria1`
    FOREIGN KEY (`IdTipoCategoria`)
    REFERENCES `cleandb`.`TipoCategoria` (`IdTipoCategoria`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Productos_TipoProducto1`
    FOREIGN KEY (`IdTipoProducto`)
    REFERENCES `cleandb`.`TipoProducto` (`IdTipoProducto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Productos_TipoMedida1`
    FOREIGN KEY (`IdTipoMedida`)
    REFERENCES `cleandb`.`TipoMedida` (`IdTipoMedida`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Producto_Usuario1`
    FOREIGN KEY (`IdUsuarioCarga`)
    REFERENCES `cleandb`.`Usuario` (`IdUsuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `cleandb`.`StockSucursal`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cleandb`.`StockSucursal` (
  `IdStockSucursal` INT NOT NULL AUTO_INCREMENT,
  `IdProducto` INT NOT NULL,
  `IdSucursal` INT NOT NULL,
  `Cantidad` DECIMAL(18,2) NOT NULL,
  `IdUsuarioUltMod` INT NOT NULL,
  `FechaAlta` INT NOT NULL,
  `FechaUltMod` INT NOT NULL,
  `FechaBaja` INT NULL,
  PRIMARY KEY (`IdStockSucursal`),
  INDEX `fk_StockSucursales_Producto1_idx` (`IdProducto` ASC) VISIBLE,
  INDEX `fk_StockSucursales_Sucursal1_idx` (`IdSucursal` ASC) VISIBLE,
  INDEX `fk_StockSucursales_Usuario1_idx` (`IdUsuarioUltMod` ASC) VISIBLE,
  CONSTRAINT `fk_StockSucursales_Producto1`
    FOREIGN KEY (`IdProducto`)
    REFERENCES `cleandb`.`Producto` (`IdProducto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_StockSucursales_Sucursal1`
    FOREIGN KEY (`IdSucursal`)
    REFERENCES `cleandb`.`Sucursal` (`IdSucursal`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_StockSucursales_Usuario1`
    FOREIGN KEY (`IdUsuarioUltMod`)
    REFERENCES `cleandb`.`Usuario` (`IdUsuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `cleandb`.`TipoFactura`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cleandb`.`TipoFactura` (
  `IdTipoFactura` INT NOT NULL AUTO_INCREMENT,
  `Descripcion` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`IdTipoFactura`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `cleandb`.`TipoDestinatarioFactura`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cleandb`.`TipoDestinatarioFactura` (
  `IdTipoDestinatarioFactura` INT NOT NULL AUTO_INCREMENT,
  `Descripcion` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`IdTipoDestinatarioFactura`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `cleandb`.`TipoFormaDePago`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cleandb`.`TipoFormaDePago` (
  `IdTipoFormaDePago` INT NOT NULL AUTO_INCREMENT,
  `Descripcion` VARCHAR(45) NOT NULL,
  `FechaBaja` VARCHAR(45) NULL,
  PRIMARY KEY (`IdTipoFormaDePago`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `cleandb`.`Factura`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cleandb`.`Factura` (
  `IdFactura` INT NOT NULL AUTO_INCREMENT,
  `IdTipoDestinatarioFactura` INT NOT NULL,
  `IdTipoFactura` INT NOT NULL,
  `IdFormaDePago` INT NOT NULL,
  `FechaEmision` DATETIME NOT NULL,
  PRIMARY KEY (`IdFactura`),
  INDEX `fk_Facturas_TipoFactura1_idx` (`IdTipoFactura` ASC) VISIBLE,
  INDEX `fk_Facturas_TipoDestinatarioFactura1_idx` (`IdTipoDestinatarioFactura` ASC) VISIBLE,
  INDEX `fk_Facturas_FormaDePago1_idx` (`IdFormaDePago` ASC) VISIBLE,
  CONSTRAINT `fk_Facturas_TipoFactura1`
    FOREIGN KEY (`IdTipoFactura`)
    REFERENCES `cleandb`.`TipoFactura` (`IdTipoFactura`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Facturas_TipoDestinatarioFactura1`
    FOREIGN KEY (`IdTipoDestinatarioFactura`)
    REFERENCES `cleandb`.`TipoDestinatarioFactura` (`IdTipoDestinatarioFactura`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Facturas_FormaDePago1`
    FOREIGN KEY (`IdFormaDePago`)
    REFERENCES `cleandb`.`TipoFormaDePago` (`IdTipoFormaDePago`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `cleandb`.`DetalleFactura`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cleandb`.`DetalleFactura` (
  `IdDetalleFactura` INT NOT NULL AUTO_INCREMENT,
  `IdFacturas` INT NOT NULL,
  `SubTotal` DECIMAL(18,2) NOT NULL,
  `Total` DECIMAL(18,2) NOT NULL,
  `DescVenta` DECIMAL(18,2) NOT NULL,
  `IncrementoVenta` DECIMAL(18,2) NOT NULL,
  `Pago` DECIMAL(18,2) NOT NULL,
  `Vuelto` DECIMAL(18,2) NOT NULL,
  `FechaBaja` DATETIME NULL,
  PRIMARY KEY (`IdDetalleFactura`),
  INDEX `fk_DetalleFactura_Facturas1_idx` (`IdFacturas` ASC) VISIBLE,
  CONSTRAINT `fk_DetalleFactura_Facturas1`
    FOREIGN KEY (`IdFacturas`)
    REFERENCES `cleandb`.`Factura` (`IdFactura`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `cleandb`.`TipoImpuesto`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cleandb`.`TipoImpuesto` (
  `IdTipoImpuesto` INT NOT NULL AUTO_INCREMENT,
  `Detalle` VARCHAR(45) NOT NULL,
  `Porcentaje` VARCHAR(45) NOT NULL,
  `FechaBaja` VARCHAR(45) NULL,
  PRIMARY KEY (`IdTipoImpuesto`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `cleandb`.`AumentoPorProducto`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cleandb`.`AumentoPorProducto` (
  `IdAumentoPorProducto` INT NOT NULL AUTO_INCREMENT,
  `IdProducto` INT NOT NULL,
  `IdTipoImpuesto` INT NOT NULL,
  `FechaBaja` DATETIME NULL,
  PRIMARY KEY (`IdAumentoPorProducto`),
  INDEX `fk_AumentoPorProducto_Producto1_idx` (`IdProducto` ASC) VISIBLE,
  INDEX `fk_AumentoPorProducto_TipoImpuesto1_idx` (`IdTipoImpuesto` ASC) VISIBLE,
  CONSTRAINT `fk_AumentoPorProducto_Producto1`
    FOREIGN KEY (`IdProducto`)
    REFERENCES `cleandb`.`Producto` (`IdProducto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_AumentoPorProducto_TipoImpuesto1`
    FOREIGN KEY (`IdTipoImpuesto`)
    REFERENCES `cleandb`.`TipoImpuesto` (`IdTipoImpuesto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `cleandb`.`GeneradorPrecios`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cleandb`.`GeneradorPrecios` (
  `IdGeneradorPrecios` INT NOT NULL AUTO_INCREMENT,
  `IdProducto` INT NOT NULL,
  `IdAumentoPorProducto` INT NOT NULL,
  `Fecha` DATETIME NULL,
  PRIMARY KEY (`IdGeneradorPrecios`),
  INDEX `fk_GeneradorPrecios_Producto1_idx` (`IdProducto` ASC) VISIBLE,
  INDEX `fk_GeneradorPrecios_AumentoPorProducto1_idx` (`IdAumentoPorProducto` ASC) VISIBLE,
  CONSTRAINT `fk_GeneradorPrecios_Producto1`
    FOREIGN KEY (`IdProducto`)
    REFERENCES `cleandb`.`Producto` (`IdProducto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_GeneradorPrecios_AumentoPorProducto1`
    FOREIGN KEY (`IdAumentoPorProducto`)
    REFERENCES `cleandb`.`AumentoPorProducto` (`IdAumentoPorProducto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `cleandb`.`Venta`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cleandb`.`Venta` (
  `IdVenta` INT NOT NULL AUTO_INCREMENT,
  `IdDetalleFactura` INT NOT NULL,
  `IdSucursal` INT NOT NULL,
  `IdGeneradorPrecios` INT NOT NULL,
  `Fecha` DATETIME NOT NULL,
  `NroVenta` INT NOT NULL,
  `Cantidad` DECIMAL(18,2) NOT NULL,
  `IdUsuarioCarga` INT NOT NULL,
  `FechaAlta` DATETIME NOT NULL,
  `FechaBaja` DATETIME NULL,
  PRIMARY KEY (`IdVenta`),
  INDEX `fk_Ventas_DetalleFactura1_idx` (`IdDetalleFactura` ASC) VISIBLE,
  INDEX `fk_Ventas_Sucursal1_idx` (`IdSucursal` ASC) VISIBLE,
  INDEX `fk_Ventas_Usuario1_idx` (`IdUsuarioCarga` ASC) VISIBLE,
  INDEX `fk_Venta_GeneradorPrecios1_idx` (`IdGeneradorPrecios` ASC) VISIBLE,
  CONSTRAINT `fk_Ventas_DetalleFactura1`
    FOREIGN KEY (`IdDetalleFactura`)
    REFERENCES `cleandb`.`DetalleFactura` (`IdDetalleFactura`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Ventas_Sucursal1`
    FOREIGN KEY (`IdSucursal`)
    REFERENCES `cleandb`.`Sucursal` (`IdSucursal`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Ventas_Usuario1`
    FOREIGN KEY (`IdUsuarioCarga`)
    REFERENCES `cleandb`.`Usuario` (`IdUsuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Venta_GeneradorPrecios1`
    FOREIGN KEY (`IdGeneradorPrecios`)
    REFERENCES `cleandb`.`GeneradorPrecios` (`IdGeneradorPrecios`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `cleandb`.`PedidosSucursal`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cleandb`.`PedidosSucursal` (
  `IdPedidosSucursal` INT NOT NULL AUTO_INCREMENT,
  `IdUsuario` INT NOT NULL,
  `IdSucursal` INT NOT NULL,
  `Fecha` DATETIME NOT NULL,
  `CantBulto` INT NOT NULL,
  `Estado` VARCHAR(55) NOT NULL,
  `FechaEnvio` DATETIME NOT NULL,
  `FechaEntrega` DATETIME NOT NULL,
  PRIMARY KEY (`IdPedidosSucursal`),
  INDEX `fk_PedidosSucursales_Usuario1_idx` (`IdUsuario` ASC) VISIBLE,
  INDEX `fk_PedidosSucursales_Sucursal1_idx` (`IdSucursal` ASC) VISIBLE,
  CONSTRAINT `fk_PedidosSucursales_Usuario1`
    FOREIGN KEY (`IdUsuario`)
    REFERENCES `cleandb`.`Usuario` (`IdUsuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_PedidosSucursales_Sucursal1`
    FOREIGN KEY (`IdSucursal`)
    REFERENCES `cleandb`.`Sucursal` (`IdSucursal`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `cleandb`.`ProductoPorPedido`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cleandb`.`ProductoPorPedido` (
  `IdProductoPorPedido` INT NOT NULL AUTO_INCREMENT,
  `IdPedidoSucursal` INT NOT NULL,
  `IdProductos` INT NOT NULL,
  `FechaBaja` VARCHAR(45) NULL,
  PRIMARY KEY (`IdProductoPorPedido`),
  INDEX `fk_ProductosPorPedido_PedidosSucursales1_idx` (`IdPedidoSucursal` ASC) VISIBLE,
  INDEX `fk_ProductosPorPedido_Productos1_idx` (`IdProductos` ASC) VISIBLE,
  CONSTRAINT `fk_ProductosPorPedido_PedidosSucursales1`
    FOREIGN KEY (`IdPedidoSucursal`)
    REFERENCES `cleandb`.`PedidosSucursal` (`IdPedidosSucursal`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_ProductosPorPedido_Productos1`
    FOREIGN KEY (`IdProductos`)
    REFERENCES `cleandb`.`Producto` (`IdProducto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `cleandb`.`Auditoria`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cleandb`.`Auditoria` (
  `IdAuditoria` INT NOT NULL AUTO_INCREMENT,
  `IdUsuario` INT NOT NULL,
  `Fecha` DATETIME NOT NULL,
  `Tabla` VARCHAR(45) NOT NULL,
  `Campo` VARCHAR(45) NOT NULL,
  `Identificador` INT NOT NULL,
  `ValorAnterior` VARCHAR(45) NOT NULL,
  `ValorActual` VARCHAR(45) NOT NULL,
  `Tipo` VARCHAR(45) NOT NULL,
  `Pendiente` BIT NOT NULL,
  PRIMARY KEY (`IdAuditoria`),
  INDEX `fk_Auditoria_Usuario1_idx` (`IdUsuario` ASC) VISIBLE,
  CONSTRAINT `fk_Auditoria_Usuario1`
    FOREIGN KEY (`IdUsuario`)
    REFERENCES `cleandb`.`Usuario` (`IdUsuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `cleandb`.`VentaDetalle`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cleandb`.`VentaDetalle` (
  `IdVentaDetalle` INT NOT NULL AUTO_INCREMENT,
  `IdVenta` INT NOT NULL,
  `IdProductos` INT NOT NULL,
  `Cantidad` DECIMAL(18,2) NULL,
  `FechaBaja` DATETIME NULL,
  PRIMARY KEY (`IdVentaDetalle`),
  INDEX `fk_VentaDetalle_Ventas1_idx` (`IdVenta` ASC) VISIBLE,
  INDEX `fk_VentaDetalle_Productos1_idx` (`IdProductos` ASC) VISIBLE,
  CONSTRAINT `fk_VentaDetalle_Ventas1`
    FOREIGN KEY (`IdVenta`)
    REFERENCES `cleandb`.`Venta` (`IdVenta`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_VentaDetalle_Productos1`
    FOREIGN KEY (`IdProductos`)
    REFERENCES `cleandb`.`Producto` (`IdProducto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `cleandb`.`GastosProtocolares`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cleandb`.`GastosProtocolares` (
  `IdGastosProtocolares` INT NOT NULL AUTO_INCREMENT,
  `IdUsuarioCarga` INT NOT NULL,
  `IdSucursal` INT NOT NULL,
  `Descripcion` VARCHAR(45) NOT NULL,
  `Monto` DECIMAL(18,2) NOT NULL,
  PRIMARY KEY (`IdGastosProtocolares`),
  INDEX `fk_GastosProtocolares_Usuario1_idx` (`IdUsuarioCarga` ASC) VISIBLE,
  INDEX `fk_GastosProtocolares_Sucursal1_idx` (`IdSucursal` ASC) VISIBLE,
  CONSTRAINT `fk_GastosProtocolares_Usuario1`
    FOREIGN KEY (`IdUsuarioCarga`)
    REFERENCES `cleandb`.`Usuario` (`IdUsuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_GastosProtocolares_Sucursal1`
    FOREIGN KEY (`IdSucursal`)
    REFERENCES `cleandb`.`Sucursal` (`IdSucursal`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `cleandb`.`PedidoProveedor`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cleandb`.`PedidoProveedor` (
  `IdPedidoProveedor` INT NOT NULL AUTO_INCREMENT,
  `IdPersona` INT NOT NULL,
  `IdProducto` INT NOT NULL,
  `Fecha` DATETIME NOT NULL,
  PRIMARY KEY (`IdPedidoProveedor`),
  INDEX `fk_PedidoProveedor_Persona1_idx` (`IdPersona` ASC) VISIBLE,
  INDEX `fk_PedidoProveedor_Producto1_idx` (`IdProducto` ASC) VISIBLE,
  CONSTRAINT `fk_PedidoProveedor_Persona1`
    FOREIGN KEY (`IdPersona`)
    REFERENCES `cleandb`.`Persona` (`IdPersona`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_PedidoProveedor_Producto1`
    FOREIGN KEY (`IdProducto`)
    REFERENCES `cleandb`.`Producto` (`IdProducto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `cleandb`.`UsuarioToken`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cleandb`.`UsuarioToken` (
  `IdUsuarioToken` INT NOT NULL AUTO_INCREMENT,
  `IdPersona` INT NOT NULL,
  `IdUsuario` INT NOT NULL,
  `Token` TEXT NOT NULL,
  `FechaCaducidad` TIME NOT NULL,
  `Activo` BIT NOT NULL,
  `FechaAlta` DATETIME NOT NULL,
  `FechaBaja` DATETIME NULL,
  PRIMARY KEY (`IdUsuarioToken`),
  INDEX `fk_UsuarioToken_Persona1_idx` (`IdPersona` ASC) VISIBLE,
  INDEX `fk_UsuarioToken_Usuario1_idx` (`IdUsuario` ASC) VISIBLE,
  CONSTRAINT `fk_UsuarioToken_Persona1`
    FOREIGN KEY (`IdPersona`)
    REFERENCES `cleandb`.`Persona` (`IdPersona`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_UsuarioToken_Usuario1`
    FOREIGN KEY (`IdUsuario`)
    REFERENCES `cleandb`.`Usuario` (`IdUsuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `cleandb`.`UsuarioRol`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cleandb`.`UsuarioRol` (
  `IdUsuarioRol` INT NOT NULL AUTO_INCREMENT,
  `IdUsuario` INT NOT NULL,
  `IdTipoRol` INT NOT NULL,
  `IdUsuarioCarga` INT NOT NULL,
  `IdUsuarioBaja` INT NULL,
  `FechaCarga` DATETIME NOT NULL,
  `FechaBaja` DATETIME NULL,
  PRIMARY KEY (`IdUsuarioRol`),
  INDEX `fk_UsuarioRol_Usuario1_idx` (`IdUsuario` ASC) VISIBLE,
  INDEX `fk_UsuarioRol_TipoRol1_idx` (`IdTipoRol` ASC) VISIBLE,
  INDEX `fk_UsuarioRol_Usuario2_idx` (`IdUsuarioCarga` ASC) VISIBLE,
  INDEX `fk_UsuarioRol_Usuario3_idx` (`IdUsuarioBaja` ASC) VISIBLE,
  CONSTRAINT `fk_UsuarioRol_Usuario1`
    FOREIGN KEY (`IdUsuario`)
    REFERENCES `cleandb`.`Usuario` (`IdUsuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_UsuarioRol_TipoRol1`
    FOREIGN KEY (`IdTipoRol`)
    REFERENCES `cleandb`.`TipoRol` (`IdTipoRol`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_UsuarioRol_Usuario2`
    FOREIGN KEY (`IdUsuarioCarga`)
    REFERENCES `cleandb`.`Usuario` (`IdUsuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_UsuarioRol_Usuario3`
    FOREIGN KEY (`IdUsuarioBaja`)
    REFERENCES `cleandb`.`Usuario` (`IdUsuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;




