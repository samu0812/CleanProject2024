SELECT * FROM cleanbd.usuario;

-- Insertar el usuario asociado a esta persona
INSERT INTO Usuario (IdPersona, Usuario, Clave, IdUsuarioCarga, FechaAlta)
VALUES (@id_persona, 'lautaro', SHA2('123', 256), 'admin', NOW());