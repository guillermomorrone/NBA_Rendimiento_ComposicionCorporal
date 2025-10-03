-- ===================================================
-- Staging Table: GAME
-- Fuente: game_ready.csv
-- ===================================================

IF OBJECT_ID('stg_game', 'U') IS NOT NULL
    DROP TABLE stg_game;

CREATE TABLE stg_game (
    game_id INT IDENTITY(1,1) PRIMARY KEY,
    game_date DATE,
    game_type NVARCHAR(50),           -- Ej: Regular Season, Playoffs, All-Star
    home_team_id INT,                 -- FK hacia dim_teams
    home_team_abbr NVARCHAR(10),
    home_team_name NVARCHAR(100),
    away_team_id INT,                 -- FK hacia dim_teams
    away_team_abbr NVARCHAR(10),
    away_team_name NVARCHAR(100),
    pts_home DECIMAL(5,2) NULL,
    pts_away DECIMAL(5,2) NULL,
    fg_pct_home DECIMAL(5,3) NULL,
    fg_pct_away DECIMAL(5,3) NULL,
    fg3_pct_home DECIMAL(5,3) NULL,
    fg3_pct_away DECIMAL(5,3) NULL,
    ft_pct_home DECIMAL(5,3) NULL,
    ft_pct_away DECIMAL(5,3) NULL,
    reb_home INT NULL,
    reb_away INT NULL,
    ast_home INT NULL,
    ast_away INT NULL,
    stl_home INT NULL,
    stl_away INT NULL,
    blk_home INT NULL,
    blk_away INT NULL,
    tov_home INT NULL,
    tov_away INT NULL,
    home_win INT NULL
);
