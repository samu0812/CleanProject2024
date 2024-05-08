--------------------------------------------- CREO EL SPH DE RolModulo ---------------------------------------------
-- Para llamar al metodo debo pasarle el id del rolmodulo que estoy queriendo habilitar y el token  --
-- CALL SPH_RolModulo(10, 'ceci') --
DELIMITER //
CREATE PROCEDURE SPH_RolModulo (
    IN p_Id INT, 
    IN p_UsuarioBearer TEXT(500)
)
BEGIN
    DECLARE v_IdUsuarioCarga INT;
    DECLARE v_Message VARCHAR(50);
    SET v_IdUsuarioCarga = FN_ObtenerUsuDesdeBearer(p_UsuarioBearer);

    IF v_IdUsuarioCarga IS NOT NULL THEN
        -- Verificar si el registro está deshabilitado y existe
        IF (SELECT COUNT(*) FROM RolModulo WHERE IdRolModulo = p_Id AND FechaBaja IS NOT NULL) > 0 THEN
            -- Habilitar el registro estableciendo la fecha de baja como NULL
            UPDATE RolModulo 
            SET FechaBaja = NULL
            WHERE IdRolModulo = p_Id;
            SET v_Message = 'OK';
        ELSE 
            SET v_Message = 'El registro ya está habilitado o no existe';
        END IF;
    ELSE
        SET v_Message = 'Token Inválido';
    END IF;

    SELECT v_Message;
END //
DELIMITER ;
--------------------------------------------- CREO EL SPH DE TipoRol ---------------------------------------------
-- Para llamar al metodo debo pasarle el id del TipoRol que estoy queriendo habilitar y el token  --
-- CALL SPH_TipoRol(7, 'ceci') --
DELIMITER //
CREATE PROCEDURE `SPH_TipoRol`(
    IN p_Id INT, 
    IN p_UsuarioBearer TEXT(500)
)
BEGIN
    DECLARE v_IdUsuarioCarga INT;
    DECLARE v_Message VARCHAR(50);
    SET v_IdUsuarioCarga = FN_ObtenerUsuDesdeBearer(p_UsuarioBearer);

	IF v_IdUsuarioCarga IS NOT NULL THEN
		IF (SELECT COUNT(*) FROM TipoRol WHERE IdTipoRol = p_Id AND FechaBaja IS NOT NULL) > 0 THEN
			UPDATE TipoRol 
			SET FechaBaja = NULL
			WHERE IdTipoRol = p_Id;
			SET v_Message = 'OK';
		ELSE 
			SET v_Message = 'El registro ya está habilitado o no existe';
		END IF;
	ElSE
		SET v_Message = 'Token Inválido';
	END IF;
    SELECT v_Message;
END//
DELIMITER ;
--------------------------------------------- CREO EL SPL DE TipoPersona ---------------------------------------------
-- Para llamar al metodo no debo pasarle ningun parametro  --
-- CALL SPL_TipoPersona() --
DELIMITER //
CREATE PROCEDURE `SPL_TipoPersona`()
BEGIN
    CREATE TEMPORARY TABLE IF NOT EXISTS TempResultados (
        IdTipoPersona INT,
        Descripcion VARCHAR(50)
    );

    INSERT INTO TempResultados (IdTipoPersona, Descripcion)
        SELECT IdTipoPersona, Descripcion
        FROM TipoPersona;
	SELECT * FROM TempResultados;

    DROP TEMPORARY TABLE IF EXISTS TempResultados;
END//
DELIMITER ;
--------------------------------------------- CREO EL SPL DE TipoDocumentacion ---------------------------------------------
-- Para llamar al metodo no debo pasarle ningun parametro --
-- CALL SPL_TipoDocumentacion() --
DELIMITER //
CREATE PROCEDURE `SPL_TipoDocumentacion`()
BEGIN
    DECLARE Message VARCHAR(50);
    CREATE TEMPORARY TABLE IF NOT EXISTS TempResultados (
        IdTipoDocumentacion INT,
        Descripcion VARCHAR(50)
    );

    INSERT INTO TempResultados (IdTipoDocumentacion, Descripcion)
        SELECT IdTipoDocumentacion, Descripcion
        FROM TipoDocumentacion;
	SELECT * FROM TempResultados;
    -- Eliminar la tabla temporal
    DROP TEMPORARY TABLE IF EXISTS TempResultados;
