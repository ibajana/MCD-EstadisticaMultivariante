# Unidad 2 — Regresión Lineal

Esta carpeta cubre la **regresión lineal simple y múltiple**, incluyendo ajuste del modelo, interpretación de coeficientes, diagnóstico de supuestos y correcciones ante violaciones.

---

## Archivos

| Archivo | Tipo | Descripción |
|---|---|---|
| `Sesion-2.R` | Script R | Regresión lineal simple, múltiple y diagnóstico completo |
| `Unidad 2.pdf` | PDF | Material teórico de la unidad |

---

## Resumen — `Sesion-2.R`

El script está organizado en siete partes usando los datasets `Auto` y `Credit` del paquete `ISLR2`.

### Parte A — Regresión lineal simple (`Auto`)
- Modelo: `mpg ~ horsepower`
- Ajuste con `lm()` e interpretación de `summary()`
- Gráfico de dispersión con recta de regresión (`abline`)
- Intervalos de confianza para coeficientes: `confint()`
- Predicción puntual e intervalar: `predict(..., interval = "confidence" / "prediction")`

### Parte B — Regresión lineal múltiple (`Auto`)
- Modelo: `mpg ~ horsepower + weight + acceleration`
- Comparación de modelos simple vs. múltiple con `anova()`
- Diagnóstico gráfico: panel 2×2 con `plot(modelo)` (residuales, Q-Q, escala-localización, influencia)
- Distancia de Cook para detección de valores influyentes

### Parte C — Multicolinealidad
- Factor de Inflación de Varianza (VIF) con `car::vif()`
- Criterios de interpretación: VIF < 5 aceptable, > 10 problemático

### Parte D — Heterocedasticidad
- Prueba de Breusch-Pagan (`lmtest::bptest()`): H₀ = varianza constante
- Errores estándar robustos ante heterocedasticidad: `sandwich::vcovHC(..., type = "HC1")`
- Comparación de coeficientes con errores clásicos vs. robustos

### Parte E — Autocorrelación
- Prueba de Durbin-Watson (`lmtest::dwtest()`): H₀ = no autocorrelación de primer orden
- Aplicación metodológica en datos transversales

### Parte F — Aplicación con `Credit`
- Modelo: `Balance ~ Income + Limit + Rating + Age`
- Diagnóstico completo: heterocedasticidad, multicolinealidad y autocorrelación

### Parte G — Actividad práctica
Instrucciones para que el estudiante ajuste su propio modelo sobre `Auto` o `Credit`, evalúe supuestos y presente conclusiones.

---

## Supuestos del modelo lineal

| Supuesto | Diagnóstico | Corrección |
|---|---|---|
| Linealidad | Residuales vs. ajustados | Transformación de variables |
| Normalidad de errores | Q-Q plot | — |
| Homocedasticidad | Breusch-Pagan | Errores robustos (HC1) |
| No multicolinealidad | VIF | Eliminar / combinar variables |
| No autocorrelación | Durbin-Watson | Modelos de series de tiempo |

---

## Librerías requeridas

```r
install.packages(c("ISLR2", "lmtest", "sandwich", "car"))

library(ISLR2)    # datasets Auto y Credit
library(lmtest)   # bptest(), dwtest(), coeftest()
library(sandwich) # vcovHC()
library(car)      # vif()
```
