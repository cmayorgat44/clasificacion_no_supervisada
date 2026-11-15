# Estado del proyecto final (zorros)

Leyenda: ⬜ pendiente · 🟨 en progreso · ✅ hecho
Última actualización: 2026-11-15

## Infraestructura
- ✅ Repo git, `CLAUDE.md`, hooks, skills y subagente revisor
- ✅ `proyecto/R/00_setup.R` (lectura de datos, paquetes, semilla, colores U/B)
- ✅ Remoto en GitHub (`cmayorgat44/clasificacion_no_supervisada`, rama `main`)
- ✅ README, AGENTS.md y CLAUDE.md preparados para que el equipo continúe

## 1. Análisis exploratorio (`R/01_eda.R`)
- ✅ Responder: ¿por qué hace falta `header = TRUE`? (verificado en R)
- ✅ Resumen numérico de F1–F3 (global y por país) + pruebas t
- ✅ Histogramas (diagonal del `pairs`)
- ✅ Diagramas de dispersión por pares (color y letra U/B)
- ✅ Cajas y bigotes por país
- ✅ Decidir si se escalan las variables → se estandarizan

## 2. Jerárquico + k-medias (`R/02_kmedias.R`)
- ✅ Dendrogramas simple/completo/promedio/Ward; Ward elegido y justificado
- ✅ Criterios para k (TWSS y silueta); k = 3 analizado como alternativa
- ✅ k-medias k = 2 con `nstart = 100`; tamaños, vectores de medias, BSS/TSS
- ✅ Justificación de k = 2 "como investigador" (32/35 coinciden con el país)

## 3. Mixtura de densidades (`R/03_mixturas.R`)
- ✅ `Mclust` G = 2: modelo EEE; BIC libre prefiere G = 1 (se discute)
- ✅ Vectores de medias, ponderadores π y matriz de covarianza común
- ✅ Comparación con k-medias (ARI = 1; B.8 con incertidumbre 0.49)

## 4. Escalamiento multidimensional (`R/04_mds.R`)
- ✅ Matriz Δ euclidiana de los datos originales
- ✅ `cmdscale` con k = 2, gráfica con `pch = rownames(X)`
- ✅ Proporción de variación: 99.6 % (Dim1 84.2 %, Dim2 15.4 %)

## Reporte (`reporte/reporte_zorros.Rnw`)
- ✅ Redacción de todas las secciones para un experto en zorros
- ✅ 6 figuras y 3 tablas, todas citadas en el texto
- ✅ Cuerpo de 8 páginas carta (justo el límite), 11 pt, sin código (verificado con el .aux y pdftotext)
- ✅ Apéndice con código y salida de consola (vía `ref.label`)
- ⬜ Lectura final y visto bueno del equipo
- ✅ Revisión con el subagente `revisor-reporte` ("casi listo") y correcciones aplicadas

## Entrega
- 🟨 PDF final: `proyecto/reporte/reporte_zorros.pdf` (pendiente de visto bueno)
- ⬜ Envío a jacob.cancino@anahuac.mx (fecha por confirmar)

## Pendientes del equipo
- ⬜ Dar acceso al repo a los compañeros (colaboradores en GitHub)
- ⬜ Agregar los nombres e IDs de los integrantes en la portada y el encabezado del reporte (hoy solo aparece Carlos)

## Bloqueos / dudas para el profe
- La fecha de entrega aún no se define.
- Opcional: confirmar si espera escalar las variables antes de k-medias (aquí se justifica hacerlo).
