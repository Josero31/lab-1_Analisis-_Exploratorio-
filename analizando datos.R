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

