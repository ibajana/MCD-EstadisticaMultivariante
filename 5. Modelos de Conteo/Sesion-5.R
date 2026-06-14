# ============================================================
# MODELOS DE CONTEO EN R
# Regresión Poisson, binomial negativa y cuasi-Poisson
# ============================================================
#
# Objetivo de la clase:
# - Modelar una variable de conteo.
# - Ajustar un modelo Poisson.
# - Diagnosticar sobredispersión.
# - Ajustar modelo binomial negativo.
# - Ajustar modelo cuasi-Poisson.
# - Modelar una variable de conteo.
# - Ajustar un modelo Poisson.
# - Diagnosticar sobredispersión.
# - Ajustar modelo binomial negativo.
# - Ajustar modelo cuasi-Poisson.
# - Comparar resultados e interpretar coeficientes.
#
# Variable respuesta:
# count = número de peces capturados
#
# Predictores:
# persons = número de personas en el grupo
# child   = número de niños en el grupo
# camper  = si el grupo llevó camper: 1 = sí, 0 = no
#
# ============================================================


# ============================================================
# 0. Preparación del entorno
# ============================================================

rm(list = ls())

# Paquetes mínimos necesarios
# MASS se usa para glm.nb(), regresión binomial negativa
if (!require(MASS)) {
  install.packages("MASS")
  library(MASS)
}

# ggplot2 es opcional para gráficos más bonitos
if (!require(ggplot2)) {
  install.packages("ggplot2")
  library(ggplot2)
}

# ============================================================
# 1. Cargar o construir los datos
# ============================================================

# Intentamos cargar el dataset fishing del paquete stats4nr.
# Si no está instalado, creamos una versión simulada para la clase.

if (requireNamespace("stats4nr", quietly = TRUE)) {
  
  library(stats4nr)
  data(fishing)
  
  cat("Dataset 'fishing' cargado desde el paquete stats4nr.\n")
  
} else {
  
  cat("El paquete 'stats4nr' no está instalado.\n")
  cat("Se generará un dataset simulado para la clase.\n")
  
  set.seed(123)
  
  n <- 250
  
  fishing <- data.frame(
    persons = sample(1:4, n, replace = TRUE),
    child   = sample(0:3, n, replace = TRUE),
    camper  = rbinom(n, size = 1, prob = 0.45)
  )
  
  # Construimos una media esperada para el conteo.
  # Más personas aumentan el conteo esperado.
  # Más niños reducen el conteo esperado.
  # Llevar camper aumenta el conteo esperado.
  
  eta <- -1.5 +
    0.75 * fishing$persons -
    0.80 * fishing$child +
    0.60 * fishing$camper
  
  mu <- exp(eta)
  
  # Generamos conteos con sobredispersión mediante binomial negativa.
  # Esto hará que el Poisson tenga problemas, lo cual es útil didácticamente.
  
  fishing$count <- rnbinom(n, size = 0.7, mu = mu)
  
  # Variable auxiliar: no pescó nada
  fishing$nofish <- ifelse(fishing$count == 0, 1, 0)
}


# Revisamos las primeras filas
head(fishing)

# Estructura de los datos
str(fishing)



# ============================================================
# 2. Exploración inicial de la variable de conteo
# ============================================================

# Resumen de la variable respuesta
summary(fishing$count)

# Media y varianza
media_count <- mean(fishing$count)
var_count   <- var(fishing$count)

media_count
var_count

cat("\nMedia del conteo:", media_count, "\n")
cat("Varianza del conteo:", var_count, "\n")

# En Poisson se espera que:
# E(Y) = Var(Y)
#
# Si la varianza es mucho mayor que la media,
# puede existir sobredispersión.

cat("\nRelación varianza/media:", var_count / media_count, "\n")



# ============================================================
# 3. Visualización del conteo
# ============================================================

# Histograma base R
hist(
  fishing$count,
  breaks = 30,
  col = "steelblue",
  border = "white",
  main = "Distribución del número de peces capturados",
  xlab = "Número de peces capturados",
  ylab = "Frecuencia"
)

# Histograma con ggplot2
ggplot(fishing, aes(x = count)) +
  geom_histogram(binwidth = 1, fill = "steelblue", color = "white") +
  labs(
    title = "Distribución del número de peces capturados",
    x = "Número de peces capturados",
    y = "Frecuencia"
  ) +
  theme_minimal()



