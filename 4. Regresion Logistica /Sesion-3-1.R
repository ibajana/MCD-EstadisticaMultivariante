###############################################################
# REGRESIÓN LOGÍSTICA BINARIA
# Ejemplo con la base mtcars
###############################################################

# -------------------------------------------------------------
# 1. Cargar y revisar la base
# -------------------------------------------------------------

data(mtcars)

head(mtcars)
str(mtcars)

# En mtcars, la variable am indica el tipo de transmisión:
# am = 0: automática
# am = 1: manual

table(mtcars$am)


# -------------------------------------------------------------
# 2. Ajustar el modelo logístico binario
# -------------------------------------------------------------

# Queremos modelar:
# P(am = 1 | wt, hp)
#
# Es decir, la probabilidad de que un auto tenga transmisión manual
# en función de su peso y potencia.

modelo_log <- glm(am ~ wt + hp,
                  data = mtcars,
                  family = binomial)


summary(modelo_log)


# -------------------------------------------------------------
# 3. Interpretar los coeficientes
# -------------------------------------------------------------

# Coeficientes en escala logit
coef(modelo_log)

# Odds ratios
exp(coef(modelo_log))

# Interpretación general:
# - Si el odds ratio es mayor que 1, aumenta la razón de posibilidades
#   de transmisión manual.
# - Si el odds ratio es menor que 1, disminuye la razón de posibilidades
#   de transmisión manual.
#
# Importante:
# El odds ratio afecta los odds, no directamente la probabilidad.


# -------------------------------------------------------------
# 4. Obtener probabilidades estimadas
# -------------------------------------------------------------

# Probabilidad estimada de transmisión manual para cada auto
probabilidades <- predict(modelo_log,
                          type = "response")

probabilidades

# Agregamos las probabilidades a la base
mtcars$prob_manual <- probabilidades

head(mtcars[, c("am", "wt", "hp", "prob_manual")])


# -------------------------------------------------------------
# 5. Clasificar usando un punto de corte
# -------------------------------------------------------------

# Usamos c = 0.50 como punto de corte.
# Si la probabilidad estimada es >= 0.50, clasificamos como manual.

mtcars$pred_manual <- ifelse(mtcars$prob_manual >= 0.50, 1, 0)

head(mtcars[, c("am", "prob_manual", "pred_manual")])


# -------------------------------------------------------------
# 6. Matriz de confusión
# -------------------------------------------------------------

matriz_confusion <- table(Real = mtcars$am,
                          Predicho = mtcars$pred_manual)

matriz_confusion


# -------------------------------------------------------------
# 7. Exactitud del modelo
# -------------------------------------------------------------

accuracy <- sum(diag(matriz_confusion)) / sum(matriz_confusion)

accuracy


# -------------------------------------------------------------
# 8. Sensibilidad y especificidad
# -------------------------------------------------------------

# En este ejemplo:
# Positivo = transmisión manual = 1
# Negativo = transmisión automática = 0

VP <- matriz_confusion["1", "1"]
VN <- matriz_confusion["0", "0"]
FP <- matriz_confusion["0", "1"]
FN <- matriz_confusion["1", "0"]

sensibilidad <- VP / (VP + FN)
especificidad <- VN / (VN + FP)

sensibilidad
especificidad


# -------------------------------------------------------------
# 9. Predicción para un nuevo auto
# -------------------------------------------------------------

# Supongamos un auto con:
# wt = 2.8 miles de libras
# hp = 120 caballos de fuerza

nuevo_auto <- data.frame(wt = 2.8,
                         hp = 120)

prob_nuevo <- predict(modelo_log,
                      newdata = nuevo_auto,
                      type = "response")

prob_nuevo

# Clasificación del nuevo auto

ifelse(prob_nuevo >= 0.50, "Manual", "Automática")


# -------------------------------------------------------------
# 10. Gráfico simple de probabilidades
# -------------------------------------------------------------

plot(mtcars$wt,
     mtcars$prob_manual,
     pch = 19,
     col = ifelse(mtcars$am == 1, "blue", "red"),
     xlab = "Peso del auto",
     ylab = "Probabilidad estimada de transmisión manual",
     main = "Regresión logística binaria")

