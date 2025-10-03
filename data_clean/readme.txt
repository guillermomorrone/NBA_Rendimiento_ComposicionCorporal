# 🏀 NBA – Composición Corporal, Rendimiento y Lesiones

Proyecto colaborativo **LEG Analytics** – Data Analytics Bootcamp.  
Análisis integral de la NBA para relacionar **composición corporal**, **rendimiento deportivo** y **lesiones** mediante un modelo estrella y dashboard interactivo.

<!-- Banner -->
![Banner del proyecto](docs/img/banner.png)  
*(Banner con el título del proyecto + logos NBA/Orlando Magic. Tamaño recomendado: 1200×300 px)*

---

## 📌 Contexto
**Cliente:** Departamento *Player Performance & Sports Science* de **Orlando Magic (NBA)**.  
**Misión:** Optimizar el desarrollo físico, reducir el riesgo de lesiones y mejorar la preparación integral.  

---

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
   - Reportes de profiling/documentación  

3. **Modelo Estrella en SQL Server** (`/sql/`)  
   - Tablas `staging`, `dim` y `fact`  
   - Relaciones PK/FK  
   - Script MER global  

4. **Dashboard Power BI** (`/dashboards/`)  
   - KPIs de composición corporal, rendimiento y lesiones  
   - Filtros por jugador, equipo y temporada  

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
/docs/ → documentación del proyecto  
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
- [06_fact_biometry.sql](./sql/06_fact_biometry.sql)  
- [dim_date.sql](./sql/dim_date.sql)  

---

## 🗺 Modelo Estrella

![Modelo Estrella](docs/img/mer.png)  
*(Diagrama estrella con dim_player, dim_team, dim_date, fact_game, fact_biometry, fact_injuries)*

---

## 📊 Dashboard

![Dashboard - Overview](docs/img/dashboard_overview.png)  
*(KPIs principales: composición corporal, rendimiento y lesiones)*

![Dashboard - Player Profile](docs/img/dashboard_player.png)  
*(Detalle de jugador con biometría y riesgo de lesión)*

---

## 👥 Equipo

- Lorena Maza  
- Eliana Olmedo  
- Guillermo Morrone  
✅ Pasos que tenés que hacer ahora:

En tu repo: crear la carpeta docs/img/.

Guardar las imágenes con estos nombres:

banner.png

pipeline.png

mer.png

dashboard_overview.png

dashboard_player.png

En VSCode: abrí el README y con Ctrl+Shift+V (Preview Markdown) comprobá que se vean.