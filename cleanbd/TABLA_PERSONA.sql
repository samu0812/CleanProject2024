SELECT * FROM cleanbd.persona;


-- Insertar una nueva persona
INSERT INTO Persona (IdTipoPersonaSistema, IdTipoDocumentacion, IdTipoPersona, IdDomicilio, IdProvincia, Nombre, Apellido, Mail, RazonSocial, FechaNacimiento, Telefono, FechaAlta)
VALUES (1, 1, 1, 1, 1, 'lautaro', 'britez', 'lautaro@example.com', 'Lautaro Britez', '1990-01-01', '123456789', NOW());