abline(h = 0.50,
       lty = 2,
       col = "gray")

legend("topright",
       legend = c("Manual", "Automática"),
       col = c("blue", "red"),
       pch = 19,
       bty = "n")

###############################################
# LDA
###############################################

library(MASS)

data(iris)

# Usamos solo dos especies y dos variables para visualizar
datos <- subset(iris, Species != "setosa")
datos$Species <- droplevels(datos$Species)

modelo_lda <- lda(Species ~ Petal.Length + Petal.Width,
                  data = datos)

# Malla para dibujar regiones
x_seq <- seq(min(datos$Petal.Length) - 0.5,
             max(datos$Petal.Length) + 0.5,
             length.out = 200)

y_seq <- seq(min(datos$Petal.Width) - 0.5,
             max(datos$Petal.Width) + 0.5,
             length.out = 200)

grid <- expand.grid(Petal.Length = x_seq,
                    Petal.Width = y_seq)

pred <- predict(modelo_lda, newdata = grid)$class

# Guardar imagen
png("lda_boundary.png", width = 900, height = 700, res = 120)

plot(grid$Petal.Length, grid$Petal.Width,
     col = ifelse(pred == "versicolor", "#A6CEE3", "#FDBF6F"),
     pch = 15,
     cex = 0.6,
     xlab = "Petal Length",
     ylab = "Petal Width",
     main = "Frontera de decisión LDA")

points(datos$Petal.Length, datos$Petal.Width,
       col = ifelse(datos$Species == "versicolor", "blue", "red"),
       pch = 19)

legend("topleft",
       legend = levels(datos$Species),
       col = c("blue", "red"),
       pch = 19,
       bty = "n")

dev.off()

###############################################################
# UNIDAD 3: INTRODUCCIÓN AL ANÁLISIS DE CLÚSTER
# Curso: Estadística para Datos Multivariantes
# Base de datos: iris
###############################################################

# -------------------------------------------------------------
# 1. Cargar la base de datos
# -------------------------------------------------------------

data(iris)

# Revisar las primeras filas
head(iris)

# Revisar la estructura de la base
str(iris)

# Tabla de frecuencias de la variable Species
# Esta variable NO será usada para construir los clústeres.
# Solo se usará al final para comparar.
table(iris$Species)


# -------------------------------------------------------------
# 2. Seleccionar variables cuantitativas
# -------------------------------------------------------------

# Usaremos solo las cuatro variables numéricas de iris
X <- iris[, 1:4]

# Revisar resumen descriptivo
summary(X)


# -------------------------------------------------------------
# 3. Escalar las variables
# -------------------------------------------------------------

# En clustering es importante escalar, porque las variables
# pueden tener unidades o rangos diferentes.
# scale() transforma cada variable a media 0 y desviación estándar 1.

X_scaled <- scale(X)

# Verificar medias aproximadas a 0
round(apply(X_scaled, 2, mean), 3)

# Verificar desviaciones estándar iguales a 1
round(apply(X_scaled, 2, sd), 3)


# -------------------------------------------------------------
# 4. Aplicar K-means
# -------------------------------------------------------------

# Fijamos una semilla para que los resultados sean reproducibles
set.seed(123)

# Aplicamos K-means con 3 clústeres
# En este ejemplo usamos 3 porque iris tiene 3 especies,
# pero el algoritmo no conoce esas etiquetas.
km <- kmeans(X_scaled,
             centers = 3,
             nstart = 25)

# Ver los centros de los clústeres
km$centers

# Ver cuántas observaciones hay en cada clúster
km$size

# Ver la asignación de clúster para las primeras observaciones
head(km$cluster)


# -------------------------------------------------------------
# 5. Comparar clústeres con especies reales
# -------------------------------------------------------------

# K-means no usa Species para formar grupos.
# Esta tabla solo permite comparar los clústeres encontrados
# con las especies reales de la base iris.

table(Cluster = km$cluster,
      Especie = iris$Species)


