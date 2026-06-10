# Unidad 0–1 — Estadística Inferencial e Introducción

Esta carpeta cubre las sesiones iniciales del curso: configuración del entorno de trabajo, librerías fundamentales de R y los primeros conceptos de análisis exploratorio y correlación.

---

## Archivos

| Archivo | Tipo | Descripción |
|---|---|---|
| `librerias_basicas_R.Rmd` | R Markdown | Tutorial de las librerías base del curso |
| `Sesion-0.R` | Script R | Exploración del cuarteto de Anscombe |
| `Sesion-0.py` | Script Python | Equivalente Python de `Sesion-0.R` |
| `Sesion-1.R` | Script R | Matrices de correlación y visualización |
| `Introducción.pdf` | PDF | Diapositivas de introducción al curso |

---

## Resumen por archivo

### `librerias_basicas_R.Rmd`
Documento R Markdown que introduce las cuatro librerías base que se usan a lo largo del curso:

| Librería | Uso |
|---|---|
| `ggplot2` | Visualización por capas |
| `magrittr` | Pipes `%>%` y `%$%` |
| `dplyr` | Filtrado, selección, agrupación y resumen de datos |
| `datasets` | Bases de datos de práctica incluidas en R |

---

### `Sesion-0.R` y `Sesion-0.py`
Análisis del **cuarteto de Anscombe**: cuatro conjuntos de datos con estadísticas descriptivas casi idénticas pero patrones visuales muy distintos. Ilustra por qué la visualización es indispensable antes de modelar.

**Temas:**
- Construcción de data frames y tibbles
- Gráficos de dispersión con `facet_wrap`
- Rectas y curvas de regresión sobre los datos (`geom_smooth`)
- Histogramas, densidades y dotplots
- Versión Python con `seaborn.FacetGrid` y equivalencias R → Python

---

### `Sesion-1.R`
Introducción a la **correlación lineal** usando los datasets `advertising` e `Auto` (paquete `ISLR2`).

**Temas:**
- Cálculo de correlación de Pearson con `cor()`
- Matrices de correlación completas
- Visualización con `corrplot`: métodos `circle`, `number`, ordenamiento jerárquico (`hclust`)

---

## Librerías requeridas

```r
install.packages(c("ggplot2", "dplyr", "magrittr", "readr",
                   "corrplot", "ISLR2"))
```

```bash
pip install pandas seaborn matplotlib
```
