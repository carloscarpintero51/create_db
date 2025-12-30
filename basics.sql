-- ============================================
-- GESTIÓN DE BASES DE DATOS
-- ============================================

-- Crear base de datos
CREATE DATABASE MiBaseDatos;

-- Eliminar base de datos (primero asegurarse de no estar usándola)
USE master;
DROP DATABASE MiBaseDatos;

-- Eliminar base de datos solo si existe
IF EXISTS (SELECT * FROM sys.databases WHERE name = 'MiBaseDatos')
    DROP DATABASE MiBaseDatos;

-- Cambiar a una base de datos
USE MiBaseDatos;


-- ============================================
-- GESTIÓN DE TABLAS
-- ============================================

-- Crear tabla
CREATE TABLE Productos (
    ProductoID INT IDENTITY(1,1) PRIMARY KEY,
    Nombre NVARCHAR(100) NOT NULL,
    Precio DECIMAL(10,2) NOT NULL,
    Stock INT DEFAULT 0
);

-- Eliminar tabla
DROP TABLE Productos;

-- Eliminar tabla solo si existe
IF OBJECT_ID('Productos', 'U') IS NOT NULL
    DROP TABLE Productos;

-- Vaciar tabla (elimina todos los registros pero mantiene la estructura)
TRUNCATE TABLE Productos;  -- Más rápido, no se puede deshacer fácilmente

-- O usar DELETE (más lento pero con más control)
DELETE FROM Productos;  -- Elimina todos los registros

-- Renombrar tabla
EXEC sp_rename 'Productos', 'ProductosNuevo';


-- ============================================
-- MODIFICAR ESTRUCTURA DE TABLA
-- ============================================

-- Agregar columna
ALTER TABLE Productos 
ADD Descripcion NVARCHAR(500) NULL;

-- Eliminar columna
ALTER TABLE Productos 
DROP COLUMN Descripcion;

-- Modificar columna
ALTER TABLE Productos 
ALTER COLUMN Nombre NVARCHAR(200) NOT NULL;

-- Agregar constraint
ALTER TABLE Productos 
ADD CONSTRAINT CK_Precio_Positivo CHECK (Precio > 0);

-- Eliminar constraint
ALTER TABLE Productos 
DROP CONSTRAINT CK_Precio_Positivo;


-- ============================================
-- INSERTAR REGISTROS
-- ============================================

-- Insertar un registro
INSERT INTO Productos (Nombre, Precio, Stock)
VALUES ('Laptop', 1200.00, 10);

-- Insertar múltiples registros
INSERT INTO Productos (Nombre, Precio, Stock)
VALUES 
    ('Mouse', 25.50, 50),
    ('Teclado', 45.00, 30),
    ('Monitor', 350.00, 15);

-- Insertar desde otra tabla
INSERT INTO ProductosArchivo (Nombre, Precio)
SELECT Nombre, Precio FROM Productos WHERE Stock = 0;


-- ============================================
-- ACTUALIZAR REGISTROS
-- ============================================

-- Actualizar un registro específico
UPDATE Productos 
SET Precio = 1150.00 
WHERE ProductoID = 1;

-- Actualizar múltiples campos
UPDATE Productos 
SET Precio = 1150.00, 
    Stock = 15 
WHERE ProductoID = 1;

-- Actualizar con condiciones
UPDATE Productos 
SET Precio = Precio * 1.10  -- Incrementar 10%
WHERE Stock > 20;

-- Actualizar todos los registros (¡CUIDADO!)
UPDATE Productos 
SET Stock = 0;


-- ============================================
-- ELIMINAR REGISTROS
-- ============================================

-- Eliminar un registro específico
DELETE FROM Productos 
WHERE ProductoID = 1;

-- Eliminar con condiciones
DELETE FROM Productos 
WHERE Stock = 0;

-- Eliminar con múltiples condiciones
DELETE FROM Productos 
WHERE Stock = 0 AND Precio < 50;

-- Eliminar todos los registros (más lento que TRUNCATE)
DELETE FROM Productos;


-- ============================================
-- CONSULTAS SELECT
-- ============================================

-- Consultar todos los registros
SELECT * FROM Productos;

-- Consultar columnas específicas
SELECT Nombre, Precio FROM Productos;

-- Consultar con filtros
SELECT * FROM Productos 
WHERE Precio > 100;

-- Consultar con ordenamiento
SELECT * FROM Productos 
ORDER BY Precio DESC;

-- Consultar con límite de resultados (TOP)
SELECT TOP 5 * FROM Productos 
ORDER BY Precio DESC;

-- Consultar con condiciones múltiples
SELECT * FROM Productos 
WHERE Precio > 50 AND Stock > 10;

-- Buscar texto parcial
SELECT * FROM Productos 
WHERE Nombre LIKE '%Laptop%';

-- Consultar valores únicos
SELECT DISTINCT Precio FROM Productos;


-- ============================================
-- TRANSACCIONES (Control de cambios)
-- ============================================

-- Iniciar transacción
BEGIN TRANSACTION;

    UPDATE Productos SET Stock = Stock - 1 WHERE ProductoID = 1;
    INSERT INTO Ventas (ProductoID, Cantidad) VALUES (1, 1);

-- Confirmar cambios
COMMIT TRANSACTION;

-- O deshacer cambios si algo salió mal
-- ROLLBACK TRANSACTION;


-- ============================================
-- GESTIÓN DE ÍNDICES
-- ============================================

-- Crear índice
CREATE INDEX IX_Productos_Nombre ON Productos(Nombre);

-- Crear índice único
CREATE UNIQUE INDEX IX_Productos_Codigo ON Productos(Codigo);

-- Eliminar índice
DROP INDEX IX_Productos_Nombre ON Productos;

-- Ver índices de una tabla
EXEC sp_helpindex 'Productos';


-- ============================================
-- INFORMACIÓN Y CONSULTAS DEL SISTEMA
-- ============================================

-- Ver todas las bases de datos
SELECT name FROM sys.databases;

-- Ver todas las tablas de la base de datos actual
SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES 
WHERE TABLE_TYPE = 'BASE TABLE';

-- Ver estructura de una tabla
EXEC sp_help 'Productos';

-- Ver columnas de una tabla
SELECT COLUMN_NAME, DATA_TYPE, IS_NULLABLE 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'Productos';

-- Contar registros
SELECT COUNT(*) AS TotalRegistros FROM Productos;

-- Ver espacio usado por una tabla
EXEC sp_spaceused 'Productos';


-- ============================================
-- RESPALDO Y RESTAURACIÓN
-- ============================================

-- Crear respaldo completo
BACKUP DATABASE MiBaseDatos 
TO DISK = 'C:\Backup\MiBaseDatos.bak';

-- Restaurar base de datos
RESTORE DATABASE MiBaseDatos 
FROM DISK = 'C:\Backup\MiBaseDatos.bak' 
WITH REPLACE;


-- ============================================
-- OPERACIONES AVANZADAS
-- ============================================

-- Agregar columna con valor calculado
ALTER TABLE Productos 
ADD PrecioConIVA AS (Precio * 1.13);

-- Reiniciar contador IDENTITY
DBCC CHECKIDENT ('Productos', RESEED, 0);

-- Verificar integridad de la base de datos
DBCC CHECKDB('MiBaseDatos');