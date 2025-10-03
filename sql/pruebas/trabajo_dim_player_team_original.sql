

USE NBA_ORLANDOMAGIC
GO
CREATE TABLE stg_common_player_info (
    person_id INT,
    birthdate NVARCHAR(20),
    school NVARCHAR(200),
    country NVARCHAR(100),
    last_affiliation NVARCHAR(200),
    season_exp FLOAT,
    jersey NVARCHAR(10),
    position NVARCHAR(50),
    rosterstatus NVARCHAR(50),
    games_played_current_season_flag FLOAT,
    team_id INT,
    team_name NVARCHAR(100),
    team_abbreviation NVARCHAR(10),
    team_code NVARCHAR(50),
    team_city NVARCHAR(100),
    playercode NVARCHAR(100),
    from_year FLOAT,
    to_year FLOAT,
    dleague_flag NVARCHAR(10),
    nba_flag NVARCHAR(10),
    games_played_flag NVARCHAR(10),
    draft_year FLOAT,
    draft_round FLOAT,
    draft_number FLOAT,
    greatest_75_flag NVARCHAR(10),
    age INT,
    age_at_debut FLOAT,
    age_at_last_season FLOAT,
    height_m FLOAT,
    weight_kg FLOAT,
    BMI FLOAT,
    body_fat_pct_est FLOAT,
    fat_mass_kg FLOAT,
    lean_mass_kg FLOAT,
    player_name_clean NVARCHAR(150),
    all_positions NVARCHAR(200),
    main_position NVARCHAR(50)
); -- Tabla a fin de cargar los datos 

SELECT COUNT(DISTINCT person_id) 
FROM stg_common_player_info; -- 0 

SELECT COUNT(*) 
FROM stg_common_player_info
WHERE team_id = 0; -- 0

SELECT TOP 10 person_id, player_name_clean 
FROM stg_common_player_info; -- Quedo cargada como dbo, se decide usar 

CREATE TABLE dim_player (
    player_id INT PRIMARY KEY,          -- person_id del jugador
    player_name NVARCHAR(150),          -- nombre limpio
    birthdate DATE,                     -- fecha de nacimiento
    country NVARCHAR(100),              -- país
    school NVARCHAR(200),               -- universidad
    from_year INT,                      -- primer año en NBA
    to_year INT,                        -- último año en NBA
    age_at_debut INT,                   -- edad debut NBA
    age_at_last_season INT,             -- edad última temporada
    height_m DECIMAL(4,2),              -- altura en metros
    weight_kg DECIMAL(5,2),             -- peso en kilos
    BMI DECIMAL(5,2),                   -- índice de masa corporal
    body_fat_pct_est DECIMAL(5,2),      -- % de grasa estimado
    fat_mass_kg DECIMAL(6,2),           -- masa grasa
    lean_mass_kg DECIMAL(6,2),          -- masa magra
    main_position NVARCHAR(50)          -- posición principal
);

CREATE TABLE dim_player (
    player_id INT PRIMARY KEY,          
    player_name NVARCHAR(150),          
    birthdate DATE,                     
    country NVARCHAR(100),              
    school NVARCHAR(200),               
    from_year INT,                      
    to_year INT,                        
    age_at_debut INT,                   
    age_at_last_season INT,             
    height_m DECIMAL(4,2),              
    weight_kg DECIMAL(5,2),             
    BMI DECIMAL(5,2),                   
    body_fat_pct_est DECIMAL(5,2),      
    fat_mass_kg DECIMAL(6,2),           
    lean_mass_kg DECIMAL(6,2),          
    main_position NVARCHAR(50)          
);



INSERT INTO dim_player (
    player_id, player_name, birthdate, country, school,
    from_year, to_year, age_at_debut, age_at_last_season,
    height_m, weight_kg, BMI, body_fat_pct_est, fat_mass_kg, lean_mass_kg, main_position
)
SELECT
    TRY_CAST(person_id AS INT),
    player_name_clean,
    TRY_CAST(birthdate AS DATE),
    country,
    school,
    TRY_CAST(from_year AS INT),
    TRY_CAST(to_year AS INT),
    TRY_CAST(age_at_debut AS INT),
    TRY_CAST(age_at_last_season AS INT),
    TRY_CAST(height_m AS DECIMAL(4,2)),
    TRY_CAST(weight_kg AS DECIMAL(5,2)),
    TRY_CAST(BMI AS DECIMAL(5,2)),
    TRY_CAST(body_fat_pct_est AS DECIMAL(5,2)),
    TRY_CAST(fat_mass_kg AS DECIMAL(6,2)),
    TRY_CAST(lean_mass_kg AS DECIMAL(6,2)),
    main_position
