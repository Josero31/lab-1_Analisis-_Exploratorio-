#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import pandas as pd
import numpy as np
from datetime import datetime
import warnings
warnings.filterwarnings('ignore')

# Cargar datos
print("=" * 80)
print("ANÁLISIS COMPLETO DE movies_2026.csv")
print("=" * 80)

df = pd.read_csv('movies_2026.csv')

print(f"\nEstructura del dataset:")
print(f"  - Filas: {len(df)}")
print(f"  - Columnas: {len(df.columns)}")
print(f"  - Columnas: {list(df.columns)[:10]}...")

# 1. EXTRAER GÉNERO PRINCIPAL
print("\n" + "=" * 80)
print("1. EXTRAYENDO GÉNERO PRINCIPAL (primer género antes del |)")
print("=" * 80)

df['mainGenre'] = df['genres'].str.split('|').str[0]
print(f"\nPrimeros 10 géneros principales:")
print(df['mainGenre'].head(10).to_string())

# 2. GÉNERO PRINCIPAL - TOP 20 PELÍCULAS MÁS RECIENTES
print("\n" + "=" * 80)
print("2. GÉNERO PRINCIPAL - TOP 20 PELÍCULAS MÁS RECIENTES")
print("=" * 80)

df['releaseDate'] = pd.to_datetime(df['releaseDate'], errors='coerce')
top_20_recientes = df.nlargest(20, 'releaseDate')[['title', 'releaseDate', 'mainGenre']]
print(f"\n{top_20_recientes.to_string(index=False)}")

genre_recent = top_20_recientes['mainGenre'].value_counts()
print(f"\nDistribución de géneros en TOP 20 recientes:")
print(genre_recent)

# 3. GÉNERO PRINCIPAL PREDOMINANTE
print("\n" + "=" * 80)
print("3. GÉNERO PRINCIPAL PREDOMINANTE EN TODO EL DATASET")
print("=" * 80)

genre_counts = df['mainGenre'].value_counts()
print(f"\n{genre_counts.to_string()}")
print(f"\nGénero más frecuente: {genre_counts.index[0]}")
print(f"Cantidad: {genre_counts.iloc[0]} películas ({genre_counts.iloc[0]/len(df)*100:.2f}%)")

# 4. GÉNERO - TOP 20 PELÍCULAS MÁS LARGAS
print("\n" + "=" * 80)
print("4. GÉNERO PRINCIPAL - TOP 20 PELÍCULAS MÁS LARGAS (runtime)")
print("=" * 80)

top_20_largas = df.nlargest(20, 'runtime')[['title', 'runtime', 'mainGenre']]
print(f"\n{top_20_largas.to_string(index=False)}")

genre_largas = top_20_largas['mainGenre'].value_counts()
print(f"\nDistribución de géneros en TOP 20 más largas:")
print(genre_largas)

# 5. GÉNERO CON MAYORES GANANCIAS
print("\n" + "=" * 80)
print("5. GÉNERO CON MAYORES GANANCIAS (revenue - budget)")
print("=" * 80)

df['profit'] = df['revenue'] - df['budget']

# Filtrar películas con datos válidos
df_valid = df[(df['budget'] > 0) & (df['revenue'] > 0)].copy()
print(f"\nPelículas con datos de budget y revenue válidos: {len(df_valid)} de {len(df)}")

if len(df_valid) > 0:
    profit_by_genre = df_valid.groupby('mainGenre').agg({
        'profit': ['sum', 'mean', 'count'],
        'revenue': 'sum',
        'budget': 'sum'
    }).round(0)
    profit_by_genre.columns = ['totalProfit', 'avgProfit', 'countMovies', 'totalRevenue', 'totalBudget']
    profit_by_genre = profit_by_genre.sort_values('totalProfit', ascending=False)
    
    print(f"\n{profit_by_genre.to_string()}")
    
    top_profit_genre = profit_by_genre.index[0]
    top_profit_value = profit_by_genre['totalProfit'].iloc[0]
    print(f"\nGénero con mayores ganancias totales: {top_profit_genre}")
    print(f"Total ganancia: ${top_profit_value:,.0f}")
else:
    print("No hay películas con datos de budget y revenue válidos")

