# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Trabajo final MAT5519: configuración común
# Se corre desde la raíz del repo. Todos los scripts empiezan con
#   source("proyecto/R/00_setup.R")
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

## ---- setup_paquetes ----
library(MASS)
library(mclust)
library(cluster)

## ---- setup_datos ----
# La cabecera tiene 3 nombres (F1, F2, F3) y las filas 4 campos: con
# header = TRUE la columna sobrante (el id) queda como nombres de fila.
# Con header = FALSE falla ("line 1 did not have 4 elements").
X <- read.table("data/Foxes.txt", header = TRUE)

# País de cada zorro, tomado del identificador (B.17 -> B). Solo para interpretar.
pais <- factor(substr(rownames(X), 1, 1))

vars <- c(F1 = "Altura hasta los hombros (cm)",
          F2 = "Longitud del cuerpo (cm)",
          F3 = "Peso (kg)")

## ---- setup_colores ----
pal_pais <- c(B = "#1b9e77", U = "#d95f02")
col_pais <- pal_pais[as.character(pais)]

set.seed(5519)