FROM common_player_info_ready;


SELECT person_id, COUNT(*) AS cantidad
FROM common_player_info_ready
GROUP BY person_id
HAVING COUNT(*) > 1;

SELECT COUNT(*) AS total_filas,
       COUNT(DISTINCT person_id) AS jugadores_unicos
FROM common_player_info_ready; --4171 -- 4171

TRUNCATE TABLE dim_player; -- Borra registros pero mantiene la estructura

INSERT INTO dim_player (
    player_id, player_name, birthdate, country, school,
    from_year, to_year, age_at_debut, age_at_last_season,
    height_m, weight_kg, BMI, body_fat_pct_est, fat_mass_kg, lean_mass_kg, main_position
)
SELECT
    TRY_CAST(person_id AS INT),
    player_name_clean,
    TRY_CAST(birthdate AS DATE),
    country,
    school,
    TRY_CAST(from_year AS INT),
    TRY_CAST(to_year AS INT),
    TRY_CAST(age_at_debut AS INT),
    TRY_CAST(age_at_last_season AS INT),
    TRY_CAST(height_m AS DECIMAL(4,2)),
    TRY_CAST(weight_kg AS DECIMAL(5,2)),
    TRY_CAST(BMI AS DECIMAL(5,2)),
    TRY_CAST(body_fat_pct_est AS DECIMAL(5,2)),
    TRY_CAST(fat_mass_kg AS DECIMAL(6,2)),
    TRY_CAST(lean_mass_kg AS DECIMAL(6,2)),
    main_position
FROM common_player_info_ready; -- (4171 rows affected)

TRUNCATE TABLE dim_player; -- borar registros de prueba 

INSERT INTO dim_player (
    player_id, player_name, birthdate, country, school,
    from_year, to_year, age_at_debut, age_at_last_season,
    height_m, weight_kg, BMI, body_fat_pct_est, fat_mass_kg, lean_mass_kg, main_position
)
SELECT
    TRY_CAST(person_id AS INT),
    player_name_clean,
    TRY_CAST(birthdate AS DATE),
    country,
    school,
    TRY_CAST(from_year AS INT),
    TRY_CAST(to_year AS INT),
    TRY_CAST(age_at_debut AS INT),
    TRY_CAST(age_at_last_season AS INT),
    TRY_CAST(height_m AS DECIMAL(4,2)),
    TRY_CAST(weight_kg AS DECIMAL(5,2)),
    TRY_CAST(BMI AS DECIMAL(5,2)),
    TRY_CAST(body_fat_pct_est AS DECIMAL(5,2)),
    TRY_CAST(fat_mass_kg AS DECIMAL(6,2)),
    TRY_CAST(lean_mass_kg AS DECIMAL(6,2)),
    main_position
FROM common_player_info_ready; -- Inserto jugadores desde staging

SELECT COUNT(*) AS total_dim_player 
FROM dim_player; -- 4171

SELECT TOP 10 * 
FROM dim_player;

SELECT DISTINCT from_year
FROM common_player_info_ready
WHERE TRY_CAST(from_year AS INT) IS NULL AND from_year IS NOT NULL; -- Año con decimal 

TRUNCATE TABLE dim_player;  -- Limpiamos para recargar todo desde cero

INSERT INTO dim_player (
    player_id, player_name, birthdate, country, school,
    from_year, to_year, age_at_debut, age_at_last_season,
    height_m, weight_kg, BMI, body_fat_pct_est, fat_mass_kg, lean_mass_kg, main_position
)
SELECT
    TRY_CAST(person_id AS INT),
    player_name_clean,
    TRY_CAST(birthdate AS DATE),
    country,
    school,
    TRY_CAST(TRY_CAST(from_year AS FLOAT) AS INT),        -- Conversión doble
    TRY_CAST(TRY_CAST(to_year AS FLOAT) AS INT),          -- Conversión doble
    TRY_CAST(age_at_debut AS INT),
    TRY_CAST(age_at_last_season AS INT),
    TRY_CAST(height_m AS DECIMAL(4,2)),
    TRY_CAST(weight_kg AS DECIMAL(5,2)),
    TRY_CAST(BMI AS DECIMAL(5,2)),
    TRY_CAST(body_fat_pct_est AS DECIMAL(5,2)),
    TRY_CAST(fat_mass_kg AS DECIMAL(6,2)),
    TRY_CAST(lean_mass_kg AS DECIMAL(6,2)),
    main_position
FROM common_player_info_ready;

