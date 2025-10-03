USE NBA_ORLANDOMAGIC;
GO

-- Si ya existiera, la eliminamos para recrearla limpia
IF OBJECT_ID('fact_combine', 'U') IS NOT NULL
    DROP TABLE fact_combine;

CREATE TABLE fact_combine (
    combine_id INT IDENTITY(1,1) PRIMARY KEY,   -- identificador único
    player_id INT NOT NULL,                     -- FK a dim_player
    season INT,                                 -- año del Combine

    -- Medidas físicas
    height_wo_shoes_cm DECIMAL(5,2),
    height_w_shoes_cm DECIMAL(5,2),
    wingspan_cm DECIMAL(5,2),
    standing_reach_cm DECIMAL(5,2),
    weight_kg DECIMAL(5,2),

    -- Composición corporal
    body_fat_pct DECIMAL(5,2),
    fat_mass_kg DECIMAL(5,2),
    fat_free_mass_kg DECIMAL(5,2),

    -- Rendimiento físico
    bench_press_reps INT,
    standing_vertical_leap_cm DECIMAL(5,2),
    max_vertical_leap_cm DECIMAL(5,2),
    lane_agility_time DECIMAL(5,2),
    three_quarter_sprint_time DECIMAL(5,2),

    FOREIGN KEY (player_id) REFERENCES dim_player(player_id)
);


SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'stg_combine';

INSERT INTO fact_combine (
    player_id, season,
    height_wo_shoes_cm, height_w_shoes_cm, wingspan_cm, standing_reach_cm, weight_kg,
    body_fat_pct, fat_mass_kg, fat_free_mass_kg,
    bench_press_reps, standing_vertical_leap_cm, max_vertical_leap_cm,
    lane_agility_time, three_quarter_sprint_time
)
SELECT
    TRY_CAST(player_id AS INT),
    TRY_CAST(season AS INT),
    TRY_CAST(height_wo_shoes_m AS DECIMAL(5,2)),       -- altura sin zapatillas
    TRY_CAST(height_w_shoes_m AS DECIMAL(5,2)),        -- altura con zapatillas
    TRY_CAST(wingspan_m AS DECIMAL(5,2)),              -- envergadura
    TRY_CAST(standing_reach_m AS DECIMAL(5,2)),        -- alcance
    TRY_CAST(weight_kg AS DECIMAL(5,2)),               -- peso en kg
    TRY_CAST(body_fat_pct AS DECIMAL(5,2)),            -- % grasa
    TRY_CAST(fat_mass_kg AS DECIMAL(5,2)),             -- masa grasa
    TRY_CAST(fat_free_mass_kg AS DECIMAL(5,2)),        -- masa libre de grasa
    TRY_CAST(bench_press AS INT),                      -- repeticiones press banca
    TRY_CAST(standing_vertical_leap_cm AS DECIMAL(5,2)), -- salto vertical estático
    TRY_CAST(max_vertical_leap_cm AS DECIMAL(5,2)),      -- salto vertical máximo
    TRY_CAST(lane_agility_time AS DECIMAL(5,2)),         -- agilidad
    TRY_CAST(three_quarter_sprint AS DECIMAL(5,2))       -- sprint 3/4 de cancha
FROM stg_combine;

SELECT COUNT(*) AS total_registros FROM fact_combine;
SELECT TOP 20 * FROM fact_combine;

-- Total de filas en staging
SELECT COUNT(*) AS total_staging 
FROM stg_combine;

-- Cuántos jugadores tienen match en dim_player
SELECT COUNT(*) AS en_dim_player
FROM stg_combine s
JOIN dim_player d 
    ON TRY_CAST(s.player_id AS INT) = d.player_id;

-- Cuántos jugadores NO están en dim_player
SELECT COUNT(*) AS fuera_dim_player
FROM stg_combine s
LEFT JOIN dim_player d 
    ON TRY_CAST(s.player_id AS INT) = d.player_id
WHERE d.player_id IS NULL;

-- Ver cuántas filas hay en cada tabla que empieza con "stg" o combine
SELECT t.name AS table_name, p.rows AS total_rows
FROM sys.tables t
JOIN sys.partitions p ON t.object_id = p.object_id
WHERE t.name LIKE 'stg%' OR t.name LIKE '%combine%'
  AND p.index_id IN (0,1)
ORDER BY total_rows DESC;

TRUNCATE TABLE stg_combine;

INSERT INTO stg_combine
SELECT *
FROM combine_ready; --(1199 rows affected)

SELECT COUNT(*) AS total_staging FROM stg_combine;
SELECT TOP 10 * FROM stg_combine;

TRUNCATE TABLE stg_combine;