# 6. CORRELACIÓN actorsAmount Y revenue
print("\n" + "=" * 80)
print("6. CORRELACIÓN ENTRE actorsAmount Y revenue")
print("=" * 80)

corr_actors_revenue = df[['actorsAmount', 'revenue']].corr().iloc[0, 1]
print(f"\nCorrelación de Pearson: {corr_actors_revenue:.4f}")

# 7. TENDENCIA DE ACTORES POR AÑO
print("\n" + "=" * 80)
print("7. TENDENCIA DE ACTORES POR AÑO (últimos años)")
print("=" * 80)

df['releaseYear'] = df['releaseDate'].dt.year
actors_by_year = df[df['releaseYear'] >= 2000].groupby('releaseYear').agg({
    'actorsAmount': ['mean', 'median', 'count']
}).round(2)
actors_by_year.columns = ['avgActors', 'medianActors', 'countMovies']
actors_by_year = actors_by_year.sort_index()

print(f"\n{actors_by_year.to_string()}")

# Calcular tendencia
valid_years = actors_by_year[actors_by_year['countMovies'] > 0]
if len(valid_years) >= 2:
    trend_corr = valid_years[['avgActors']].reset_index()['releaseYear'].corr(valid_years['avgActors'].reset_index(drop=True))
    print(f"\nCorrelación año vs promedio de actores: {trend_corr:.4f}")
    
    if trend_corr > 0.3:
        print("→ Tendencia: AUMENTAN los actores en los últimos años")
    elif trend_corr < -0.3:
        print("→ Tendencia: DISMINUYEN los actores en los últimos años")
    else:
        print("→ Tendencia: SIN CAMBIO SIGNIFICATIVO")

# 8. CORRELACIÓN CAST WOMEN/MEN CON popularity Y revenue
print("\n" + "=" * 80)
print("8. CORRELACIÓN DE GÉNERO DE CAST CON popularity Y revenue")
print("=" * 80)

# Crear ratios
df['totalCast'] = df['castWomenAmount'] + df['castMenAmount']
df['womenRatio'] = df['castWomenAmount'] / (df['totalCast'] + 1)

corr_women_popularity = df[['castWomenAmount', 'popularity']].corr().iloc[0, 1]
corr_women_revenue = df[['castWomenAmount', 'revenue']].corr().iloc[0, 1]
corr_men_popularity = df[['castMenAmount', 'popularity']].corr().iloc[0, 1]
corr_men_revenue = df[['castMenAmount', 'revenue']].corr().iloc[0, 1]
corr_ratio_popularity = df[['womenRatio', 'popularity']].corr().iloc[0, 1]
corr_ratio_revenue = df[['womenRatio', 'revenue']].corr().iloc[0, 1]

print(f"\nMUJERES EN CAST:")
print(f"  - Correlación con popularity: {corr_women_popularity:.4f}")
print(f"  - Correlación con revenue: {corr_women_revenue:.4f}")

print(f"\nHOMBRES EN CAST:")
print(f"  - Correlación con popularity: {corr_men_popularity:.4f}")
print(f"  - Correlación con revenue: {corr_men_revenue:.4f}")

print(f"\nRATIO MUJERES/TOTAL CAST:")
print(f"  - Correlación con popularity: {corr_ratio_popularity:.4f}")
print(f"  - Correlación con revenue: {corr_ratio_revenue:.4f}")

# 9. DIRECTORES - TOP 20 PELÍCULAS MEJOR CALIFICADAS
print("\n" + "=" * 80)
print("9. DIRECTORES - TOP 20 PELÍCULAS MEJOR CALIFICADAS")
print("(Filtro: voteCount >= 100)")
print("=" * 80)

top_rated = df[df['voteCount'] >= 100].nlargest(20, 'voteAvg')[['title', 'voteAvg', 'voteCount', 'director', 'releaseYear']]
print(f"\n{top_rated.to_string(index=False)}")

director_counts = top_rated['director'].value_counts()
print(f"\nDirectores más frecuentes en TOP 20:")
print(director_counts)

print("\n" + "=" * 80)
print("FIN DEL ANÁLISIS")
print("=" * 80)
