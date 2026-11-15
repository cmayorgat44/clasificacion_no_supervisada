---
name: compilar-reporte
description: Compila proyecto/reporte/reporte_zorros.Rnw a PDF con knitr + TinyTeX y verifica las reglas de entrega (máximo 8 páginas sin apéndice, sin código en el cuerpo, carta, 11 pt). Usar cuando se pida compilar, generar o revisar el PDF del reporte.
---

# Compilar el reporte

`pdflatex` **no** está en el PATH; TinyTeX está en `~/Library/TinyTeX` y `tinytex::latexmk()` lo encuentra solo.

## 1. Compilar
Desde la raíz del repo:
```bash
cd proyecto/reporte && Rscript -e 'knitr::knit("reporte_zorros.Rnw"); tinytex::latexmk("reporte_zorros.tex", clean = FALSE)'
```
Si falla, lee el error de knitr (chunk y línea) o `reporte_zorros.log` y corrige en el script de `proyecto/R/`
o en el `.Rnw`, no en el `.tex`.

## 2. Verificar
```bash
cd proyecto/reporte
pdfinfo reporte_zorros.pdf | grep -E 'Pages|Page size'      # carta = 612 x 792 pts
grep 'newlabel{fin-reporte}' reporte_zorros.aux             # el 2.º {} es la página donde acaba el cuerpo
```
- **Páginas del cuerpo ≤ 8** (la etiqueta `fin-reporte` está justo antes del apéndice). Si se pasa, propone qué recortar.
- **Sin código en el cuerpo**: en el `.Rnw`, todo chunk antes de `\label{fin-reporte}` debe tener `echo=FALSE`
  (o heredar el default del setup) y no imprimir salida de consola (`results='hide'` o `include=FALSE`,
  salvo tablas formateadas con `kable`/`xtable`).
- Cada figura del cuerpo tiene caption y se menciona en el texto (`\ref{fig:...}`).

## 3. Reportar
Di cuántas páginas tiene el cuerpo y cuántas el total, y lista los warnings relevantes (referencias indefinidas, overfull grandes).
Para una revisión de contenido, sugiere el subagente `revisor-reporte`.
