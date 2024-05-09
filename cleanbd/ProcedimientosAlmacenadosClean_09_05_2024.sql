use cleandb;

-----------------------------------------------------
DROP PROCEDURE IF EXISTS SP_ValidarUsuario;
-- Procedimiento Almacenado que Valida que el usuario este registrado en nuestro sistema--
DELIMITER //
CREATE PROCEDURE `SP_ValidarUsuario` (IN p_usuario VARCHAR(45), IN p_clave VARCHAR(255), OUT p_resultado BOOLEAN)
BEGIN
    DECLARE v_count INT;
	DECLARE v_hashed_clave VARCHAR(255);
    -- Deshashear la contraseña proporcionada
    SET v_hashed_clave = SHA2(p_clave, 256);

    -- Verificar si el usuario y la contraseña coinciden en la tabla Usuario
    SELECT COUNT(*) INTO v_count
    FROM Usuario u
    JOIN Persona p ON u.IdPersona = p.IdPersona
    WHERE u.Usuario = p_usuario AND u.Clave = v_hashed_clave;

    -- Si el conteo es mayor que 0, significa que las credenciales son válidas
    IF v_count > 0 THEN
        SET p_resultado = TRUE;
    ELSE
        SET p_resultado = FALSE;
    END IF;
END //
DELIMITER ;
--------------------------------------------- CREO EL SP DE GETMENU ---------------------------------------------
-- Para llamar al getmenu, debo pasarle el bearer de la persona que esta logueada que tendra su credencial con el rol que le corresponde y podremos obtener los menus a mostrar --
-- CALL SP_GetMenu('ceci');  --
DELIMITER //
CREATE PROCEDURE SP_GetMenu (
    IN p_bearer TEXT
)
BEGIN
    DECLARE v_Id INT;
    SET SQL_SAFE_UPDATES = 0;

    CREATE TEMPORARY TABLE Menues (
        IdTipoModulo INT,
        Orden VARCHAR(10),
        Detalle VARCHAR(100),
        PathRoute VARCHAR(100),
        TipoMenu INT,
        TipoIcono VARCHAR(100),
        Icono MEDIUMBLOB,
        PoseePermiso INT
    );

    INSERT INTO Menues(IdTipoModulo, Orden, Detalle, PathRoute, TipoMenu, TipoIcono, Icono)
    SELECT IdTipoModulo, Orden, Detalle, PathRout, TipoMenu, TipoIcono, Icono
    FROM cleandb.TipoModulo
    WHERE FechaBaja IS NULL AND IdPadre = 0;

    UPDATE Menues
    SET PathRoute = CONCAT('/', CAST(IdTipoModulo AS CHAR(10)), '/submenu')
    WHERE TipoMenu = 2;

	UPDATE Menues
	SET PoseePermiso = 1
	WHERE IdTipoModulo IN (
		SELECT D.IdTipoModulo
		FROM Persona AS E
		INNER JOIN Usuario AS F ON E.IdPersona = F.IdPersona
		INNER JOIN UsuarioToken AS T ON T.IdPersona = E.IdPersona
		INNER JOIN UsuarioRol AS UR ON UR.IdUsuario = F.IdUsuario
		INNER JOIN TipoRol AS TR ON TR.IdTipoRol = UR.IdTipoRol
		INNER JOIN RolModulo AS C ON C.IdTipoRol = TR.IdTipoRol
		INNER JOIN TipoModulo AS D ON D.IdTipoModulo = C.IdTipoModulo
		WHERE T.Token = p_bearer
		AND D.FechaBaja IS NULL
		AND D.PathRout IS NOT NULL
	);
    
    UPDATE Menues 
    SET PoseePermiso = 0
    WHERE PoseePermiso IS NULL;

    SELECT * FROM Menues;
	DROP TABLE IF EXISTS Menues;
END //
DELIMITER //
--------------------------------------------- CREO EL SP DE GETSUBMENU ---------------------------------------------
-- Para llamar al SUBGETMENU, debo pasarle el bearer de la persona que esta logueada y el id del menu (IDPADRE en TipoModulo) a donde esta queriendo entrar --
-- CALL SP_GetSubMenu('ceci', 3);  --
DELIMITER //
CREATE PROCEDURE SP_GetSubMenu (
    IN p_bearer TEXT,
    IN p_IdMenu INT
)
BEGIN
    DECLARE v_Id INT;

    CREATE TEMPORARY TABLE Menues (
        Id INT,
        Orden VARCHAR(10),
        Detalle VARCHAR(100),
        PathRoute VARCHAR(100),
        TipoIcono VARCHAR(100),
        Icono MEDIUMBLOB,
        PoseePermiso INT
    );

    INSERT INTO Menues(Id, Orden, Detalle, PathRoute, TipoIcono, Icono)
    SELECT IdTipoModulo, Orden, Detalle, PathRout, TipoIcono, Icono
    FROM cleandb.TipoModulo
    WHERE FechaBaja IS NULL AND IdPadre = p_IdMenu;

    UPDATE Menues
    SET PoseePermiso = 1
    WHERE Id IN (
        SELECT D.IdTipoModulo
        FROM Persona AS E
        INNER JOIN Usuario AS F ON E.IdPersona = F.IdPersona
        INNER JOIN UsuarioToken AS T ON T.IdPersona = E.IdPersona
        INNER JOIN UsuarioRol AS UR ON UR.IdUsuario = F.IdUsuario
        INNER JOIN TipoRol AS TR ON TR.IdTipoRol = UR.IdTipoRol
        INNER JOIN RolModulo AS C ON C.IdTipoRol = TR.IdTipoRol
        INNER JOIN TipoModulo AS D ON D.IdTipoModulo = C.IdTipoModulo
        WHERE T.Token = p_bearer
        AND D.FechaBaja IS NULL
        AND D.PathRout IS NOT NULL
    );

    UPDATE Menues 
    SET PoseePermiso = 0
    WHERE PoseePermiso IS NULL;

    SELECT * FROM Menues;
    DROP TEMPORARY TABLE IF EXISTS Menues;
