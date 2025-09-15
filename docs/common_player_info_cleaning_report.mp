Documento de Limpieza – common_player_info

1. Introducción

El dataset common_player_info contiene información general de jugadores de la NBA, incluyendo datos demográficos, de carrera, físicos y de draft.
Nuestro objetivo fue limpiar, normalizar y enriquecer estos datos para poder integrarlos en un modelo analítico más amplio.

2. Pasos Realizados
2.1 Carga inicial y revisión

Se cargaron 4171 registros y 33 columnas.

Se identificaron columnas redundantes y con formatos heterogéneos (nombres, altura en pies, peso en libras, fechas como texto, etc.).

Se revisaron valores nulos, duplicados y posibles outliers.

2.2 Limpieza de duplicados

No se detectaron duplicados en person_id.

Se confirmó unicidad de los registros.

2.3 Transformación de fechas y edades

Se convirtió birthdate a formato datetime.

Se calcularon:

age (edad actual).

age_at_debut (edad en la primera temporada).

age_at_last_season (edad en la última temporada).

Se corrigieron casos imposibles (debut a los 8 años, jugadores con nacimiento en 1905, etc.).

Resultado: rangos consistentes (debut 18–36 años, retiro 18–50 años).

2.4 Variables físicas

height en pies-pulgadas → convertida a metros (height_m).

weight en libras → convertida a kilogramos (weight_kg).

Se calculó IMC (BMI).

2.5 Composición corporal estimada

Aplicamos fórmula de Deurenberg (1991) para estimar % de grasa corporal (body_fat_pct_est).

Derivamos:

fat_mass_kg (masa grasa).

lean_mass_kg (masa libre de grasa).

Redondeo a 1 decimal para coherencia.

2.6 Normalización de nombres

Se creó player_name_clean, eliminando guiones y estandarizando formato Title Case.

Verificación: no quedaron duplicados problemáticos.

2.7 Normalización de posiciones

position original a menudo contenía múltiples posiciones unidas por guiones.

Se generaron:

all_positions (lista completa de posiciones).

main_position (posición principal, simplificada).

Distribución final consistente: Guards, Forwards, Centers.

2.8 Normalización de países

Se detectaron 73 variantes distintas.

Se corrigieron inconsistencias (ej. USA → United States, DRC → Democratic Republic of the Congo, etc.).

2.9 Eliminación de columnas redundantes

Se eliminaron variables en formato duplicado:

feet, inches, height (mantuvimos height_m).

weight (mantuvimos weight_kg).

Mantuvimos todas las columnas clave para integración (person_id, team_id, draft_*, position, etc.).

3. Resultados finales

Registros: 4171

Columnas: 39

Dataset limpio, consistente y enriquecido con métricas derivadas.

Guardado en:
data_clean/common_player_info_clean_vFinal.csv

4. Visualizaciones realizadas

Histogramas y boxplots de variables físicas y de edad.

Distribución de posiciones en la liga.

Análisis temporal (edad al debut, edad de retiro).

Relación entre masa grasa/magra y posiciones.

5. Conclusiones

Jugadores de la NBA presentan en promedio:

Altura: ~2.0 m

Peso: ~100 kg

IMC: 24–25 (saludable).

La estimación de composición corporal muestra diferencias claras por posición:

Centers → mayor masa magra absoluta, más % de grasa que Guards.

Guards → más ligeros, menor grasa, mayor agilidad.

El dataset quedó listo para integración con otras tablas