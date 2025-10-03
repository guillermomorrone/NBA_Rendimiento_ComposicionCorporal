Limpieza de draft_combine

🔹 Observaciones iniciales

Dataset con 1.199 registros y 56 columnas.

Contiene información física y de rendimiento de jugadores evaluados en el Draft Combine de la NBA.

Variables principales: altura, peso, envergadura, alcance de pie, % grasa corporal, saltos, agilidad, sprint, bench press, etc.

Presenta información duplicada en algunos jugadores (participaron en más de un Combine).

🔹 Problemas detectados

Identificador: columna player_id necesaria para futuras uniones con common.

Posiciones: aparecen combinadas (ej. SF-PF, SG-PG), se normalizó en position_main.

Fechas: no incluye birthdate, solo temporada del Combine (season).

Medidas: estaban en pulgadas/libras → se convirtieron a sistema métrico (m, kg, cm).

Valores nulos:

Muchos en pruebas de tiro (spot_*, off_drib_*, etc.) → mantenidos para análisis avanzado.

Algunos en body_fat_pct, standing_vertical_leap, max_vertical_leap, lane_agility_time.

Duplicados: se detectaron 24 jugadores con múltiples registros, se analizaron diferencias en peso, % grasa, salto y agilidad a lo largo de temporadas.

🔹 Transformaciones realizadas

Conversión a sistema métrico:

Altura, peso, envergadura, alcance y saltos convertidos a metros o centímetros.

Normalización de nombres:

Columna player_name_clean (sin guiones, capitalización uniforme).

Posiciones:

Se crearon position_all (texto original) y position_main (posición principal).

Composición corporal:

Se derivaron masa grasa (fat_mass_kg) y masa libre de grasa (fat_free_mass_kg).

Estadísticos descriptivos:

Distribución de medidas físicas y de rendimiento.

Identificación de outliers históricos (ej. Tacko Fall en altura, Desagana Diop en peso, Kenny Gregory en salto).

Duplicados:

Se construyó tabla comparativa por jugador y temporada (delta_weight, delta_bodyfat, delta_leap, delta_agility).

🔹 Relación con otras tablas

Con common_ready:

Se enlaza por player_id.

Permite vincular datos demográficos y trayectoria con pruebas físicas del Combine.