SELECT COUNT(*) FROM dim_player; 

SELECT TOP 20 player_id, player_name, from_year, to_year
FROM dim_player
ORDER BY from_year;

TRUNCATE TABLE dim_player;  -- limpiamos la tabla antes de recargar

INSERT INTO dim_player (
    player_id, player_name, birthdate, country, school,
    from_year, to_year, age_at_debut, age_at_last_season,
    height_m, weight_kg, BMI, body_fat_pct_est, fat_mass_kg, lean_mass_kg, main_position
)
SELECT
    TRY_CAST(person_id AS INT),
    player_name_clean,
    TRY_CAST(birthdate AS DATE),
    country,
    school,
    CASE 
        WHEN TRY_CAST(TRY_CAST(from_year AS FLOAT) AS INT) = 0 THEN NULL
        ELSE TRY_CAST(TRY_CAST(from_year AS FLOAT) AS INT)
    END,
    CASE 
        WHEN TRY_CAST(TRY_CAST(to_year AS FLOAT) AS INT) = 0 THEN NULL
        ELSE TRY_CAST(TRY_CAST(to_year AS FLOAT) AS INT)
    END,
    TRY_CAST(age_at_debut AS INT),
    TRY_CAST(age_at_last_season AS INT),
    TRY_CAST(height_m AS DECIMAL(4,2)),
    TRY_CAST(weight_kg AS DECIMAL(5,2)),
    TRY_CAST(BMI AS DECIMAL(5,2)),
    TRY_CAST(body_fat_pct_est AS DECIMAL(5,2)),
    TRY_CAST(fat_mass_kg AS DECIMAL(6,2)),
    TRY_CAST(lean_mass_kg AS DECIMAL(6,2)),
    main_position
FROM common_player_info_ready;

SELECT TOP 20 player_id, player_name, from_year, to_year
FROM dim_player
ORDER BY from_year;

-- Crear dim_team

CREATE TABLE dim_team (
    team_id INT PRIMARY KEY,
    team_name NVARCHAR(100),
    team_abbreviation NVARCHAR(10),
    team_code NVARCHAR(50),
    team_city NVARCHAR(100)
);

-- Probar equipos únicos
INSERT INTO dim_team (team_id, team_name, team_abbreviation, team_code, team_city)
SELECT DISTINCT
    TRY_CAST(team_id AS INT),
    team_name,
    team_abbreviation,
    team_code,
    team_city
FROM common_player_info_ready
WHERE team_id IS NOT NULL AND team_id <> 0;

TRUNCATE TABLE dim_team;

INSERT INTO dim_team (team_id, team_name, team_abbreviation, team_code, team_city)
SELECT DISTINCT
    TRY_CAST(team_id AS INT),
    team_name,
    team_abbreviation,
    team_code,
    team_city
FROM common_player_info_ready
WHERE team_id IS NOT NULL AND team_id <> 0;

SELECT team_id, COUNT(*) AS cantidad
FROM common_player_info_ready
WHERE team_id IS NOT NULL AND team_id <> 0
GROUP BY team_id
HAVING COUNT(*) > 1
ORDER BY cantidad DESC; 

-- 1. Borramos todos los registros de la tabla dim_team
--    (esto nos asegura que no haya duplicados de intentos anteriores)
TRUNCATE TABLE dim_team;


-- 2. Insertamos un único registro por cada equipo (team_id)
--    Usamos GROUP BY para que solo quede una fila por team_id
--    y funciones MIN() para elegir un valor representativo
--    de las otras columnas (nombre, ciudad, abreviatura, etc.)
INSERT INTO dim_team (team_id, team_name, team_abbreviation, team_code, team_city)
SELECT
    team_id,                                -- Clave primaria única del equipo
    MIN(team_name) AS team_name,            -- Nombre completo del equipo
    MIN(team_abbreviation) AS team_abbreviation, -- Abreviatura (ej. LAL)
    MIN(team_code) AS team_code,            -- Código interno (ej. lakers)
    MIN(team_city) AS team_city             -- Ciudad base del equipo
FROM common_player_info_ready
WHERE team_id IS NOT NULL                   -- Quitamos nulos (jugadores sin equipo)
  AND team_id <> 0                          -- Quitamos los "0" que no son válidos
GROUP BY team_id;                           -- Un registro único por equipo -- 45 rows affected

-- Contar cuántos equipos únicos cargamos
SELECT COUNT(*) AS total_equipos FROM dim_team; -- Total 45 equipos



-- Ver los primeros 20 equipos para revisar que todo esté ok
SELECT TOP 20 * FROM dim_team;





















