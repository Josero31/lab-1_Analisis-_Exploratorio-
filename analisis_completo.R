# Análisis Completo de movies_2026.csv
library(tidyverse)
library(stringr)

# Cargar datos
df <- read.csv("movies_2026.csv", stringsAsFactors = FALSE)

# Ver estructura inicial
cat("=== ESTRUCTURA DEL DATASET ===\n")
print(head(df))
cat("\nDimensiones:", nrow(df), "x", ncol(df), "\n")
cat("Columnas:", colnames(df), "\n\n")

# 1. EXTRAER GÉNERO PRINCIPAL (primer género antes del |)
cat("=== 1. EXTRAYENDO GÉNERO PRINCIPAL ===\n")
df$mainGenre <- sapply(strsplit(df$genres, "\\|"), function(x) trimws(x[1]))
cat("Primeros 10 géneros principales:\n")
print(head(df$mainGenre, 10))
cat("\n")

# 2. GÉNERO PRINCIPAL DE LAS 20 PELÍCULAS MÁS RECIENTES
cat("=== 2. GÉNERO PRINCIPAL - TOP 20 PELÍCULAS MÁS RECIENTES ===\n")
df$releaseYear <- as.numeric(format(as.Date(df$releaseDate, format="%Y-%m-%d"), "%Y"))
top_20_recientes <- df %>% 
  arrange(desc(releaseDate)) %>% 
  head(20) %>%
  select(title, releaseDate, releaseYear, mainGenre)
print(top_20_recientes)

# Contar géneros en top 20
genre_count_recent <- table(top_20_recientes$mainGenre)
cat("\nDistribución de géneros en TOP 20 recientes:\n")
print(sort(genre_count_recent, decreasing = TRUE))
cat("\n")

# 3. GÉNERO PRINCIPAL PREDOMINANTE EN TODO EL DATASET
cat("=== 3. GÉNERO PRINCIPAL PREDOMINANTE ===\n")
genre_counts <- table(df$mainGenre)
genre_counts_sorted <- sort(genre_counts, decreasing = TRUE)
print(genre_counts_sorted)
cat("\nGénero más frecuente:", names(genre_counts_sorted[1]), 
    "con", genre_counts_sorted[1], "películas\n")
cat("Porcentaje:", round(genre_counts_sorted[1] / nrow(df) * 100, 2), "%\n\n")

# 4. GÉNERO PRINCIPAL DE LAS 20 PELÍCULAS MÁS LARGAS
cat("=== 4. GÉNERO PRINCIPAL - TOP 20 PELÍCULAS MÁS LARGAS ===\n")
top_20_largas <- df %>% 
  arrange(desc(runtime)) %>% 
  head(20) %>%
  select(title, runtime, mainGenre)
print(top_20_largas)

# Contar géneros en top 20 más largas
genre_count_largas <- table(top_20_largas$mainGenre)
cat("\nDistribución de géneros en TOP 20 más largas:\n")
print(sort(genre_count_largas, decreasing = TRUE))
cat("\n")

# 5. GÉNERO CON MAYORES GANANCIAS (revenue - budget)
cat("=== 5. GÉNERO CON MAYORES GANANCIAS (REVENUE - BUDGET) ===\n")
df$profit <- df$revenue - df$budget

# Filtrar películas con datos de budget y revenue válidos
df_with_profit <- df %>% 
  filter(budget > 0 & revenue > 0 & !is.na(budget) & !is.na(revenue))

cat("Películas con datos de budget y revenue:", nrow(df_with_profit), "\n\n")

profit_by_genre <- df_with_profit %>%
  group_by(mainGenre) %>%
  summarise(
    totalProfit = sum(profit, na.rm = TRUE),
    avgProfit = mean(profit, na.rm = TRUE),
    totalRevenue = sum(revenue, na.rm = TRUE),
    totalBudget = sum(budget, na.rm = TRUE),
    countMovies = n()
  ) %>%
  arrange(desc(totalProfit))

print(as.data.frame(profit_by_genre))
cat("\nGénero con más ganancias totales:", profit_by_genre$mainGenre[1],
    "- Total:", formatC(profit_by_genre$totalProfit[1], format="f", digits=0), "\n\n")

