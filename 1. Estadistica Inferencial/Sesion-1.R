library(readr)
#advertising <- read_csv("./Datasets/advertising.csv")
#View(advertising)
installed.packages("ISLR2")
library(ISLR2)
advertising %>% names

advertising %>%
  ggplot(aes(x = TV,y = Sales)) +
  geom_point()

advertising %>%
  ggplot(aes(x = TV,y = Sales)) +
  geom_point() +
  geom_smooth(method = "lm")


cor(advertising$TV,advertising$Sales)
cor(advertising)

# Gráficos de correlación

library(corrplot)
Mat_correlacion <- advertising %>% cor
corrplot(Mat_correlacion,type="upper",diag = FALSE)
?corrplot
corrplot(Mat_correlacion,type="upper", order="hclust",diag = FALSE)
corrplot(Mat_correlacion,type="upper", order="hclust",method = "number")


library(ISLR2)
Mat_correlacion <- Auto %>% select(-name) %>% cor
corrplot(Mat_correlacion,type="upper",diag = FALSE)
corrplot(Mat_correlacion,type="upper", order="hclust",diag = FALSE)
corrplot(Mat_correlacion,type="upper", order="hclust",method = "number")
data(credit)
