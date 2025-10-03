USE NBA_ORLANDOMAGIC
GO

-- Borramos si existe una previa
IF OBJECT_ID('dbo.stg_injuries', 'U') IS NOT NULL
    DROP TABLE dbo.stg_injuries;

-- Creamos tabla staging
CREATE TABLE dbo.stg_injuries (
    [Date]           VARCHAR(50),
    [Team]           VARCHAR(50),
    [name_clean]     VARCHAR(100),
    [Status]         VARCHAR(50),
    [InjuryCategory] VARCHAR(100)
);
USE NBA;

BULK INSERT dbo.stg_injuries
FROM 'C:\Users\elian\OneDrive\Escritorio\NBA_ComposicionCorporal_Rendimiento\data_clean\nba_injuries_ready.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,               -- saltea la fila de encabezados
    FIELDTERMINATOR = ',',      -- separador de columnas
    ROWTERMINATOR = '\n',       -- salto de línea
    TABLOCK
);

-- Primeras filas
SELECT TOP 10 * FROM dbo.stg_injuries;

-- Recuento de registros
SELECT COUNT(*) AS total_filas FROM dbo.stg_injuries;

USE NBA;

-- Si ya existe, la borramos
IF OBJECT_ID('dbo.dim_injury_category', 'U') IS NOT NULL
    DROP TABLE dbo.dim_injury_category;

-- Creamos la tabla de categorías limpias
CREATE TABLE dbo.dim_injury_category (
    injury_category_id INT IDENTITY(1,1) PRIMARY KEY,
    injury_category    VARCHAR(100)
);

-- Insertamos categorías únicas, dividiendo cuando hay "/"
INSERT INTO dbo.dim_injury_category (injury_category)
SELECT DISTINCT LTRIM(RTRIM(value)) AS injury_category
FROM dbo.stg_injuries
CROSS APPLY STRING_SPLIT(InjuryCategory, '/');


-- Borramos si ya existiera
IF OBJECT_ID('dbo.dim_injury_category', 'U') IS NOT NULL
    DROP TABLE dbo.dim_injury_category;

-- Creamos la tabla vacía
CREATE TABLE dbo.dim_injury_category (
    injury_category_id INT IDENTITY(1,1) PRIMARY KEY,
    injury_category    VARCHAR(100)
);

SELECT TOP 10 * 
FROM dbo.dim_injury_category;

SELECT TOP 20 InjuryCategory
FROM dbo.stg_injuries
WHERE InjuryCategory IS NOT NULL;