END //
--------------------------------------------- CREO EL SP DE GetImagenSubMenu ---------------------------------------------
-- Hay que pasarle la PATH como parametro para que arroje el icono del modulo solicitado --
-- CALL SP_GetImagenSubMenu('/seguridad/usuarios');  --
DELIMITER //
CREATE PROCEDURE SP_GetImagenSubMenu (
    IN p_RoutePath VARCHAR(100)
)
BEGIN
    SELECT 
        IdTipoModulo,
        TipoIcono,
        Icono
    FROM cleandb.TipoModulo
    WHERE PathRout = p_RoutePath;
END //
DELIMITER //
--------------------------------------------- CREO EL SP DE GETMENUSUARIO ---------------------------------------------
-- Para llamar al GETMENUSUARIO, debo pasarle el ID DEL USUARIO LOGUEADO, y este devuelve el rol, nivel, el menu y la ruta habilitada del usuario --
-- CALL SP_GetMenuUsuario(1);  --
DELIMITER //
CREATE PROCEDURE SP_GetMenuUsuario (
    IN p_IdPersona INT
)
BEGIN
    SELECT 
        B.Descripcion AS Rol,
        C.IdTipoPermiso AS Nivel,
        D.Detalle AS MenuDescripcion,
        D.PathRout AS MenuRutaHabilitada 
    FROM Persona AS E 
    INNER JOIN Usuario AS F ON E.IdPersona = F.IdPersona
    INNER JOIN UsuarioRol AS A ON E.IdPersona = A.IdUsuario
    INNER JOIN TipoRol AS B ON A.IdTipoRol = B.IdTipoRol
    INNER JOIN RolModulo AS C ON B.IdTipoRol = C.IdTipoRol
    INNER JOIN TipoModulo AS D ON C.IdTipoModulo = D.IdTipoModulo
    WHERE E.IdPersona = p_IdPersona
    AND D.PathRout IS NOT NULL;
END //
DELIMITER //
--------------------------------------------- CREO EL SP DE SISTEMAAPIS ---------------------------------------------
-- Para llamar al metodo debo pasarle el METODO, o sea get put delete o post, mas el nombre de la api --
-- CALL SP_SistemaAPIs('GET', 'Obtener Menu'); --
DELIMITER //
CREATE PROCEDURE SP_SistemaAPIs (
    IN Metodo VARCHAR(100),
    IN Nombre VARCHAR(100)
)
BEGIN
    SELECT IdSistemaAPIs, Detalle, Method, Path
    FROM cleandb.SistemaAPIs
    WHERE (Method = COALESCE(Metodo, Method)) 
    AND (Detalle LIKE CONCAT('%', COALESCE(Nombre, Detalle), '%'));
END //
DELIMITER //
--------------------------------------------- CREO EL SP DE SistemaModuloApis ---------------------------------------------
-- Para llamar al metodo debo pasarle el id del tipomodulo, la paginacion, la cantidad de registros y el tipo de lista --
-- CALL SP_SistemaModuloApis(1, 5, 999, 1); --
DELIMITER //
CREATE PROCEDURE SP_SistemaModuloApis (
    IN p_IdTipoModulo INT,
    IN p_Pagina INT,
    IN p_CantRegistros INT,
    IN p_TipoLista TINYINT
)
BEGIN
    DECLARE SkipRegistros INT;
    
    SET SkipRegistros = (p_Pagina - 1) * p_CantRegistros;

    IF p_TipoLista IN (1, 2, 3) THEN
        SELECT 
            a.IdSistemaModuloAPIs AS Id,
            a.IdTipoModulo,
            b.Detalle AS Modulo,
            a.IdSistemasAPIs AS IdSistemaAPIs,
            c.Detalle AS SistemaAPIs,
            c.Method AS Metodo,
            c.Path AS Ruta,
            (SELECT COUNT(*) FROM SistemaModuloApis WHERE IdTipoModulo = p_IdTipoModulo) AS CantRegistros
        FROM
            SistemaModuloApis a
        INNER JOIN
            TipoModulo b ON a.IdTipoModulo = b.IdTipoModulo
        INNER JOIN
            SistemaAPIs c ON a.IdSistemasAPIs = c.IdSistemaAPIs
        WHERE
            a.IdTipoModulo = COALESCE(p_IdTipoModulo, a.IdTipoModulo)
        ORDER BY
            a.IdSistemaModuloAPIs
        LIMIT SkipRegistros, p_CantRegistros;
    END IF;
