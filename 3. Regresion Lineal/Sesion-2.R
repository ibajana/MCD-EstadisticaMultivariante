# ============================================================
# Unidad 2: Regresión lineal
# Ejemplos con datasets del paquete ISLR2
# ============================================================

# ------------------------------------------------------------
# 1. Instalación y carga de paquetes
# ------------------------------------------------------------

# Instalar solo si no los tienes
# install.packages("ISLR2")
# install.packages("lmtest")
# install.packages("sandwich")
# install.packages("car")

library(ISLR2)
library(lmtest)
library(sandwich)
library(car)

# ============================================================
# PARTE A: REGRESIÓN LINEAL SIMPLE
# Dataset: Auto
# ============================================================

data(Auto)

# Revisar estructura de los datos
summary(Auto)
# Matriz de correlaciones solo con variables numéricas
R_auto <- Auto %>%
  select(where(is.numeric)) %>%
  cor(use = "complete.obs")

round(R_auto, 2)

# ------------------------------------------------------------
# Modelo simple: mpg explicado por horsepower
# ------------------------------------------------------------

modelo_simple <- lm(mpg ~ horsepower, data = Auto)

summary(modelo_simple)

# ------------------------------------------------------------
# Gráfico de dispersión con recta de regresión
# ------------------------------------------------------------

plot(Auto$horsepower, Auto$mpg,
     pch = 19,
     col = "steelblue",
     xlab = "Horsepower",
     ylab = "Miles per gallon",
     main = "Regresión lineal simple: mpg vs horsepower")

abline(modelo_simple,
       col = "red",
       lwd = 2)

# ------------------------------------------------------------
# Intervalos de confianza para los coeficientes
# ------------------------------------------------------------

confint(modelo_simple)

# ------------------------------------------------------------
# Predicción para nuevos valores
# ------------------------------------------------------------

nuevos_autos <- data.frame(horsepower = c(100, 150, 200))

predict(modelo_simple,
        newdata = nuevos_autos,
        interval = "confidence")

predict(modelo_simple,
        newdata = nuevos_autos,
        interval = "prediction")

# ============================================================
# PARTE B: REGRESIÓN LINEAL MÚLTIPLE
# Dataset: Auto
# ============================================================

modelo_multiple <- lm(mpg ~ horsepower + weight + acceleration,
                      data = Auto)

summary(modelo_multiple)

# ------------------------------------------------------------
# Comparación de modelos
# ------------------------------------------------------------

anova(modelo_simple, modelo_multiple)

# ------------------------------------------------------------
# Diagnóstico gráfico del modelo múltiple
# ------------------------------------------------------------

par(mfrow = c(2, 2))
plot(modelo_multiple)
par(mfrow = c(1, 1))

cooks.distance(modelo_multiple) |> 
  sort(decreasing = TRUE) |> 
  head()

# ------------------------------------------------------------
# Valores ajustados y residuales
# ------------------------------------------------------------

fitted_values <- fitted(modelo_multiple)
residuos <- residuals(modelo_multiple)

head(fitted_values)
head(residuos)

plot(fitted_values, residuos,
     pch = 19,
     col = "steelblue",
     xlab = "Valores ajustados",
     ylab = "Residuales",
     main = "Residuales vs valores ajustados")

abline(h = 0,
       col = "red",
       lwd = 2)

# ============================================================
# PARTE C: MULTICOLINEALIDAD
# ============================================================

# Factor de Inflación de Varianza
vif(modelo_multiple)

# Interpretación general:
# VIF cercano a 1: baja colinealidad
# VIF entre 5 y 10: posible problema
# VIF mayor a 10: colinealidad severa

# ============================================================
# PARTE D: HETEROCEDASTICIDAD
# ============================================================

# ------------------------------------------------------------
# Prueba de Breusch-Pagan
# H0: varianza constante de los errores
# H1: heterocedasticidad
# ------------------------------------------------------------

bptest(modelo_multiple)

# ------------------------------------------------------------
# Errores estándar robustos ante heterocedasticidad
# ------------------------------------------------------------

coeftest(modelo_multiple,
         vcov = vcovHC(modelo_multiple, type = "HC1"))

# ------------------------------------------------------------
# Comparación con errores estándar clásicos
# ------------------------------------------------------------

summary(modelo_multiple)$coefficients

coeftest(modelo_multiple,
         vcov = vcovHC(modelo_multiple, type = "HC1"))

# ============================================================
# PARTE E: AUTOCORRELACIÓN
# ============================================================

# ------------------------------------------------------------
# Prueba de Durbin-Watson
# H0: no autocorrelación de primer orden
# H1: autocorrelación
# ------------------------------------------------------------

dwtest(modelo_multiple)

# Nota:
# Este ejemplo usa datos no temporales.
# La prueba se muestra con fines metodológicos.
# En datos transversales, la autocorrelación no siempre es el diagnóstico principal.

# ============================================================
# PARTE F: EJEMPLO CON DATASET CREDIT
# ============================================================

data(Credit)

dim(Credit)
str(Credit)
summary(Credit)

# ------------------------------------------------------------
# Modelo de regresión para explicar Balance
# ------------------------------------------------------------

modelo_credit <- lm(Balance ~ Income + Limit + Rating + Age,
                    data = Credit)

summary(modelo_credit)

# ------------------------------------------------------------
# Diagnóstico gráfico
# ------------------------------------------------------------

par(mfrow = c(2, 2))
plot(modelo_credit)
par(mfrow = c(1, 1))

# ------------------------------------------------------------
# Heterocedasticidad
# ------------------------------------------------------------

bptest(modelo_credit)

coeftest(modelo_credit,
         vcov = vcovHC(modelo_credit, type = "HC1"))

# ------------------------------------------------------------
# Multicolinealidad
# ------------------------------------------------------------

vif(modelo_credit)

# ------------------------------------------------------------
# Autocorrelación
# ------------------------------------------------------------

dwtest(modelo_credit)

# ============================================================
# PARTE G: ACTIVIDAD PRÁCTICA
# ============================================================

# Instrucciones:
# 1. Seleccionen el dataset Auto o Credit.
# 2. Definan una variable respuesta continua.
# 3. Ajusten un modelo de regresión lineal simple.
# 4. Ajusten un modelo de regresión lineal múltiple.
# 5. Interpreten los coeficientes principales.
# 6. Evalúen diagnóstico gráfico.
# 7. Evalúen heterocedasticidad.
# 8. Apliquen errores robustos si corresponde.
# 9. Evalúen autocorrelación si el contexto lo justifica.
# 10. Presenten una conclusión breve.

# Preguntas:
# - ¿Qué variables son estadísticamente significativas?
# - ¿Cómo interpretan el coeficiente más importante?
# - ¿Hay evidencia de heterocedasticidad?
# - ¿Cambian las conclusiones usando errores robustos?
# - ¿El modelo es útil para explicar la variable respuesta?