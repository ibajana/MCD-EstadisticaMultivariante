data(iris)
X <- iris[, 1:4]
pca <- prcomp(X, scale. = TRUE)
summary(pca)
pca$rotation
head(pca$x)
var_exp <- pca$sdev^2 / sum(pca$sdev^2)
round(var_exp, 3)
cumsum(var_exp)
plot(var_exp,
     type = "b",
     pch = 19,
     xlab = "Componente principal",
     ylab = "Proporcion de varianza explicada",
     col = "steelblue")

plot(pca$x[,1], pca$x[,2],
     pch = 19,
     col = iris$Species,
     xlab = "PC1",
     ylab = "PC2")
legend("topright",
       legend = levels(iris$Species),
       col = 1:3,
       pch = 19)
