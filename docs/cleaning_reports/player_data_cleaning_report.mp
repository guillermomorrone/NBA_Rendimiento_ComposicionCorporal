Documentación – player_data_ready
Introducción

El dataset player_data fue sometido a un proceso de exploración, limpieza y enriquecimiento con el fin de obtener una versión consistente y utilizable en análisis de rendimiento y composición corporal de jugadores de la NBA.
El resultado final fue guardado en ../data_clean/player_data_ready.csv.

Exploración inicial

El dataset fue cargado desde ../data_raw/player_data.csv.

Se revisaron dimensiones, tipos de datos y valores nulos.

Se detectaron inconsistencias en:

Nombres de jugadores (guiones, espacios extra, mayúsculas/minúsculas).

Alturas y pesos (expresados en pies-pulgadas y libras).

Posiciones (valores con guiones en lugar de separadores estándar).

Limpieza aplicada

Nombres: creación de la columna player_name_clean, con formato estandarizado (sin guiones, con espacios correctos y en formato título).

Altura y peso: conversión a métricas internacionales:

height_m en metros.

weight_kg en kilogramos.

Fechas y edades:

Conversión de birth_date a tipo datetime.

Cálculo de age_at_debut y age_at_last_season.

Posiciones: normalización con / como separador y creación de:

position_all: todas las posiciones reportadas.

position_main: posición principal.

Universidad: imputación de valores faltantes con "Unknown".

Eliminación de redundancias: columnas originales height, weight y position fueron eliminadas tras la transformación.

Métricas derivadas

BMI (Índice de Masa Corporal).

Porcentaje de grasa corporal estimado usando la fórmula de Deurenberg (1.20 * BMI + 0.23 * edad - 16.2).

Masa grasa (kg).

Masa magra (kg).

Estas métricas permiten analizar el estado nutricional y la composición corporal de los jugadores a lo largo de sus temporadas.

Exportación final

El dataset limpio y enriquecido fue guardado en:

../data_clean/player_data_ready.csv


Incluye todas las transformaciones y métricas adicionales necesarias para integrarse con los otros datasets (common_player_info_ready y combine_ready).

Finalidad

El archivo player_data_ready.csv constituye una versión lista para análisis que:

Asegura consistencia en los nombres y variables clave.

Permite cruzar información con otras fuentes (common y combine).

Facilita el análisis de la evolución de jugadores en términos de rendimiento y composición corporal.