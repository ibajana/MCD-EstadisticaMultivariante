# Tareas

Carpeta de entregas del curso **Estadística de Datos Multivariantes**. Cada tarea está en formato R Markdown (`.Rmd`) y produce un reporte HTML autocontenido.

---

## Entregas

| Tarea | Archivo | Tema | Autores |
|---|---|---|---|
| Tarea 1 | `Tarea1-EstructurasLatentes.Rmd` | PCA sobre `USArrests` | Campuzano, Ugarte, Pluas |
| Tarea 2 | `Tarea2-RegresionLinealSimpleMultiple.Rmd` | Regresión lineal simple y múltiple | Campuzano, Ugarte, Pluas |
| Tarea 3 | `Tarea3-MetodosDeClasificacion.Rmd` | Regresión logística vs. LDA — riesgo crediticio | Campuzano, Ugarte, Pluas, Bajaña |

---

## Descripción por tarea

### Tarea 1 — Estructuras Latentes (PCA)
- **Dataset:** `USArrests` (50 estados de EE. UU., 4 variables de criminalidad)
- **Objetivo:** aplicar Análisis de Componentes Principales para reducir dimensionalidad e identificar patrones latentes
- **Librerías:** `dplyr`, `factoextra`

### Tarea 2 — Regresión Lineal Simple y Múltiple
- **Objetivo:** ajustar modelos de regresión lineal, interpretar coeficientes y diagnosticar supuestos (multicolinealidad, heterocedasticidad, autocorrelación)
- **Librerías:** `ISLR2`, `lmtest`, `sandwich`, `car`

### Tarea 3 — Métodos de Clasificación: Riesgo Crediticio
- **Dataset:** `Default` del paquete `ISLR2` (10 000 clientes, variables: `student`, `balance`, `income`)
- **Objetivo:** predecir el incumplimiento de pago (`default`) comparando Regresión Logística Binaria y LDA
- **Métricas:** Accuracy, Sensibilidad, Especificidad
- **Énfasis:** la sensibilidad es la métrica más relevante en el contexto de riesgo crediticio
- **Librerías:** `ISLR2`, `MASS`, `caret`, `tidyverse`, `kableExtra`, `patchwork`

---

## Cómo generar los reportes

```r
# Desde RStudio: botón "Knit"
# Desde consola:
rmarkdown::render("Tarea1-EstructurasLatentes.Rmd")
rmarkdown::render("Tarea2-RegresionLinealSimpleMultiple.Rmd")
rmarkdown::render("Tarea3-MetodosDeClasificacion.Rmd")
```
