USE NBA_ORLANDOMAGIC;
GO

-- 1. Drop + Create de fact_game
IF OBJECT_ID('dbo.fact_game', 'U') IS NOT NULL
    DROP TABLE dbo.fact_game;
GO

CREATE TABLE dbo.fact_game (
    game_id INT PRIMARY KEY,
    season_id INT,
    game_date DATE,
    season_type NVARCHAR(50),
    team_id_home INT,
    team_abbreviation_home NVARCHAR(10),
    team_name_home NVARCHAR(100),
    fgm_home INT,
    fga_home INT,
    fg_pct_home FLOAT,
    fg3m_home INT,
    fg3a_home INT,
    fg3_pct_home FLOAT,
    ftm_home INT,
    fta_home INT,
    ft_pct_home FLOAT,
    oreb_home INT,
    dreb_home INT,
    reb_home INT,
    ast_home INT,
    stl_home INT,
    blk_home INT,
    tov_home INT,
    pf_home INT,
    pts_home INT,
    plus_minus_home INT,
    team_id_away INT,
    team_abbreviation_away NVARCHAR(10),
    team_name_away NVARCHAR(100),
    fgm_away INT,
    fga_away INT,
    fg_pct_away FLOAT,
    fg3m_away INT,
    fg3a_away INT,
    fg3_pct_away FLOAT,
    ftm_away INT,
    fta_away INT,
    ft_pct_away FLOAT,
    oreb_away INT,
    dreb_away INT,
    reb_away INT,
    ast_away INT,
    stl_away INT,
    blk_away INT,
    tov_away INT,
    pf_away INT,
    pts_away INT,
    plus_minus_away INT
);
GO

-- 2. Insertar desde stg_game sin duplicados
;WITH juegos_unicos AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY game_id ORDER BY TRY_CAST(game_date AS DATE)) AS rn
    FROM stg_game
)
INSERT INTO fact_game
SELECT 
    game_id,
    season_id,
    TRY_CAST(game_date AS DATE),
    season_type,
    team_id_home, team_abbreviation_home, team_name_home,
    TRY_CAST(fgm_home AS INT), TRY_CAST(fga_home AS INT), TRY_CAST(fg_pct_home AS FLOAT),
    TRY_CAST(fg3m_home AS INT), TRY_CAST(fg3a_home AS INT), TRY_CAST(fg3_pct_home AS FLOAT),
    TRY_CAST(ftm_home AS INT), TRY_CAST(fta_home AS INT), TRY_CAST(ft_pct_home AS FLOAT),
    TRY_CAST(oreb_home AS INT), TRY_CAST(dreb_home AS INT), TRY_CAST(reb_home AS INT),
    TRY_CAST(ast_home AS INT), TRY_CAST(stl_home AS INT), TRY_CAST(blk_home AS INT),
    TRY_CAST(tov_home AS INT), TRY_CAST(pf_home AS INT), TRY_CAST(pts_home AS INT),
    TRY_CAST(plus_minus_home AS INT),
    team_id_away, team_abbreviation_away, team_name_away,
    TRY_CAST(fgm_away AS INT), TRY_CAST(fga_away AS INT), TRY_CAST(fg_pct_away AS FLOAT),
    TRY_CAST(fg3m_away AS INT), TRY_CAST(fg3a_away AS INT), TRY_CAST(fg3_pct_away AS FLOAT),
    TRY_CAST(ftm_away AS INT), TRY_CAST(fta_away AS INT), TRY_CAST(ft_pct_away AS FLOAT),
    TRY_CAST(oreb_away AS INT), TRY_CAST(dreb_away AS INT), TRY_CAST(reb_away AS INT),
    TRY_CAST(ast_away AS INT), TRY_CAST(stl_away AS INT), TRY_CAST(blk_away AS INT),
    TRY_CAST(tov_away AS INT), TRY_CAST(pf_away AS INT), TRY_CAST(pts_away AS INT),
    TRY_CAST(plus_minus_away AS INT)
FROM juegos_unicos
WHERE rn = 1;

SELECT COUNT(*) AS total_stg FROM stg_game;

SELECT TOP 5 game_id, game_date, team_name_home, team_name_away
FROM stg_game; -- 0

DROP TABLE stg_game;  -- borra la vacía
EXEC sp_rename 'game_ready', 'stg_game';

;WITH juegos_unicos AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY game_id ORDER BY TRY_CAST(game_date AS DATE)) AS rn
    FROM stg_game
)
INSERT INTO fact_game
SELECT 
    game_id,
    season_id,
    TRY_CAST(game_date AS DATE),
    season_type,
    team_id_home, team_abbreviation_home, team_name_home,
    TRY_CAST(fgm_home AS INT), TRY_CAST(fga_home AS INT), TRY_CAST(fg_pct_home AS FLOAT),
    TRY_CAST(fg3m_home AS INT), TRY_CAST(fg3a_home AS INT), TRY_CAST(fg3_pct_home AS FLOAT),
    TRY_CAST(ftm_home AS INT), TRY_CAST(fta_home AS INT), TRY_CAST(ft_pct_home AS FLOAT),
    TRY_CAST(oreb_home AS INT), TRY_CAST(dreb_home AS INT), TRY_CAST(reb_home AS INT),
    TRY_CAST(ast_home AS INT), TRY_CAST(stl_home AS INT), TRY_CAST(blk_home AS INT),
    TRY_CAST(tov_home AS INT), TRY_CAST(pf_home AS INT), TRY_CAST(pts_home AS INT),
    TRY_CAST(plus_minus_home AS INT),
    team_id_away, team_abbreviation_away, team_name_away,
    TRY_CAST(fgm_away AS INT), TRY_CAST(fga_away AS INT), TRY_CAST(fg_pct_away AS FLOAT),
    TRY_CAST(fg3m_away AS INT), TRY_CAST(fg3a_away AS INT), TRY_CAST(fg3_pct_away AS FLOAT),
    TRY_CAST(ftm_away AS INT), TRY_CAST(fta_away AS INT), TRY_CAST(ft_pct_away AS FLOAT),
    TRY_CAST(oreb_away AS INT), TRY_CAST(dreb_away AS INT), TRY_CAST(reb_away AS INT),
    TRY_CAST(ast_away AS INT), TRY_CAST(stl_away AS INT), TRY_CAST(blk_away AS INT),
    TRY_CAST(tov_away AS INT), TRY_CAST(pf_away AS INT), TRY_CAST(pts_away AS INT),
    TRY_CAST(plus_minus_away AS INT)
FROM juegos_unicos
WHERE rn = 1; -- (65642 rows affected)

-- Cantidad de partidos únicos
SELECT COUNT(DISTINCT game_id) AS total_partidos FROM fact_game;

-- Ejemplo de All-Star, debería aparecer solo una vez
SELECT * FROM fact_game WHERE game_id = 30100001;

-- fact_game cargada exitosamente con 65.642 registros.
-- Se eliminaron duplicados por game_id (ej. All-Star Games).
-- Cada partido quedó representado con un único registro.
-- Columnas convertidas a tipos correctos (INT, FLOAT, DATE).
-- Incluye partidos de temporada regular, playoffs y All-Star.




