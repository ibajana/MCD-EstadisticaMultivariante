# Datasets

Bases de datos utilizadas en las sesiones prácticas del curso. Los archivos aquí almacenados son los que no están disponibles directamente desde paquetes de R.

---

## Archivos

| Archivo | Formato | Variables principales | Uso en el curso |
|---|---|---|---|
| `advertising.csv` | CSV | `TV`, `Radio`, `Newspaper`, `Sales` | Correlación y regresión lineal (Sesión 1 y 2) |
| `diabetes2.csv` | CSV | Variables clínicas (glucosa, IMC, insulina, etc.) | Clasificación y regresión logística |
| `cancer.df.txt` | TXT | Características tumorales | Clasificación |
| `mines.df.txt` | TXT | Señales de sonar | Clasificación binaria (mina vs. roca) |
| `onions.df.txt` | TXT | Variables agrícolas de producción de cebolla | Regresión |
| `optdigits.tra` | TXT | Píxeles de dígitos escritos a mano (0–9) | Clasificación multivariante |

---

## Datasets cargados desde paquetes R

Los siguientes datasets se cargan directamente en los scripts sin necesidad de archivos locales:

| Dataset | Paquete | Descripción |
|---|---|---|
| `Auto` | `ISLR2` | Características y consumo de 392 automóviles |
| `Credit` | `ISLR2` | Variables financieras de 400 clientes |
| `Default` | `ISLR2` | Incumplimiento de pago de 10 000 clientes |
| `iris` | `datasets` | Medidas morfológicas de 150 flores (3 especies) |
| `mtcars` | `datasets` | Características de 32 automóviles (1974) |
| `USArrests` | `datasets` | Estadísticas de crimen por estado en EE. UU. |

```r
# Cargar cualquiera de estos datasets:
library(ISLR2)
data("Default")
data("Auto")
```
