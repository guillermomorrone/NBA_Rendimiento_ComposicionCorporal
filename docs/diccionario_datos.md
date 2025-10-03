# 📑 Diccionario de Datos

Este documento describe las tablas finales del **modelo estrella NBA** con sus columnas, tipos de datos y descripciones.

---

## 🟦 Tabla: dim_date
**Descripción:** Dimensión de fechas utilizada para análisis temporal.

| Columna      | Tipo de dato | Descripción |
|--------------|--------------|-------------|
| date_id (PK) | INT          | Identificador único de la fecha |
| full_date    | DATE         | Fecha completa (AAAA-MM-DD) |
| year         | INT          | Año |
| month        | INT          | Mes (numérico) |
| month_name   | VARCHAR(20)  | Nombre del mes |
| day          | INT          | Día del mes |
| day_name     | VARCHAR(20)  | Nombre del día |

---

## 🟦 Tabla: dim_injury_category
**Descripción:** Categorías de lesiones de jugadores.

| Columna                | Tipo de dato | Descripción |
|-------------------------|--------------|-------------|
| injury_category_id (PK) | INT          | Identificador único de la categoría |
| injury_category         | VARCHAR(50)  | Nombre de la categoría de lesión |

---

## 🟦 Tabla: dim_player
**Descripción:** Información única de cada jugador.

| Columna          | Tipo de dato | Descripción |
|------------------|--------------|-------------|
| player_id (PK)   | INT          | Identificador único del jugador |
| player_name      | VARCHAR(100) | Nombre completo |
| birthdate        | DATE         | Fecha de nacimiento |
| country          | VARCHAR(100) | País de origen |
| height_m         | DECIMAL(4,2) | Altura en metros |
| weight_kg        | DECIMAL(5,2) | Peso en kilogramos |
| BMI              | DECIMAL(5,2) | Índice de masa corporal |
| body_fat_pct_est | DECIMAL(5,2) | % de grasa estimado |
| fat_mass_kg      | DECIMAL(6,2) | Masa grasa en kilogramos |
| lean_mass_kg     | DECIMAL(6,2) | Masa magra en kilogramos |
| main_position    | VARCHAR(20)  | Posición principal |
| draft_year       | INT          | Año del draft |
| from_year        | INT          | Año debut en NBA |
| to_year          | INT          | Última temporada jugada |
| age_at_debut     | INT          | Edad al debutar |
| age_at_last_season | INT        | Edad en la última temporada |

---

## 🟦 Tabla: dim_season
**Descripción:** Dimensión de temporadas de la NBA.

| Columna       | Tipo de dato | Descripción |
|---------------|--------------|-------------|
| season_id (PK)| INT          | Identificador único de la temporada |
| season_year   | VARCHAR(20)  | Identificador tipo “1996-97” |

---

## 🟦 Tabla: dim_team
**Descripción:** Información única de cada equipo.

| Columna      | Tipo de dato | Descripción |
|--------------|--------------|-------------|
| team_id (PK) | INT          | Identificador único del equipo |
| team_name    | VARCHAR(100) | Nombre del equipo |
| team_abbr    | VARCHAR(10)  | Abreviatura |
| city         | VARCHAR(100) | Ciudad |
| state        | VARCHAR(100) | Estado/Región |
| year_founded | INT          | Año de fundación |

---

## 🟨 Tabla: fact_biometry
**Descripción:** Historial biométrico de jugadores.

| Columna            | Tipo de dato | Descripción |
|--------------------|--------------|-------------|
| biometry_id (PK)   | INT          | Identificador único |
| player_id (FK)     | INT          | Jugador asociado |
| season_id (FK)     | INT          | Temporada |
| height_m           | DECIMAL(4,2) | Altura en metros |
| weight_kg          | DECIMAL(5,2) | Peso en kg |
| body_fat_pct_est   | DECIMAL(5,2) | % de grasa estimado |

---

## 🟨 Tabla: fact_combine
**Descripción:** Resultados de las pruebas físicas del Draft Combine.

| Columna           | Tipo de dato | Descripción |
|-------------------|--------------|-------------|
| combine_id (PK)   | INT          | Identificador único |
| player_id (FK)    | INT          | Jugador evaluado |
| season_id (FK)    | INT          | Año del combine |
| wingspan_m        | DECIMAL(4,2) | Envergadura |
| standing_reach_m  | DECIMAL(4,2) | Alcance |
| vertical_leap_m   | DECIMAL(4,2) | Salto vertical |
| agility_sec       | DECIMAL(4,2) | Tiempo en prueba de agilidad |

---

## 🟨 Tabla: fact_game
**Descripción:** Información de partidos de la NBA.

| Columna          | Tipo de dato | Descripción |
|------------------|--------------|-------------|
| game_id (PK)     | INT          | Identificador único del partido |
| date_id (FK)     | INT          | Fecha del partido |
| season_id (FK)   | INT          | Temporada |
| team_home_id (FK)| INT          | Equipo local |
| team_away_id (FK)| INT          | Equipo visitante |
| pts_home         | INT          | Puntos del equipo local |
| pts_away         | INT          | Puntos del equipo visitante |
| home_win         | BIT          | 1 = local ganó, 0 = perdió |

---

## 🟨 Tabla: fact_injuries
**Descripción:** Historial de lesiones de jugadores.

| Columna                      | Tipo de dato | Descripción |
|------------------------------|--------------|-------------|
| injury_id (PK)               | INT          | Identificador único |
| date_id (FK)                 | INT          | Fecha de la lesión |
| player_id (FK)               | INT          | Jugador lesionado |
| main_injury_category_id (FK) | INT          | Categoría principal |
| secondary_injury_category_id (FK) | INT     | Categoría secundaria |
| injury_category_text          | VARCHAR(100)| Texto original de la lesión |
| status                        | VARCHAR(50) | Estado (Relinquished, Acquired, etc.) |

---

## 🟨 Tabla: fact_player_stats
**Descripción:** Estadísticas de jugadores en partidos.

| Columna         | Tipo de dato | Descripción |
|-----------------|--------------|-------------|
| stat_id (PK)    | INT          | Identificador único |
| player_id (FK)  | INT          | Jugador |
| game_id (FK)    | INT          | Partido |
| season_id (FK)  | INT          | Temporada |
| pts             | INT          | Puntos |
| reb             | INT          | Rebotes |
| ast             | INT          | Asistencias |
| stl             | INT          | Robos |
| blk             | INT          | Tapones |
| tov             | INT          | Pérdidas |
| fg_pct          | DECIMAL(4,3) | % de tiros de campo |
| fg3_pct         | DECIMAL(4,3) | % de triples |
| ft_pct          | DECIMAL(4,3) | % de tiros libres |
