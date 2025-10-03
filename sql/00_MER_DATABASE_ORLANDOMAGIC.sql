USE NBA_ORLANDOMAGIC
GO

sp_help 'dbo.dim_draft';

SELECT * from dim_draft 

USE NBA_ORLANDOMAGIC
GO

-- 1. Agregamos la columna como INT (ya correcto)
ALTER TABLE dbo.dim_player
ADD draft_year INT NULL;
GO

-- 2. Poblarla casteando
UPDATE p
SET p.draft_year = TRY_CAST(s.draft_year AS INT)
FROM dbo.dim_player p
LEFT JOIN dbo.common_player_info_ready s
    ON p.player_id = s.person_id;
GO 

-- (4172 rows affected)

SELECT * From dim_player

-- 3. Validación rápida
SELECT TOP 20 player_id, player_name, draft_year
FROM dbo.dim_player
ORDER BY draft_year DESC;

DROP TABLE dim_draft

