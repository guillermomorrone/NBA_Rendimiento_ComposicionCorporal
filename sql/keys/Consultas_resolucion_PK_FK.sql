USE NBA_ORLANDOMAGIC
GO

SELECT 
    f.name AS constraint_name,
    t.name AS table_name,
    c.name AS column_name,
    rt.name AS ref_table_name,
    rc.name AS ref_column_name
FROM sys.foreign_keys f
INNER JOIN sys.foreign_key_columns fc ON f.object_id = fc.constraint_object_id
INNER JOIN sys.tables t ON f.parent_object_id = t.object_id
INNER JOIN sys.columns c ON fc.parent_column_id = c.column_id AND fc.parent_object_id = c.object_id
INNER JOIN sys.tables rt ON f.referenced_object_id = rt.object_id
INNER JOIN sys.columns rc ON fc.referenced_column_id = rc.column_id AND fc.referenced_object_id = rc.object_id;

USE NBA_ORLANDOMAGIC;
GO

/* ============================
   FACT INJURIES
============================ */
ALTER TABLE dbo.fact_injuries
ADD CONSTRAINT FK_fact_injuries_player
    FOREIGN KEY (player_id) REFERENCES dbo.dim_player(player_id);
GO

ALTER TABLE dbo.fact_injuries
ADD CONSTRAINT FK_fact_injuries_date
    FOREIGN KEY (date_id) REFERENCES dbo.dim_date(date_id);
GO

ALTER TABLE dbo.fact_injuries
ADD CONSTRAINT FK_fact_injuries_cat1
    FOREIGN KEY (main_injury_category_id) REFERENCES dbo.dim_injury_category(injury_category_id);
GO
-- La FK a secondary_injury_category_id ya está creada (cat2)


/* ============================
   FACT COMBINE
============================ */
ALTER TABLE dbo.fact_combine
ADD CONSTRAINT FK_fact_combine_player
    FOREIGN KEY (player_id) REFERENCES dbo.dim_player(player_id);
GO ----

ALTER TABLE dbo.fact_combine
ADD CONSTRAINT FK_fact_combine_season
    FOREIGN KEY (season) REFERENCES dbo.dim_season(season_name);
GO ----
-- Si preferís trabajar con surrogate key (season_sk), habría que hacer ETL para reemplazar season por season_sk en staging y fact.


/* ============================
   FACT BIOMETRY
============================ */
ALTER TABLE dbo.fact_biometry
ADD CONSTRAINT FK_fact_biometry_player
    FOREIGN KEY (player_id) REFERENCES dbo.dim_player(player_id);
GO

ALTER TABLE dbo.fact_biometry
ADD CONSTRAINT FK_fact_biometry_draft
    FOREIGN KEY (draft_sk) REFERENCES dbo.dim_draft(draft_sk);
GO -----


/* ============================
   FACT GAME
============================ */
ALTER TABLE dbo.fact_game
ADD CONSTRAINT FK_fact_game_player
    FOREIGN KEY (player_id) REFERENCES dbo.dim_player(player_id);
GO ---- 

ALTER TABLE dbo.fact_game
ADD CONSTRAINT FK_fact_game_team
    FOREIGN KEY (team_id) REFERENCES dbo.dim_team(team_id);
GO ----

ALTER TABLE dbo.fact_game
ADD CONSTRAINT FK_fact_game_date
    FOREIGN KEY (date_id) REFERENCES dbo.dim_date(date_id);
GO -----

ALTER TABLE dbo.fact_game
ADD CONSTRAINT FK_fact_game_season
    FOREIGN KEY (season_id) REFERENCES dbo.dim_season(season_sk);
GO ----

UPDATE f
SET f.player_id = 0
FROM dbo.fact_combine f
LEFT JOIN dbo.dim_player p ON f.player_id = p.player_id
WHERE p.player_id IS NULL; --(497 rows affected)

ALTER TABLE dbo.fact_combine
ADD CONSTRAINT FK_fact_combine_player
    FOREIGN KEY (player_id) REFERENCES dbo.dim_player(player_id);
GO

UPDATE f
SET f.player_id = 0
FROM dbo.fact_biometry f
LEFT JOIN dbo.dim_player p ON f.player_id = p.player_id
WHERE p.player_id IS NULL; --(0 rows affected)

ALTER TABLE dbo.fact_biometry
ADD CONSTRAINT FK_fact_biometry_player
    FOREIGN KEY (player_id) REFERENCES dbo.dim_player(player_id);
GO

sp_help 'dbo.fact_game';

