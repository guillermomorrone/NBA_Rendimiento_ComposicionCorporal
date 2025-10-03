USE NBA_ORLANDOMAGIC;
GO

-- Preview: vemos cómo quedaría la carga de fact_injuries
SELECT TOP 20 
    d.date_id,
    t.team_id,
    p.player_id,
    c.injury_category_id,
    s.Status
FROM dbo.stg_injuries s
JOIN dbo.dim_date d 
    ON s.Date = d.full_date
JOIN dbo.dim_team t 
    ON s.Team = t.team_name
JOIN dbo.dim_player p 
    ON s.name_clean = p.player_name
JOIN dbo.dim_injury_category c
    ON s.InjuryCategory LIKE '%' + c.injury_category + '%';

-- Equipos en staging
SELECT DISTINCT Team FROM dbo.stg_injuries ORDER BY Team;

-- Equipos en dimensión
SELECT DISTINCT team_name FROM dbo.dim_team ORDER BY team_name;

-- Jugadores en staging
SELECT TOP 20 name_clean FROM dbo.stg_injuries;

-- Jugadores en dimensión
SELECT TOP 20 player_name FROM dbo.dim_player;

USE NBA_ORLANDOMAGIC;
GO

-- Preview: ver si los JOIN encuentran coincidencias
SELECT TOP 20 
    d.date_id,
    p.player_id,
    c.injury_category_id,
    s.Status
FROM dbo.stg_injuries s
JOIN dbo.dim_date d 
    ON s.Date = d.full_date
JOIN dbo.dim_player p 
    ON s.name_clean = p.player_name
JOIN dbo.dim_injury_category c
    ON s.InjuryCategory LIKE '%' + c.injury_category + '%';

USE NBA_ORLANDOMAGIC;
GO

SELECT TOP 20 
    s.name_clean,
    p.player_name
FROM dbo.stg_injuries s
JOIN dbo.dim_player p
    ON p.player_name LIKE s.name_clean + '%';