END//
DELIMITER ;
-- ------------------------------------------- Inserto datos en TipoMedida ------------------------------------------ ---
INSERT INTO `cleandb`.`tipomedida`(`Detalle`,`Abreviatura`,`FechaBaja`)
VALUES('Centímetros cúbicos','cm3', NULL);
INSERT INTO `cleandb`.`tipomedida`(`Detalle`,`Abreviatura`,`FechaBaja`)
VALUES('Mililitros','mls', NULL);
INSERT INTO `cleandb`.`tipomedida`(`Detalle`,`Abreviatura`,`FechaBaja`)
VALUES('Litros','lts', NULL);
INSERT INTO `cleandb`.`tipomedida`(`Detalle`,`Abreviatura`,`FechaBaja`)
VALUES('Kilogramos','kgs', NULL);
INSERT INTO `cleandb`.`tipomedida`(`Detalle`,`Abreviatura`,`FechaBaja`)
VALUES('Gramos','grs', NULL);
INSERT INTO `cleandb`.`tipomedida`(`Detalle`,`Abreviatura`,`FechaBaja`)
VALUES('Miligramos','mgs', NULL);
INSERT INTO `cleandb`.`tipomedida`(`Detalle`,`Abreviatura`,`FechaBaja`)
VALUES('Unidad','un', NULL);
--------------------------------------------- CREO EL SPL DE TipoMedida ---------------------------------------------
-- Para llamar al metodo no debo pasarle ningun parametro --
-- CALL SPL_TipoMedida() --
DELIMITER //
CREATE PROCEDURE `SPL_TipoMedida`()
BEGIN
    DECLARE Message VARCHAR(50);
    CREATE TEMPORARY TABLE IF NOT EXISTS TempResultados (
        IdTipoMedida INT,
        Detalle VARCHAR(45),
        Abreviatura VARCHAR(45),
        FechaBaja DATETIME
    );

    INSERT INTO TempResultados (IdTipoMedida, Detalle, Abreviatura)
        SELECT IdTipoMedida, Detalle, Abreviatura
        FROM TipoMedida;
	SELECT * FROM TempResultados;
    -- Eliminar la tabla temporal
    DROP TEMPORARY TABLE IF EXISTS TempResultados;
END//
DELIMITER ;
--------------------------------------------- CREO EL SPL DE TipoDomicilio ---------------------------------------------
-- Para llamar al metodo no debo pasarle ningun parametro --
-- CALL SPL_TipoDomicilio() --
DELIMITER //
CREATE PROCEDURE `SPL_TipoDomicilio`()
BEGIN
    CREATE TEMPORARY TABLE IF NOT EXISTS TempResultados (
        IdTipoDomicilio INT,
        Descripcion VARCHAR(50)
    );

    INSERT INTO TempResultados (IdTipoDomicilio, Descripcion)
        SELECT IdTipoDomicilio, Descripcion
        FROM TipoDomicilio;
	SELECT * FROM TempResultados;

    DROP TEMPORARY TABLE IF EXISTS TempResultados;
END//
DELIMITER ;
-- ------------------------------------------- INSERTO EN TIPO FACTURA ------------------------------------------- --
INSERT INTO `cleandb`.`tipofactura`(`Descripcion`)
VALUES('Factura A');
INSERT INTO `cleandb`.`tipofactura`(`Descripcion`)
VALUES('Factura B');
INSERT INTO `cleandb`.`tipofactura`(`Descripcion`)
VALUES('Factura C');
INSERT INTO `cleandb`.`tipofactura`(`Descripcion`)
VALUES('Factura E');
INSERT INTO `cleandb`.`tipofactura`(`Descripcion`)
VALUES('Ticket');
INSERT INTO `cleandb`.`tipofactura`(`Descripcion`)
VALUES('Remito');
INSERT INTO `cleandb`.`tipofactura`(`Descripcion`)
VALUES('Nota de Crédito');
INSERT INTO `cleandb`.`tipofactura`(`Descripcion`)
VALUES('Recibo');
--------------------------------------------- CREO EL SPL DE TipoFactura ---------------------------------------------
-- Para llamar al metodo no debo pasarle ningun parametro --
-- CALL SPL_TipoFactura() --
DELIMITER //
CREATE PROCEDURE `SPL_TipoFactura`()
BEGIN
    CREATE TEMPORARY TABLE IF NOT EXISTS TempResultados (
        IdTipoFactura INT,
        Descripcion VARCHAR(50)
    );

    INSERT INTO TempResultados (IdTipoFactura, Descripcion)
        SELECT IdTipoFactura, Descripcion
        FROM TipoFactura;
	SELECT * FROM TempResultados;

    DROP TEMPORARY TABLE IF EXISTS TempResultados;
