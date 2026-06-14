# ============================================================
# Ejemplo de offset en regresión Poisson
# ============================================================

datos <- data.frame(
  peces = c(6, 6, 10, 12, 4, 15),
  horas = c(1, 6, 2, 4, 1, 5),
  personas = c(2, 2, 3, 4, 1, 5),
  camper = c(0, 1, 0, 1, 0, 1)
)

# Tasa observada de peces por hora
datos$tasa <- datos$peces / datos$horas

datos

# Modelo Poisson sin offset
m_sin_offset <- glm(
  peces ~ personas + camper,
  family = poisson(link = "log"),
  data = datos
)

# Modelo Poisson con offset
m_con_offset <- glm(
  peces ~ personas + camper + offset(log(horas)),
  family = poisson(link = "log"),
  data = datos
)

summary(m_sin_offset)
summary(m_con_offset)

# Coeficientes exponentiados
exp(coef(m_sin_offset))
exp(coef(m_con_offset))

# Predicciones
datos$pred_sin_offset <- predict(m_sin_offset, type = "response")
datos$pred_con_offset <- predict(m_con_offset, type = "response")

datos

# Tasa predicha con offset
datos$tasa_predicha <- datos$pred_con_offset / datos$horas

datos