# -------------------------------------------------------------
# 6. Visualizar clústeres usando dos variables
# -------------------------------------------------------------
par(mfrow = c(2, 1))
plot(X_scaled[, "Petal.Length"],
     X_scaled[, "Petal.Width"],
     col = km$cluster,
     pch = 19,
     xlab = "Petal.Length escalada",
     ylab = "Petal.Width escalada",
     main = "Clústeres K-means en iris")

# Agregar los centros de los clústeres
points(km$centers[, "Petal.Length"],
       km$centers[, "Petal.Width"],
       col = 1:3,
       pch = 8,
       cex = 2,
       lwd = 2)

legend("topleft",
       legend = paste("Clúster", 1:3),
       col = 1:3,
       pch = 19,
       bty = "n")


# -------------------------------------------------------------
# 7. Comparar visualmente con las especies reales
# -------------------------------------------------------------

plot(X_scaled[, "Petal.Length"],
     X_scaled[, "Petal.Width"],
     col = iris$Species,
     pch = 19,
     xlab = "Petal.Length escalada",
     ylab = "Petal.Width escalada",
     main = "Especies reales en iris")

legend("topleft",
       legend = levels(iris$Species),
       col = 1:3,
       pch = 19,
       bty = "n")

par(mfrow = c(1, 1))
# -------------------------------------------------------------
# 8. Elegir número de clústeres: método del codo
# -------------------------------------------------------------

# Calculamos la suma de cuadrados intra-clúster para varios valores de k

wss <- numeric(10)

for (k in 1:10) {
  modelo_k <- kmeans(X_scaled,
                     centers = k,
                     nstart = 25)
  
  wss[k] <- modelo_k$tot.withinss
}

# Gráfico del método del codo
plot(1:10,
     wss,
     type = "b",
     pch = 19,
     xlab = "Número de clústeres K",
     ylab = "Suma de cuadrados intra-clúster",
     main = "Método del codo")


# -------------------------------------------------------------
# 9. Clustering jerárquico
# -------------------------------------------------------------

# Calculamos una matriz de distancias euclidianas
distancias <- dist(X_scaled,
                   method = "euclidean")

# Aplicamos clustering jerárquico con método de Ward
hc <- hclust(distancias,
             method = "ward.D2")

# Dendrograma
plot(hc,
     labels = FALSE,
     hang = -1,
     main = "Dendrograma - Clustering jerárquico",
     xlab = "Observaciones",
     ylab = "Distancia")

# Cortamos el dendrograma en 3 grupos
grupos_hc <- cutree(hc, k = 3)

# Comparación con especies reales
table(Cluster = grupos_hc,
      Especie = iris$Species)

# ¿Qué pasa si no se escala la variable?

# -------------------------------------------------------------
# extra. Tipos de clustering
# -------------------------------------------------------------

# Aglomerativo
distancias <- dist(X)
hc_aglo <- hclust(distancias,
                  method = "ward.D2")
plot(hc_aglo,
     labels = FALSE,
     main = "Clustering aglomerativo")
# Separativo
library(cluster)
hc_sep <- diana(X)
plot(hc_sep,
     main = "Clustering separativo")

# -------------------------------------------------------------
# 10. Visualización del clustering jerárquico
# -------------------------------------------------------------

plot(X_scaled[, "Petal.Length"],
     X_scaled[, "Petal.Width"],
     col = grupos_hc,
     pch = 19,
     xlab = "Petal.Length escalada",
     ylab = "Petal.Width escalada",
     main = "Clustering jerárquico en iris")

legend("topleft",
       legend = paste("Grupo", 1:3),
       col = 1:3,
       pch = 19,
       bty = "n")


# -------------------------------------------------------------
# 11. Ideas para interpretar
# -------------------------------------------------------------

# Preguntas para discutir:
#
# 1. ¿K-means recupera bien las especies reales?
# 2. ¿Qué especie parece más fácil de separar?
# 3. ¿Qué especies se mezclan más?
# 4. ¿El número K = 3 parece razonable según el método del codo?
# 5. ¿Los resultados de K-means y clustering jerárquico son similares?
#
# Recordatorio:
# El análisis de clúster es no supervisado.
# Eso significa que busca grupos sin usar etiquetas previas.