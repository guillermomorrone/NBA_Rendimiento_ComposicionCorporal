USE NBA_ORLANDOMAGIC
GO

IF OBJECT_ID('dbo.player_data_ready_raw', 'U') IS NOT NULL
    DROP TABLE dbo.player_data_ready_raw;
GO

IF OBJECT_ID('dbo.player_data_ready_raw', 'U') IS NOT NULL
    DROP TABLE dbo.player_data_ready_raw;
GO

CREATE TABLE dbo.player_data_ready_raw (
    name               VARCHAR(200) NULL,
    year_start         VARCHAR(50) NULL,
    year_end           VARCHAR(50) NULL,
    birth_date         VARCHAR(50) NULL,
    college            VARCHAR(200) NULL,
    player_name_clean  VARCHAR(200) NULL,
    height_m           VARCHAR(50) NULL,
    weight_kg          VARCHAR(50) NULL,
    age_at_debut       VARCHAR(50) NULL,
    age_at_last_season VARCHAR(50) NULL,
    position_all       VARCHAR(50) NULL,
    position_main      VARCHAR(50) NULL,
    BMI                VARCHAR(50) NULL,
    body_fat_pct_est   VARCHAR(50) NULL,
    fat_mass_kg        VARCHAR(50) NULL,
    lean_mass_kg       VARCHAR(50) NULL
);
GO

BULK INSERT dbo.player_data_ready_raw
FROM 'C:\Users\elian\OneDrive\Escritorio\NBA_ComposicionCorporal_Rendimiento\data_clean\player_data_ready.csv'
WITH (
    FIRSTROW = 2,              -- salta la fila de encabezados
    FIELDTERMINATOR = ',',     -- separador de columnas
    ROWTERMINATOR = '\n',      -- fin de fila
    TABLOCK,
    CODEPAGE = '65001'         -- asegura UTF-8
);
GO --(4550 rows affected)

-- Limpiar la STAGING antes de cargar
TRUNCATE TABLE dbo.stg_player_biometry;
GO

-- Insert con TRY_CAST para evitar errores de conversión
INSERT INTO dbo.stg_player_biometry (
    name, year_start, year_end, birth_date, college, player_name_clean,
    height_m, weight_kg, age_at_debut, age_at_last_season,
    position_all, position_main, BMI, body_fat_pct_est, fat_mass_kg, lean_mass_kg
)
SELECT 
    name,
    TRY_CAST(NULLIF(year_start,'') AS INT),
    TRY_CAST(NULLIF(year_end,'') AS INT),
    TRY_CAST(NULLIF(birth_date,'') AS DATE),
    college,
    player_name_clean,
    TRY_CAST(NULLIF(height_m,'') AS FLOAT),
    TRY_CAST(NULLIF(weight_kg,'') AS FLOAT),
    TRY_CAST(NULLIF(age_at_debut,'') AS INT),
    TRY_CAST(NULLIF(age_at_last_season,'') AS INT),
    position_all,
    position_main,
    TRY_CAST(NULLIF(BMI,'') AS FLOAT),
    TRY_CAST(NULLIF(body_fat_pct_est,'') AS FLOAT),
    TRY_CAST(NULLIF(fat_mass_kg,'') AS FLOAT),
    TRY_CAST(NULLIF(lean_mass_kg,'') AS FLOAT)
FROM dbo.player_data_ready_raw;
GO


SELECT TOP 20 * FROM dbo.stg_player_biometry;
SELECT COUNT(*) AS total_registros FROM dbo.stg_player_biometry;

IF OBJECT_ID('dbo.fact_biometry', 'U') IS NOT NULL
    DROP TABLE dbo.fact_biometry;
GO

CREATE TABLE dbo.fact_biometry (
    fact_biometry_id   INT IDENTITY(1,1) PRIMARY KEY,
    player_id          INT NOT NULL,       -- FK → dim_player
    year_start         INT NULL,
    year_end           INT NULL,
    birth_date         DATE NULL,
    college            VARCHAR(150) NULL,
    height_m           FLOAT NULL,
    weight_kg          FLOAT NULL,
    age_at_debut       INT NULL,
    age_at_last_season INT NULL,
    position_all       VARCHAR(20) NULL,
    position_main      VARCHAR(20) NULL,
    BMI                FLOAT NULL,
    body_fat_pct_est   FLOAT NULL,
    fat_mass_kg        FLOAT NULL,
    lean_mass_kg       FLOAT NULL
);
GO

INSERT INTO dbo.fact_biometry (
    player_id, year_start, year_end, birth_date, college,
    height_m, weight_kg, age_at_debut, age_at_last_season,
    position_all, position_main, BMI, body_fat_pct_est, fat_mass_kg, lean_mass_kg
)
SELECT 
    dp.player_id,               -- clave de jugador
    stg.year_start,
    stg.year_end,
    stg.birth_date,
    stg.college,
    stg.height_m,
    stg.weight_kg,
    stg.age_at_debut,
    stg.age_at_last_season,
    stg.position_all,
    stg.position_main,
    stg.BMI,
    stg.body_fat_pct_est,
    stg.fat_mass_kg,
    stg.lean_mass_kg
FROM dbo.stg_player_biometry stg
JOIN dbo.dim_player dp
    ON dp.player_name = stg.player_name_clean;   -- match por nombre limpio
GO -- (3294 rows affected)

SELECT TOP 20 * FROM dbo.fact_biometry;
SELECT COUNT(*) AS total_registros FROM dbo.fact_biometry;



