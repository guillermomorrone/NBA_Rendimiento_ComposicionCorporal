-- 1. Seleccionar la base
USE NBA_ORLANDOMAGIC;
GO

-- 2. Renombrar la tabla importada para usarla como staging
EXEC sp_rename 'dbo.fact_game', 'stg_game';
GO

SELECT COUNT(*) AS total_registros FROM dbo.stg_game;

SELECT COUNT(*) AS total_partidos FROM dbo.fact_game;
SELECT TOP 10 * FROM dbo.fact_game;

SELECT name 
FROM sys.tables
WHERE name LIKE '%game%';

USE NBA_ORLANDOMAGIC;
GO

-- Limpiamos fact_game antes de cargar
TRUNCATE TABLE dbo.fact_game;

-- Insertamos desde la tabla importada game_ready
INSERT INTO dbo.fact_game (
    game_id, season_id, game_date, season_type,
    team_id_home, team_id_away,
    pts_home, pts_away, reb_home, reb_away,
    ast_home, ast_away, stl_home, stl_away,
    blk_home, blk_away, tov_home, tov_away,
    fg_pct_home, fg_pct_away,
    fg3_pct_home, fg3_pct_away,
    ft_pct_home, ft_pct_away
)
SELECT
    game_id,
    season_id,
    TRY_CAST(game_date AS DATE),
    season_type,
    TRY_CAST(team_id_home AS INT),
    TRY_CAST(team_id_away AS INT),
    TRY_CAST(pts_home AS INT),
    TRY_CAST(pts_away AS INT),
    TRY_CAST(reb_home AS INT),
    TRY_CAST(reb_away AS INT),
    TRY_CAST(ast_home AS INT),
    TRY_CAST(ast_away AS INT),
    TRY_CAST(stl_home AS INT),
    TRY_CAST(stl_away AS INT),
    TRY_CAST(blk_home AS INT),
    TRY_CAST(blk_away AS INT),
    TRY_CAST(tov_home AS INT),
    TRY_CAST(tov_away AS INT),
    TRY_CAST(fg_pct_home AS FLOAT),
    TRY_CAST(fg_pct_away AS FLOAT),
    TRY_CAST(fg3_pct_home AS FLOAT),
    TRY_CAST(fg3_pct_away AS FLOAT),
    TRY_CAST(ft_pct_home AS FLOAT),
    TRY_CAST(ft_pct_away AS FLOAT)
FROM dbo.game_ready;
GO -- Error por duplicados ya que en la tabla anterior definimo game_ID

SELECT game_id, COUNT(*) AS cantidad
FROM dbo.game_ready
GROUP BY game_id
HAVING COUNT(*) > 1; -- Se confirma que estan duplicados 

SELECT *
FROM dbo.game_ready
WHERE game_id = '30100001'; -- Se confirma que los registros son iguales 

-- Si ya existe, la borramos
IF OBJECT_ID('dbo.fact_game', 'U') IS NOT NULL
    DROP TABLE dbo.fact_game;
GO