END//
DELIMITER ;
-- ------------------------------------------- INSERTO EN TIPO DESTINATARIO FACTURA ------------------------------------------- --
INSERT INTO `cleandb`.`tipodestinatariofactura`(`Descripcion`)
VALUES('Cliente');
INSERT INTO `cleandb`.`tipodestinatariofactura`(`Descripcion`)
VALUES('Proveedor');
--------------------------------------------- CREO EL SPL DE TipoDestinatarioFactura ---------------------------------------------
-- Para llamar al metodo no debo pasarle ningun parametro --
-- CALL SPL_TipoDestinatarioFactura() --
DELIMITER //
CREATE PROCEDURE `SPL_TipoDestinatarioFactura`()
BEGIN
    CREATE TEMPORARY TABLE IF NOT EXISTS TempResultados (
        IdTipoDestinatarioFactura INT,
        Descripcion VARCHAR(50)
    );

    INSERT INTO TempResultados (IdTipoDestinatarioFactura, Descripcion)
        SELECT IdTipoDestinatarioFactura, Descripcion
        FROM TipoDestinatarioFactura;
	SELECT * FROM TempResultados;

    DROP TEMPORARY TABLE IF EXISTS TempResultados;
END//
DELIMITER ;
--------------------------------------------- CREO EL SPL DE TipoPermiso ---------------------------------------------
-- Para llamar al metodo no debo pasarle ningun parametro --
-- CALL SPL_TipoPermiso() --
DELIMITER //
CREATE PROCEDURE `SPL_TipoPermiso`()
BEGIN
    CREATE TEMPORARY TABLE IF NOT EXISTS TempResultados (
        IdTipoPermiso INT,
        Detalle VARCHAR(50)
    );

    INSERT INTO TempResultados (IdTipoPermiso, Detalle)
        SELECT IdTipoPermiso, Detalle
        FROM TipoPermiso;
	SELECT * FROM TempResultados;

    DROP TEMPORARY TABLE IF EXISTS TempResultados;
END//
DELIMITER ;
--------------------------------------------- CREO EL SPL DE TipoPermisoDetalle ---------------------------------------------
-- Para llamar al metodo debo pasarle si quiero el IdTipoPermiso para que filtre, si no le debo pasar NULL y devuelve todos --
-- CALL SPL_TipoPermisoDetalle(NULL) --
DELIMITER //
CREATE PROCEDURE `SPL_TipoPermisoDetalle`(
    IN p_IdTipoPermiso INT
)
BEGIN
	DECLARE v_Exists INT;
    DECLARE v_Message VARCHAR(100);
    CREATE TEMPORARY TABLE IF NOT EXISTS TempResultados (
        IdTipoPermisoDetalle INT,
        TipoPermiso VARCHAR(45),
        Method VARCHAR(45)
    );
    -- Verificar si p_IdTipoPermiso existe en la tabla TipoPermiso
    SELECT COUNT(*) INTO v_Exists FROM TipoPermiso WHERE IdTipoPermiso = p_IdTipoPermiso;

	IF v_Exists = 0 and p_IdTipoPermiso IS NOT NULL THEN
        SET v_Message = 'El IdTipoPermiso proporcionado no existe en la tabla TipoPermiso';
        SELECT v_Message;
    ELSE
		IF p_IdTipoPermiso IS NOT NULL THEN
			-- Si se pasa un valor para IdTipoPermiso, filtrar por ese valor
			INSERT INTO TempResultados (IdTipoPermisoDetalle, TipoPermiso, Method)
			SELECT tpd.IdTipoPermisoDetalle, tp.Detalle AS TipoPermiso, tpd.Method
			FROM TipoPermisoDetalle tpd
			INNER JOIN TipoPermiso tp ON tp.IdTipoPermiso = tpd.IdTipoPermiso
			WHERE tp.IdTipoPermiso = p_IdTipoPermiso;
		ELSE
			-- Si se pasa NULL, mostrar todos los registros
			INSERT INTO TempResultados (IdTipoPermisoDetalle, TipoPermiso, Method)
			SELECT tpd.IdTipoPermisoDetalle, tp.Detalle AS TipoPermiso, tpd.Method
			FROM TipoPermisoDetalle tpd
			INNER JOIN TipoPermiso tp ON tp.IdTipoPermiso = tpd.IdTipoPermiso;
		END IF;
        SELECT * FROM TempResultados;
		DROP TEMPORARY TABLE IF EXISTS TempResultados;
	END IF;
