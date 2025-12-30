-- Crear la base de datos
CREATE DATABASE EjemploEmpresa;
GO

-- Usar la base de datos
USE EjemploEmpresa;
GO

-- Crear tabla (v2)
CREATE TABLE Empleados
(
    -- ID como clave primaria con autoincremento
    EmpleadoID INT IDENTITY(1,1) PRIMARY KEY,

    -- Datos personales
    Nombre NVARCHAR(100) NOT NULL,
    Apellido NVARCHAR(100) NOT NULL,
    Email VARCHAR(255) NOT NULL UNIQUE,
    Telefono VARCHAR(20) NULL,

    -- Datos numericos
    Edad TINYINT NULL,
    Salario DECIMAL(18,2) NOT NULL,
    Comision DECIMAL(5,2) NULL,

    -- Datos de fecha y hora
    FechaNacimiento DATE NULL,
    FechaContratacion DATETIME2 NOT NULL DEFAULT GETDATE(),
    UltimaActualizacion DATETIME2 NULL,

    -- Datos logicos
    Activo BIT NOT NULL DEFAULT 1,
    TieneSeguro BIT NOT NULL DEFAULT 0,

    -- Datos de texto largo
    Observaciones NVARCHAR(MAX) NULL,

    -- Identificador único global
    EmpleadoGUID UNIQUEIDENTIFIER DEFAULT NEWID(),

    -- Campos de auditoría
    CreadoPor NVARCHAR(100) NOT NULL DEFAULT SUSER_SNAME(),
    FechaCreacion DATETIME2 NOT NULL DEFAULT GETDATE(),
    ModificadoPor NVARCHAR(100) NULL,
    FechaModificacion DATETIME2 NULL
);
GO

-- Crear índices adicionales para mejorar el rendimiento
CREATE INDEX IX_Empleados_Email ON Empleados(Email);
CREATE INDEX IX_Empleados_FechaContratacion ON Empleados(FechaContratacion);
CREATE INDEX IX_Empleados_Activo ON Empleados(Activo) WHERE Activo = 1;
GO

-- Insertar datos de ejemplo
INSERT INTO Empleados
    (Nombre, Apellido, Email, Telefono, Edad, Salario, Comision,
    FechaNacimiento, TieneSeguro, Observaciones)
VALUES
    ('Juan', 'Pérez', 'juan.perez@empresa.com', '555-1234', 30, 2500.00, 5.50,
        '1994-05-15', 1, 'Empleado del área de ventas'),
    ('María', 'González', 'maria.gonzalez@empresa.com', '555-5678', 28, 3000.00, NULL,
        '1996-08-20', 1, NULL),
    ('Carlos', 'Rodríguez', 'carlos.rodriguez@empresa.com', NULL, 35, 3500.50, 7.25,
        '1989-03-10', 0, 'Jefe de departamento');
GO

-- Consultar los datos
SELECT *
FROM Empleados;


-- Crear tabla (v1)
CREATE TABLE dbo.Employees
(
    -- Clave primaria autoincremental
    EmployeeID INT IDENTITY(1,1) NOT NULL,

    -- Texto corto
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,

    -- Texto largo
    Email VARCHAR(150) NOT NULL,

    -- Valores numericos
    Age TINYINT NULL,
    Salary DECIMAL(10,2) NULL,

    -- Booleanos
    IsActive BIT NOT NULL DEFAULT 1,

    -- Fechas
    BirthDate DATE NULL,
    CreatedAt DATETIME2(0) NOT NULL DEFAULT SYSDATETIME(),

    -- Identificadores unicos
    EmployeeUUID UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),

    -- Clave primaria (indice clustered por defecto)
    CONSTRAINT PK_Employees PRIMARY KEY CLUSTERED (EmployeeID)
);