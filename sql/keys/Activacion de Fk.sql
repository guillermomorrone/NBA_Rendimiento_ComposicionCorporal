USE NBA_ORLANDOMAGIC;
GO

/* =========================================================
   1. Insertar registros "Unknown" en las dimensiones
   ========================================================= */

-- Dimensión Team
IF NOT EXISTS (SELECT 1 FROM dbo.dim_team WHERE team_id = 0)
BEGIN
    INSERT INTO dbo.dim_team (team_id, team_name, team_abbreviation, team_code, team_city)
    VALUES (0, 'Unknown Team', 'UNK', 'UNK', 'Unknown');
END
GO

-- Dimensión Player
IF NOT EXISTS (SELECT 1 FROM dbo.dim_player WHERE player_id = 0)
BEGIN
    INSERT INTO dbo.dim_player (
        player_id, player_name, birthdate, country, school,
        from_year, to_year, age_at_debut, age_at_last_season,
        height_m, weight_kg, BMI, body_fat_pct_est,
        fat_mass_kg, lean_mass_kg, main_position
    )
    VALUES (0, 'Unknown Player', NULL, 'Unknown', 'Unknown',
            NULL, NULL, NULL, NULL,
            NULL, NULL, NULL, NULL, NULL, NULL, 'UNK');
END
GO

-- Dimensión Season
IF NOT EXISTS (SELECT 1 FROM dbo.dim_season WHERE season_sk = 0)
BEGIN
    INSERT INTO dbo.dim_season (season_sk, season_name)
    VALUES (0, 'Unknown Season');
END
GO

IF NOT EXISTS (SELECT 1 FROM dbo.dim_season WHERE season_name = 'Unknown Season')
BEGIN
    INSERT INTO dbo.dim_season (season_name)
    VALUES ('Unknown Season');
END


-- Dimensión Date
IF NOT EXISTS (SELECT 1 FROM dbo.dim_date WHERE date_id = 0)
BEGIN
    INSERT INTO dbo.dim_date (date_id, full_date, year, month, day, quarter)
    VALUES (0, '1900-01-01', 1900, 1, 1, 1);
END
GO

/* =========================================================
   2. Crear claves foráneas en las tablas de hechos
   ========================================================= */

-- Fact Player Stats
ALTER TABLE dbo.fact_player_stats
ADD CONSTRAINT FK_fact_stats_player FOREIGN KEY (player_id) REFERENCES dbo.dim_player(player_id);
GO

UPDATE f
SET f.player_id = 0
FROM dbo.fact_player_stats f
LEFT JOIN dbo.dim_player p ON f.player_id = p.player_id
WHERE p.player_id IS NULL;

ALTER TABLE dbo.fact_player_stats
ADD CONSTRAINT FK_fact_stats_player FOREIGN KEY (player_id) REFERENCES dbo.dim_player(player_id);


ALTER TABLE dbo.fact_player_stats
ADD CONSTRAINT FK_fact_stats_team FOREIGN KEY (team_id) REFERENCES dbo.dim_team(team_id);
GO

---

/* =========================================================
   Saneos en fact_player_stats antes de crear las FK
   ========================================================= */

-- Player
UPDATE f
SET f.player_id = 0
FROM dbo.fact_player_stats f
LEFT JOIN dbo.dim_player p ON f.player_id = p.player_id
WHERE p.player_id IS NULL;

-- Team
UPDATE f
SET f.team_id = 0
FROM dbo.fact_player_stats f
LEFT JOIN dbo.dim_team t ON f.team_id = t.team_id
WHERE t.team_id IS NULL;

-- Season
UPDATE f
SET f.season_sk = 0
FROM dbo.fact_player_stats f
LEFT JOIN dbo.dim_season s ON f.season_sk = s.season_sk
WHERE s.season_sk IS NULL;

ALTER TABLE dbo.fact_player_stats
ADD CONSTRAINT FK_fact_stats_player FOREIGN KEY (player_id) REFERENCES dbo.dim_player(player_id);

ALTER TABLE dbo.fact_player_stats
ADD CONSTRAINT FK_fact_stats_team FOREIGN KEY (team_id) REFERENCES dbo.dim_team(team_id);