# 6. CORRELACIÓN ENTRE actorsAmount Y revenue
cat("=== 6. CORRELACIÓN ENTRE actorsAmount Y revenue ===\n")
correlation_6 <- cor(df$actorsAmount, df$revenue, use = "complete.obs")
cat("Correlación de Pearson:", correlation_6, "\n\n")

# 7. TENDENCIA DE ACTORES EN LOS ÚLTIMOS AÑOS
cat("=== 7. TENDENCIA DE ACTORES POR AÑO ===\n")
actors_by_year <- df %>%
  filter(!is.na(releaseYear) & releaseYear >= 2000) %>%
  group_by(releaseYear) %>%
  summarise(
    avgActors = mean(actorsAmount, na.rm = TRUE),
    medianActors = median(actorsAmount, na.rm = TRUE),
    countMovies = n()
  ) %>%
  arrange(releaseYear)

print(as.data.frame(actors_by_year))
cat("\n")

# Calcular tendencia (correlación entre año y promedio de actores)
actors_trend <- cor(actors_by_year$releaseYear, actors_by_year$avgActors)
cat("Correlación entre año y cantidad promedio de actores:", actors_trend, "\n")
if(actors_trend > 0.3) {
  cat("→ Tendencia: AUMENTAN los actores en los últimos años\n")
} else if(actors_trend < -0.3) {
  cat("→ Tendencia: DISMINUYEN los actores en los últimos años\n")
} else {
  cat("→ Tendencia: SIN CAMBIO SIGNIFICATIVO\n")
}
cat("\n")

# 8. CORRELACIÓN ENTRE castWomenAmount/castMenAmount CON popularity Y revenue
cat("=== 8. CORRELACIÓN DE GÉNERO DE CAST CON popularity Y revenue ===\n")

# Crear ratio de mujeres vs hombres
df$womenRatio <- df$castWomenAmount / (df$castMenAmount + df$castWomenAmount + 1)
df$menRatio <- df$castMenAmount / (df$castMenAmount + df$castWomenAmount + 1)

# Correlaciones
corr_women_popularity <- cor(df$castWomenAmount, df$popularity, use = "complete.obs")
corr_women_revenue <- cor(df$castWomenAmount, df$revenue, use = "complete.obs")
corr_men_popularity <- cor(df$castMenAmount, df$popularity, use = "complete.obs")
corr_men_revenue <- cor(df$castMenAmount, df$revenue, use = "complete.obs")

cat("MUJERES EN CAST:\n")
cat("  - Correlación con popularity:", corr_women_popularity, "\n")
cat("  - Correlación con revenue:", corr_women_revenue, "\n\n")

cat("HOMBRES EN CAST:\n")
cat("  - Correlación con popularity:", corr_men_popularity, "\n")
cat("  - Correlación con revenue:", corr_men_revenue, "\n\n")

# Ratio women/men
corr_ratio_women_popularity <- cor(df$womenRatio, df$popularity, use = "complete.obs")
corr_ratio_women_revenue <- cor(df$womenRatio, df$revenue, use = "complete.obs")

cat("RATIO MUJERES/TOTAL:\n")
cat("  - Correlación con popularity:", corr_ratio_women_popularity, "\n")
cat("  - Correlación con revenue:", corr_ratio_women_revenue, "\n\n")

# 9. DIRECTORES DE LAS 20 PELÍCULAS MEJOR CALIFICADAS
cat("=== 9. DIRECTORES - TOP 20 PELÍCULAS MEJOR CALIFICADAS ===\n")
cat("(Filtro: voteCount >= 100)\n\n")

top_20_calificadas <- df %>%
  filter(voteCount >= 100) %>%
  arrange(desc(voteAverage)) %>%
  head(20) %>%
  select(title, voteAverage, voteCount, director, releaseYear)

print(top_20_calificadas)
cat("\n")

# Contar directores más frecuentes en el top 20
director_counts <- table(top_20_calificadas$director)
cat("Directores más frecuentes en TOP 20:\n")
print(sort(director_counts, decreasing = TRUE))

cat("\n=== FIN DEL ANÁLISIS ===\n")
