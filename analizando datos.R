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

# ================================
# EJERCICIO 3
# ================================

# Librerías
library(tidyverse)
library(nortest)

# Datos
datos <- read.csv("C:/Users/andre/Downloads/Data.csv")

# -------------------------------
# VARIABLES CUANTITATIVAS
# -------------------------------

vars_cuant <- c("budget", "revenue", "runtime", "popularity", "voteAvg")

for (var in vars_cuant) {
  # Histograma
  hist(datos[[var]], main = paste("Histograma de", var), 
       xlab = var, col = "skyblue", border = "white")
  
  # Boxplot
  boxplot(datos[[var]], main = paste("Boxplot de", var), 
          horizontal = TRUE, col = "tomato")
  
  # Prueba Lilliefors
  print(paste("Prueba de Lilliefors para", var))
  print(lillie.test(na.omit(datos[[var]])))
}

# -------------------------------
# VARIABLES CUALITATIVAS
# -------------------------------

vars_cual <- c("originalLanguage", "releaseYear")

frecuencias <- lapply(vars_cual, function(v) {
  datos %>%
    count(.data[[v]]) %>%
    arrange(desc(n))
})

names(frecuencias) <- vars_cual
frecuencias

# ================================
# EJERCICIO 4
# ================================

# -------------------------------
# EJERCICIO 4.1
# -------------------------------

cat("\n--------- Top 10 Presupuesto ---------\n")
top_10_budget <- datos[order(-datos$budget), c("title", "budget")][1:10, ]
print(top_10_budget)

# -------------------------------
# EJERCICIO 4.2
# -------------------------------

cat("\n--------- Top 10 Ingresos ---------\n")
top_10_revenue <- datos[order(-datos$revenue), c("title", "revenue")][1:10, ]
print(top_10_revenue)

# -------------------------------
# EJERCICIO 4.3
# -------------------------------

cat("\n--------- Película con Más Votos ---------\n")
mas_votos <- datos[which.max(datos$voteCount), c("title", "voteCount")]
print(mas_votos)

# -------------------------------
# EJERCICIO 4.4
# -------------------------------

cat("\n--------- Película con Menos Votos ---------\n")
menos_votos <- datos %>% 
  filter(voteCount > 0) %>% 
  arrange(voteCount) %>% 
  select(title, voteCount) %>% 
  head(1)
print(menos_votos)

# -------------------------------
# EJERCICIO 4.5
# -------------------------------

cat("\n--------- 20 Películas Más Recientes ---------\n")
datos$releaseDate <- as.Date(datos$releaseDate)
top_20_recientes <- datos[order(datos$releaseDate, decreasing = TRUE), c("title", "releaseDate")][1:20, ]
print(top_20_recientes)