# ============================================================
# 4. Exploración por predictores
# ============================================================

# Conteo promedio por número de personas
aggregate(count ~ persons, data = fishing, mean)

# Conteo promedio por número de niños
aggregate(count ~ child, data = fishing, mean)

# Conteo promedio según camper
aggregate(count ~ camper, data = fishing, mean)


# Gráfico: count vs persons
ggplot(fishing, aes(x = factor(persons), y = count)) +
  geom_boxplot(fill = "lightblue") +
  labs(
    title = "Conteo de peces según número de personas",
    x = "Número de personas",
    y = "Número de peces capturados"
  ) +
  theme_minimal()


# Gráfico: count vs child
ggplot(fishing, aes(x = factor(child), y = count)) +
  geom_boxplot(fill = "lightgreen") +
  labs(
    title = "Conteo de peces según número de niños",
    x = "Número de niños",
    y = "Número de peces capturados"
  ) +
  theme_minimal()


# Gráfico: count vs camper
ggplot(fishing, aes(x = factor(camper), y = count)) +
  geom_boxplot(fill = "orange") +
  labs(
    title = "Conteo de peces según uso de camper",
    x = "Camper: 0 = no, 1 = sí",
    y = "Número de peces capturados"
  ) +
  theme_minimal()




# ============================================================
# 5. Modelo 1: regresión Poisson
# ============================================================

# Modelo:
# Y_i ~ Poisson(lambda_i)
#
# log(lambda_i) = beta0 + beta1*persons_i + beta2*child_i + beta3*camper_i
#
# La función de enlace log garantiza que lambda_i > 0.

m_pois <- glm(
  count ~ persons + child + camper,
  family = poisson(link = "log"),
  data = fishing
)

summary(m_pois)



# ============================================================
# 6. Interpretación de coeficientes Poisson
# ============================================================

# Los coeficientes del modelo Poisson están en escala logarítmica.
coef(m_pois)

# Para interpretarlos en escala multiplicativa:
# exp(beta_j) = razón de tasas o razón de conteos esperados.

irr_pois <- exp(coef(m_pois))
irr_pois

cat("\nRazones de tasas del modelo Poisson:\n")
print(irr_pois)

# Interpretación general:
# Si exp(beta) > 1, el conteo esperado aumenta.
# Si exp(beta) < 1, el conteo esperado disminuye.
# Si exp(beta) = 1, no hay cambio multiplicativo.



# ============================================================
# 7. Intervalos de confianza para razones de tasas
# ============================================================

# Usamos confint.default para evitar cálculos largos de perfil.
ic_pois <- exp(confint.default(m_pois))

ic_pois

cat("\nIntervalos de confianza aproximados para IRR - Poisson:\n")
print(ic_pois)



# ============================================================
# 8. Diagnóstico de sobredispersión
# ============================================================

# En el modelo Poisson:
# Var(Y_i) = E(Y_i)
#
# En datos reales, muchas veces:
# Var(Y_i) > E(Y_i)
#
# Eso se llama sobredispersión.

# Medida 1: deviance / grados de libertad
disp_deviance <- deviance(m_pois) / df.residual(m_pois)

# Medida 2: suma de residuos Pearson al cuadrado / grados de libertad
disp_pearson <- sum(residuals(m_pois, type = "pearson")^2) /
  df.residual(m_pois)

disp_deviance
disp_pearson

cat("\nDispersión usando deviance:", disp_deviance, "\n")
cat("Dispersión usando residuos de Pearson:", disp_pearson, "\n")

# Regla práctica:
# valor cercano a 1  -> Poisson puede ser razonable.
# valor mayor que 1  -> posible sobredispersión.
# valor mucho mayor que 1 -> sobredispersión importante.




# ============================================================
# 9. Gráficos diagnósticos del modelo Poisson
# ============================================================

# Residuos de Pearson vs valores ajustados
plot(
  fitted(m_pois),
  residuals(m_pois, type = "pearson"),
  pch = 19,
  col = "steelblue",
  xlab = "Valores ajustados",
  ylab = "Residuos de Pearson",
  main = "Modelo Poisson: residuos vs ajustados"
)
abline(h = 0, lwd = 2, col = "red")

