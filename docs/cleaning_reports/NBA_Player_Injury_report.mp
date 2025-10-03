## Documentación del proceso de limpieza

1. **Carga de datos**  
   - Se utilizó `pandas.read_csv()` para importar el archivo original.  
   - Se verificaron nulos, tipos de datos y estructura inicial del DataFrame.  

2. **Normalización de columnas**  
   - `Date` se convirtió a formato `datetime`.  
   - Se creó `name_clean` para estandarizar nombres de jugadores.  
   - Se creó `Status` para diferenciar jugadores lesionados (Relinquished) y reincorporados (Acquired).  

3. **Clasificación de lesiones**  
   - Se definió la función `simplify_injury()` para agrupar las notas en categorías:  
     *Knee, Ankle/Foot, Back, Arm/Hand, Muscular, Head, Illness, Surgery, Other, Unknown*.  
   - Se generó la columna `InjuryCategory` aplicando esta función sobre `Notes`.  

4. **Reducción del dataset**  
   - Se eliminaron columnas redundantes (`Acquired`, `Relinquished`, `Notes`).  
   - Se filtraron las categorías `Unknown` para trabajar solo con registros útiles.  

5. **Validación**  
   - Se contó la cantidad de registros originales vs filtrados.  
   - Se calculó el porcentaje de datos útiles disponibles para análisis.  

El dataset resultante tiene menor ruido, está más organizado y permite realizar análisis descriptivos (frecuencia por tipo de lesión, ranking de jugadores, tendencias temporales, etc.).  