END //
DELIMITER ;
--------------------------------------------- CREO EL SPA DE UsuarioToken ---------------------------------------------
-- Para llamar al metodo debo pasarle el id de la persona y el token --
-- CALL SPA_UsuarioToken(1, 'ceci'); --
DELIMITER //
CREATE PROCEDURE `SPA_UsuarioToken`(
    IN IdPersonalIN INT,
    IN Token TEXT
)
BEGIN
    DECLARE Message VARCHAR(50);
    DECLARE NombrePersonal VARCHAR(100);
    DECLARE DocumentacionPersonal INT;
    DECLARE SucursalPersonal INT;
    DECLARE UsuarioId INT;
    DECLARE TiempoToken INT;

    SELECT IdUsuario INTO UsuarioId
	FROM Usuario
	WHERE IdPersona = IdPersonalIN AND FechaBaja IS NULL AND IdPersona IS NOT NULL;

    IF UsuarioId IS NOT NULL THEN
		SET TiempoToken = 60;
        SET Message = 'Ok';
        UPDATE UsuarioToken
		SET Activo = 0
		WHERE IdPersona = IdPersonalIN;
		
		INSERT INTO UsuarioToken(IdPersona, IdUsuario, Token, FechaAlta, FechaCaducidad, Activo)
		VALUES(IdPersonalIN, UsuarioId, Token, NOW(), DATE_ADD(NOW(), INTERVAL TiempoToken MINUTE), 1);
		
		SELECT Nombre, Documentacion INTO NombrePersonal, DocumentacionPersonal
		FROM Persona
		WHERE IdPersona = IdPersonalIN;
    ELSE
        SET Message = 'Personal Inexistente';
    END IF;
    
    SELECT Message AS Mensaje, 
           TiempoToken AS TiempoCaduca,
           NombrePersonal AS NombrePersonal,
           DocumentacionPersonal AS DocumentacionPersonal;
END//
DELIMITER ;
--------------------------------------------- CREO EL FN DE ObtenerUsuDesdeBearer ---------------------------------------------
-- Para llamar al metodo debo pasarle el token de la persona y lde devolvera 1 si existe y NULL si no existe --
-- SELECT FN_ObtenerUsuDesdeBearer('ceci');
DELIMITER //
CREATE FUNCTION `FN_ObtenerUsuDesdeBearer`(
    p_UsuarioBearer text(500)
)
RETURNS INT
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE v_IdUsu INT;
    SELECT IdUsuario INTO v_IdUsu
    FROM UsuarioToken
    WHERE Token = p_UsuarioBearer AND Activo = 1; 
    RETURN v_IdUsu;
END//
--------------------------------------------- CREO EL SPA DE TipoRol ---------------------------------------------
-- Para llamar al metodo debo pasarle la descripcion que estoy queriendo agregar y el token --
-- CALL SPA_TipoRol('AA', 'ceci'); --
DELIMITER //
CREATE PROCEDURE `SPA_TipoRol`(
    IN p_Descripcion VARCHAR(50), 
    IN p_UsuarioBearer TEXT
)
BEGIN
    DECLARE v_IdUsuarioCarga INT;
    DECLARE v_Message VARCHAR(50);
    SET v_IdUsuarioCarga = FN_ObtenerUsuDesdeBearer(p_UsuarioBearer);
	IF v_IdUsuarioCarga IS NOT NULL THEN
		IF (SELECT COUNT(*) FROM TipoRol WHERE Descripcion = p_Descripcion) = 0 THEN
			INSERT INTO TipoRol (Descripcion, FechaBaja)
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
DELIMITER ;
--------------------------------------------- CREO EL SPM DE TipoRol ---------------------------------------------
-- Para llamar al metodo debo pasarle el id del tiporol que estoy queriendo modificar, el valor nuevo y el token  --
-- CALL SPM_TipoRol(3, 'Repartidor', 'ceci'); --
DELIMITER //
CREATE PROCEDURE `SPM_TipoRol`(
	IN p_Id INT, 
    IN p_Descripcion VARCHAR(50), 
    IN p_UsuarioBearer text(500)
)
BEGIN
    DECLARE v_IdUsuarioCarga INT;
    DECLARE v_Message VARCHAR(50);
    DECLARE v_CountExistTipoRol INT;
    
    SET v_IdUsuarioCarga = FN_ObtenerUsuDesdeBearer(p_UsuarioBearer);
    SELECT COUNT(*) INTO v_CountExistTipoRol FROM TipoRol WHERE IdTipoRol = p_Id;
    
	IF v_IdUsuarioCarga IS NOT NULL THEN
		IF v_CountExistTipoRol = 0 THEN
			SET v_Message = 'El TipoRol ingresado no existe.';
		ELSE
			IF (SELECT COUNT(*) FROM TipoRol WHERE IdTipoRol = p_Id AND Descripcion = p_Descripcion) = 0 THEN
				IF (SELECT COUNT(*) FROM TipoRol WHERE IdTipoRol = p_Id AND FechaBaja IS NOT NULL) = 0 THEN
					UPDATE TipoRol 
					SET Descripcion = p_Descripcion, FechaBaja = NULL 
					WHERE IdTipoRol = p_Id;
					SET v_Message = 'OK';
				ELSE 
					SET v_Message = 'El valor ingresado se encuentra inhabilitado.';
				END IF;
			ELSE 
				SET v_Message = 'El valor ingresado ya existe.';
			END IF;
		END IF;
	ElSE
		SET v_Message = 'Token Inválido.';
	END IF;
    SELECT v_Message;
END//
DELIMITER ;

