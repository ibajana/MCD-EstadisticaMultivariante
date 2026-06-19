install.packages(c("ggplot2","psych","corrplot"))
library(ggplot2)
library(psych)
library(corrplot)

install.packages(c("lmtest","car"))
library(lmtest)
library(car)


df <- read.csv("Heart_Attack_Analysis_&_Prediction_Dataset/heart.csv")# Leyendo los datos

# Análisis del df

str(df)
dim(df)

# Limpieza

# 1. Verificación de filas nulas
sum(is.na(df))
# No tenemos filas nulas

#2. Verificación de filas duplicadas
sum(duplicated(df))
# Tenemos una fila duplicada

#La talasemia solo puede aceptar valores entre el 1-3, verifiquemos ceros
table(df$thall)       
# Existen dos ceros, lo cual puede ser por datos nulos.

#Quitando duplicados:
df <- df[!duplicated(df),]

# Aquellos valores de cero es mejor tratarlos como nulos:
df$thall[df$thall == 0 ] <- NA

# Las variables categóricas deben ser tratadas como variables categóricas, no númericas
df$sex <- factor(df$sex)
df$cp <- factor(df$cp)
df$fbs <- factor(df$fbs)
df$restecg <- factor(df$restecg)
df$exng <- factor(df$exng)
df$slp <- factor(df$slp)
df$thall <- factor(df$thall)
df$output <- factor(df$output)

summary(df) # todo está correcto


# Bueno, en este caso, con los NA tenemos dos alternativas
# o los elimino, o los imputo con la media, considero que al ser solo 2
#observaciones puedo eliminarla

df <- df[!is.na(df$thall),]


# --------------------
# Exploración Inicial
#-----------------------

summary(df)
205/300
256/300
146/300
4/300
202/300
# Podemos describir las variables como:
# La edad de las personas observadas empieza desde 29 y con un máximo de 77, 
# promedio de 54, el sexo que predomina es el masculino con abundante 68.33% 
# de la muestra. Existen 4 tipos de dolores, de los cuales el dolor 0(angina típica)
# es el que más se ha visto vs solo 23 personas las cuales han sido asintómaticos.
# La presión arterial empieza en 94 con un máximo de 200, su promedio es 131.
# El colesterol empieza con 126 y su máximo es 564, el promedio es de 246.
# La glucosa)fbs) en ayunas es una variable dicotómica la cual nos indica si el paciente observado
# se encontraba con una glucosa mayor a 120 cuando se tomó la muestra, el 85.33%
# no tenía la glucosa elevada.
# En el resultado del electrocardiograma, el 48.67% de la muestra la tenía normal,
# el 50% tenía una anomalía y el 1.33%(4 pacientes) teníua hipertrofia ventricular izquierda
# La frecuencia cardiaca máxima entre los pacientes estaba entre [71,202] con una media
# de 149.
# El 67.33% demostró que no tenía angina producida por ejercicio(exng)

#----------------------
#Falta interpretar las otras
#----------------------

# Distribuciónd de las variables cuantitativas

ggplot(df, aes(x = age)) +
  geom_histogram(bins = 20, fill = "steelblue", color = "white") +
  labs(title = "Distribución de la edad",
       x = "Edad (años)", y = "Frecuencia") +
  theme_minimal()

# Como pudimos observar en el summary, la mayor cantidad de pacientes observados tienen
#alrededor de 57 años, parece ser una variable con distribución normal

ggplot(df, aes(x = chol)) +
  geom_histogram(bins = 20, fill = "steelblue", color = "white") +
  labs(title = "Distribución del colesterol",
       x = "Colesterol", y = "Frecuencia") +
  theme_minimal()

# La mayor cantidad de personas tenían un colesterol menor a 
#250, sin embargo parece que tenemos un outlier, con un colesterol muy elevado
# Esta variable se encuentra sesgada a la derecha

ggplot(df, aes(x = thalachh )) +
  geom_histogram(bins = 20, fill = "steelblue", color = "white") +
  labs(title = "Distribución de la frecuencia cardiaca máxima",
       x = "frecuencia cardiaca", y = "Frecuencia") +
  theme_minimal()

