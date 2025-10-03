USE NBA_ORLANDOMAGIC;
GO

-- Si ya existe, la borramos
IF OBJECT_ID('dbo.fact_injuries', 'U') IS NOT NULL
    DROP TABLE dbo.fact_injuries;
GO

-- Crear nueva fact_injuries
CREATE TABLE dbo.fact_injuries (
    injury_id INT IDENTITY(1,1) PRIMARY KEY,   -- clave surrogate
    date_id INT NOT NULL,                      -- FK → dim_date
    player_id INT NOT NULL,                    -- FK → dim_player
    main_injury_category_id INT NULL,          -- FK → dim_injury_category
    secondary_injury_category_id INT NULL,     -- FK opcional → dim_injury_category
    injury_category_text VARCHAR(100),         -- texto original de la lesión
    status VARCHAR(50)                         -- estado (Relinquished, Acquired)
);
GO

-- Limpiamos la tabla antes de insertar
TRUNCATE TABLE dbo.fact_injuries;
GO

-- Insertamos solo 20 filas para validar
INSERT INTO dbo.fact_injuries (date_id, player_id, main_injury_category_id, secondary_injury_category_id, injury_category_text, status)
SELECT TOP 20
    d.date_id,
    p.player_id,
    c1.injury_category_id AS main_injury,
    c2.injury_category_id AS secondary_injury,
    s.InjuryCategory AS injury_category_text,  -- guardamos el texto original
    s.Status
FROM dbo.stg_injuries s
JOIN dbo.dim_date d 
    ON s.Date = d.full_date
JOIN dbo.dim_player p 
    ON p.player_name LIKE s.name_clean + '%'
LEFT JOIN dbo.dim_injury_category c1
    ON UPPER(LTRIM(RTRIM(c1.injury_category))) = 
       UPPER(LTRIM(RTRIM(
            LEFT(s.InjuryCategory, 
                 CASE 
                     WHEN CHARINDEX('/', s.InjuryCategory) > 0 
                     THEN CHARINDEX('/', s.InjuryCategory) - 1
                     ELSE LEN(s.InjuryCategory)
                 END))))
LEFT JOIN dbo.dim_injury_category c2
    ON CHARINDEX('/', s.InjuryCategory) > 0
   AND UPPER(LTRIM(RTRIM(c2.injury_category))) = 
       UPPER(LTRIM(RTRIM(
            RIGHT(s.InjuryCategory, LEN(s.InjuryCategory) - CHARINDEX('/', s.InjuryCategory)))));
GO

-- Validamos los 20 registros insertados
SELECT TOP 20 
    f.injury_id, 
    f.date_id, 
    p.player_name, 
    f.injury_category_text, 
    c1.injury_category AS main_injury, 
    c2.injury_category AS secondary_injury, 
    f.status
FROM dbo.fact_injuries f
JOIN dbo.dim_player p ON f.player_id = p.player_id
LEFT JOIN dbo.dim_injury_category c1 ON f.main_injury_category_id = c1.injury_category_id
LEFT JOIN dbo.dim_injury_category c2 ON f.secondary_injury_category_id = c2.injury_category_id;

-- Valores únicos de categorías en staging
SELECT DISTINCT InjuryCategory
FROM dbo.stg_injuries
ORDER BY InjuryCategory;

-- Valores únicos en la dimensión
SELECT DISTINCT injury_category
FROM dbo.dim_injury_category
ORDER BY injury_category;

-- Insertar categorías correctas en la dimensión
INSERT INTO dbo.dim_injury_category (injury_category)
SELECT v.cat
FROM (VALUES 
    ('Ankle'),
    ('Foot'),
    ('Arm'),
    ('Hand'),
    ('Back'),
    ('Head'),
    ('Illness'),
    ('Knee'),
    ('Muscular'),
    ('Other'),
    ('Surgery'),
    ('Unknown')
) v(cat)
WHERE NOT EXISTS (
    SELECT 1 
    FROM dbo.dim_injury_category c 
    WHERE c.injury_category = v.cat
);

SELECT * 
FROM dbo.dim_injury_category
ORDER BY injury_category;

USE NBA_ORLANDOMAGIC; -- Crear dimension desde cero 
GO

-- Borrar si existía algo con el mismo nombre
IF OBJECT_ID('dbo.dim_injury_category', 'U') IS NOT NULL
    DROP TABLE dbo.dim_injury_category;
GO

-- Crear la tabla de categorías de lesiones
CREATE TABLE dbo.dim_injury_category (
    injury_category_id INT IDENTITY(1,1) PRIMARY KEY,
    injury_category VARCHAR(100) NOT NULL
);
GO

INSERT INTO dbo.dim_injury_category (injury_category)
VALUES 
    ('Ankle'),
    ('Foot'),
    ('Arm'),
    ('Hand'),
    ('Back'),
    ('Head'),
    ('Illness'),
    ('Knee'),
    ('Muscular'),
    ('Other'),
    ('Surgery'),
    ('Unknown');


	SELECT * 
FROM dbo.dim_injury_category
ORDER BY injury_category;

TRUNCATE TABLE dbo.fact_injuries;
GO

