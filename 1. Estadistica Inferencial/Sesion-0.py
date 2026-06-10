# Datos de Anscombe - Migración de R a Python
#
# Equivalencias de librerías:
#   library(ggplot2)   →  seaborn + matplotlib
#   library(dplyr)     →  pandas  (method chaining con .pipe(), .query(), etc.)
#   library(magrittr)  →  pandas  (los DataFrames ya soportan encadenamiento)
#   library(datasets)  →  seaborn.load_dataset() (tiene anscombe incorporado)

import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt

# ── Cargar y preparar datos ───────────────────────────────────────────────────
#
# R:  data.frame con X, Y, Caso construido manualmente desde el dataset wide
# Py: seaborn ya tiene anscombe en formato largo (tidy): columnas dataset, x, y

df_anscombe = sns.load_dataset("anscombe")
print(df_anscombe)          # equivalente a print(df_anscombe) en R
print(df_anscombe.dtypes)   # equivalente a str(df_anscombe) en R

# Renombramos columnas para que coincidan con la nomenclatura del script R
# R:  factor con etiquetas "Caso 1" … "Caso 4"
# Py: columna categórica (pd.Categorical) con las mismas etiquetas
df_anscombe = df_anscombe.rename(columns={"dataset": "Caso", "x": "X", "y": "Y"})

etiquetas = {"I": "Caso 1", "II": "Caso 2", "III": "Caso 3", "IV": "Caso 4"}
df_anscombe["Caso"] = (
    df_anscombe["Caso"]
    .map(etiquetas)
    .astype("category")          # equivalente a factor() en R
)

print(df_anscombe)
print(df_anscombe["Caso"].dtype)  # debería mostrar category

# ── Graficando con seaborn ────────────────────────────────────────────────────
#
# La filosofía de seaborn es muy parecida a ggplot2:
#   - FacetGrid  ≈  facet_wrap / facet_grid
#   - scatterplot ≈  geom_point
#   - regplot     ≈  geom_smooth(method = "lm")
#   - histplot    ≈  geom_histogram
#   - kdeplot     ≈  geom_density
#   - stripplot   ≈  geom_dotplot

# 1. Scatter básico
# R:  df_anscombe %>% ggplot(aes(x=X, y=Y)) + geom_point()
fig, ax = plt.subplots()
sns.scatterplot(data=df_anscombe, x="X", y="Y", ax=ax)
plt.title("Scatter básico")
plt.tight_layout()
plt.show()

# 2. Scatter con facets por Caso
# R:  + facet_wrap("Caso")
g = sns.FacetGrid(df_anscombe, col="Caso", col_wrap=2, height=3)
g.map_dataframe(sns.scatterplot, x="X", y="Y")
g.set_titles(col_template="{col_name}")
plt.show()

# 3. Scatter + recta de regresión (lm)
# R:  + geom_smooth(method = "lm")
g = sns.FacetGrid(df_anscombe, col="Caso", col_wrap=2, height=3)
g.map_dataframe(sns.regplot, x="X", y="Y", ci=95)   # ci=95 ≈ banda de confianza por defecto en ggplot2
g.set_titles(col_template="{col_name}")
g.figure.suptitle("Estudio de correlación del caso Anscombe's quartet", y=1.03)
plt.tight_layout()
plt.show()

# 4. Scatter + curva cuadrática
# R:  + geom_smooth(method = "lm", formula = y ~ poly(x, 2))
g = sns.FacetGrid(df_anscombe, col="Caso", col_wrap=2, height=3)
g.map_dataframe(sns.regplot, x="X", y="Y", order=2)  # order=2 → polinomio grado 2
g.set_titles(col_template="{col_name}")
g.figure.suptitle("Regresión cuadrática - Anscombe's quartet", y=1.03)
plt.tight_layout()
plt.show()

# 5. Scatter con color por Caso + tema
# R:  geom_point(aes(color = Caso)) + theme_gray()
g = sns.FacetGrid(df_anscombe, col="Caso", col_wrap=2, height=3, hue="Caso")
g.map_dataframe(sns.scatterplot, x="X", y="Y")
g.map_dataframe(sns.regplot, x="X", y="Y", scatter=False)
g.set_titles(col_template="{col_name}")
g.add_legend()
g.figure.suptitle("Estudio de correlación del caso Anscombe's quartet", y=1.03)
sns.set_theme(style="darkgrid")   # ≈ theme_dark() / theme_gray()
plt.tight_layout()
plt.show()

# ── Distribución de Y ─────────────────────────────────────────────────────────

# 6. Histograma
# R:  ggplot(aes(Y)) + geom_histogram(bins=7, color="gray20") + theme_light()
sns.set_theme(style="whitegrid")  # ≈ theme_light()
fig, ax = plt.subplots()
sns.histplot(data=df_anscombe, x="Y", bins=7, edgecolor="#333333", ax=ax)
plt.tight_layout()
plt.show()

# 7. Densidad
# R:  geom_density(fill="purple", alpha=0.5)
fig, ax = plt.subplots()
sns.kdeplot(data=df_anscombe, x="Y", fill=True, color="purple", alpha=0.5, ax=ax)
plt.tight_layout()
plt.show()

# 8. Dotplot
# R:  geom_dotplot(binwidth=0.7)
# En Python no existe geom_dotplot nativo; el equivalente más cercano es stripplot
fig, ax = plt.subplots()
sns.stripplot(data=df_anscombe, x="Y", jitter=True, ax=ax)
plt.tight_layout()
plt.show()