UPDATE f
SET f.season_id = 0
FROM dbo.fact_game f
LEFT JOIN dbo.dim_season s ON f.season_id = s.season_sk
WHERE s.season_sk IS NULL; --(65642 rows affected)

ALTER TABLE dbo.fact_game
ADD CONSTRAINT FK_fact_game_season
FOREIGN KEY (season_id) REFERENCES dbo.dim_season(season_sk);
GO

SET IDENTITY_INSERT dbo.dim_season ON;

INSERT INTO dbo.dim_season (season_sk, season_name)
VALUES (0, 'Unknown');

SET IDENTITY_INSERT dbo.dim_season OFF;

SELECT DISTINCT f.season_id
FROM dbo.fact_game f
LEFT JOIN dbo.dim_season s ON f.season_id = s.season_sk
WHERE s.season_sk IS NULL; -- 0

EXEC sp_fkeys 'fact_game';

-- KK limpia en game 

ALTER TABLE dbo.fact_game
ADD CONSTRAINT FK_fact_game_season
FOREIGN KEY (season_id) REFERENCES dbo.dim_season(season_sk);

SELECT DISTINCT season_id
FROM dbo.fact_game
WHERE season_id IS NULL
   OR season_id NOT IN (SELECT season_sk FROM dbo.dim_season); -- 0

SET IDENTITY_INSERT dbo.dim_season ON;

INSERT INTO dbo.dim_season (season_sk, season_name)
VALUES (0, 'Unknown');

SET IDENTITY_INSERT dbo.dim_season OFF; -- 1

ALTER TABLE dbo.fact_game
ADD CONSTRAINT FK_fact_game_season
FOREIGN KEY (season_id) REFERENCES dbo.dim_season(season_sk);

SET IDENTITY_INSERT dbo.dim_season ON;

INSERT INTO dbo.dim_season (season_sk, season_name)
VALUES (0, 'Unknown');

SET IDENTITY_INSERT dbo.dim_season OFF;

EXEC sp_fkeys 'fact_game';

SELECT name, type_desc
FROM sys.objects
WHERE name = 'FK_fact_game_season';

ALTER TABLE dbo.fact_game
DROP CONSTRAINT FK_fact_game_season;

ALTER TABLE dbo.fact_game
ADD CONSTRAINT FK_fact_game_season
FOREIGN KEY (season_id) REFERENCES dbo.dim_season(season_sk);

UPDATE f
SET f.team_id_home = 0
FROM dbo.fact_game f
LEFT JOIN dbo.dim_team t ON f.team_id_home = t.team_id
WHERE t.team_id IS NULL; --(100 rows affected)

ALTER TABLE dbo.fact_game
ADD CONSTRAINT FK_fact_game_team_home
FOREIGN KEY (team_id_home) REFERENCES dbo.dim_team(team_id);

UPDATE f
SET f.team_id_away = 0
FROM dbo.fact_game f
LEFT JOIN dbo.dim_team t ON f.team_id_away = t.team_id
WHERE t.team_id IS NULL; --(140 rows affected)

ALTER TABLE dbo.fact_game
ADD CONSTRAINT FK_fact_game_team_away
FOREIGN KEY (team_id_away) REFERENCES dbo.dim_team(team_id);

sp_help 'dbo.fact_game';

sp_help 'dbo.dim_date';

ALTER TABLE dbo.fact_game
ADD date_id INT;

ALTER TABLE dbo.fact_game
ADD date_id INT; -- Existe

UPDATE f
SET f.date_id = d.date_id
FROM dbo.fact_game f
JOIN dbo.dim_date d 
    ON f.game_date = d.full_date; --(65514 rows affected)

ALTER TABLE dbo.fact_game
ADD CONSTRAINT FK_fact_game_date
FOREIGN KEY (date_id) REFERENCES dbo.dim_date(date_id);

SELECT 
    f.name AS FK_name,
    OBJECT_NAME(f.parent_object_id) AS fact_table,
    c1.name AS fact_column,
    OBJECT_NAME (f.referenced_object_id) AS dim_table,
    c2.name AS dim_column
FROM sys.foreign_keys f
INNER JOIN sys.foreign_key_columns fc 
    ON f.object_id = fc.constraint_object_id
INNER JOIN sys.columns c1 
    ON fc.parent_object_id = c1.object_id AND fc.parent_column_id = c1.column_id
INNER JOIN sys.columns c2 
    ON fc.referenced_object_id = c2.object_id AND fc.referenced_column_id = c2.column_id
ORDER BY fact_table, FK_name;
































