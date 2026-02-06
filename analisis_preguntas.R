# ==============================================================================
# ANÁLISIS PREGUNTAS 4.6 - 4.10
# ==============================================================================

library(dplyr)
library(ggplot2)
library(tidyr)

# Cargar datos
movies <- read.csv("movies_2026.csv", stringsAsFactors = FALSE)

# Extraer género principal (primer género antes del |)
movies$genero_principal <- sapply(strsplit(movies$genres, "\\|"), function(x) {
  if(length(x) > 0 && x[1] != "") return(x[1])
  else return(NA)
})

# ==============================================================================
# 4.6. ANÁLISIS DE GÉNEROS
# ==============================================================================

cat("\n========== 4.6. ANÁLISIS DE GÉNEROS ==========\n\n")

# a) Género de las 20 películas más recientes
cat("a) Género principal de las 20 películas más recientes:\n")
top20_recientes <- movies %>% 
  arrange(desc(releaseDate)) %>% 
  head(20)

genero_recientes <- sort(table(top20_recientes$genero_principal), decreasing = TRUE)
print(genero_recientes)
cat("\nGénero más común en las 20 más recientes:", names(genero_recientes)[1], "\n")

# b) Género predominante en el dataset completo
cat("\nb) Género principal que predomina en el conjunto de datos:\n")
genero_dataset <- sort(table(movies$genero_principal), decreasing = TRUE)
print(head(genero_dataset, 10))
cat("\nGénero predominante:", names(genero_dataset)[1], "con", genero_dataset[1], "películas\n")

# c) Género de películas más largas
cat("\nc) Género de las películas más largas:\n")
top_largas <- movies %>% 
  filter(runtime > 0) %>%
  arrange(desc(runtime)) %>%
  head(20)

genero_largas <- sort(table(top_largas$genero_principal), decreasing = TRUE)
print(genero_largas)
cat("\nGénero más común en películas largas:", names(genero_largas)[1], "\n")

# Crear gráfico para 4.6
png("grafico_4_6.png", width = 1200, height = 800, res = 120)
par(mfrow = c(2, 2))

# Gráfico 1: Top 10 géneros en dataset
top10_generos <- head(genero_dataset, 10)
barplot(top10_generos, las = 2, col = "steelblue", 
        main = "Top 10 Géneros en el Dataset",
        ylab = "Cantidad de Películas", cex.names = 0.7)

# Gráfico 2: Géneros en top 20 recientes
barplot(genero_recientes, las = 2, col = "coral",
        main = "Géneros en las 20 Películas Más Recientes",
        ylab = "Cantidad", cex.names = 0.7)

# Gráfico 3: Géneros en películas más largas
barplot(genero_largas, las = 2, col = "mediumseagreen",
        main = "Géneros en las 20 Películas Más Largas",
        ylab = "Cantidad", cex.names = 0.7)

dev.off()

# ==============================================================================
# 4.7. GÉNERO CON MAYORES GANANCIAS
# ==============================================================================

cat("\n\n========== 4.7. GÉNERO CON MAYORES GANANCIAS ==========\n\n")

movies$ganancia <- movies$revenue - movies$budget

genero_ganancias <- movies %>%
  filter(ganancia > 0, !is.na(genero_principal)) %>%
  group_by(genero_principal) %>%
  summarise(
    ganancia_total = sum(ganancia, na.rm = TRUE),
    ganancia_promedio = mean(ganancia, na.rm = TRUE),
    n_peliculas = n()
  ) %>%
  arrange(desc(ganancia_total))

cat("Top 10 géneros con mayores ganancias totales:\n")
print(head(genero_ganancias, 10))

cat("\nTop 10 géneros con mayores ganancias promedio (mínimo 10 películas):\n")
genero_ganancias_prom <- genero_ganancias %>%
  filter(n_peliculas >= 10) %>%
  arrange(desc(ganancia_promedio))
print(head(genero_ganancias_prom, 10))

# Gráfico 4.7
png("grafico_4_7.png", width = 1200, height = 600, res = 120)
par(mfrow = c(1, 2))

top10_ganancias <- head(genero_ganancias, 10)
barplot(top10_ganancias$ganancia_total / 1e9, 
        names.arg = top10_ganancias$genero_principal,
        las = 2, col = "darkgreen",
        main = "Top 10 Géneros - Ganancia Total",
        ylab = "Ganancia (Miles de Millones $)",
        cex.names = 0.7)

barplot(head(genero_ganancias_prom, 10)$ganancia_promedio / 1e6,
        names.arg = head(genero_ganancias_prom, 10)$genero_principal,
        las = 2, col = "gold",
        main = "Top 10 Géneros - Ganancia Promedio\n(min 10 películas)",
        ylab = "Ganancia Promedio (Millones $)",
        cex.names = 0.7)

dev.off()

# ==============================================================================
# 4.8. CANTIDAD DE ACTORES E INGRESOS
# ==============================================================================

cat("\n\n========== 4.8. INFLUENCIA DE CANTIDAD DE ACTORES ==========\n\n")

# Correlación cantidad de actores vs ingresos
cor_actores_revenue <- cor(movies$actorsAmount, movies$revenue, 
                           use = "complete.obs")
cat("Correlación entre cantidad de actores e ingresos:", 
    round(cor_actores_revenue, 4), "\n")

# Tendencia de actores por año
actores_por_año <- movies %>%
  filter(releaseYear >= 1990, actorsAmount > 0) %>%
  group_by(releaseYear) %>%
  summarise(
    promedio_actores = mean(actorsAmount, na.rm = TRUE),
    mediana_actores = median(actorsAmount, na.rm = TRUE),
    n_peliculas = n()
  ) %>%
  arrange(releaseYear)