--------------------------------------------- CREO EL SPB DE TipoRol ---------------------------------------------
-- Para llamar al metodo debo pasarle el id del tiporol que estoy queriendo inhabilitar y el token  --
-- CALL SPB_TipoRol(5,'ceci'); --
DELIMITER //
CREATE PROCEDURE `SPB_TipoRol`(
    IN p_Id INT, 
    IN p_UsuarioBearer TEXT(500)
)
BEGIN
    DECLARE v_IdUsuarioCarga INT;
    DECLARE v_Message VARCHAR(50);
    SET v_IdUsuarioCarga = FN_ObtenerUsuDesdeBearer(p_UsuarioBearer);

	IF v_IdUsuarioCarga IS NOT NULL THEN
		IF (SELECT COUNT(*) FROM TipoRol WHERE IdTipoRol = p_Id AND FechaBaja IS NULL) > 0 THEN
			UPDATE TipoRol 
			SET FechaBaja = NOW() 
			WHERE IdTipoRol = p_Id;
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
--------------------------------------------- CREO EL SPL DE TipoRol ---------------------------------------------
-- Para llamar al metodo debo pasarle el id del tipolista, endonde 1 es activo y 2 baja  --
-- CALL SPL_TipoRol(1) --
DELIMITER //
CREATE PROCEDURE `SPL_TipoRol`(
    IN TipoLista INT
)
BEGIN
    DECLARE Message VARCHAR(50);
    CREATE TEMPORARY TABLE IF NOT EXISTS TempResultados (
        IdTipoRol INT,
        Descripcion VARCHAR(50)
    );

    IF TipoLista = 1 THEN
        INSERT INTO TempResultados (IdTipoRol, Descripcion)
        SELECT IdTipoRol, Descripcion
        FROM TipoRol
        WHERE FechaBaja IS NULL;
    ELSEIF TipoLista = 2 THEN
        INSERT INTO TempResultados (IdTipoRol, Descripcion)
        SELECT IdTipoRol, Descripcion
        FROM TipoRol
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
--------------------------------------------- CREO EL SPL DE RolModulo ---------------------------------------------
-- Para llamar al metodo debo pasarle el id del tiporol y tipolista, donde 1 es activo y 2 es baja, para listar los roles por modulo.  --
-- CALL SPL_RolModulo(3, 5) --
DELIMITER //
CREATE PROCEDURE `SPL_RolModulo` (
    IN p_IdTipoRol INT,
    IN p_TipoLista INT
)
BEGIN
    CREATE TEMPORARY TABLE IF NOT EXISTS tmp_TablaFS_TipoRol (
        Id INT,
        IdTipoRol INT,
        TipoRol VARCHAR(50),
        IdTipoModulo INT,
        TipoModulo VARCHAR(50),
        IdTipoPermiso INT,
        TipoPermiso VARCHAR(50),
        FechaBaja VARCHAR(8)
    );
    INSERT INTO tmp_TablaFS_TipoRol (Id, IdTipoRol, TipoRol, IdTipoModulo, TipoModulo, IdTipoPermiso, TipoPermiso, FechaBaja)
    SELECT 
        a.IdRolModulo, a.IdTipoRol, b.Descripcion AS TipoRol, a.IdTipoModulo, c.Detalle AS TipoModulo, 
        a.IdTipoPermiso, d.Detalle AS TipoPermiso, DATE_FORMAT(a.FechaBaja, '%Y%m%d')
    FROM 
        RolModulo AS a 
    INNER JOIN 
        TipoRol AS b ON a.IdTipoRol = b.IdTipoRol
    INNER JOIN 
        TipoModulo AS c ON a.IdTipoModulo = c.IdTipoModulo
    INNER JOIN 
        TipoPermiso AS d ON a.IdTipoPermiso = d.IdTipoPermiso
    WHERE 
        (IFNULL(p_IdTipoRol, b.IdTipoRol) = b.IdTipoRol);

    IF p_TipoLista = 1 THEN
        DELETE FROM tmp_TablaFS_TipoRol WHERE FechaBaja IS NOT NULL;
    ELSEIF p_TipoLista = 2 THEN
        DELETE FROM tmp_TablaFS_TipoRol WHERE FechaBaja IS NULL;
	ELSE
		DELETE FROM tmp_TablaFS_TipoRol;
    END IF;

    SELECT * FROM tmp_TablaFS_TipoRol
    ORDER BY Id;
    
    DROP TEMPORARY TABLE IF EXISTS tmp_TablaFS_TipoRol;
END //