END//
DELIMITER ;

--------------------------------------------- CREO EL SPL DE TipoPersonaSistema ---------------------------------------------
-- Para llamar al metodo debo pasarle el parametro de lista, donde 1 es habilitado y 2 inhabilitado --
-- CALL SPL_TipoPersonaSistema(2) --
DELIMITER //
CREATE PROCEDURE `SPL_TipoPersonaSistema`(
    IN TipoLista INT
)
BEGIN
    DECLARE Message VARCHAR(50);
    CREATE TEMPORARY TABLE IF NOT EXISTS TempResultados (
        IdTipoPersonaSistema INT,
        Descripcion VARCHAR(50),
        FechaBaja datetime
    );

    IF TipoLista = 1 THEN
        INSERT INTO TempResultados (IdTipoPersonaSistema, Descripcion, FechaBaja)
        SELECT IdTipoPersonaSistema, Descripcion, FechaBaja
        FROM TipoPersonaSistema
        WHERE FechaBaja IS NULL;
    ELSEIF TipoLista = 2 THEN
        INSERT INTO TempResultados (IdTipoPersonaSistema, Descripcion, FechaBaja)
        SELECT IdTipoPersonaSistema, Descripcion, FechaBaja
        FROM TipoPersonaSistema
        WHERE FechaBaja IS NOT NULL;
    END IF;

    IF TipoLista = 1 OR TipoLista = 2 THEN
        SELECT * FROM TempResultados;
	ELSE
		SET Message = 'Tipo de lista no válido';
        SELECT Message;
    END IF;

    -- Eliminar la tabla temporal
    DROP TEMPORARY TABLE IF EXISTS TempResultados;
END//
DELIMITER ;
--------------------------------------------- CREO EL SPA DE TipoPersonaSistema ---------------------------------------------
-- Para llamar al metodo debo pasarle la descripcion que estoy queriendo agregar y el token --
-- CALL SPA_TipoPersonaSistema('Prueba', 'ceci'); --
DELIMITER //
CREATE PROCEDURE `SPA_TipoPersonaSistema`(
    IN p_Descripcion VARCHAR(50), 
    IN p_UsuarioBearer TEXT
)
BEGIN
    DECLARE v_IdUsuarioCarga INT;
    DECLARE v_Message VARCHAR(50);
    SET v_IdUsuarioCarga = FN_ObtenerUsuDesdeBearer(p_UsuarioBearer);
	IF v_IdUsuarioCarga IS NOT NULL THEN
		IF (SELECT COUNT(*) FROM TipoPersonaSistema WHERE Descripcion = p_Descripcion) = 0 THEN
			INSERT INTO TipoPersonaSistema (Descripcion, FechaBaja)
			VALUES (p_Descripcion, NULL);
			SET v_Message = 'OK';
		ELSE 
			SET v_Message = 'El valor ingresado ya existe';
		END IF;
	ElSE
		SET v_Message = 'Token Inválido';
	END IF;
	-- Devolver el mensaje
	SELECT v_Message;
		