# La mayor cantidad de personas tenían una frecuencia caediaca [160,170]
# esta variable se encuentra sesgada a la izquierda

ggplot(df, aes(x = oldpeak )) +
  geom_histogram(bins = 20, fill = "steelblue", color = "white") +
  labs(title = "Distribución de la frecuencia cardiaca máxima",
       x = "frecuencia cardiaca", y = "Frecuencia") +
  theme_minimal()

# La depresión del segmento ST está claramente sesgada a la derecha
# parece que  tenemos outliers.


ggplot(df, aes(y = chol)) +
  geom_boxplot(fill = "skyblue") +
  labs(title = "Boxplot del colesterol",
       y = "Colesterol (mg/dl)") +
  theme_minimal()
# Contamos con presencia de outliers 

ggplot(df, aes(y = trtbps )) +
  geom_boxplot(fill = "skyblue") +
  labs(title = "Boxplot de la presión arterial",
       y = "presión (mm Hg)") +
  theme_minimal()
# Contamos con presencia de outliers 

ggplot(df, aes(y = oldpeak)) +
  geom_boxplot(fill = "skyblue") +
  labs(title = "Boxplot de la Depresión del segmento ST inducida por ejercicio",
       y = "presión(mm)") +
  theme_minimal()

# Presencia de outliers



ggplot(df, aes(x = output, y = thalachh, fill = output)) +
  geom_boxplot() +
  labs(title = "Frecuencia cardíaca máxima según riesgo de infarto",
       x = "Output (0 = menor riesgo, 1 = mayor riesgo)",
       y = "FC máxima (lpm)") +
  theme_minimal()

# Aquellos ue tienen mayor riesgo de infarto cuentan con
# la frecuencia máxima promedia más alta que aquellos que tienen menor
#riesgo de infarto, los dos grupos si tienen una diferencia clara

ggplot(df, aes(x = output, y = age , fill = output)) +
  geom_boxplot() +
  labs(title = "Edad según riesgo de infarto",
       x = "Output (0 = menor riesgo, 1 = mayor riesgo)",
       y = "Edad") +
  theme_minimal()

# El boxplot nos muestra que aquellos que tienen mayor riesgo de infarto
# tienen menos edad en promedio, alrededor de 45 y 58 años, en cambio
#en promedio las personas con más edad tienen menor riesgo de infarto.
# eso si, las edades están muy cercanas.

ggplot(df, aes(x = output, y = oldpeak , fill = output)) +
  geom_boxplot() +
  labs(title = "Depresión del segmento ST según riesgo de infarto",
       x = "Output (0 = menor riesgo, 1 = mayor riesgo)",
       y = "Depresión del segmento ST") +
  theme_minimal()

# El boxplot nos muestra que con gran diferencia, aquellos que tienen menor depresión
#tienen mayor riesgo a sufrir de un infarto, frente a los que tienen depresión.



# Obtener la correlación

# Haré un vector con el nombre de las variables cuantitativas
cuanti <- c("age","trtbps","chol","thalachh","oldpeak","caa")
mat_cor <- cor(df[cuanti])
round(mat_cor, 2)   

# La relación más fuerte que podemos encontrar es de la edad con 
#lafrecencia cardiaca(-0.4), la misma que es negativa, nos da un indicio que probablemente
#mientras más edad tiene la persona es menor su frecuencia cardiaca máxima


#La siguiente que tiene una relción fuerte e inversamente proporcional es 
#la depresión del segmento ST(oldpeak) con la frecuencia cardiaca(thalachh) (-0.35)

#La siguiente correlación, en este caso positiva es entre la edad y el número
# de vasos sanguineos caa (0.3)


# No existen correlaciones muy altas que nos den a simple vista un indicio de
#multicolinealidad, lo cual es bueno para la regresión.



#De forma más visual:

corrplot(mat_cor, method = "color", type = "upper",
         addCoef.col = "black", tl.col = "black",
         title = "Matriz de correlación de variables cuantitativas",
         mar = c(0,0,1,0))


#Estructuras Latentes

