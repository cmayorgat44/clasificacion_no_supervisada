# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Punto 3: modelo de mixtura de densidades normales con el k elegido (k = 2)
# Uso: Rscript proyecto/R/03_mixturas.R   (desde la raíz del repo)
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
source("proyecto/R/02_kmedias.R")   # trae X, pais y grupo_km

## ---- mc_bic ----
# BIC de todos los modelos con 1 a 5 componentes, solo como referencia
bic_todos <- mclustBIC(X, G = 1:5, verbose = FALSE)
summary(bic_todos)

## ---- mc_ajuste ----
# Con k = 2 fijo, Mclust elige por BIC la forma de las covarianzas.
# Se ajusta en unidades originales: el modelo estima su propia escala.
mc <- Mclust(X, G = 2, verbose = FALSE)
mc$modelName
mc$bic

# Etiquetas estables: componente 1 = cuerpo más corto (igual que k-medias)
orden <- order(mc$parameters$mean["F2", ])
grupo_mc <- match(mc$classification, orden)

pesos_mc <- mc$parameters$pro[orden]            # ponderadores pi
medias_mc <- mc$parameters$mean[, orden]        # vectores de medias
sigma_mc <- mc$parameters$variance$sigma[, , orden]
round(pesos_mc, 3)
round(medias_mc, 2)
round(sigma_mc[, , 1], 3)
round(sqrt(diag(sigma_mc[, , 1])), 2)           # desviaciones estándar
round(cov2cor(sigma_mc[, , 1]), 2)              # correlaciones dentro de grupo

## ---- mc_comparacion ----
tab_mc_km <- table(mixtura = grupo_mc, kmedias = grupo_km)
tab_mc_km
ari_mc_km <- adjustedRandIndex(grupo_mc, grupo_km)
ari_mc_pais <- adjustedRandIndex(grupo_mc, pais)
round(c(mc_km = ari_mc_km, mc_pais = ari_mc_pais), 3)

# Zorros con mayor incertidumbre de asignación (1 - probabilidad máxima)
incert <- sort(mc$uncertainty, decreasing = TRUE)
round(head(incert, 5), 3)
prob_dudoso <- round(mc$z[names(incert)[1], orden], 2)
prob_dudoso

## ---- mc_fig ----
# Colores por componente: el grupo 1 (corto) en el color de B, el 2 en el de U
col_mc <- character(2); col_mc[orden] <- unname(pal_pais[c("B", "U")])
sym_mc <- numeric(2);   sym_mc[orden] <- c(16, 17)
plot(mc, what = "classification", col = col_mc, symbols = sym_mc)
