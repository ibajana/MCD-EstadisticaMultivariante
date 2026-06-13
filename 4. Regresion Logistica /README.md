# Unidad 3 — Regresión Logística, LDA y Análisis de Clúster

Esta carpeta cubre los métodos de **clasificación supervisada** (regresión logística y LDA) y los primeros métodos de **agrupamiento no supervisado** (K-means y clustering jerárquico).

---

## Archivos

| Archivo | Tipo | Descripción |
|---|---|---|
| `Sesion-3-1.R` | Script R | Regresión logística, LDA y análisis de clúster |
| `Unidad 3.pdf` | PDF | Material teórico de la unidad |
| `Análisis Cluster.pdf` | PDF | Material complementario sobre clustering |

---

## Resumen — `Sesion-3-1.R`

El script está dividido en tres bloques temáticos.

### Bloque 1 — Regresión Logística Binaria (`mtcars`)

Modelo: `P(am = 1 | wt, hp)` — probabilidad de transmisión manual en función del peso y potencia del vehículo.

| Paso | Descripción |
|---|---|
| Ajuste | `glm(..., family = binomial)` |
| Coeficientes | Logit y Odds Ratios (`exp(coef())`) |
| Probabilidades | `predict(..., type = "response")` |
| Clasificación | Umbral c = 0.50 |
| Evaluación | Matriz de confusión, exactitud, sensibilidad, especificidad |
| Predicción nueva | `predict()` sobre observación nueva |
| Visualización | Probabilidades vs. peso con `plot()` |

---

### Bloque 2 — Análisis Discriminante Lineal (LDA) (`iris`)

Clasificación entre *versicolor* y *virginica* usando `Petal.Length` y `Petal.Width`.

- Ajuste con `MASS::lda()`
- Construcción de una malla de predicción para visualizar la **frontera de decisión lineal**
- Gráfico de regiones de clasificación coloreadas por clase predicha

---

### Bloque 3 — Análisis de Clúster (`iris`)

Agrupa las 150 observaciones de `iris` sin usar la etiqueta `Species`.

**K-means**
- Escalado previo con `scale()`
- `kmeans(..., centers = 3, nstart = 25)`
- Comparación con especies reales mediante tabla cruzada
- Visualización en el espacio (`Petal.Length` vs. `Petal.Width`)
- **Método del codo:** suma de cuadrados intra-clúster para K = 1…10

**Clustering Jerárquico**
- Distancias euclidianas con `dist()`
- Método de Ward (`hclust(..., method = "ward.D2")`)
- Dendrograma y corte en 3 grupos con `cutree()`
- Variantes: aglomerativo (`hclust`) y separativo (`cluster::diana()`)

---

## Conceptos clave

| Concepto | Técnica |
|---|---|
| Clasificación supervisada | Logística, LDA |
| Frontera de decisión lineal | LDA |
| Agrupamiento no supervisado | K-means, clustering jerárquico |
| Selección de K | Método del codo (WSS) |
| Linkage | Ward D2 |

---

## Librerías requeridas

```r
install.packages(c("MASS", "cluster"))

library(MASS)     # lda()
library(cluster)  # diana()
# mtcars e iris están disponibles en base R
```
