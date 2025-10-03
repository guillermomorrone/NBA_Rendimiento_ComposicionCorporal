USE NBA_ORLANDOMAGIC;
GO

-- Borrar si ya existe
IF OBJECT_ID('dbo.fact_player_stats', 'U') IS NOT NULL
    DROP TABLE dbo.fact_player_stats;
GO

-- Crear fact con business keys
CREATE TABLE dbo.fact_player_stats (
    fact_id INT IDENTITY(1,1) PRIMARY KEY,
    player_id INT NOT NULL,   -- Business key (de dim_player)
    team_id INT NOT NULL,     -- Business key (de dim_team)
    season_sk INT NOT NULL,   -- Surrogate key de dim_season
    player_age INT,
    gp INT,
    gs INT,
    min INT,
    fgm INT,
    fga INT,
    fg_pct FLOAT,
    fg3m INT,
    fg3a INT,
    fg3_pct FLOAT,
    ftm INT,
    fta INT,
    ft_pct FLOAT,
    oreb INT,
    dreb INT,
    reb INT,
    ast INT,
    stl INT,
    blk INT,
    tov INT,
    pf INT,
    pts INT
);
GO

INSERT INTO dbo.fact_player_stats (
    player_id, team_id, season_sk,
    player_age, gp, gs, min, fgm, fga, fg_pct,
    fg3m, fg3a, fg3_pct, ftm, fta, ft_pct,
    oreb, dreb, reb, ast, stl, blk, tov, pf, pts
)
SELECT 
    stg.PLAYER_ID,
    stg.TEAM_ID,
    s.season_sk,
    stg.PLAYER_AGE,
    stg.GP, stg.GS, stg.MIN, stg.FGM, stg.FGA, stg.FG_PCT,
    stg.FG3M, stg.FG3A, stg.FG3_PCT, stg.FTM, stg.FTA, stg.FT_PCT,
    stg.OREB, stg.DREB, stg.REB, stg.AST, stg.STL, stg.BLK, stg.TOV, stg.PF, stg.PTS
FROM dbo.stg_player_stats stg
JOIN dbo.dim_season s 
    ON s.season_name = stg.SEASON_ID;
GO

SELECT COUNT(*) AS total_registros_fact
FROM dbo.fact_player_stats;

SELECT TOP 20 *
FROM dbo.fact_player_stats; --ok 

SELECT TOP 20
    fps.fact_id,
    p.player_name,
    t.team_abbreviation,
    s.season_name,
    fps.player_age,
    fps.gp, fps.gs, fps.min,
    fps.pts, fps.reb, fps.ast, fps.stl, fps.blk
FROM dbo.fact_player_stats fps
JOIN dbo.dim_player p 
    ON fps.player_id = p.player_id
JOIN dbo.dim_team t 
    ON fps.team_id = t.team_id
JOIN dbo.dim_season s 
    ON fps.season_sk = s.season_sk
ORDER BY p.player_name, s.season_name;