END//
--------------------------------------------- CREO EL SPM DE TipoPersonaSistema ---------------------------------------------
-- Para llamar al metodo debo pasarle el id del TipoPersonaSistema que estoy queriendo modificar, el valor nuevo y el token  --
-- CALL SPM_TipoPersonaSistema(11, 'AA', 'ceci'); --
DELIMITER //
CREATE PROCEDURE `SPM_TipoPersonaSistema`(
	IN p_Id INT, 
    IN p_Descripcion VARCHAR(50), 
    IN p_UsuarioBearer text(500)
)
BEGIN
    DECLARE v_IdUsuarioCarga INT;
    DECLARE v_Message VARCHAR(50);
    DECLARE v_CountExistTipoPersonaSistema INT;
    
    SET v_IdUsuarioCarga = FN_ObtenerUsuDesdeBearer(p_UsuarioBearer);
    SELECT COUNT(*) INTO v_CountExistTipoPersonaSistema FROM TipoPersonaSistema WHERE IdTipoPersonaSistema = p_Id;
    
	IF v_IdUsuarioCarga IS NOT NULL THEN
		IF v_CountExistTipoPersonaSistema = 0 THEN
			SET v_Message = 'El TipoPersonaSistema ingresado no existe.';
		ELSE
			IF (SELECT COUNT(*) FROM TipoPersonaSistema WHERE IdTipoPersonaSistema = p_Id AND Descripcion = p_Descripcion) = 0 THEN
				IF (SELECT COUNT(*) FROM TipoPersonaSistema WHERE IdTipoPersonaSistema = p_Id AND FechaBaja IS NOT NULL) = 0 THEN
					UPDATE TipoPersonaSistema 
					SET Descripcion = p_Descripcion, FechaBaja = NULL 
					WHERE IdTipoPersonaSistema = p_Id;
					SET v_Message = 'OK';
				ELSE 
					SET v_Message = 'El ID ingresado se encuentra inhabilitado.';
				END IF;
			ELSE 
				SET v_Message = 'La descripción ingresada ya existe.';
			END IF;
		END IF;
	ElSE
		SET v_Message = 'Token Inválido.';
	END IF;
    SELECT v_Message;
END//
DELIMITER ;
--------------------------------------------- CREO EL SPB DE TipoPersonaSistema ---------------------------------------------
-- Para llamar al metodo debo pasarle el id del TipoPersonaSistema que estoy queriendo inhabilitar y el token  --
-- CALL SPB_TipoPersonaSistema(4,'ceci'); --
DELIMITER //
CREATE PROCEDURE `SPB_TipoPersonaSistema`(
    IN p_Id INT, 
    IN p_UsuarioBearer TEXT(500)
)
BEGIN
    DECLARE v_IdUsuarioCarga INT;
    DECLARE v_Message VARCHAR(50);
    SET v_IdUsuarioCarga = FN_ObtenerUsuDesdeBearer(p_UsuarioBearer);

	IF v_IdUsuarioCarga IS NOT NULL THEN
		IF (SELECT COUNT(*) FROM TipoPersonaSistema WHERE IdTipoPersonaSistema = p_Id AND FechaBaja IS NULL) > 0 THEN
			UPDATE TipoPersonaSistema 
			SET FechaBaja = NOW() 
			WHERE IdTipoPersonaSistema = p_Id;
			SET v_Message = 'OK';
		ELSE 
			SET v_Message = 'El registro ya está deshabilitado o no existe';
		END IF;
	ElSE
		SET v_Message = 'Token Inválido';
	END IF;
    SELECT v_Message;
END//
DELIMITER ;
--------------------------------------------- CREO EL SPH DE TipoPersonaSistema ---------------------------------------------
-- Para llamar al metodo debo pasarle el id del TipoPersonaSistema que estoy queriendo habilitar y el token  --
-- CALL SPH_TipoPersonaSistema(3, 'ceci') --
DELIMITER //
CREATE PROCEDURE `SPH_TipoPersonaSistema`(
    IN p_Id INT, 
    IN p_UsuarioBearer TEXT(500)
)
BEGIN
    DECLARE v_IdUsuarioCarga INT;
    DECLARE v_Message VARCHAR(50);
    SET v_IdUsuarioCarga = FN_ObtenerUsuDesdeBearer(p_UsuarioBearer);

	IF v_IdUsuarioCarga IS NOT NULL THEN
		IF (SELECT COUNT(*) FROM TipoPersonaSistema WHERE IdTipoPersonaSistema = p_Id AND FechaBaja IS NOT NULL) > 0 THEN
			UPDATE TipoPersonaSistema 
			SET FechaBaja = NULL
			WHERE IdTipoPersonaSistema = p_Id;
			SET v_Message = 'OK';
		ELSE 
			SET v_Message = 'El registro ya está habilitado o no existe';
		END IF;
	ElSE
		SET v_Message = 'Token Inválido';
	END IF;
    SELECT v_Message;
