# Datos de anscombe -------------------------------------------------------

# cargamos la librerías

library(ggplot2) #graficación
library(magrittr) # pipes %$%
library(dplyr) # %>%
library(datasets)

?anscombe

df_anscombe <- data.frame(
  X = with(anscombe,c(x1,x2,x3,x4)),
  Y = with(anscombe,c(y1,y2,y3,y4)),
  Caso = factor(rep(c("Caso 1","Caso 2","Caso 3","Caso 4"),
                    each=nrow(anscombe)))
)

df_anscombe
df_anscombe <- df_anscombe %>% as_tibble

print(df_anscombe)


# Graficando con ggplot2 --------------------------------------------------

df_anscombe %>% names

df_anscombe %>% 
  ggplot()       # datos + gráfico

df_anscombe %>% 
  ggplot(aes(x = X,y = Y)) # agregamos x e y

df_anscombe %>% 
  ggplot(aes(x = X,y = Y)) + # agregamos x e y
  geom_point() # agregamos puntos

df_anscombe %>% 
  ggplot(aes(x = X,y = Y)) + # agregamos x e y
  geom_point() + # agregamos puntos 
  facet_grid("Caso")

df_anscombe %>% 
  ggplot(aes(x = X,y = Y)) + # agregamos x e y
  geom_point() + # agregamos puntos 
  facet_wrap("Caso") # un caso por ventana

df_anscombe %>% 
  ggplot(aes(x = X,y = Y)) + # agregamos x e y
  geom_point() + # agregamos puntos 
  facet_wrap("Caso") + # un caso por ventana
  geom_smooth(method = "lm") # rectas de regresión # linear model

df_anscombe %>% 
  ggplot(aes(x = X,y = Y)) + # agregamos x e y
  geom_point() + # agregamos puntos 
  facet_wrap("Caso") + # un caso por ventana
  geom_smooth(method = "lm",formula = y ~ poly(x,2)) # curva de regresión cuadrática

df_anscombe %>% 
  ggplot(aes(x = X,y = Y)) + # agregamos x e y
  geom_point() + # agregamos puntos 
  facet_wrap("Caso") + # un caso por ventana
  geom_smooth(method = "lm") + # rectas de regresión
  labs(title = "Estudio de correlación del caso Anscombe's quartet")

df_anscombe %>% 
  ggplot(aes(x = X,y = Y)) + # agregamos x e y
  geom_point() + # agregamos puntos 
  facet_wrap("Caso") + # un caso por ventana
  geom_smooth(method = "lm") + # rectas de regresión
  labs(title = "Estudio de correlación del caso Anscombe's quartet") +
  theme_bw()

df_anscombe %>% 
  ggplot(aes(x = X,y = Y)) + # agregamos x e y
  geom_point(color = "white") + # agregamos puntos 
  facet_wrap("Caso") + # un caso por ventana
  geom_smooth(method = "lm") + # rectas de regresión
  labs(title = "Estudio de correlación del caso Anscombe's quartet") +
  theme_dark()

df_anscombe %>% 
  ggplot(aes(x = X,y = Y)) + # agregamos x e y
  geom_point(aes(color = Caso)) + # agregamos puntos 
  facet_wrap("Caso") + # un caso por ventana
  geom_smooth(aes(color = Caso),method = "lm") + # rectas de regresión
  labs(title = "Estudio de correlación del caso Anscombe's quartet") +
  theme_gray()

df_anscombe %>%
  ggplot(aes(Y)) + 
  geom_histogram()

df_anscombe %>%
  ggplot(aes(Y)) + 
  geom_histogram(bins = 7,color = "gray20") + 
  theme_light()

df_anscombe %>%
  ggplot(aes(Y)) + 
  geom_density(fill = "purple",alpha = 0.5)

df_anscombe %>%
  ggplot(aes(Y)) + 
  geom_dotplot(binwidth = 0.7)