CREATE TABLE dbo.fact_game (
    game_id INT PRIMARY KEY,               -- identificador único del partido
    season_id INT,                         -- temporada
    game_date DATE,                        -- fecha
    season_type NVARCHAR(50),              -- Regular, Playoffs, All-Star
    
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
    plus_minus_home INT,                   -- diferencia puntos

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

;WITH juegos_unicos AS (
    SELECT 
        game_id,
        season_id,
        TRY_CAST(game_date AS DATE) AS game_date,
        season_type,

        team_id_home,
        team_abbreviation_home,
        team_name_home,
        TRY_CAST(fgm_home AS INT) AS fgm_home,
        TRY_CAST(fga_home AS INT) AS fga_home,
        TRY_CAST(fg_pct_home AS FLOAT) AS fg_pct_home,
        TRY_CAST(fg3m_home AS INT) AS fg3m_home,
        TRY_CAST(fg3a_home AS INT) AS fg3a_home,
        TRY_CAST(fg3_pct_home AS FLOAT) AS fg3_pct_home,
        TRY_CAST(ftm_home AS INT) AS ftm_home,
        TRY_CAST(fta_home AS INT) AS fta_home,
        TRY_CAST(ft_pct_home AS FLOAT) AS ft_pct_home,
        TRY_CAST(oreb_home AS INT) AS oreb_home,
        TRY_CAST(dreb_home AS INT) AS dreb_home,
        TRY_CAST(reb_home AS INT) AS reb_home,
        TRY_CAST(ast_home AS INT) AS ast_home,
        TRY_CAST(stl_home AS INT) AS stl_home,
        TRY_CAST(blk_home AS INT) AS blk_home,
        TRY_CAST(tov_home AS INT) AS tov_home,
        TRY_CAST(pf_home AS INT) AS pf_home,
        TRY_CAST(pts_home AS INT) AS pts_home,
        TRY_CAST(plus_minus_home AS INT) AS plus_minus_home,

        team_id_away,
        team_abbreviation_away,
        team_name_away,
        TRY_CAST(fgm_away AS INT) AS fgm_away,
        TRY_CAST(fga_away AS INT) AS fga_away,
        TRY_CAST(fg_pct_away AS FLOAT) AS fg_pct_away,
        TRY_CAST(fg3m_away AS INT) AS fg3m_away,
        TRY_CAST(fg3a_away AS INT) AS fg3a_away,
        TRY_CAST(fg3_pct_away AS FLOAT) AS fg3_pct_away,
        TRY_CAST(ftm_away AS INT) AS ftm_away,
        TRY_CAST(fta_away AS INT) AS fta_away,
        TRY_CAST(ft_pct_away AS FLOAT) AS ft_pct_away,
        TRY_CAST(oreb_away AS INT) AS oreb_away,
        TRY_CAST(dreb_away AS INT) AS dreb_away,
        TRY_CAST(reb_away AS INT) AS reb_away,
        TRY_CAST(ast_away AS INT) AS ast_away,
        TRY_CAST(stl_away AS INT) AS stl_away,
        TRY_CAST(blk_away AS INT) AS blk_away,
        TRY_CAST(tov_away AS INT) AS tov_away,
        TRY_CAST(pf_away AS INT) AS pf_away,
        TRY_CAST(pts_away AS INT) AS pts_away,
        TRY_CAST(plus_minus_away AS INT) AS plus_minus_away,

        ROW_NUMBER() OVER (PARTITION BY game_id ORDER BY TRY_CAST(game_date AS DATE)) AS rn
    FROM stg_game
)

INSERT INTO fact_game (
    game_id,
    season_id,
    game_date,
    season_type,
    team_id_home, team_abbreviation_home, team_name_home,
    fgm_home, fga_home, fg_pct_home,
    fg3m_home, fg3a_home, fg3_pct_home,
    ftm_home, fta_home, ft_pct_home,
    oreb_home, dreb_home, reb_home,
    ast_home, stl_home, blk_home,
    tov_home, pf_home, pts_home,
    plus_minus_home,
    team_id_away, team_abbreviation_away, team_name_away,
    fgm_away, fga_away, fg_pct_away,
    fg3m_away, fg3a_away, fg3_pct_away,
    ftm_away, fta_away, ft_pct_away,
    oreb_away, dreb_away, reb_away,
    ast_away, stl_away, blk_away,
    tov_away, pf_away, pts_away,
    plus_minus_away
)
SELECT 
    game_id,
    season_id,
    game_date,
    season_type,
    team_id_home, team_abbreviation_home, team_name_home,
    fgm_home, fga_home, fg_pct_home,
    fg3m_home, fg3a_home, fg3_pct_home,
    ftm_home, fta_home, ft_pct_home,
    oreb_home, dreb_home, reb_home,
    ast_home, stl_home, blk_home,
    tov_home, pf_home, pts_home,
    plus_minus_home,
    team_id_away, team_abbreviation_away, team_name_away,
    fgm_away, fga_away, fg_pct_away,
    fg3m_away, fg3a_away, fg3_pct_away,
    ftm_away, fta_away, ft_pct_away,
    oreb_away, dreb_away, reb_away,
    ast_away, stl_away, blk_away,
    tov_away, pf_away, pts_away,
    plus_minus_away
FROM juegos_unicos
WHERE rn = 1; -- 0 rows, incompatibilidad de nombres de columnas, latabla stg_game esta vacia 

SELECT TOP 5 * FROM stg_game;

SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'stg_game';

-- season_id
team_id_home
team_abbreviation_home
team_name_home
game_id
game_date
matchup_home
min
fgm_home
fga_home
fg_pct_home
fg3m_home
fg3a_home
fg3_pct_home
ftm_home
fta_home
ft_pct_home
oreb_home
dreb_home
reb_home
ast_home
stl_home
blk_home
tov_home
pf_home
pts_home
plus_minus_home
team_id_away
team_abbreviation_away
team_name_away
fgm_away
fga_away
fg_pct_away
fg3m_away
fg3a_away
fg3_pct_away
ftm_away
fta_away
ft_pct_away
oreb_away
dreb_away
reb_away
ast_away
stl_away
blk_away
tov_away
pf_away
pts_away
plus_minus_away
season_type