cat("\nTendencia de actores en los últimos 10 años:\n")
print(tail(actores_por_año, 10))

# Gráfico 4.8
png("grafico_4_8.png", width = 1200, height = 600, res = 120)
par(mfrow = c(1, 2))

# Dispersión actores vs ingresos
plot(movies$actorsAmount, movies$revenue / 1e6,
     xlab = "Cantidad de Actores", 
     ylab = "Ingresos (Millones $)",
     main = paste0("Actores vs Ingresos\nCorrelación: ", 
                   round(cor_actores_revenue, 3)),
     pch = 16, col = rgb(0, 0, 1, 0.3), cex = 0.8)
abline(lm(revenue ~ actorsAmount, data = movies), col = "red", lwd = 2)

# Tendencia de actores por año
plot(actores_por_año$releaseYear, actores_por_año$promedio_actores,
     type = "l", lwd = 2, col = "darkblue",
     xlab = "Año", ylab = "Promedio de Actores",
     main = "Evolución de la Cantidad de Actores\npor Película (1990-2026)")
points(actores_por_año$releaseYear, actores_por_año$promedio_actores, 
       pch = 16, col = "darkblue")

dev.off()

# ==============================================================================
# 4.9. INFLUENCIA DE GÉNERO DEL REPARTO
# ==============================================================================

cat("\n\n========== 4.9. INFLUENCIA DE GÉNERO DEL REPARTO ==========\n\n")

# Correlaciones
cor_mujeres_pop <- cor(movies$castWomenAmount, movies$popularity, 
                       use = "complete.obs")
cor_hombres_pop <- cor(movies$castMenAmount, movies$popularity, 
                       use = "complete.obs")
cor_mujeres_rev <- cor(movies$castWomenAmount, movies$revenue, 
                       use = "complete.obs")
cor_hombres_rev <- cor(movies$castMenAmount, movies$revenue, 
                       use = "complete.obs")

cat("Correlaciones con Popularidad:\n")
cat("  - Cantidad de Mujeres:", round(cor_mujeres_pop, 4), "\n")
cat("  - Cantidad de Hombres:", round(cor_hombres_pop, 4), "\n\n")

cat("Correlaciones con Ingresos:\n")
cat("  - Cantidad de Mujeres:", round(cor_mujeres_rev, 4), "\n")
cat("  - Cantidad de Hombres:", round(cor_hombres_rev, 4), "\n")

# Gráfico 4.9
png("grafico_4_9.png", width = 1200, height = 800, res = 120)
par(mfrow = c(2, 2))

# Mujeres vs Popularidad
plot(movies$castWomenAmount, movies$popularity,
     xlab = "Cantidad de Mujeres en el Reparto",
     ylab = "Popularidad",
     main = paste0("Mujeres vs Popularidad\nCorr: ", 
                   round(cor_mujeres_pop, 3)),
     pch = 16, col = rgb(1, 0, 0, 0.3))

# Hombres vs Popularidad
plot(movies$castMenAmount, movies$popularity,
     xlab = "Cantidad de Hombres en el Reparto",
     ylab = "Popularidad",
     main = paste0("Hombres vs Popularidad\nCorr: ", 
                   round(cor_hombres_pop, 3)),
     pch = 16, col = rgb(0, 0, 1, 0.3))

# Mujeres vs Ingresos
plot(movies$castWomenAmount, movies$revenue / 1e6,
     xlab = "Cantidad de Mujeres en el Reparto",
     ylab = "Ingresos (Millones $)",
     main = paste0("Mujeres vs Ingresos\nCorr: ", 
                   round(cor_mujeres_rev, 3)),
     pch = 16, col = rgb(1, 0, 0, 0.3))

# Hombres vs Ingresos
plot(movies$castMenAmount, movies$revenue / 1e6,
     xlab = "Cantidad de Hombres en el Reparto",
     ylab = "Ingresos (Millones $)",
     main = paste0("Hombres vs Ingresos\nCorr: ", 
                   round(cor_hombres_rev, 3)),
     pch = 16, col = rgb(0, 0, 1, 0.3))

dev.off()

# ==============================================================================
# 4.10. DIRECTORES DE PELÍCULAS MEJOR CALIFICADAS
# ==============================================================================

cat("\n\n========== 4.10. DIRECTORES DE PELÍCULAS MEJOR CALIFICADAS ==========\n\n")

top20_calificadas <- movies %>%
  filter(voteCount >= 100, voteAvg > 0, director != "") %>%
  arrange(desc(voteAvg)) %>%
  head(20)

cat("Top 20 películas mejor calificadas:\n")
print(select(top20_calificadas, title, director, voteAvg, voteCount))

directores_top <- sort(table(top20_calificadas$director), decreasing = TRUE)
cat("\n\nDirectores con más películas en el Top 20:\n")
print(directores_top)

# Contar cuántas películas ha dirigido cada director en general
directores_count <- movies %>%
  filter(director != "") %>%
  count(director, name = "total_peliculas") %>%
  arrange(desc(total_peliculas))

# Gráfico 4.10
png("grafico_4_10.png", width = 1200, height = 600, res = 120)
par(mfrow = c(1, 2))

# Top 20 películas
barplot(top20_calificadas$voteAvg[1:15],
        names.arg = substr(top20_calificadas$title[1:15], 1, 20),
        las = 2, col = "purple",
        main = "Top 15 Películas Mejor Calificadas",
        ylab = "Calificación Promedio",
        cex.names = 0.6)

# Directores con más películas en top 20
if(length(directores_top) > 0) {
  barplot(directores_top,
          las = 2, col = "orange",
          main = "Directores en Top 20 Películas",
          ylab = "Cantidad de Películas",
          cex.names = 0.7)
}

dev.off()

cat("\n\n========== ANÁLISIS COMPLETADO ==========\n\n")