INSERT INTO stg_combine (
    season, player_id, first_name, last_name, player_name,
    position, height_wo_shoes, height_wo_shoes_ft_in,
    height_w_shoes, height_w_shoes_ft_in, weight,
    wingspan, wingspan_ft_in, standing_reach, standing_reach_ft_in,
    body_fat_pct, hand_length, hand_width,
    standing_vertical_leap, max_vertical_leap,
    lane_agility_time, modified_lane_agility_time,
    three_quarter_sprint, bench_press,
    spot_college_corner_left, flag_invalid_id,
    height_wo_shoes_m, height_w_shoes_m,
    weight_kg, wingspan_m, standing_reach_m,
    standing_vertical_leap_cm, max_vertical_leap_cm,
    player_name_clean, position_all, position_main,
    fat_mass_kg, fat_free_mass_kg
)
SELECT
    season, player_id, first_name, last_name, player_name,
    position, height_wo_shoes, height_wo_shoes_ft_in,
    height_w_shoes, height_w_shoes_ft_in, weight,
    wingspan, wingspan_ft_in, standing_reach, standing_reach_ft_in,
    body_fat_pct, hand_length, hand_width,
    standing_vertical_leap, max_vertical_leap,
    lane_agility_time, modified_lane_agility_time,
    three_quarter_sprint, bench_press,
    spot_college_corner_left, flag_invalid_id,
    height_wo_shoes_m, height_w_shoes_m,
    weight_kg, wingspan_m, standing_reach_m,
    standing_vertical_leap_cm, max_vertical_leap_cm,
    player_name_clean, position_all, position_main,
    fat_mass_kg, fat_free_mass_kg
FROM combine_ready;

SELECT COUNT(*) AS total_staging FROM stg_combine;
SELECT TOP 10 * FROM stg_combine;

TRUNCATE TABLE stg_combine;

INSERT INTO stg_combine (
    season, player_id, first_name, last_name, player_name,
    position, height_wo_shoes, height_wo_shoes_ft_in,
    height_w_shoes, height_w_shoes_ft_in, weight,
    wingspan, wingspan_ft_in, standing_reach, standing_reach_ft_in,
    body_fat_pct, hand_length, hand_width,
    standing_vertical_leap, max_vertical_leap,
    lane_agility_time, modified_lane_agility_time,
    three_quarter_sprint, bench_press,
    spot_college_corner_left, flag_invalid_id,
    height_wo_shoes_m, height_w_shoes_m,
    weight_kg, wingspan_m, standing_reach_m,
    standing_vertical_leap_cm, max_vertical_leap_cm,
    player_name_clean, position_all, position_main,
    fat_mass_kg, fat_free_mass_kg
)
SELECT
    season, player_id, first_name, last_name, player_name,
    position, height_wo_shoes, height_wo_shoes_ft_in,
    height_w_shoes, height_w_shoes_ft_in, weight,
    wingspan, wingspan_ft_in, standing_reach, standing_reach_ft_in,
    body_fat_pct, hand_length, hand_width,
    standing_vertical_leap, max_vertical_leap,
    lane_agility_time, modified_lane_agility_time,
    three_quarter_sprint, bench_press,
    spot_college_corner_left, flag_invalid_id,
    height_wo_shoes_m, height_w_shoes_m,
    weight_kg, wingspan_m, standing_reach_m,
    standing_vertical_leap_cm, max_vertical_leap_cm,
    player_name_clean, position_all, position_main,
    fat_mass_kg, fat_free_mass_kg
FROM combine_ready;

SELECT COUNT(*) AS total_staging FROM stg_combine;
SELECT TOP 10 * FROM stg_combine;

INSERT INTO fact_combine (
    player_id, season,
    height_wo_shoes_cm, height_w_shoes_cm, wingspan_cm, standing_reach_cm, weight_kg,
    body_fat_pct, fat_mass_kg, fat_free_mass_kg,
    bench_press_reps, standing_vertical_leap_cm, max_vertical_leap_cm,
    lane_agility_time, three_quarter_sprint_time
)
SELECT
    TRY_CAST(player_id AS INT),
    TRY_CAST(season AS INT),
    TRY_CAST(height_wo_shoes_m AS DECIMAL(5,2)),      
    TRY_CAST(height_w_shoes_m AS DECIMAL(5,2)),       
    TRY_CAST(wingspan_m AS DECIMAL(5,2)),             
    TRY_CAST(standing_reach_m AS DECIMAL(5,2)),       
    TRY_CAST(weight_kg AS DECIMAL(5,2)),              
    TRY_CAST(body_fat_pct AS DECIMAL(5,2)),           
    TRY_CAST(fat_mass_kg AS DECIMAL(5,2)),            
    TRY_CAST(fat_free_mass_kg AS DECIMAL(5,2)),       
    TRY_CAST(bench_press AS INT),                     
    TRY_CAST(standing_vertical_leap_cm AS DECIMAL(5,2)), 
    TRY_CAST(max_vertical_leap_cm AS DECIMAL(5,2)),      
    TRY_CAST(lane_agility_time AS DECIMAL(5,2)),         
    TRY_CAST(three_quarter_sprint AS DECIMAL(5,2))       
