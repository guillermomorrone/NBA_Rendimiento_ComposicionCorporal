Reporte de Limpieza – game.csv
Observaciones iniciales

La tabla tiene 65.698 registros y 55 columnas.

Claves principales: game_id (único por partido), junto con team_id_home y team_id_away.

La columna game_date estaba en formato texto → convertida a datetime.

Columnas de resultado: wl_home y wl_away, con valores W/L y algunos nulos.

Métricas: puntos, rebotes, asistencias, robos, pérdidas, tiros de campo, triples, libres, etc. separadas en _home y _away.

Existen muchos valores nulos en estadísticas defensivas de temporadas antiguas.

Columna min presentó valores poco realistas (0, 265, 365…), que no corresponden a la duración real de un partido (48 min). Se marcó para validación.

Patrones duplicados home/away → útil para comparación, aunque hace ancha la tabla.

Transformaciones realizadas

Conversión de fechas:

game_date → datetime64.

Creación de variable binaria home_win:

Se definió home_win = 1 si pts_home > pts_away, caso contrario 0.

Esto permite análisis directos de victorias locales.

Validación de consistencia:

Se revisó la coherencia entre wl_home y los puntos (pts_home vs pts_away).

Resumen estadístico (describe):

Generado para métricas principales (pts, reb, ast, stl, blk, tov, fg%, ft%).

Detectados nulos y outliers (ej: partidos con estadísticas incompletas).

Resultados finales

Dataset limpio con 65.698 registros y 55 columnas.

Fechas normalizadas.

Variable derivada: home_win.

Se detectaron inconsistencias en minutos jugados y en métricas incompletas de temporadas antiguas.

Finalidad del dataset

El dataset de game queda listo para:

Análisis de rendimiento colectivo (comparaciones home vs away).

Modelado de factores de victoria (qué variables más impactan en ganar de local).

Integración con otras tablas (player_data, injuries, common_player_info) para relacionar estadísticas de equipo con composición corporal y lesiones.