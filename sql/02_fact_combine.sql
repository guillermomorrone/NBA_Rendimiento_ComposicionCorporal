USE NBA_ORLANDOMAGIC;
GO

-- 1. Crear tabla fact_combine (si ya existe, borrarla)
IF OBJECT_ID('fact_combine', 'U') IS NOT NULL
    DROP TABLE fact_combine;
GO

CREATE TABLE fact_combine (
    season INT,
    player_id INT,
    player_name_clean NVARCHAR(150),
    position_all NVARCHAR(50),
    position_main NVARCHAR(50),
    height_wo_shoes_m FLOAT,
    height_w_shoes_m FLOAT,
    weight_kg FLOAT,
    wingspan_m FLOAT,
    standing_reach_m FLOAT,
    body_fat_pct FLOAT,
    standing_vertical_leap_cm FLOAT,
    max_vertical_leap_cm FLOAT,
    lane_agility_time FLOAT,
    modified_lane_agility_time FLOAT,
    three_quarter_sprint FLOAT,
    bench_press FLOAT,
    fat_mass_kg FLOAT,
    fat_free_mass_kg FLOAT
);

-- 2. Insertar datos desde staging
INSERT INTO fact_combine (
    season, player_id, player_name_clean, position_all, position_main,
    height_wo_shoes_m, height_w_shoes_m, weight_kg, wingspan_m, standing_reach_m,
    body_fat_pct, standing_vertical_leap_cm, max_vertical_leap_cm,
    lane_agility_time, modified_lane_agility_time, three_quarter_sprint, bench_press,
    fat_mass_kg, fat_free_mass_kg
)
SELECT
    TRY_CAST(season AS INT),
    TRY_CAST(player_id AS INT),
    player_name_clean,
    position_all,
    position_main,
    TRY_CAST(height_wo_shoes_m AS FLOAT),
    TRY_CAST(height_w_shoes_m AS FLOAT),
    TRY_CAST(weight_kg AS FLOAT),
    TRY_CAST(wingspan_m AS FLOAT),
    TRY_CAST(standing_reach_m AS FLOAT),
    TRY_CAST(body_fat_pct AS FLOAT),
    TRY_CAST(standing_vertical_leap_cm AS FLOAT),
    TRY_CAST(max_vertical_leap_cm AS FLOAT),
    TRY_CAST(lane_agility_time AS FLOAT),
    TRY_CAST(modified_lane_agility_time AS FLOAT),
    TRY_CAST(three_quarter_sprint AS FLOAT),
    TRY_CAST(bench_press AS FLOAT),
    TRY_CAST(fat_mass_kg AS FLOAT),
    TRY_CAST(fat_free_mass_kg AS FLOAT)
FROM stg_combine;

-- 3. Validaciones
SELECT COUNT(*) AS total_registros FROM fact_combine;
SELECT TOP 10 * FROM fact_combine;