DELIMITER ;
--------------------------------------------- CREO EL SPA DE RolModulo ---------------------------------------------
-- Para llamar al metodo debo pasarle el id del tiporol que estoy queriendo inhabilitar y el token  --
-- CALL SPA_RolModulo(1, 4, 1, 'ceci') --
DELIMITER //
CREATE PROCEDURE SPA_RolModulo (
    IN v_IdTipoRol INT,
    IN v_IdTipoModulo INT,
    IN v_IdTipoPermiso INT,
    IN UsuarioBearer VARCHAR(500)
)
BEGIN
    DECLARE IdUsuarioCarga INT;
    DECLARE Message VARCHAR(50);
    SET IdUsuarioCarga = FN_ObtenerUsuDesdeBearer(UsuarioBearer);

    IF IdUsuarioCarga IS NOT NULL THEN
        -- Verificar si el tipo de rol proporcionado existe en la tabla TipoRol
        IF EXISTS (SELECT 1 FROM TipoRol WHERE IdTipoRol = v_IdTipoRol) THEN
            -- Verificar si el tipo de módulo proporcionado existe en la tabla TipoModulo
            IF EXISTS (SELECT 1 FROM TipoModulo WHERE IdTipoModulo = v_IdTipoModulo) THEN
                -- Verificar si el tipo de permiso proporcionado existe en la tabla TipoPermiso
                IF EXISTS (SELECT 1 FROM TipoPermiso WHERE IdTipoPermiso = v_IdTipoPermiso) THEN
                    -- Verificar si el registro ya existe
                    IF EXISTS (SELECT 1 FROM RolModulo WHERE IdTipoRol = v_IdTipoRol AND IdTipoModulo = v_IdTipoModulo AND IdTipoPermiso = v_IdTipoPermiso) THEN
                        SET Message = 'El rolModulo ya existe.';
                    ELSE
                        -- Insertar el nuevo registro
                        INSERT INTO RolModulo (IdTipoRol, IdTipoModulo, IdTipoPermiso) 
                        VALUES (v_IdTipoRol, v_IdTipoModulo, v_IdTipoPermiso);
                        SET Message = 'OK';
                    END IF;
                ELSE
                    SET Message = 'El nivel de permiso proporcionado no existe.';
                END IF;
            ELSE
                SET Message = 'El tipo de módulo proporcionado no existe.';
            END IF;
        ELSE
            SET Message = 'El tipo de rol proporcionado no existe.';
        END IF;
    ELSE
        SET Message = 'Token Inválido.';
    END IF;
    
    SELECT Message;
END //
DELIMITER ;
--------------------------------------------- CREO EL SPB DE RolModulo ---------------------------------------------
-- Para llamar al metodo debo pasarle el id del rolmodulo que estoy queriendo inhabilitar y el token  --
-- CALL SPB_RolModulo(1, 'ceAci') --
DELIMITER //
CREATE PROCEDURE SPB_RolModulo (
    IN p_Id INT, 
    IN p_UsuarioBearer TEXT(500)
)
BEGIN
    DECLARE v_IdUsuarioCarga INT;
    DECLARE v_Message VARCHAR(50);
    SET v_IdUsuarioCarga = FN_ObtenerUsuDesdeBearer(p_UsuarioBearer);

	IF v_IdUsuarioCarga IS NOT NULL THEN
		IF (SELECT COUNT(*) FROM RolModulo WHERE IdRolModulo = p_Id AND FechaBaja IS NULL) > 0 THEN
			UPDATE RolModulo 
			SET FechaBaja = NOW() 
			WHERE IdRolModulo = p_Id;
			SET v_Message = 'OK';
		ELSE 
			SET v_Message = 'El registro ya está deshabilitado o no existe';
		END IF;
	ElSE
		SET v_Message = 'Token Inválido';
	END IF;
    SELECT v_Message;
END //
DELIMITER ;
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
			SET v_Message = 'El TipoProducto ingresado no existe.';
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
--------------------------------------------- CREO EL SPL DE TipoCategoria ---------------------------------------------
-- Para llamar al metodo debo pasarle el tipo de lista, donde 1 es habilitado y 2 es inhabilitado --
-- CALL SPL_TipoCategoria(1) --
DELIMITER //
CREATE PROCEDURE `SPL_TipoCategoria`(
    IN TipoLista INT
)
BEGIN
    DECLARE Message VARCHAR(50);
    CREATE TEMPORARY TABLE IF NOT EXISTS TempResultados (
        IdTipoCategoria INT,
        Descripcion VARCHAR(50),
        FechaBaja datetime
    );

    IF TipoLista = 1 THEN
        INSERT INTO TempResultados (IdTipoCategoria, Descripcion, FechaBaja)
        SELECT IdTipoCategoria, Descripcion, FechaBaja
        FROM TipoCategoria
        WHERE FechaBaja IS NULL;
    ELSEIF TipoLista = 2 THEN
        INSERT INTO TempResultados (IdTipoCategoria, Descripcion, FechaBaja)
        SELECT IdTipoCategoria, Descripcion, FechaBaja
        FROM TipoCategoria
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
--------------------------------------------- CREO EL SPA DE TipoCategoria ---------------------------------------------
-- Para llamar al metodo debo pasarle la descripcion que estoy queriendo agregar y el token --
-- CALL SPA_TipoCategoria('Prueba2', 'ceci'); --
DELIMITER //
CREATE PROCEDURE `SPA_TipoCategoria`(
    IN p_Descripcion VARCHAR(50), 
    IN p_UsuarioBearer TEXT
)
BEGIN
    DECLARE v_IdUsuarioCarga INT;
    DECLARE v_Message VARCHAR(50);
    SET v_IdUsuarioCarga = FN_ObtenerUsuDesdeBearer(p_UsuarioBearer);
	IF v_IdUsuarioCarga IS NOT NULL THEN
		IF (SELECT COUNT(*) FROM TipoCategoria WHERE Descripcion = p_Descripcion) = 0 THEN
			INSERT INTO TipoCategoria (Descripcion, FechaBaja)
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

