---
name: analisis-zorros
description: Requisitos y convenciones del proyecto final de clasificación no supervisada con Foxes.txt (EDA, dendrograma, k-medias, mixturas con Mclust, MDS). Usar antes de escribir o modificar cualquier script de proyecto/R/ o sección de análisis del reporte.
---

# Análisis de los zorros: qué pide cada punto

Enunciado: `proyecto/pr_CA.pdf`. Datos: `data/Foxes.txt` (35 zorros: 20 `B.*`, 15 `U.*`).
Variables: F1 altura hasta los hombros (cm), F2 longitud del cuerpo (cm), F3 peso (kg).
El lector del reporte es un **experto en zorros con estadística básica**: explica la intuición, no la teoría.

## Convenciones de código
- Un script por punto: `01_eda.R`, `02_kmedias.R`, `03_mixturas.R`, `04_mds.R`.
- Cada script empieza con `source("proyecto/R/00_setup.R")` y debe correr solo desde la raíz:
  `Rscript proyecto/R/0X_*.R`. Verifícalo después de cada cambio.
- Divide cada script en chunks con `## ---- etiqueta ----` (prefijo por punto: `eda_`, `km_`, `mc_`, `mds_`).
  El `.Rnw` los usa por etiqueta, así que **no renombres etiquetas** sin actualizar el reporte.
- Los objetos que usa el texto del reporte (`\Sexpr{}`) deben tener nombres claros y estables.
- Objetos de `00_setup.R`: `X` (data frame con F1–F3, rownames = id), `pais` (factor B/U),
  `col_pais` (vector de colores por zorro), `vars` (nombres largos de las variables).
- Las etiquetas U/B **no entran a ningún ajuste**: solo sirven para colorear e interpretar.
- Gráficas en R base o ggplot2; sin títulos que repitan el caption; ejes con unidades.
- Paquetes disponibles: mclust, MASS, cluster, factoextra, ggplot2. Funciones del profesor en `rcode/`.

## Punto 1: Exploratorio
- Responder **por qué `header = TRUE`** (verificado en R el 2026-11-15): la primera línea tiene los nombres
  F1–F3 (3 campos) y las demás 4 campos (id + 3 medidas). Con `header = TRUE` los nombres se usan como
  encabezados y la columna sobrante (id) como rownames. Con `header = FALSE` explícito falla:
  `line 1 did not have 4 elements`. Si se omite el argumento, `read.table` lo **detecta solo** justo por
  ese campo de menos, así que declararlo es lo correcto y explícito, no un requisito absoluto. No afirmar otra cosa.
- Resumen por variable, global y por país; histogramas o densidades; `pairs` coloreado por país; cajas por país.
- Discutir las escalas (cm contra kg y sus varianzas) para decidir si se escala → `DECISIONES.md`.

## Punto 2: Jerárquico → k-medias
- Dendrogramas con al menos simple, completo, promedio y Ward; **justificar el enlace elegido**
  (el simple encadena; Ward y el completo dan grupos compactos).
- Elegir k con varios criterios: salto en el dendrograma, codo de TWSS, silueta promedio.
- `kmeans(X, k, nstart = 100)` tras `set.seed()`. Reportar tamaños, **vectores de medias**
  (en unidades originales aunque se haya escalado) y BSS/TSS.
- Justificar k "como investigador": ¿los grupos corresponden a U/B? Tabla cruzada con `pais`.

## Punto 3: Mixtura de densidades
- `Mclust(X, G = k)`: modelo elegido por BIC y su significado (volumen/forma/orientación).
- Reportar **medias** (`$parameters$mean`), **ponderadores π** (`$parameters$pro`) y
  **matrices de covarianza** (`$parameters$variance$sigma`).
- Comparar con k-medias: tabla cruzada, `adjustedRandIndex`, zorros con alta incertidumbre (`$uncertainty`).
- Comentar las diferencias de método: asignación dura contra probabilística y grupos esféricos contra elípticos.

## Punto 4: MDS
- `Delta <- dist(X)` sobre los **datos originales** (sin escalar, como pide el enunciado).
- `mds <- cmdscale(Delta, k = 2, eig = TRUE)`.
- Proporción de variación: `sum(abs(eig[1:2])) / sum(abs(eig))` y también `sum(eig[1:2]) / sum(eig[eig > 0])`.
  Con distancia euclidiana todos los eigenvalores son ≥ 0, así que deben coincidir.
- Gráfica: `plot(mds$points, pch = substr(rownames(X), 1, 1), xlab = bquote(Dim[1]), ylab = bquote(Dim[2]), las = 1)`.
  Ojo: `pch = rownames(X)` usa el primer carácter, y es lo que sugiere el enunciado.
- Interpretar qué variable domina cada dimensión (la que tenga más varianza dominará sin escalar).

## Al terminar un punto
Marca `docs/ESTADO.md`, registra las decisiones y anota en el devlog los números clave.