# Residuos deviance vs valores ajustados
plot(
  fitted(m_pois),
  residuals(m_pois, type = "deviance"),
  pch = 19,
  col = "darkgreen",
  xlab = "Valores ajustados",
  ylab = "Residuos deviance",
  main = "Modelo Poisson: residuos deviance vs ajustados"
)
abline(h = 0, lwd = 2, col = "red")



# ============================================================
# 10. Modelo 2: regresión binomial negativa
# ============================================================

# La binomial negativa permite sobredispersión.
#
# Una parametrización común:
#
# Var(Y_i) = mu_i + mu_i^2 / theta
#
# Si theta es grande, el modelo se aproxima a Poisson.
# Si theta es pequeño, hay mayor sobredispersión.

m_nb <- glm.nb(
  count ~ persons + child + camper,
  data = fishing
)

summary(m_nb)

 


# ============================================================
# 11. Interpretación de coeficientes binomial negativa
# ============================================================

coef(m_nb)

irr_nb <- exp(coef(m_nb))
irr_nb

cat("\nRazones de tasas del modelo binomial negativo:\n")
print(irr_nb)

ic_nb <- exp(confint.default(m_nb))

cat("\nIntervalos de confianza aproximados para IRR - Binomial negativa:\n")
print(ic_nb)

 


# ============================================================
# 12. Modelo 3: regresión cuasi-Poisson
# ============================================================

# El modelo cuasi-Poisson conserva la misma estructura de media:
#
# log(mu_i) = beta0 + beta1*x1 + ...
#
# Pero modifica la varianza:
#
# Var(Y_i) = phi * mu_i
#
# donde phi es el parámetro de dispersión.

m_qpois <- glm(
  count ~ persons + child + camper,
  family = quasipoisson(link = "log"),
  data = fishing
)

summary(m_qpois)

 


# ============================================================
# 13. Interpretación de coeficientes cuasi-Poisson
# ============================================================

coef(m_qpois)

irr_qpois <- exp(coef(m_qpois))
irr_qpois

cat("\nRazones de tasas del modelo cuasi-Poisson:\n")
print(irr_qpois)

ic_qpois <- exp(confint.default(m_qpois))

cat("\nIntervalos de confianza aproximados para IRR - Cuasi-Poisson:\n")
print(ic_qpois)

 


# ============================================================
# 14. Comparación de coeficientes entre modelos
# ============================================================

coef_comparacion <- data.frame(
  Variable = names(coef(m_pois)),
  Poisson = coef(m_pois),
  Binomial_Negativa = coef(m_nb),
  Cuasi_Poisson = coef(m_qpois)
)

coef_comparacion

cat("\nCoeficientes en escala logarítmica:\n")
print(coef_comparacion)


irr_comparacion <- data.frame(
  Variable = names(coef(m_pois)),
  Poisson = exp(coef(m_pois)),
  Binomial_Negativa = exp(coef(m_nb)),
  Cuasi_Poisson = exp(coef(m_qpois))
)

cat("\nRazones de tasas:\n")
print(irr_comparacion)

 


# ============================================================
# 15. Comparación de errores estándar
# ============================================================

se_comparacion <- data.frame(
  Variable = names(coef(m_pois)),
  SE_Poisson = summary(m_pois)$coefficients[, "Std. Error"],
  SE_Binomial_Negativa = summary(m_nb)$coefficients[, "Std. Error"],
  SE_Cuasi_Poisson = summary(m_qpois)$coefficients[, "Std. Error"]
)

cat("\nComparación de errores estándar:\n")
print(se_comparacion)

# En presencia de sobredispersión,
# los errores estándar del Poisson suelen ser demasiado pequeños.
# Cuasi-Poisson y binomial negativa tienden a corregir este problema.

 


# ============================================================
# 16. Comparación con AIC
# ============================================================

# AIC se puede usar para comparar modelos con verosimilitud definida.
# Poisson y binomial negativa tienen verosimilitud.
# Cuasi-Poisson no tiene una verosimilitud completa estándar.

aic_comparacion <- AIC(m_pois, m_nb)

cat("\nComparación AIC: Poisson vs Binomial negativa\n")
print(aic_comparacion)

# El modelo con menor AIC suele ser preferible,
# siempre que la comparación tenga sentido sustantivo.

 


# ============================================================
# 17. Predicción con los modelos
# ============================================================

# Creamos nuevos perfiles hipotéticos de grupos de pesca.

