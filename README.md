# 🎬 Laboratorio 1: Análisis Exploratorio de Datos

**Curso:** Minería de Datos  
**Autores:** Roberto Navera, Andre Pivaral, Jose Sanchez  
**Dataset:** movies_2026.csv

## Descripción

Análisis exploratorio completo de un dataset de películas (`movies_2026.csv`) que incluye información sobre presupuestos, ingresos, calificaciones, géneros, directores y más.

## Contenido del Repositorio

| Archivo | Descripción |
|---------|-------------|
| `markdown lab#1.Rmd` | Documento principal en R Markdown con todo el análisis exploratorio, gráficos y conclusiones |
| `analisis_completo.R` | Script de R con el análisis completo |
| `analisis_completo.py` | Versión en Python del análisis |
| `analisis_preguntas.R` | Script de R enfocado en responder las preguntas del laboratorio |
| `analizando datos.R` | Script auxiliar de exploración de datos |
| `movies_2026.csv` | Dataset de películas utilizado para el análisis |

## Estructura del Análisis (R Markdown)

1. **Carga y exploración inicial:** Estructura, dimensiones y tipos de datos
2. **Estadísticas descriptivas:** Resumen estadístico y detección de valores faltantes
3. **Ejercicio 3:** Análisis de distribución de variables cuantitativas (normalidad) y tablas de frecuencia de variables cualitativas
4. **Ejercicio 4:** Preguntas de análisis (4.1–4.16) incluyendo:
   - Películas con mayor presupuesto e ingresos
   - Análisis de géneros cinematográficos
   - Correlación presupuesto vs ingresos
   - Influencia de actores, género del reparto y directores
   - Análisis temporal por mes y año
   - Videos promocionales y páginas oficiales
5. **Preguntas extras:** ROI por género, duración vs calificación, idioma original, productoras y más

## Requisitos

- R (>= 4.0)
- Paquetes: `tidyverse`, `ggplot2`, `dplyr`, `lubridate`, `nortest`, `knitr`

## Cómo ejecutar

1. Clonar el repositorio
2. Abrir `markdown lab#1.Rmd` en RStudio
3. Asegurarse de que `movies_2026.csv` esté en el mismo directorio
4. Hacer clic en "Knit" para generar el HTML