--------------------------------------------- CREO EL SPM DE TipoCategoria ---------------------------------------------
-- Para llamar al metodo debo pasarle el id del TipoCategoria que estoy queriendo modificar, el valor nuevo y el token  --
-- CALL SPM_TipoCategoria(1, 'PruebaAA', 'ceci'); --
DELIMITER //
CREATE PROCEDURE `SPM_TipoCategoria`(
	IN p_Id INT, 
    IN p_Descripcion VARCHAR(50), 
    IN p_UsuarioBearer text(500)
)
BEGIN
    DECLARE v_IdUsuarioCarga INT;
    DECLARE v_Message VARCHAR(50);
    DECLARE v_CountExistTipoCategoria INT;
    
    SET v_IdUsuarioCarga = FN_ObtenerUsuDesdeBearer(p_UsuarioBearer);
    SELECT COUNT(*) INTO v_CountExistTipoCategoria FROM TipoCategoria WHERE IdTipoCategoria = p_Id;
    
	IF v_IdUsuarioCarga IS NOT NULL THEN
		IF v_CountExistTipoCategoria = 0 THEN
			SET v_Message = 'El TipoCategoria ingresado no existe.';
		ELSE
			IF (SELECT COUNT(*) FROM TipoCategoria WHERE IdTipoCategoria = p_Id AND Descripcion = p_Descripcion) = 0 THEN
				IF (SELECT COUNT(*) FROM TipoCategoria WHERE IdTipoCategoria = p_Id AND FechaBaja IS NOT NULL) = 0 THEN
					UPDATE TipoCategoria 
					SET Descripcion = p_Descripcion, FechaBaja = NULL 
					WHERE IdTipoCategoria = p_Id;
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
--------------------------------------------- CREO EL SPB DE TipoCategoria ---------------------------------------------
-- Para llamar al metodo debo pasarle el id del TipoCategoria que estoy queriendo inhabilitar y el token  --
-- CALL SPB_TipoCategoria(4,'ceci'); --
DELIMITER //
CREATE PROCEDURE `SPB_TipoCategoria`(
    IN p_Id INT, 
    IN p_UsuarioBearer TEXT(500)
)
BEGIN
    DECLARE v_IdUsuarioCarga INT;
    DECLARE v_Message VARCHAR(50);
    SET v_IdUsuarioCarga = FN_ObtenerUsuDesdeBearer(p_UsuarioBearer);

	IF v_IdUsuarioCarga IS NOT NULL THEN
		IF (SELECT COUNT(*) FROM TipoCategoria WHERE IdTipoCategoria = p_Id AND FechaBaja IS NULL) > 0 THEN
			UPDATE TipoCategoria 
			SET FechaBaja = NOW() 
			WHERE IdTipoCategoria = p_Id;
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
--------------------------------------------- CREO EL SPH DE TipoCategoria ---------------------------------------------
-- Para llamar al metodo debo pasarle el id del TipoCategoria que estoy queriendo habilitar y el token  --
-- CALL SPH_TipoCategoria(4, 'ceci') --
DELIMITER //
CREATE PROCEDURE `SPH_TipoCategoria`(
    IN p_Id INT, 
    IN p_UsuarioBearer TEXT(500)
)
BEGIN
    DECLARE v_IdUsuarioCarga INT;
    DECLARE v_Message VARCHAR(50);
    SET v_IdUsuarioCarga = FN_ObtenerUsuDesdeBearer(p_UsuarioBearer);

	IF v_IdUsuarioCarga IS NOT NULL THEN
		IF (SELECT COUNT(*) FROM TipoCategoria WHERE IdTipoCategoria = p_Id AND FechaBaja IS NOT NULL) > 0 THEN
			UPDATE TipoCategoria 
			SET FechaBaja = NULL
			WHERE IdTipoCategoria = p_Id;
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
--------------------------------------------- CREO EL SPL DE TipoImpuesto ---------------------------------------------
-- Para llamar al metodo debo pasarle el tipo de lista, donde 1 es habilitado y 2 es inhabilitado --
-- CALL SPL_TipoImpuesto(1) --
DELIMITER //
CREATE PROCEDURE `SPL_TipoImpuesto`(
    IN TipoLista INT
)
BEGIN
    DECLARE Message VARCHAR(50);
    CREATE TEMPORARY TABLE IF NOT EXISTS TempResultados (
        IdTipoImpuesto INT,
        Detalle VARCHAR(50),
        Porcentaje DECIMAL(18,2),
        FechaBaja datetime
    );

    IF TipoLista = 1 THEN
        INSERT INTO TempResultados (IdTipoImpuesto, Detalle, Porcentaje, FechaBaja)
        SELECT IdTipoImpuesto, Detalle, Porcentaje, FechaBaja
        FROM TipoImpuesto
        WHERE FechaBaja IS NULL;
    ELSEIF TipoLista = 2 THEN
        INSERT INTO TempResultados (IdTipoImpuesto, Detalle, Porcentaje, FechaBaja)
        SELECT IdTipoImpuesto, Detalle, Porcentaje, FechaBaja
        FROM TipoImpuesto
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
--------------------------------------------- CREO EL SPA DE TipoImpuesto ---------------------------------------------
-- Para llamar al metodo debo pasarle la descripcion que estoy queriendo agregar y el token --
-- CALL SPA_TipoImpuesto('Ganancias Prueba', '25', 'ceci'); --
DELIMITER //
CREATE PROCEDURE `SPA_TipoImpuesto`(
    IN p_Descripcion VARCHAR(50), 
    IN p_Porcentaje DECIMAL(18,2), 
    IN p_UsuarioBearer TEXT
)
BEGIN
    DECLARE v_IdUsuarioCarga INT;
    DECLARE v_Message VARCHAR(50);
    SET v_IdUsuarioCarga = FN_ObtenerUsuDesdeBearer(p_UsuarioBearer);
	IF v_IdUsuarioCarga IS NOT NULL THEN
		IF (SELECT COUNT(*) FROM TipoImpuesto WHERE Detalle = p_Descripcion AND Porcentaje = p_Porcentaje) = 0 THEN
			INSERT INTO TipoImpuesto (Detalle, Porcentaje, FechaBaja)
			VALUES (p_Descripcion, p_Porcentaje, NULL);
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

