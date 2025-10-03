# 🏀 Resumen Documentado: Cliente y Mockup

## Contexto

**Cliente:** Departamento *Player Performance & Sports Science* de **Orlando Magic (NBA)**.  
**Misión:** Optimizar el desarrollo físico/técnico de jugadores, reducir riesgo de lesiones y mejorar la preparación integral.  

Necesitan información basada en evidencia que combine:  
- Estadísticas deportivas  
- Composición corporal  
- Historial de lesiones  

Con el fin de tomar **decisiones estratégicas en tiempo real**.  

---

## Objetivos del trabajo

- Identificar perfiles físicos óptimos según posición y estilo de juego.  
- Relacionar composición corporal y morfología con rendimiento físico.  
- Detectar métricas clave para anticipar desempeño.  
- Predecir riesgos de lesiones mediante análisis de datos.  
- Explorar aplicaciones futuras para predicción de talento.  

---

## Problema detectado

- La NBA no mide pliegues cutáneos ni masa muscular exacta.  
- Solo hay datos de altura, peso, % de grasa estimado, envergadura, alcance, salto y agilidad.  

---

## Nuestra solución (LEG DATA)

**Integración de datasets:**
- `common_player_info_ready` → datos biográficos  
- `combine_ready` → composición corporal y pruebas físicas  
- `game_ready` → rendimiento en cancha  
- `nba_injuries_ready` → historial de lesiones  

**Modelado en esquema estrella** con staging, dimensiones y hechos.  

**Dashboard con KPIs:**
- Composición corporal promedio por posición  
- Relación entre % de grasa y rendimiento (puntos, rebotes, velocidad)  
- Incidencia de lesiones según perfil físico  

---

## Mockup (resumen)

**Pantalla inicial:** KPIs de jugadores activos  
**Filtros:** temporada, posición, equipo y jugador  

**Visualizaciones:**
- Boxplots de % de grasa por posición  
- Gráficos de dispersión: masa magra vs. rebotes, masa grasa vs. lesiones  
- Radar charts de rendimiento físico por jugador 

---