END//
DELIMITER ;
-- ------------------------------------------- INSERTO EN TipoProducto ------------------------------------------- --
INSERT INTO `cleandb`.`tipoproducto`(`Detalle`)
VALUES('Envasado');
INSERT INTO `cleandb`.`tipoproducto`(`Detalle`)
VALUES('Preparado');
INSERT INTO `cleandb`.`tipoproducto`(`Detalle`)
VALUES('Suelto');
--------------------------------------------- CREO EL SPL DE TipoProducto ---------------------------------------------
-- Para llamar al metodo debo pasarle el parametro de lista, donde 1 es habilitado y 2 inhabilitado --
-- CALL SPL_TipoProducto(2) --
DELIMITER //
CREATE PROCEDURE `SPL_TipoProducto`(
    IN TipoLista INT
)
BEGIN
    DECLARE Message VARCHAR(50);
    CREATE TEMPORARY TABLE IF NOT EXISTS TempResultados (
        IdTipoProducto INT,
        Detalle VARCHAR(50),
        FechaBaja datetime
    );

    IF TipoLista = 1 THEN
        INSERT INTO TempResultados (IdTipoProducto, Detalle, FechaBaja)
        SELECT IdTipoProducto, Detalle, FechaBaja
        FROM TipoProducto
        WHERE FechaBaja IS NULL;
    ELSEIF TipoLista = 2 THEN
        INSERT INTO TempResultados (IdTipoProducto, Detalle, FechaBaja)
        SELECT IdTipoProducto, Detalle, FechaBaja
        FROM TipoProducto
        WHERE FechaBaja IS NOT NULL;
    END IF;

    IF TipoLista = 1 OR TipoLista = 2 THEN
        SELECT * FROM TempResultados;
	ELSE
		SET Message = 'Tipo de lista no válido';
        SELECT Message;
    END IF;

    -- Eliminar la tabla temporal
    DROP TEMPORARY TABLE IF EXISTS TempResultados;
END//
DELIMITER ;
--------------------------------------------- CREO EL SPA DE TipoProducto ---------------------------------------------
-- Para llamar al metodo debo pasarle la descripcion que estoy queriendo agregar y el token --
-- CALL SPA_TipoProducto('Prueba2', 'ceci'); --
DELIMITER //
CREATE PROCEDURE `SPA_TipoProducto`(
    IN p_Descripcion VARCHAR(50), 
    IN p_UsuarioBearer TEXT
)
BEGIN
    DECLARE v_IdUsuarioCarga INT;
    DECLARE v_Message VARCHAR(50);
    SET v_IdUsuarioCarga = FN_ObtenerUsuDesdeBearer(p_UsuarioBearer);
	IF v_IdUsuarioCarga IS NOT NULL THEN
		IF (SELECT COUNT(*) FROM TipoProducto WHERE Detalle = p_Descripcion) = 0 THEN
			INSERT INTO TipoProducto (Detalle, FechaBaja)
			VALUES (p_Descripcion, NULL);
			SET v_Message = 'OK';
		ELSE 
			SET v_Message = 'El valor ingresado ya existe';
		END IF;
	ElSE
		SET v_Message = 'Token Inválido';
	END IF;
	-- Devolver el mensaje
	SELECT v_Message;
		
END//