INSERT INTO dbo.fact_injuries (
    date_id, 
    player_id, 
    main_injury_category_id, 
    secondary_injury_category_id, 
    injury_category_text, 
    status
)
SELECT TOP 20
    d.date_id,
    p.player_id,
    ISNULL(c1.injury_category_id, u.injury_category_id) AS main_injury,
    c2.injury_category_id AS secondary_injury,
    s.InjuryCategory AS injury_category_text,
    s.Status
FROM dbo.stg_injuries s
JOIN dbo.dim_date d 
    ON s.Date = d.full_date
JOIN dbo.dim_player p 
    ON p.player_name LIKE s.name_clean + '%'
LEFT JOIN dbo.dim_injury_category c1
    ON UPPER(LTRIM(RTRIM(c1.injury_category))) = 
       UPPER(LTRIM(RTRIM(
            LEFT(s.InjuryCategory, 
                 CASE 
                     WHEN CHARINDEX('/', s.InjuryCategory) > 0 
                     THEN CHARINDEX('/', s.InjuryCategory) - 1
                     ELSE LEN(s.InjuryCategory)
                 END))))
LEFT JOIN dbo.dim_injury_category c2
    ON CHARINDEX('/', s.InjuryCategory) > 0
   AND UPPER(LTRIM(RTRIM(c2.injury_category))) = 
       UPPER(LTRIM(RTRIM(
            RIGHT(s.InjuryCategory, LEN(s.InjuryCategory) - CHARINDEX('/', s.InjuryCategory)))))
CROSS JOIN (SELECT injury_category_id 
            FROM dbo.dim_injury_category 
            WHERE injury_category = 'Unknown') u;
GO

SELECT TOP 20 
    f.injury_id, 
    p.player_name, 
    f.injury_category_text, 
    c1.injury_category AS main_injury, 
    c2.injury_category AS secondary_injury, 
    f.status
FROM dbo.fact_injuries f
JOIN dbo.dim_player p ON f.player_id = p.player_id
LEFT JOIN dbo.dim_injury_category c1 ON f.main_injury_category_id = c1.injury_category_id
LEFT JOIN dbo.dim_injury_category c2 ON f.secondary_injury_category_id = c2.injury_category_id; -- ok 

TRUNCATE TABLE dbo.fact_injuries;
GO

INSERT INTO dbo.fact_injuries (
    date_id, 
    player_id, 
    main_injury_category_id, 
    secondary_injury_category_id, 
    injury_category_text, 
    status
)
SELECT 
    d.date_id,
    p.player_id,
    ISNULL(c1.injury_category_id, u.injury_category_id) AS main_injury,
    c2.injury_category_id AS secondary_injury,
    s.InjuryCategory AS injury_category_text,
    s.Status
FROM dbo.stg_injuries s
JOIN dbo.dim_date d 
    ON s.Date = d.full_date
JOIN dbo.dim_player p 
    ON p.player_name LIKE s.name_clean + '%'
LEFT JOIN dbo.dim_injury_category c1
    ON UPPER(LTRIM(RTRIM(c1.injury_category))) = 
       UPPER(LTRIM(RTRIM(
            LEFT(s.InjuryCategory, 
                 CASE 
                     WHEN CHARINDEX('/', s.InjuryCategory) > 0 
                     THEN CHARINDEX('/', s.InjuryCategory) - 1
                     ELSE LEN(s.InjuryCategory)
                 END))))
LEFT JOIN dbo.dim_injury_category c2
    ON CHARINDEX('/', s.InjuryCategory) > 0
   AND UPPER(LTRIM(RTRIM(c2.injury_category))) = 
       UPPER(LTRIM(RTRIM(
            RIGHT(s.InjuryCategory, LEN(s.InjuryCategory) - CHARINDEX('/', s.InjuryCategory)))))
CROSS JOIN (SELECT injury_category_id 
            FROM dbo.dim_injury_category 
            WHERE injury_category = 'Unknown') u; -- 10120 rows afectadas
GO

SELECT injury_category_text, COUNT(*) AS total
FROM dbo.fact_injuries
GROUP BY injury_category_text
ORDER BY total DESC;

SELECT COUNT(*) AS total_unknown
FROM dbo.fact_injuries f
JOIN dbo.dim_injury_category c ON f.main_injury_category_id = c.injury_category_id
WHERE c.injury_category = 'Unknown';

/* 
------------------------------------------------------------
📌 Validación de categorías de lesiones (fact_injuries)
------------------------------------------------------------

Resultado del conteo por categoría original (injury_category_text):

- Ankle/Foot  →  2.613
- Knee        →  2.243
- Muscular    →  1.355
- Back        →  1.276
- Arm/Hand    →  1.166
- Illness     →  1.048
- Other       →    191
- Head        →    188
- Surgery     →     40

✅ Se preserva el texto original de la lesión en `injury_category_text`.
✅ Se mapearon categorías principales/secundarias con la dimensión.
👉 Esto permite analizar, por ejemplo:
   - Jugadores con más lesiones de rodilla (Knee).
   - Evolución de lesiones de tobillo vs pie (Ankle vs Foot).
   - Proporción de lesiones de espalda (Back) por década.
   - Comparaciones entre categorías frecuentes y raras.
*/


