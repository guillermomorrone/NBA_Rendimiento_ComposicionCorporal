Documentación del proceso de limpieza – NBA_PLAYER_DATASET

Introducción

El objetivo de este notebook fue realizar la limpieza y normalización del dataset NBA_PLAYER_DATASET, garantizando consistencia en los datos para futuros análisis de rendimiento y dashboards.

Se siguió un flujo estandarizado de trabajo con datos:

Carga del dataset crudo desde data_raw/.

Exploración inicial (dimensiones, tipos de datos, valores nulos y duplicados).

Limpieza de datos: imputación de nulos, normalización de nombres y conversión de tipos.

Análisis exploratorio: estadísticas descriptivas y visualizaciones.

Exportación del dataset final limpio a data_clean/.

Exploración inicial

El dataset fue cargado desde ../data_raw/NBA_PLAYER_DATASET.csv.

Se revisaron dimensiones (shape), tipos de datos (info()), y primeras filas (head()).

Se detectaron columnas con valores nulos en métricas de rendimiento (GS, FG3M, FG3A, OREB, DREB, TOV, entre otras).

Se observaron duplicados en jugadores con múltiples registros por temporada.

Algunos nombres de jugadores presentaban inconsistencias (espacios extra, guiones).

Limpieza aplicada

Imputación de nulos:

Columnas de rendimiento (GS, FG3M, FG3A, STL, BLK, OREB, DREB, TOV) → reemplazados por 0.

TEAM_ABBREVIATION → nulos reemplazados por "TOT" (jugadores con múltiples equipos en una temporada).

Otras métricas menores (MIN, REB, FT_PCT, FG_PCT) → reemplazadas por 0.

Conversión de tipos:

Columnas enteras (PLAYER_AGE, GS, MIN, FG3M, FG3A, OREB, DREB, REB, STL, BLK, TOV) pasadas a int.

Normalización de nombres:

Creación de columna Name_clean:

Eliminación de espacios extra.

Reemplazo de guiones por espacios.

Formato título.

Detección de duplicados:

Se identificaron jugadores con múltiples registros por temporada mediante PLAYER_ID + SEASON_ID.

Análisis exploratorio

Se realizaron distintas visualizaciones descriptivas:

Distribución de edades (histograma).

Evolución de puntos promedio por temporada (línea temporal).

Ranking de máximos anotadores históricos (Top 10).

Distribución de porcentajes de tiro (FG_PCT, FG3_PCT, FT_PCT) con boxplots.

Matriz de correlación entre métricas de rendimiento (puntos, rebotes, asistencias, robos, bloqueos, pérdidas y porcentajes de tiro).

Estos gráficos permitieron detectar patrones generales de rendimiento y validar la consistencia de los datos.

Exportación final

El dataset limpio fue exportado a la carpeta data_clean/ con el siguiente nombre:

NBA_PLAYER_DATASET_ready.csv


Ruta relativa desde notebooks:

df.to_csv("../data_clean/NBA_PLAYER_DATASET_ready.csv", index=False)


Este archivo es la versión lista para análisis y puede ser utilizada en:

Dashboards en Power BI.

Modelado estadístico o de machine learning.

Integración con bases de datos SQL.

Conclusión

El proceso de limpieza permitió transformar el dataset NBA_PLAYER_DATASET en una versión estructurada, consistente y lista para análisis.
Gracias a la organización en carpetas (data_raw/, data_clean/, notebooks/, src/), el flujo de trabajo es reproducible y escalable, facilitando el trabajo en equipo y la trazabilidad de los cambios.