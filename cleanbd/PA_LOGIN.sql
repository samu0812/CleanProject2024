-- Procedimientos Almacenados para el Login--
use cleanbd;
DROP PROCEDURE IF EXISTS ValidarUsuario;
-- Procedimiento Almacenado que Valida que el usuario este registrado en nuestro sistema--
DELIMITER //

CREATE PROCEDURE `ValidarUsuario` (IN p_usuario VARCHAR(45), IN p_clave VARCHAR(255), OUT p_resultado BOOLEAN)
BEGIN
    DECLARE v_count INT;

    -- Deshashear la contraseña proporcionada
    DECLARE v_hashed_clave VARCHAR(255);
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


-- Llamando al Procedimientos Almacenados Login
CALL ValidarUsuario('lautaro', '1232', @resultado);
SELECT @resultado;