# Para porder hacer un análisis de componentes principales, 
#consideramos que debemos estandarizar las variables, el colesterol 
#sino las variables que tengan unos valores altos se dominarían todo.
#Esto lo hare colocando el parámetro scale 

pca <- prcomp(df[cuanti], scale. = TRUE) 
summary(pca)

# En este caso, los primeros dos componentes solo explican un 51.69% de la varianza 
# entre ellas dos, es decir, no están tan correlacionadas entre sí(lo vimos en las correlaciones)
# para lograr un 79% de explicación de la variabilidad debo llegar al 4to componente
# por lo que cada variable aporta información relativamente propia, entonces el PCA no nos
# permite disminuir las dimensiones.

#Gráfico de sedimentación:

var_exp <- pca$sdev^2 / sum(pca$sdev^2)
plot(var_exp, type = "b", pch = 19,
     xlab = "Componente", ylab = "Proporción de varianza explicada",
     main = "Gráfico de sedimentación")

# Para tomar una decisión usaré los autovalores de cada componente

pca$sdev^2 

# Bueno, el análisis del codo nos indica que deberíamos de tomar
#los primeros dos componentes y, como el criterio de kaiser nos indica que debríamos
#tomar aquellos componentes cuyos eigen-values sea mayor a 1, nos vuelve a indicar que usemos 
#los primeros dos componentes.


#Interpretación de las cargas

round(pca$rotation[,1:2],3)

# En el PC1 dominan las variables de edad(-0.526), depresion  del
#segmento ST(-0.435) y el número de vasos sanguineos(-0.413), todos con carga negativa. Y por último la 
#variable de frecuencia cardiaca máxima(0.468) con carga positiva.
# En el PC2 dominan en carga el colesterol(-0.696), la frecuencia cardiaca máxima (-0.424)
# y la presión arterial en reposo al ingreso(trtbps[-0.474])

biplot(pca, scale = 0, cex = 0.6,
       main = "Biplot: PC1 vs PC2")

#Con esto podemos resumir que
# PC1 es un eje de salud cardiovascular: un paciente 
#con puntuación muy negativa es mayor, con más depresión ST
#y más vasos afectados pero menor FC máxima (perfil de deterioro),
#uno con puntuación positiva es lo contrario (mientras más joven
#mayor capacidad cardíaca).

# Por su parte PC2 es un eje perfil metabolico-presión, es decir, de colesterol
# y presión arterial.

# La variable de frecuencia máxima es una variable compartida entre ambos PCAs

#------------------------------------------

# ¿Qué factores clínicos explican a la Frecuencia Cardíaca Máxima)

#-----------------------------------

#RLS

modelo_fc_age <- lm(thalachh ~ age, data = df)
summary(modelo_fc_age)

#El coeficiente de edad es negativo ys siginificativo
#con un nivel de confianza del 5%. Al explicar a la frecuencia
#cardpiaca máxima, lo que nos indica que a mayor edad se espera que la FC máxima
#disminuya 1.0022
#Tenemos un coeficiente de determinación R2) de 0.158, es decir, la edad 
#por si sola explica aprox el 16%  de la FC máxima


#----------------------------
# Regresión Múltiple

#--------------------

mod_multiple <- lm(thalachh ~ age + trtbps + chol + oldpeak + caa + exng + cp,
               data = df)
summary(mod_multiple)

# Este modelo nos está explicando el 34.24% de la FC máxima(R2 Ajustado),
# Nos podemos fijar que las variables significativas en este caso (con un 95% de confianza)
# son la edad, ladepresión del segmento ST, la angina inducida por ejercicio(en caso de que sí),
# y los tipos de dolor de pecho (cp), nos quedaremos con esas varibales para
#disminuir variables en el modelo.

mod_multiple <- lm(thalachh ~ age + oldpeak  + exng + cp,
                   data = df)
summary(mod_multiple)

# El modelo se mantiene y el R2 ajustado solo disminuyó muy poco, antes era
# 0.3424 y ahora 0.3312, por lo que las otras variables casi no aportaban al modelo.

# Diagnóstico de supuestos del modelo:

par(mfrow = c(2,2))  
plot(mod_multiple)
par(mfrow = c(1,1)) 

