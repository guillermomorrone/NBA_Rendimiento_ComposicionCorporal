<<<<<<< Updated upstream
# NBA_ComposicionCorporal_Rendimiento
Proyecto Final de Data Analytics - Análisis de cómo la composición corporal influye en el rendimiento de jugadores de la NBA.
=======
# 🏀 NBA – Composición Corporal, Rendimiento y Lesiones

Proyecto colaborativo **LEG Analytics** – Data Analytics Bootcamp.  
Análisis integral de la NBA para relacionar **composición corporal**, **rendimiento deportivo** y **lesiones** mediante el analisis con Python, SQL, PBI.
>>>>>>> Stashed changes

<!-- Banner -->
![Banner del proyecto](docs/img/banner.png)  
*(Banner con el título del proyecto + logos NBA/Orlando Magic. Tamaño recomendado: 1200×300 px)*

---

## 📌 Contexto
**Cliente:** Departamento *Player Performance & Sports Science* de **Orlando Magic (NBA)**.  
**Misión:** Optimizar el desarrollo físico, reducir el riesgo de lesiones y mejorar la preparación integral.  

---

<<<<<<< Updated upstream
## Entregables
1. Base de datos en SQL Server.  
2. Notebooks en Python con limpieza y análisis.  
3. Dashboard en Power BI.  
4. Documentación del proyecto.  
=======
## 🎯 Objetivos
- Identificar perfiles físicos óptimos por posición y estilo de juego.  
- Relacionar composición corporal y morfología con rendimiento en cancha.  
- Detectar métricas clave para anticipar desempeño.  
- Predecir riesgos de lesiones mediante análisis de datos.  
- Construir un dashboard con KPIs clave para la toma de decisiones.  

---

## 🔄 Pipeline de trabajo

![Pipeline de trabajo](docs/img/pipeline.png)  
*(Flujo: `Datasets → Limpieza/Transformación → SQL Modelo Estrella → Dashboard Power BI`)*

1. **Datasets originales** (`/data_raw/`)  
   - common_player_info  
   - draft_combine_info  
   - game_info  
   - NBA_PLAYER_DATASET  
   - NBA_Player_Injury  

2. **Limpieza y transformación** (`/notebooks/` + `/docs/cleaning_reports/`)  
   - Notebooks de limpieza (Python)  
   - Reportes de documentación  

3. **Modelo Estrella en SQL Server** (`/sql/`)  
   - Tablas `dim` y `fact`  
   - Relaciones PK/FK  
   - Script MER global  

4. **Dashboard Power BI** (`/dashboards/`)  
   - KPIs de composición corporal, rendimiento y lesiones  
   - Filtros por equipo, temporada y posición. 

---

## 📂 Estructura del repositorio

/data_raw/ → datasets originales  
/data_clean/ → datasets limpios listos para SQL  
/sql/ → scripts SQL del modelo estrella  
/sql/staging/ → tablas staging  
/sql/keys/ → llaves PK/FK y constraints  
/sql/pruebas/ → scripts de prueba y versiones anteriores  
/notebooks/ → notebooks de limpieza y análisis  
/dashboards/ → dashboard Power BI y capturas  
/docs/ → documentación del proyecto, diccionario de datos
/docs/cleaning_reports/ → reportes de profiling y limpieza  
/docs/img/ → imágenes (banner, pipeline, MER, dashboard)  

---

## 📑 Recursos principales

### 🧹 Limpieza de datos
- [Notebooks de limpieza](./notebooks/)  
- [Cleaning reports](./docs/cleaning_reports/)  

### 🗄️ Modelo Estrella (SQL)
- [00_MER_DATABASE_ORLANDOMAGIC.sql](./sql/00_MER_DATABASE_ORLANDOMAGIC.sql)  
- [01_dim_player_team.sql](./sql/01_dim_player_team.sql)  
- [02_fact_combine.sql](./sql/02_fact_combine.sql)  
- [03_fact_game.sql](./sql/03_fact_game.sql)  
- [04_fact_injuries.sql](./sql/04_fact_injuries.sql)  
- [05_fact_player_stats.sql](./sql/05_fact_player_stats.sql)
- [06_dim_date.sql](./sql/dim_date.sql)  

---

## 🗺 Modelo Estrella

![Modelo Estrella](docs/img/mer.png)  
*(Diagrama estrella con dim_player, dim_team, dim_date, dim_season, fact_game, fact_player_stats, fact_combine, fact_injuries)*

---

## 📊 Dashboard

![Dashboard - Overview](docs/img/dashboard_1.png)  
*(KPIs principales: equipos, jugadores, temporadas. Promedio de peso y altura por posición)*

![Dashboard - Player Profile](docs/img/dashboard_2.png)  
*(KPIs principales: AVG IMC, masa grasa, masa muscular, % masa grasa. Detalle de jugadores por posicion y biometría)*

![Dashboard - Player Profile](docs/img/dashboard_3.png)  
*(KPIs principales: AVG IMC, AVG masa grasa, AVG masa muscular. Analisis temporal, altura, peso, masa grasa y masa muscular)*

---

## 👥 Equipo

- Lorena Maza  
- Eliana Olmedo  
- Guillermo Morrone  
>>>>>>> Stashed changes
