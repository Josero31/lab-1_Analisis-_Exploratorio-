# ==============================
# CARGA DE DATOS
# ==============================
datos <- read.csv("movies_2026.csv")

# ==============================
# 1. ESTRUCTURA DEL DATASET (str)
# ==============================
str(datos)

# Versión en tabla de la estructura
tabla_estructura <- data.frame(
  Variable = names(datos),
  Tipo_de_dato = sapply(datos, class),
  row.names = NULL
)

tabla_estructura

# ==============================
# 2. DIMENSIONES DEL DATASET (dim)
# ==============================
dim(datos)

# Versión en tabla de las dimensiones
dimensiones <- data.frame(
  Filas = dim(datos)[1],
  Columnas = dim(datos)[2]
)

dimensiones

# ==============================
# 3. RESUMEN ESTADÍSTICO GENERAL (summary)
# ==============================
summary(datos)

# Versión en tabla del resumen
resumen <- as.data.frame(summary(datos))
resumen

# ==============================
# 4. PRIMERAS FILAS DEL DATASET (head)
# ==============================
head(datos)

# Versión en tabla (ya es tabla)
primeras_filas <- head(datos)
primeras_filas

# ==============================
# 5. TIPOS DE DATOS POR VARIABLE
# ==============================
tipos_datos <- sapply(datos, class)
tipos_datos

# Versión en tabla
tabla_tipos <- data.frame(
  Variable = names(datos),
  Tipo_de_dato = tipos_datos,
  row.names = NULL
)

tabla_tipos

# ==============================
# 6. VALORES FALTANTES POR VARIABLE
# ==============================
faltantes <- data.frame(
  Variable = names(datos),
  Valores_Faltantes = colSums(is.na(datos))
)

faltantes

> file.choose()

# ==============================
# INCISO 3
# ==============================

install.packages("tidyverse")
install.packages("nortest")

library(tidyverse)
library(nortest)

quant_vars <- movies %>%
  select(
    budget,
    revenue,
    runtime,
    popularity,
    voteAvg,
    voteCount,
    actorsPopularity
  )

hist(movies$budget,
     main = "Histograma del Presupuesto",
     xlab = "Presupuesto",
     col = "lightblue",
     breaks = 30)

hist(movies$revenue,
     main = "Histograma de Ingresos",
     xlab = "Ingresos",
     col = "lightgreen",
     breaks = 30)

hist(movies$popularity,
     main = "Histograma de Popularidad",
     xlab = "Popularidad",
     col = "orange",
     breaks = 30)

set.seed(123)

lillie_budget <- lillie.test(sample(movies$budget, 500))
lillie_revenue <- lillie.test(sample(movies$revenue, 500))
lillie_popularity <- lillie.test(sample(movies$popularity, 500))

lillie_budget
lillie_revenue
lillie_popularity

freq_language <- table(movies$originalLanguage)
freq_language

prop.table(freq_language)

freq_video <- table(movies$video)
freq_video
prop.table(freq_video)

freq_genres <- table(movies$genres)
freq_genres

table(movies$originalLanguage)
table(movies$video)
table(movies$genres)