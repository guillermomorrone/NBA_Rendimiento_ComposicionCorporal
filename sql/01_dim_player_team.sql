---------------------------------------
-- Script 01: Crear dimensiones básicas
-- Origen: stg_common_player_info
---------------------------------------

-- Tabla de jugadores
IF OBJECT_ID('dim_player', 'U') IS NOT NULL
    DROP TABLE dim_player;

CREATE TABLE dim_player (
    player_id INT PRIMARY KEY,
    player_name_clean NVARCHAR(150),
    birthdate DATE NULL,
    country NVARCHAR(100),
    position NVARCHAR(50),
    main_position NVARCHAR(50),
    height_m DECIMAL(5,2) NULL,
    weight_kg DECIMAL(5,2) NULL,
    BMI DECIMAL(5,2) NULL,
    body_fat_pct_est DECIMAL(5,2) NULL,
    fat_mass_kg DECIMAL(5,2) NULL,
    lean_mass_kg DECIMAL(5,2) NULL,
    from_year INT NULL,
    to_year INT NULL
);

INSERT INTO dim_player (
    player_id, player_name_clean, birthdate, country, position, main_position,
    height_m, weight_kg, BMI, body_fat_pct_est, fat_mass_kg, lean_mass_kg,
    from_year, to_year
)
SELECT DISTINCT
    TRY_CAST(person_id AS INT),
    player_name_clean,
    TRY_CAST(birthdate AS DATE),
    country,
    all_positions,
    main_position,
    TRY_CAST(height_m AS DECIMAL(5,2)),
    TRY_CAST(weight_kg AS DECIMAL(5,2)),
    TRY_CAST(BMI AS DECIMAL(5,2)),
    TRY_CAST(body_fat_pct_est AS DECIMAL(5,2)),
    TRY_CAST(fat_mass_kg AS DECIMAL(5,2)),
    TRY_CAST(lean_mass_kg AS DECIMAL(5,2)),
    TRY_CAST(from_year AS INT),
    TRY_CAST(to_year AS INT)
FROM stg_common_player_info;

-- Tabla de equipos
IF OBJECT_ID('dim_team', 'U') IS NOT NULL
    DROP TABLE dim_team;

CREATE TABLE dim_team (
    team_id INT PRIMARY KEY,
    team_name NVARCHAR(100),
    team_abbreviation NVARCHAR(10),
    team_code NVARCHAR(50),
    team_city NVARCHAR(100)
);

INSERT INTO dim_team (team_id, team_name, team_abbreviation, team_code, team_city)
SELECT
    team_id,
    MIN(team_name),
    MIN(team_abbreviation),
    MIN(team_code),
    MIN(team_city)
FROM stg_common_player_info
WHERE team_id IS NOT NULL AND team_id <> 0
GROUP BY team_id;