--------------------------------------------- CREO EL SPM DE TipoImpuesto ---------------------------------------------
-- Para llamar al metodo debo pasarle el id del TipoImpuesto que estoy queriendo modificar, el valor nuevo y el token  --
-- CALL SPM_TipoImpuesto(1, 'PruebaAA', 21, 'ceci'); --
DELIMITER //
CREATE PROCEDURE `SPM_TipoImpuesto`(
	IN p_Id INT, 
    IN p_Descripcion VARCHAR(50),
    IN p_Porcentaje DECIMAL(18,2),
    IN p_UsuarioBearer text(500)
)
BEGIN
    DECLARE v_IdUsuarioCarga INT;
    DECLARE v_Message VARCHAR(50);
    DECLARE v_CountExistTipoImpuesto INT;
    
    SET v_IdUsuarioCarga = FN_ObtenerUsuDesdeBearer(p_UsuarioBearer);
    SELECT COUNT(*) INTO v_CountExistTipoImpuesto FROM TipoImpuesto WHERE IdTipoImpuesto = p_Id;
    
	IF v_IdUsuarioCarga IS NOT NULL THEN
		IF v_CountExistTipoImpuesto = 0 THEN
			SET v_Message = 'El TipoImpuesto ingresado no existe.';
		ELSE
			IF (SELECT COUNT(*) FROM TipoImpuesto WHERE IdTipoImpuesto = p_Id AND Detalle = p_Descripcion AND Porcentaje = p_Porcentaje) = 0 THEN
				IF (SELECT COUNT(*) FROM TipoImpuesto WHERE IdTipoImpuesto = p_Id AND FechaBaja IS NOT NULL) = 0 THEN
					UPDATE TipoImpuesto 
					SET Detalle = p_Descripcion, Porcentaje = p_Porcentaje, FechaBaja = NULL 
					WHERE IdTipoImpuesto = p_Id;
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
--------------------------------------------- CREO EL SPB DE TipoImpuesto ---------------------------------------------
-- Para llamar al metodo debo pasarle el id del TipoImpuesto que estoy queriendo inhabilitar y el token  --
-- CALL SPB_TipoImpuesto(4,'ceci'); --
DELIMITER //
CREATE PROCEDURE `SPB_TipoImpuesto`(
    IN p_Id INT, 
    IN p_UsuarioBearer TEXT(500)
)
BEGIN
    DECLARE v_IdUsuarioCarga INT;
    DECLARE v_Message VARCHAR(50);
    SET v_IdUsuarioCarga = FN_ObtenerUsuDesdeBearer(p_UsuarioBearer);

	IF v_IdUsuarioCarga IS NOT NULL THEN
		IF (SELECT COUNT(*) FROM TipoImpuesto WHERE IdTipoImpuesto = p_Id AND FechaBaja IS NULL) > 0 THEN
			UPDATE TipoImpuesto 
			SET FechaBaja = NOW() 
			WHERE IdTipoImpuesto = p_Id;
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
--------------------------------------------- CREO EL SPH DE TipoImpuesto ---------------------------------------------
-- Para llamar al metodo debo pasarle el id del TipoImpuesto que estoy queriendo habilitar y el token  --
-- CALL SPH_TipoImpuesto(4, 'ceci') --
DELIMITER //
CREATE PROCEDURE `SPH_TipoImpuesto`(
    IN p_Id INT, 
    IN p_UsuarioBearer TEXT(500)
)
BEGIN
    DECLARE v_IdUsuarioCarga INT;
    DECLARE v_Message VARCHAR(50);
    SET v_IdUsuarioCarga = FN_ObtenerUsuDesdeBearer(p_UsuarioBearer);

	IF v_IdUsuarioCarga IS NOT NULL THEN
		IF (SELECT COUNT(*) FROM TipoImpuesto WHERE IdTipoImpuesto = p_Id AND FechaBaja IS NOT NULL) > 0 THEN
			UPDATE TipoImpuesto 
			SET FechaBaja = NULL
			WHERE IdTipoImpuesto = p_Id;
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
--------------------------------------------- CREO EL SPL DE TipoFormaDePago ---------------------------------------------
-- Para llamar al metodo debo pasarle el parametro de lista, donde 1 es habilitado y 2 inhabilitado --
-- CALL SPL_TipoFormaDePago(1) --
DELIMITER //
CREATE PROCEDURE `SPL_TipoFormaDePago`(
    IN TipoLista INT
)
BEGIN
    DECLARE Message VARCHAR(50);
    CREATE TEMPORARY TABLE IF NOT EXISTS TempResultados (
        IdTipoFormaDePago INT,
        Descripcion VARCHAR(50),
        FechaBaja datetime
    );

    IF TipoLista = 1 THEN
        INSERT INTO TempResultados (IdTipoFormaDePago, Descripcion, FechaBaja)
        SELECT IdTipoFormaDePago, Descripcion, FechaBaja
        FROM TipoFormaDePago
        WHERE FechaBaja IS NULL;
    ELSEIF TipoLista = 2 THEN
        INSERT INTO TempResultados (IdTipoFormaDePago, Descripcion, FechaBaja)
        SELECT IdTipoFormaDePago, Descripcion, FechaBaja
        FROM TipoFormaDePago
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
--------------------------------------------- CREO EL SPA DE TipoFormaDePago ---------------------------------------------
-- Para llamar al metodo debo pasarle la descripcion que estoy queriendo agregar y el token --
-- CALL SPA_TipoFormaDePago('Prueba', 'ceci'); --
DELIMITER //
CREATE PROCEDURE `SPA_TipoFormaDePago`(
    IN p_Descripcion VARCHAR(50), 
    IN p_UsuarioBearer TEXT
)
BEGIN
    DECLARE v_IdUsuarioCarga INT;
    DECLARE v_Message VARCHAR(50);
    SET v_IdUsuarioCarga = FN_ObtenerUsuDesdeBearer(p_UsuarioBearer);
	IF v_IdUsuarioCarga IS NOT NULL THEN
		IF (SELECT COUNT(*) FROM TipoFormaDePago WHERE Descripcion = p_Descripcion) = 0 THEN
			INSERT INTO TipoFormaDePago (Descripcion, FechaBaja)
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
--------------------------------------------- CREO EL SPM DE TipoFormaDePago ---------------------------------------------
-- Para llamar al metodo debo pasarle el id del TipoFormaDePago que estoy queriendo modificar, el valor nuevo y el token  --
-- CALL SPM_TipoFormaDePago(8, 'AA', 'ceci'); --
DELIMITER //
CREATE PROCEDURE `SPM_TipoFormaDePago`(
	IN p_Id INT, 
    IN p_Descripcion VARCHAR(50), 
    IN p_UsuarioBearer text(500)
)
BEGIN
    DECLARE v_IdUsuarioCarga INT;
    DECLARE v_Message VARCHAR(50);
    DECLARE v_CountExistTipoFormaDePago INT;
    
    SET v_IdUsuarioCarga = FN_ObtenerUsuDesdeBearer(p_UsuarioBearer);
    SELECT COUNT(*) INTO v_CountExistTipoFormaDePago FROM TipoFormaDePago WHERE IdTipoFormaDePago = p_Id;
    
	IF v_IdUsuarioCarga IS NOT NULL THEN
		IF v_CountExistTipoFormaDePago = 0 THEN
			SET v_Message = 'El TipoFormaDePago ingresado no existe.';
		ELSE
			IF (SELECT COUNT(*) FROM TipoFormaDePago WHERE IdTipoFormaDePago = p_Id AND Descripcion = p_Descripcion) = 0 THEN
				IF (SELECT COUNT(*) FROM TipoFormaDePago WHERE IdTipoFormaDePago = p_Id AND FechaBaja IS NOT NULL) = 0 THEN
					UPDATE TipoFormaDePago 
					SET Descripcion = p_Descripcion, FechaBaja = NULL 
					WHERE IdTipoFormaDePago = p_Id;
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
--------------------------------------------- CREO EL SPB DE TipoFormaDePago ---------------------------------------------
-- Para llamar al metodo debo pasarle el id del TipoFormaDePago que estoy queriendo inhabilitar y el token  --
-- CALL SPB_TipoFormaDePago(8,'ceci'); --
DELIMITER //
CREATE PROCEDURE `SPB_TipoFormaDePago`(
    IN p_Id INT, 
    IN p_UsuarioBearer TEXT(500)
)
BEGIN
    DECLARE v_IdUsuarioCarga INT;
    DECLARE v_Message VARCHAR(50);
    SET v_IdUsuarioCarga = FN_ObtenerUsuDesdeBearer(p_UsuarioBearer);

	IF v_IdUsuarioCarga IS NOT NULL THEN
		IF (SELECT COUNT(*) FROM TipoFormaDePago WHERE IdTipoFormaDePago = p_Id AND FechaBaja IS NULL) > 0 THEN
			UPDATE TipoFormaDePago 
			SET FechaBaja = NOW() 
			WHERE IdTipoFormaDePago = p_Id;
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
--------------------------------------------- CREO EL SPH DE TipoFormaDePago ---------------------------------------------
-- Para llamar al metodo debo pasarle el id del TipoFormaDePago que estoy queriendo habilitar y el token  --
-- CALL SPH_TipoFormaDePago(8, 'ceci') --
DELIMITER //
CREATE PROCEDURE `SPH_TipoFormaDePago`(
    IN p_Id INT, 
    IN p_UsuarioBearer TEXT(500)
)
BEGIN
    DECLARE v_IdUsuarioCarga INT;
    DECLARE v_Message VARCHAR(50);
    SET v_IdUsuarioCarga = FN_ObtenerUsuDesdeBearer(p_UsuarioBearer);

	IF v_IdUsuarioCarga IS NOT NULL THEN
		IF (SELECT COUNT(*) FROM TipoFormaDePago WHERE IdTipoFormaDePago = p_Id AND FechaBaja IS NOT NULL) > 0 THEN
			UPDATE TipoFormaDePago 
			SET FechaBaja = NULL
			WHERE IdTipoFormaDePago = p_Id;
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





