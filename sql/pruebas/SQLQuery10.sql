USE NBA_ORLANDOMAGIC 
GO

IF OBJECT_ID('stg_injuries', 'U') IS NOT NULL
    DROP TABLE stg_injuries;
GO

CREATE TABLE stg_injuries (
    injury_id INT IDENTITY(1,1) PRIMARY KEY,
    injury_date DATE,
    team NVARCHAR(100),
    player_name NVARCHAR(100),
    status NVARCHAR(50),
    injury_category NVARCHAR(50)
);
GO