ALTER TABLE dbo.fact_player_stats
ADD CONSTRAINT FK_fact_stats_season FOREIGN KEY (season_sk) REFERENCES dbo.dim_season(season_sk);

SELECT name, type_desc
FROM sys.objects
WHERE parent_object_id = OBJECT_ID('dbo.fact_player_stats')
  AND type = 'F';

ALTER TABLE dbo.fact_player_stats
ADD CONSTRAINT FK_fact_stats_season FOREIGN KEY (season_sk) REFERENCES dbo.dim_season(season_sk);
GO

----------------
-- Player
UPDATE f
SET f.player_id = 0
FROM dbo.fact_injuries f
LEFT JOIN dbo.dim_player p ON f.player_id = p.player_id
WHERE p.player_id IS NULL;

-- Date
UPDATE f
SET f.date_id = 0
FROM dbo.fact_injuries f
LEFT JOIN dbo.dim_date d ON f.date_id = d.date_id
WHERE d.date_id IS NULL;

-- Categorías
UPDATE f
SET f.main_injury_category_id = 0
FROM dbo.fact_injuries f
LEFT JOIN dbo.dim_injury_category c ON f.main_injury_category_id = c.injury_category_id
WHERE c.injury_category_id IS NULL;

UPDATE f
SET f.secondary_injury_category_id = 0
FROM dbo.fact_injuries f
LEFT JOIN dbo.dim_injury_category c ON f.secondary_injury_category_id = c.injury_category_id
WHERE c.injury_category_id IS NULL;

UPDATE f
SET f.player_id = 0
FROM dbo.fact_injuries f
LEFT JOIN dbo.dim_player p ON f.player_id = p.player_id
WHERE p.player_id IS NULL;

UPDATE f
SET f.date_id = 0
FROM dbo.fact_injuries f
LEFT JOIN dbo.dim_date d ON f.date_id = d.date_id
WHERE d.date_id IS NULL;

UPDATE f
SET f.main_injury_category_id = 0
FROM dbo.fact_injuries f
LEFT JOIN dbo.dim_injury_category c ON f.main_injury_category_id = c.injury_category_id
WHERE c.injury_category_id IS NULL;

ALTER TABLE dbo.fact_injuries
ADD CONSTRAINT FK_fact_injuries_player FOREIGN KEY (player_id) REFERENCES dbo.dim_player(player_id),
    CONSTRAINT FK_fact_injuries_date FOREIGN KEY (date_id) REFERENCES dbo.dim_date(date_id),
    CONSTRAINT FK_fact_injuries_cat1 FOREIGN KEY (main_injury_category_id) REFERENCES dbo.dim_injury_category(injury_category_id),
    CONSTRAINT FK_fact_injuries_cat2 FOREIGN KEY (secondary_injury_category_id) REFERENCES dbo.dim_injury_category(injury_category_id);

SELECT DISTINCT f.secondary_injury_category_id
FROM dbo.fact_injuries f
LEFT JOIN dbo.dim_injury_category c 
       ON f.secondary_injury_category_id = c.injury_category_id
WHERE c.injury_category_id IS NULL;

IF NOT EXISTS (SELECT 1 FROM dbo.dim_injury_category WHERE injury_category_id = 0)
BEGIN
    INSERT INTO dbo.dim_injury_category (injury_category_id, category_name)
    VALUES (0, 'Unknown Injury Category');
END

sp_help 'dbo.dim_injury_category';

INSERT INTO dbo.dim_injury_category (injury_category_id, injury_category)
VALUES (0, 'Unknown');

SET IDENTITY_INSERT dbo.dim_injury_category ON;

INSERT INTO dbo.dim_injury_category (injury_category_id, injury_category)
VALUES (0, 'Unknown');

SET IDENTITY_INSERT dbo.dim_injury_category OFF;

ALTER TABLE dbo.fact_injuries
ADD CONSTRAINT FK_fact_injuries_cat2
FOREIGN KEY (secondary_injury_category_id)
REFERENCES dbo.dim_injury_category(injury_category_id);
GO

--- fact_player_stats conectado con dim_player, dim_team, dim_season.

--- fact_injuries conectado con dim_date, dim_player, dim_injury_category (primaria y secundaria).

--- fact_combine y fact_biometry conectados con dim_player.


