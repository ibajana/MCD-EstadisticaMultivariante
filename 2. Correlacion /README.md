# Unidad 1 (continuación) — Correlación y Análisis de Componentes Principales

Esta carpeta complementa la Unidad 1 con el tema de **Análisis de Componentes Principales (ACP / PCA)**, una técnica de reducción de dimensionalidad basada en la estructura de covarianza/correlación de los datos.

---

## Archivos

| Archivo | Tipo | Descripción |
|---|---|---|
| `Sesion-1_2.R` | Script R | PCA paso a paso con el dataset `iris` |
| `Unidad 1.pdf` | PDF | Material teórico de la unidad |

---

## Resumen por archivo

### `Sesion-1_2.R`
Implementación completa de PCA usando la función `prcomp()` sobre el dataset `iris` (150 observaciones, 4 variables numéricas, 3 especies).

**Flujo del análisis:**

1. **Preparación:** se seleccionan las 4 variables morfológicas (`Sepal.Length`, `Sepal.Width`, `Petal.Length`, `Petal.Width`)
2. **Ajuste del modelo:** `prcomp(X, scale. = TRUE)` — estandarización previa obligatoria
3. **Cargas (loadings):** `pca$rotation` — contribución de cada variable a cada componente
4. **Scores:** `pca$x` — coordenadas de cada observación en el nuevo espacio
5. **Varianza explicada:**
   - Proporción por componente: `pca$sdev^2 / sum(pca$sdev^2)`
   - Acumulada: `cumsum(var_exp)`
6. **Gráfico de codo (scree plot):** varianza explicada por componente
7. **Biplot (PC1 vs PC2):** visualización de las observaciones coloreadas por especie

**Resultado clave:** las dos primeras componentes explican más del 95 % de la varianza total, y PC1 separa casi completamente las tres especies de iris.

---

## Concepto central

> El ACP transforma las variables originales (posiblemente correlacionadas) en un nuevo conjunto de variables ortogonales (componentes principales), ordenadas de mayor a menor varianza explicada. Permite reducir dimensionalidad conservando la mayor cantidad posible de información.

---

## Librerías requeridas

```r
# No requiere instalación adicional; prcomp() está en base R
# El dataset iris está en el paquete datasets (incluido en R)
library(datasets)
```
