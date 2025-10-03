USE NBA_ORLANDOMAGIC;
GO

/* =========================================================
   PRIMARY KEYS (ya definidas al crear tablas)
   ========================================================= */

-- Dimensiones
ALTER TABLE dbo.dim_player ADD CONSTRAINT PK_dim_player PRIMARY KEY (player_id);
ALTER TABLE dbo.dim_team ADD CONSTRAINT PK_dim_team PRIMARY KEY (team_id);
ALTER TABLE dbo.dim_season ADD CONSTRAINT PK_dim_season PRIMARY KEY (season_sk);
ALTER TABLE dbo.dim_date ADD CONSTRAINT PK_dim_date PRIMARY KEY (date_id);
ALTER TABLE dbo.dim_injury_category ADD CONSTRAINT PK_dim_injury_category PRIMARY KEY (injury_category_id);

-- Hechos
ALTER TABLE dbo.fact_player_stats ADD CONSTRAINT PK_fact_player_stats PRIMARY KEY (fact_id);
ALTER TABLE dbo.fact_injuries ADD CONSTRAINT PK_fact_injuries PRIMARY KEY (injury_id);
ALTER TABLE dbo.fact_combine ADD CONSTRAINT PK_fact_combine PRIMARY KEY (combine_id);
ALTER TABLE dbo.fact_game ADD CONSTRAINT PK_fact_game PRIMARY KEY (game_id);
ALTER TABLE dbo.fact_biometry ADD CONSTRAINT PK_fact_biometry PRIMARY KEY (biometry_id);

GO

/* =========================================================
   FOREIGN KEYS
   ========================================================= */

-- Fact Player Stats
ALTER TABLE dbo.fact_player_stats
ADD CONSTRAINT FK_fact_stats_player FOREIGN KEY (player_id) REFERENCES dbo.dim_player(player_id);

ALTER TABLE dbo.fact_player_stats
ADD CONSTRAINT FK_fact_stats_team FOREIGN KEY (team_id) REFERENCES dbo.dim_team(team_id);

ALTER TABLE dbo.fact_player_stats
ADD CONSTRAINT FK_fact_stats_season FOREIGN KEY (season_sk) REFERENCES dbo.dim_season(season_sk);

-- Fact Injuries
ALTER TABLE dbo.fact_injuries
ADD CONSTRAINT FK_fact_injuries_player FOREIGN KEY (player_id) REFERENCES dbo.dim_player(player_id);

ALTER TABLE dbo.fact_injuries
ADD CONSTRAINT FK_fact_injuries_date FOREIGN KEY (date_id) REFERENCES dbo.dim_date(date_id);

ALTER TABLE dbo.fact_injuries
ADD CONSTRAINT FK_fact_injuries_cat1 FOREIGN KEY (main_injury_category_id) REFERENCES dbo.dim_injury_category(injury_category_id);

ALTER TABLE dbo.fact_injuries
ADD CONSTRAINT FK_fact_injuries_cat2 FOREIGN KEY (secondary_injury_category_id) REFERENCES dbo.dim_injury_category(injury_category_id);

-- Fact Combine
ALTER TABLE dbo.fact_combine
ADD CONSTRAINT FK_fact_combine_player FOREIGN KEY (player_id) REFERENCES dbo.dim_player(player_id);

-- Fact Game
ALTER TABLE dbo.fact_game
ADD CONSTRAINT FK_fact_game_date FOREIGN KEY (date_id) REFERENCES dbo.dim_date(date_id);

ALTER TABLE dbo.fact_game
ADD CONSTRAINT FK_fact_game_team1 FOREIGN KEY (team_id_home) REFERENCES dbo.dim_team(team_id);

ALTER TABLE dbo.fact_game
ADD CONSTRAINT FK_fact_game_team2 FOREIGN KEY (team_id_away) REFERENCES dbo.dim_team(team_id);

-- Fact Biometry
ALTER TABLE dbo.fact_biometry
ADD CONSTRAINT FK_fact_biometry_player FOREIGN KEY (player_id) REFERENCES dbo.dim_player(player_id);

GO
