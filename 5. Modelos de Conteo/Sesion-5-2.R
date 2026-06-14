# ============================================================
# Actividad: Modelos de conteo con datos ecológicos
# Dataset: Salamanders, paquete glmmTMB
# ============================================================

# Instalar paquetes si hace falta
# install.packages("glmmTMB")
# install.packages("MASS")
# install.packages("ggplot2")
# install.packages("dplyr")

library(glmmTMB)
library(MASS)
library(ggplot2)
library(dplyr)

# Cargar dataset
data("Salamanders", package = "glmmTMB")
levels(Salamanders$site)
unique(Salamanders$site)
sitio_1 <- Salamanders %>%
  filter(site == "R-1")
head(sitio_1)

varios_sitios <- Salamanders %>%
  filter(site %in% c("R-1", "R-2", "R-3", "R-4"))

ggplot(Salamanders, aes(x = site, y = count, fill = site)) +
  geom_boxplot() +
  labs(
    title = "Conteo de Salamandras por Sitio",
    x = "Sitio",
    y = "Conteo"
  ) +
  theme_minimal() +
  theme(legend.position = "none")

# Crear objeto de trabajo
datos <- Salamanders

# Revisar estructura
str(datos)

# Primeras filas
head(datos)

# Resumen general
summary(datos)

# Ver nombres de variables
names(datos)

# ============================================================
# Exploración inicial
# ============================================================

# Variable respuesta
summary(datos$count)

# Media y varianza del conteo
mean(datos$count)
var(datos$count)

# Relación varianza/media
var(datos$count) / mean(datos$count)

# Proporción de ceros
mean(datos$count == 0)

# Histograma del conteo
ggplot(datos, aes(x = count)) +
  geom_histogram(binwidth = 1,
                 fill = "steelblue",
                 color = "white") +
  labs(
    title = "Distribución del número de salamandras observadas",
    x = "Número de salamandras",
    y = "Frecuencia"
  ) +
  theme_minimal()

# Conteo según minería
ggplot(datos, aes(x = mined, y = count, fill = mined)) +
  geom_boxplot() +
  labs(
    title = "Conteo de salamandras según condición minera",
    x = "Sitio afectado por minería",
    y = "Número de salamandras"
  ) +
  theme_minimal()

# Conteo según especie
ggplot(datos, aes(x = spp, y = count, fill = spp)) +
  geom_boxplot() +
  labs(
    title = "Conteo de salamandras según especie",
    x = "Especie",
    y = "Número de salamandras"
  ) +
  theme_minimal() +
  theme(legend.position = "none")

# Relación con temperatura del agua
ggplot(datos, aes(x = Wtemp, y = count)) +
  geom_point(alpha = 0.6, color = "darkgreen") +
  geom_smooth(method = "loess", se = FALSE, color = "red") +
  labs(
    title = "Conteo de salamandras y temperatura del agua",
    x = "Temperatura del agua",
    y = "Número de salamandras"
  ) +
  theme_minimal()

# ============================================================
# Actividad: los estudiantes deben decidir el modelo
# ============================================================

# Preguntas guía:
#
# 1. ¿La variable count es adecuada para un modelo de conteo?
Sí, es adecuada por que estamos analizando enteros positivos. Para un modelo de conteos cuenta con valores positivos y enteros. 

# 2. ¿La media y la varianza son similares?
No. Los datos que hemos observados suele haber varianza mayor que la media. 

# 3. ¿Hay indicios de sobredispersión?
Claro que hay dispersion, el valor que responde al dividir la varianza contra la media es de 5.25. 

# 4. ¿Hay muchos ceros?
Sí hay muchos 0s es casi el 60% de la muestra. 

# 5. ¿Qué modelo usarían primero: Poisson, cuasi-Poisson o binomial negativa?
Poisson, no se puede utilizar debido a que la varianza y la media no son iguales. 
Cuasin-Poisson, 
Binomial negativa, escogemos por que se utiliza cuando el modelo presenta sobredispersion. 

# 6. ¿Qué predictores incluirían?


# 7. ¿Cómo interpretarían el efecto de mined?
# 8. ¿Cómo interpretarían el efecto de Wtemp?
# 9. ¿Conviene incluir spp como predictor?
# 10. ¿Qué limitaciones tiene el análisis si ignoramos que hay mediciones repetidas por site?