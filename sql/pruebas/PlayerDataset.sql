USE NBA_ORLANDOMAGIC;
GO

-------------------------------------------------
-- 1. STAGING: PLAYER STATS
-------------------------------------------------
IF OBJECT_ID('dbo.stg_player_stats', 'U') IS NOT NULL
    DROP TABLE dbo.stg_player_stats;
GO

CREATE TABLE dbo.stg_player_stats (
    PLAYER_ID INT,
    Name VARCHAR(100),
    SEASON_ID VARCHAR(10),
    TEAM_ID INT,
    TEAM_ABBREVIATION VARCHAR(10),
    PLAYER_AGE INT,
    GP INT,
    GS INT,
    MIN INT,
    FGM INT,
    FGA INT,
    FG_PCT FLOAT,
    FG3M INT,
    FG3A INT,
    FG3_PCT FLOAT,
    FTM INT,
    FTA INT,
    FT_PCT FLOAT,
    OREB INT,
    DREB INT,
    REB INT,
    AST INT,
    STL INT,
    BLK INT,
    TOV INT,
    PF INT,
    PTS INT,
    Name_clean VARCHAR(100),
    Name_strip VARCHAR(100)
);
GO

-- Carga del CSV en staging
BULK INSERT dbo.stg_player_stats
FROM 'C:\Users\elian\OneDrive\Escritorio\NBA_ComposicionCorporal_Rendimiento\data_clean\NBA_PLAYER_DATASET_ready.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