FROM stg_combine;

SELECT COUNT(*) AS fuera_dim_player
FROM stg_combine s
LEFT JOIN dim_player d 
    ON TRY_CAST(s.player_id AS INT) = d.player_id
WHERE d.player_id IS NULL;

SELECT
    COUNT(*) AS total_registros,
    SUM(CASE WHEN TRY_CAST(height_wo_shoes_m AS FLOAT) IS NULL OR TRY_CAST(height_wo_shoes_m AS FLOAT) = 0 THEN 1 ELSE 0 END) AS height_wo_shoes_m_malos,
    SUM(CASE WHEN TRY_CAST(height_w_shoes_m AS FLOAT) IS NULL OR TRY_CAST(height_w_shoes_m AS FLOAT) = 0 THEN 1 ELSE 0 END) AS height_w_shoes_m_malos,
    SUM(CASE WHEN TRY_CAST(weight_kg AS FLOAT) IS NULL OR TRY_CAST(weight_kg AS FLOAT) = 0 THEN 1 ELSE 0 END) AS weight_kg_malos,
    SUM(CASE WHEN TRY_CAST(wingspan_m AS FLOAT) IS NULL OR TRY_CAST(wingspan_m AS FLOAT) = 0 THEN 1 ELSE 0 END) AS wingspan_m_malos,
    SUM(CASE WHEN TRY_CAST(standing_reach_m AS FLOAT) IS NULL OR TRY_CAST(standing_reach_m AS FLOAT) = 0 THEN 1 ELSE 0 END) AS standing_reach_m_malos,
    SUM(CASE WHEN TRY_CAST(standing_vertical_leap_cm AS FLOAT) IS NULL OR TRY_CAST(standing_vertical_leap_cm AS FLOAT) = 0 THEN 1 ELSE 0 END) AS standing_vertical_leap_cm_malos,
    SUM(CASE WHEN TRY_CAST(max_vertical_leap_cm AS FLOAT) IS NULL OR TRY_CAST(max_vertical_leap_cm AS FLOAT) = 0 THEN 1 ELSE 0 END) AS max_vertical_leap_cm_malos,
    SUM(CASE WHEN TRY_CAST(fat_mass_kg AS FLOAT) IS NULL OR TRY_CAST(fat_mass_kg AS FLOAT) = 0 THEN 1 ELSE 0 END) AS fat_mass_kg_malos,
    SUM(CASE WHEN TRY_CAST(fat_free_mass_kg AS FLOAT) IS NULL OR TRY_CAST(fat_free_mass_kg AS FLOAT) = 0 THEN 1 ELSE 0 END) AS fat_free_mass_kg_malos
FROM stg_combine;

-- Exploramos valores no numéricos en stg_combine
SELECT DISTINCT height_wo_shoes_m
FROM stg_combine
WHERE TRY_CAST(height_wo_shoes_m AS FLOAT) IS NULL AND height_wo_shoes_m IS NOT NULL;

SELECT DISTINCT height_w_shoes_m
FROM stg_combine
WHERE TRY_CAST(height_w_shoes_m AS FLOAT) IS NULL AND height_w_shoes_m IS NOT NULL;

SELECT DISTINCT weight_kg
FROM stg_combine
WHERE TRY_CAST(weight_kg AS FLOAT) IS NULL AND weight_kg IS NOT NULL;

SELECT DISTINCT wingspan_m
FROM stg_combine
WHERE TRY_CAST(wingspan_m AS FLOAT) IS NULL AND wingspan_m IS NOT NULL;

SELECT DISTINCT standing_reach_m
FROM stg_combine
WHERE TRY_CAST(standing_reach_m AS FLOAT) IS NULL AND standing_reach_m IS NOT NULL;

SELECT DISTINCT standing_vertical_leap_cm
FROM stg_combine
WHERE TRY_CAST(standing_vertical_leap_cm AS FLOAT) IS NULL AND standing_vertical_leap_cm IS NOT NULL;

SELECT DISTINCT max_vertical_leap_cm
FROM stg_combine
WHERE TRY_CAST(max_vertical_leap_cm AS FLOAT) IS NULL AND max_vertical_leap_cm IS NOT NULL;

SELECT DISTINCT fat_mass_kg
FROM stg_combine
WHERE TRY_CAST(fat_mass_kg AS FLOAT) IS NULL AND fat_mass_kg IS NOT NULL;

SELECT DISTINCT fat_free_mass_kg
FROM stg_combine
WHERE TRY_CAST(fat_free_mass_kg AS FLOAT) IS NULL AND fat_free_mass_kg IS NOT NULL; -- Todos datos numéricos