nuevos <- data.frame(
  persons = c(1, 2, 3, 4),
  child   = c(0, 1, 1, 2),
  camper  = c(0, 0, 1, 1)
)

nuevos

# Predicción del conteo esperado
nuevos$pred_pois <- predict(m_pois, newdata = nuevos, type = "response")
nuevos$pred_nb <- predict(m_nb, newdata = nuevos, type = "response")
nuevos$pred_qpois <- predict(m_qpois, newdata = nuevos, type = "response")

cat("\nPredicciones de conteo esperado:\n")
print(nuevos)

 


# ============================================================
# 18. Gráfico de predicciones
# ============================================================

# Transformamos la tabla a formato largo sin usar paquetes adicionales.

pred_long <- data.frame(
  perfil = rep(1:nrow(nuevos), times = 3),
  modelo = rep(c("Poisson", "Binomial negativa", "Cuasi-Poisson"),
               each = nrow(nuevos)),
  prediccion = c(nuevos$pred_pois, nuevos$pred_nb, nuevos$pred_qpois)
)

ggplot(pred_long, aes(x = factor(perfil), y = prediccion, fill = modelo)) +
  geom_col(position = "dodge") +
  labs(
    title = "Conteo esperado según modelo",
    x = "Perfil hipotético",
    y = "Conteo esperado"
  ) +
  theme_minimal()

 


# ============================================================
# 19. Revisión del exceso de ceros
# ============================================================

# Proporción observada de ceros
prop_ceros_obs <- mean(fishing$count == 0)

cat("\nProporción observada de ceros:", prop_ceros_obs, "\n")

# Proporción esperada aproximada de ceros bajo Poisson:
# Para Poisson, P(Y = 0) = exp(-lambda_i)

prob_cero_pois <- exp(-fitted(m_pois))
prop_ceros_pois <- mean(prob_cero_pois)

cat("Proporción esperada de ceros bajo Poisson:", prop_ceros_pois, "\n")

# Si los ceros observados son mucho más frecuentes que los esperados,
# puede considerarse un modelo con inflación de ceros.

 


# ============================================================
# 20. Tabla resumen final
# ============================================================

resumen_modelos <- data.frame(
  Modelo = c("Poisson", "Binomial negativa", "Cuasi-Poisson"),
  Supuesto_varianza = c(
    "Var(Y) = mu",
    "Var(Y) = mu + mu^2/theta",
    "Var(Y) = phi * mu"
  ),
  AIC = c(
    AIC(m_pois),
    AIC(m_nb),
    NA
  ),
  Dispersion_aprox = c(
    disp_pearson,
    NA,
    summary(m_qpois)$dispersion
  )
)

cat("\nResumen comparativo de modelos:\n")
print(resumen_modelos)

 

# ============================================================
# 21. Conclusión
# ============================================================

cat("\n============================================================\n")
cat("CONCLUSIÓN DIDÁCTICA\n")
cat("============================================================\n\n")

cat("1. La variable respuesta es un conteo: 0, 1, 2, ...\n")
cat("2. El modelo Poisson es el punto de partida natural.\n")
cat("3. Poisson asume media igual a varianza.\n")
cat("4. Si la varianza excede a la media, puede haber sobredispersión.\n")
cat("5. La binomial negativa modela explícitamente esa sobredispersión.\n")
cat("6. Cuasi-Poisson corrige los errores estándar mediante un parámetro phi.\n")
cat("7. Los coeficientes se interpretan mejor como exp(beta), es decir, razones de tasas.\n")
cat("8. La elección final debe considerar diagnóstico, AIC, dispersión e interpretación sustantiva.\n\n")


# ============================================================
# 22. Preguntas para discusión
# ============================================================

cat("PREGUNTAS:\n\n")

cat("a) ¿La varianza del conteo es cercana a la media?\n")
cat("b) ¿El modelo Poisson parece adecuado?\n")
cat("c) ¿Qué evidencia hay de sobredispersión?\n")
cat("d) ¿Qué predictor aumenta el conteo esperado?\n")
cat("e) ¿Qué predictor reduce el conteo esperado?\n")
cat("f) ¿Qué modelo recomendarían y por qué?\n")
cat("g) ¿Hay indicios de exceso de ceros?\n")


# ============================================================
# FIN DEL SCRIPT
# ============================================================