# En base a los gráficos de los supuestos, los errores parecen tener una varianza constante
# por lo podemos inducir homocedasticidad, en cuanto al qq residuals, en las
# colas los resiudos empiezan a abrirse un poco de la línea, lo que
#nos da un indicio de no normalidad.

# Realizamos la prueba de Breusch Pagan para verificar homocedssticidad

bptest(mod_multiple)

# El pvalue de la prueba es 0.1033, lo que nos indica que no debemos rechazar
# la hhipotesis nula de que existe homocedssticidad, es decir, los residuos tienen 
#una varianza constante

# Shapiro test para normalidad

shapiro.test(residuals(mod_multiple))

# En este caso, con un pvalue menos a 5% rechazamos la H_0
# en donde la hipotesis era que los residuos eran normales,
# por ende se rechaza la normalidad de los rsiduos.
#como la muestra tiene una cantidad de observaciones de 300 
#por el teorema del limite central la inferencia sobre los coeficientes 
#es robusta a desviaciones leves de normalidad.

# VIF para multicolinealidad

vif(mod_multiple)

# Como el VIF es bajo, queda demostrado que no existe multicolinealidad entre
# las variables, es decir, son independientes

# Durbin Watson para autocorrelación

dwtest(mod_multiple) #p value 0.3087

# En este caso, como no tenemos orden temporal y son pacientes independientes
# la autocorrelación no constituye un supuesto crítico en este modelo.

#---------------------------------
# Métodos de clasificación
#-------------------------------------


#Haremos una partición 70/30 para tener datos de entrenamiento y de prueba

set.seed(27278)
n <- nrow(df)
indices <- sample(1:n, size = 0.7 * n)
train <- df[indices, ]
test  <- df[-indices, ]

dim(train)   #210 observaciones
dim(test)    #90 observaciones


# Modelo de regresión logísitica

# Usaré el modelo con el conjutno de predictores de sentido clínico fuert
# que vimos en el anpalisis exploratorio

mod_log <- glm(output ~ age + sex + cp + thalachh + exng + oldpeak + caa,
               data = train, family = binomial)
summary(mod_log)

# Tal parece que las variables que me explican al modelo
# son el sexo, los tipos de dolor de pecho, la angina inducida por ejercicio,
# la depresión del segmento ST y el número de vasos sanguíneos


#Interpretación de los Odds:

exp(coef(mod_log)) 
exp(cbind(OR = coef(mod_log), confint(mod_log)))  # con intervalos de confianza

# edad 0.96, la variable edad disminuye las probabilidades de mayor riesgo, por
#cada años más las probabilidades disminuyen en 4%
# sexo1: 0.3152, el ser hombre disminuye las probailidades de mayor riesgo, 
# si eres hombre tus probabilidades disminuyen en apróx 69%
# En el caso de los dolores de pecho, estos aumentan las posibilidades de riesgo
# de manera muy alta.
# La frecuencia cardiaca máxima: 1.0195, esta aumenta las probabilidades de riesgo
# por cada lpm más, el riesgo aumenta en 1.9%
# El tener engina enducida por ejercicio disminuye aprox en 67% la probabilidad
# de mayor riesgo
# La depresión del segmento ST: 0.58 disminuye la probabilidad de mayor riesgo, 
# por cada unidad extra de depresión del segmento ST la probauilidad disminuye en 42% aprox
# Por cada número de sanguíneos principales visibles por fluoroscopía la probabilidad 
# de mayor riesgo disminuye en 44% aprox.



# Matriz de Confusión

prob <- predict(mod_log, newdata = test, type = "response")

pred <- ifelse(prob > 0.5, 1, 0)
pred <- factor(pred, levels = c(0, 1))

matriz_confusion <- table(Predicho = pred, Real = test$output)
matriz_confusion


# En este caso, la matriz de confusión nos está dando la siguiente información:

#Exactitud: 83.33%
(29+46)/(90)
#Sensibilidad: 92%
46/50
#Especificidad: 72.5%
29/(40)

#Es decir, nuestro modelo tuvo un total de 83.33% de aciertos(exactitud)
# de aquellos que si tenían riesgo se detectaron un total de 792% (sensibilidad)
# y de las personas que tenían un menor riesgo nuestro modelo ha predicho el 72.5%




