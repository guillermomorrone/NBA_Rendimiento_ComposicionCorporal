USE NBA_ORLANDOMAGIC;
GO

-- Borramos si ya existía
IF OBJECT_ID('dbo.dim_date', 'U') IS NOT NULL
    DROP TABLE dbo.dim_date;

-- Creamos tabla
CREATE TABLE dbo.dim_date (
    date_id INT PRIMARY KEY,     -- formato YYYYMMDD
    full_date DATE NOT NULL,     -- fecha completa
    year INT,
    month INT,
    day INT,
    month_name VARCHAR(20),
    quarter INT,
    day_of_week INT,
    day_name VARCHAR(20)
);

-- Insertamos fechas desde 1947 hasta 2030
;WITH DateSequence AS (
    SELECT CAST('1947-01-01' AS DATE) AS d
    UNION ALL
    SELECT DATEADD(DAY, 1, d)
    FROM DateSequence
    WHERE d < '2030-12-31'
)
INSERT INTO dbo.dim_date (date_id, full_date, year, month, day, month_name, quarter, day_of_week, day_name)
SELECT 
    CONVERT(INT, FORMAT(d, 'yyyyMMdd')) AS date_id,
    d AS full_date,
    YEAR(d) AS year,
    MONTH(d) AS month,
    DAY(d) AS day,
    DATENAME(MONTH, d) AS month_name,
    DATEPART(QUARTER, d) AS quarter,
    DATEPART(WEEKDAY, d) AS day_of_week,
    DATENAME(WEEKDAY, d) AS day_name
FROM DateSequence
OPTION (MAXRECURSION 0);