--------------------------------------------- CREO EL SPM DE TipoProducto ---------------------------------------------
-- Para llamar al metodo debo pasarle el id del TipoProducto que estoy queriendo modificar, el valor nuevo y el token  --
-- CALL SPM_TipoProducto(1, 'PruebaAA', 'ceci'); --
DELIMITER //
CREATE PROCEDURE `SPM_TipoProducto`(
	IN p_Id INT, 
    IN p_Descripcion VARCHAR(50), 
    IN p_UsuarioBearer text(500)
)
BEGIN
    DECLARE v_IdUsuarioCarga INT;
    DECLARE v_Message VARCHAR(50);
    DECLARE v_CountExistTipoProducto INT;
    
    SET v_IdUsuarioCarga = FN_ObtenerUsuDesdeBearer(p_UsuarioBearer);
    SELECT COUNT(*) INTO v_CountExistTipoProducto FROM TipoProducto WHERE IdTipoProducto = p_Id;
    
	IF v_IdUsuarioCarga IS NOT NULL THEN
		IF v_CountExistTipoProducto = 0 THEN
			SET v_Message = 'El TipoPersonaSistema ingresado no existe.';
		ELSE
			IF (SELECT COUNT(*) FROM TipoProducto WHERE IdTipoProducto = p_Id AND Detalle = p_Descripcion) = 0 THEN
				IF (SELECT COUNT(*) FROM TipoProducto WHERE IdTipoProducto = p_Id AND FechaBaja IS NOT NULL) = 0 THEN
					UPDATE TipoProducto 
					SET Detalle = p_Descripcion, FechaBaja = NULL 
					WHERE IdTipoProducto = p_Id;
					SET v_Message = 'OK';
				ELSE 
					SET v_Message = 'El ID ingresado se encuentra inhabilitado.';
				END IF;
			ELSE 
				SET v_Message = 'La descripción ingresada ya existe.';
			END IF;
		END IF;
	ElSE
		SET v_Message = 'Token Inválido.';
	END IF;
    SELECT v_Message;
END//
DELIMITER ;
--------------------------------------------- CREO EL SPB DE TipoProducto ---------------------------------------------
-- Para llamar al metodo debo pasarle el id del TipoProducto que estoy queriendo inhabilitar y el token  --
-- CALL SPB_TipoProducto(4,'ceci'); --
DELIMITER //
CREATE PROCEDURE `SPB_TipoProducto`(
    IN p_Id INT, 
    IN p_UsuarioBearer TEXT(500)
)
BEGIN
    DECLARE v_IdUsuarioCarga INT;
    DECLARE v_Message VARCHAR(50);
    SET v_IdUsuarioCarga = FN_ObtenerUsuDesdeBearer(p_UsuarioBearer);

	IF v_IdUsuarioCarga IS NOT NULL THEN
		IF (SELECT COUNT(*) FROM TipoProducto WHERE IdTipoProducto = p_Id AND FechaBaja IS NULL) > 0 THEN
			UPDATE TipoProducto 
			SET FechaBaja = NOW() 
			WHERE IdTipoProducto = p_Id;
			SET v_Message = 'OK';
		ELSE 
			SET v_Message = 'El registro ya está deshabilitado o no existe';
		END IF;
	ElSE
		SET v_Message = 'Token Inválido';
	END IF;
    SELECT v_Message;
END//
DELIMITER ;
--------------------------------------------- CREO EL SPH DE TipoProducto ---------------------------------------------
-- Para llamar al metodo debo pasarle el id del TipoProducto que estoy queriendo habilitar y el token  --
-- CALL SPH_TipoProducto(4, 'ceci') --
DELIMITER //
CREATE PROCEDURE `SPH_TipoProducto`(
    IN p_Id INT, 
    IN p_UsuarioBearer TEXT(500)
)
BEGIN
    DECLARE v_IdUsuarioCarga INT;
    DECLARE v_Message VARCHAR(50);
    SET v_IdUsuarioCarga = FN_ObtenerUsuDesdeBearer(p_UsuarioBearer);

	IF v_IdUsuarioCarga IS NOT NULL THEN
		IF (SELECT COUNT(*) FROM TipoProducto WHERE IdTipoProducto = p_Id AND FechaBaja IS NOT NULL) > 0 THEN
			UPDATE TipoProducto 
			SET FechaBaja = NULL
			WHERE IdTipoProducto = p_Id;
			SET v_Message = 'OK';
		ELSE 
			SET v_Message = 'El registro ya está habilitado o no existe';
		END IF;
	ElSE
		SET v_Message = 'Token Inválido';
	END IF;
    SELECT v_Message;
END//
DELIMITER ;