# Modelo no supervisado: Clusterizado 

#Debemos estandarizar nuestras variables
datos_esc <- scale(df[cuanti]) 

set.seed(8282)
wss <- sapply(1:10, function(k) {
  kmeans(datos_esc, centers = k, nstart = 10)$tot.withinss
})

plot(1:10, wss, type = "b", pch = 19,
     xlab = "Número de grupos (k)",
     ylab = "Suma de cuadrados intra-grupo (WSS)",
     main = "Método del codo")

# El modelo del codo no me permite ver bien cuantos clusters usar, pareciera dos 
# pero prefiero validar con el modelo silhouette


library(cluster)
sil <- sapply(2:10, function(k) {
  km <- kmeans(datos_esc, centers = k, nstart = 10)
  mean(silhouette(km$cluster, dist(datos_esc))[, 3])
})

plot(2:10, sil, type = "b", pch = 19,
     xlab = "Número de grupos (k)",
     ylab = "Silueta promedio",
     main = "Método de la silueta")
# En la silueta, el valor más alto me lo está dando haciendo dos clusters
# por lo que queda confirmado que debemos usar k=2

km <- kmeans(datos_esc, centers = 2, nstart = 25)
table(Cluster = km$cluster, Output = df$output)

#Cluster 1 77% son de riesgo (output 1)
# Cluster 2 72% son sanos (output 2)

#Aciertos:
(123+101)/300
# 74.67%


# El k-means con k=2 forma dos grupos que coinciden en 74.67% con el riesgo real,
# a pesar que no usa la variable output, lo que confirma que las variables cuantitativas
# capturan buena parte de la estructura del riesgo cardíaco. El ~25% de desacuerdo
# sugiere que las variables categóricas (cp, thall) aportan información adicional
# que el clúster no recoge.


#--------------------------
# Modelo de conteo: Usaremos caa
#-----------------------------

#¿Por qué usaremos caa?
# Es el numero de vasos sanguíneos, va desde 0 a 4 y es conteo real, 
# numeros enteros positivos


table(df$caa)
barplot(table(df$caa),
        main = "Distribución del número de vasos (caa)",
        xlab = "Número de vasos", ylab = "Frecuencia")

# Tenemos una gran cantidad de ceros(sobredispersión)

# Media vs varianza
mean(df$caa)
var(df$caa)


# La media y la varianza no son las mismas, lo que nos indica que 
# no debemos usar poisson debido a que se subestima los errores estandar


# Realizaremos el modelo solo para verificar el parámetro solicitado:

modelo_poisson <- glm(caa ~ age + sex + oldpeak + output,
                data = df, family = poisson)
summary(modelo_poisson)

# Las variables que son significativas son edad y output

#Parametro de razón de disoersión

deviance(mod_pois) / df.residual(mod_pois)

# El parámetro es 1.10442, como es mayor a 1  confirmamos nuevamente sobredispersión

# Binomial Negativa

modelo_binomial_negativa <- glm.nb(caa ~ age + sex + oldpeak + output, data = df)
summary(modelo_binomial_negativa)

# Las variables significativas son las mismas que el modelo poisson(age y output),
# lo que nos muestra consistencia en el modelo, adicional de que tenemos un theta relativamente alto (9)

#Haciendo la comparación

AIC(modelo_poisson,modelo_binomial_negativa)

#El modelo Poisson tiene un AIC ligeramente menos a la binomial negativa
# en este caso podríamos decir que la Poisson ajusta mejor el modelo, a pesar de demostrarse
# inicialmente que se demostraba sobredispersión pero esta era muy débil


#Interpretación IRR

exp(coef(modelo_poisson))                          # IRR
exp(cbind(IRR = coef(modelo_poisson), confint(modelo_poisson)))   # con intervalos

# Como solo salieron significativos age y output, las interpretaciones serán 
#sobre estas:

# Age: 1.04: Por cada año extra, tendremos 4% más de vasos esperados.
# Output: 0.36: Aquellos que tienen mayor riesgo de infarto tienen apróximadamente 64% menos vasos sanguíneos visibles

