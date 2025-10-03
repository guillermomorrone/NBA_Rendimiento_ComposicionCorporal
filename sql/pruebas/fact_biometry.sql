-- ========================================================
-- FACT BIOMETRY
-- Crea la tabla de hechos para composición corporal
-- Fuente: stg_player_biometry
-- Relación: FK con dim_player (player_id)
-- ========================================================

-- Borrar si ya existe
IF OBJECT_ID('dbo.fact_biometry', 'U') IS NOT NULL
    DROP TABLE dbo.fact_biometry;
GO

-- Crear tabla fact_biometry
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

-- Poblar fact_biometry desde la staging
INSERT INTO dbo.fact_biometry (
    player_id, year_start, year_end, birth_date, college,
    height_m, weight_kg, age_at_debut, age_at_last_season,
    position_all, position_main, BMI, body_fat_pct_est, fat_mass_kg, lean_mass_kg
)
SELECT 
    dp.player_id,
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
    ON dp.player_name = stg.player_name_clean;
GO

-- Validación
SELECT TOP 20 * FROM dbo.fact_biometry;
SELECT COUNT(*) AS total_registros FROM dbo.fact_biometry;
GO
