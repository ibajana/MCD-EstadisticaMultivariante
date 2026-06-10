# Estadística de Datos Multivariantes — MCD

Repositorio de la materia **Estadística de Datos Multivariantes** del programa de Maestría en Ciencia de Datos (MCD). Contiene scripts de sesiones, material de apoyo, datasets y simuladores interactivos.

---

## Contenido del repositorio

```
MCD-EstadisticaMultivariante/
├── 1. Estadistica Inferencial/     # Unidad 0–1: introducción y correlación
├── 2. Correlacion/                 # Unidad 1 (continuación): PCA
├── 3. Regresion Lineal/            # Unidad 2: regresión simple y múltiple
├── Datasets/                       # Bases de datos utilizadas en clase
├── Libro/                          # Bibliografía del curso (ISLR)
├── Simuladores/                    # Herramientas interactivas HTML
├── Tareas/                         # Entrega de tareas y ejercicios
└── Proyecto/                       # Proyecto final del curso
```

---

## Unidades

### Unidad 0 — Introducción y herramientas (`1. Estadistica Inferencial/`)

| Archivo | Descripción |
|---|---|
| `librerias_basicas_R.Rmd` | Tutorial de las librerías base: `ggplot2`, `dplyr`, `magrittr`, `datasets` |
| `Sesion-0.R` | Exploración del cuarteto de Anscombe con visualizaciones en `ggplot2` |
| `Sesion-0.py` | Equivalente Python del script anterior con `pandas`, `seaborn` y `matplotlib` |
| `Introducción.pdf` | Diapositivas de introducción al curso |

**Temas:** visualización con `ggplot2` / `seaborn`, pipes, manipulación de datos, gráficos de dispersión, histogramas, densidades.

---

### Unidad 1 — Correlación y ACP (`1. Estadistica Inferencial/` + `2. Correlacion/`)

| Archivo | Descripción |
|---|---|
| `Sesion-1.R` | Matrices de correlación, `corrplot`, datasets `advertising` y `Auto` |
| `Sesion-1_2.R` | Análisis de Componentes Principales (ACP) con dataset `iris` |
| `Unidad 1.pdf` | Material de la unidad |

**Temas:** correlación de Pearson, matrices de correlación, visualización con `corrplot`, varianza explicada, biplot, reducción de dimensionalidad (PCA con `prcomp`).

---

### Unidad 2 — Regresión Lineal (`3. Regresion Lineal/`)

| Archivo | Descripción |
|---|---|
| `Sesion-2.R` | Regresión lineal simple y múltiple, diagnóstico de supuestos |
| `Unidad 2.pdf` | Material de la unidad |

**Temas cubiertos:**

- **Regresión simple:** `mpg ~ horsepower` con dataset `Auto`; interpretación de coeficientes, intervalos de confianza y predicción
- **Regresión múltiple:** modelo con múltiples predictores, comparación vía ANOVA
- **Diagnóstico gráfico:** residuales vs. ajustados, Q-Q, distancia de Cook
- **Multicolinealidad:** Factor de Inflación de Varianza (VIF) con `car::vif()`
- **Heterocedasticidad:** prueba de Breusch-Pagan (`lmtest::bptest()`), errores estándar robustos (`sandwich::vcovHC()`)
- **Autocorrelación:** prueba de Durbin-Watson (`lmtest::dwtest()`)
- **Aplicación:** modelo sobre dataset `Credit` para explicar el saldo (`Balance`)

---

## Datasets

| Archivo | Descripción |
|---|---|
| `advertising.csv` | Inversión en publicidad (TV, Radio, Newspaper) y ventas |
| `diabetes2.csv` | Variables clínicas para predicción de diabetes |
| `cancer.df.txt` | Datos de diagnóstico de cáncer |
| `mines.df.txt` | Datos de detección de minas |
| `onions.df.txt` | Datos de producción de cebolla |
| `optdigits.tra` | Dígitos ópticos (clasificación de imágenes) |

Los datasets `Auto`, `Credit` e `iris` se cargan directamente desde los paquetes `ISLR2` y `datasets`.

---

## Simuladores interactivos

Archivos HTML autocontenidos, se abren directamente en el navegador sin necesidad de instalar nada.

| Archivo | Descripción |
|---|---|
| `simulador_correlacion_pearson.html` | Exploración visual del coeficiente de correlación de Pearson |
| `simulador_pca_step_by_step.html` | PCA paso a paso: centrado, covarianza, eigenvectores y proyección |

---

## Tareas

Carpeta destinada a la entrega de ejercicios y tareas del curso. Se irá poblando a lo largo del semestre.

---

## Proyecto

Carpeta destinada al proyecto final del curso. Se irá poblando a lo largo del semestre.

---

## Libro de referencia

El curso usa como bibliografía principal:

- **ISLR v2** — *An Introduction to Statistical Learning with Applications in R* (James, Witten, Hastie, Tibshirani) — `ISLRv2_corrected_June_2023.pdf`
- **ISLP** — *An Introduction to Statistical Learning with Applications in Python* — `ISLP_website_python.pdf`

---

## Requisitos

**R (≥ 4.1)**
```r
install.packages(c("ggplot2", "dplyr", "magrittr", "readr", "corrplot",
                   "ISLR2", "lmtest", "sandwich", "car"))
```

**Python (≥ 3.9)**
```bash
pip install pandas seaborn matplotlib
```
