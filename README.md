# Trabajo Final: análisis de clusters de zorros rojos

MAT5519 (10160) Clasificación no Supervisada · Universidad Anáhuac · septiembre–diciembre 2026

Análisis de clusters de 35 zorros rojos machos (`data/Foxes.txt`) con tres medidas: altura hasta los
hombros (F1, cm), longitud del cuerpo (F2, cm) y peso (F3, kg). El enunciado está en
`proyecto/pr_CA.pdf` y el reporte final en **`proyecto/reporte/reporte_zorros.pdf`**.

> **Si eres un agente de código:** lee `CLAUDE.md` (o `AGENTS.md` si no eres Claude Code) antes de nada.

## Dónde vamos

Los cuatro puntos del enunciado están resueltos y el reporte pasó una revisión contra la rúbrica.
Falta la lectura final del equipo y la entrega (fecha por definir). El detalle vivo está en
`docs/ESTADO.md` y la historia en `docs/DEVLOG.md`.

### Resultados en una línea por punto

1. **Exploratorio:** B y U no difieren en altura, pero los U son ~8.4 cm más largos y ~500 g más ligeros.
   Se estandarizan las variables porque, en sus unidades, la longitud domina las distancias.
2. **k-medias (Ward como punto de partida):** k = 2, un grupo de zorros cortos y pesados y otro de
   largos y ligeros, que coincide con el país en 32 de 35 zorros. Las siluetas son bajas para todo k:
   la estructura es moderada.
3. **Mixtura (Mclust, G = 2, modelo EEE):** misma partición que k-medias (ARI = 1). Solo B.8 queda en
   la frontera. El BIC libre prefiere una sola población, y el reporte lo discute.
4. **MDS:** las dos dimensiones concentran el 99.6 % de la variación; Dim1 ≈ longitud y Dim2 ≈ altura.

Las razones de cada elección están en `docs/DECISIONES.md`.

## Estructura

```
CLAUDE.md / AGENTS.md     reglas para agentes (fuente única: CLAUDE.md)
docs/
  ESTADO.md               checklist: qué está hecho y qué falta
  DEVLOG.md               bitácora por sesión (la más reciente arriba)
  DECISIONES.md           decisiones de método y su porqué
proyecto/
  pr_CA.pdf               enunciado
  R/                      código del análisis (fuente única)
    00_setup.R            paquetes, lectura de datos, país, colores, semilla
    01_eda.R              punto 1: exploratorio
    02_kmedias.R          punto 2: dendrogramas, criterios para k, k-medias
    03_mixturas.R         punto 3: Mclust
    04_mds.R              punto 4: escalamiento multidimensional
  reporte/
    reporte_zorros.Rnw    reporte (knitr + LaTeX); carga los scripts con read_chunk
    reporte_zorros.pdf    reporte compilado
data/                     datos del curso (Foxes.txt es el del proyecto)
rcode/                    funciones del profesor (no modificar)
tarea/                    tarea individual ya entregada (no modificar)
Exercises_CA.pdf          enunciado de la tarea
.claude/                  hooks, skills y subagente para Claude Code
```

## Cómo correrlo

Requisitos: R ≥ 4.4 y una distribución de LaTeX (TinyTeX basta).

```r
install.packages(c("mclust", "cluster", "knitr", "tinytex"))   # MASS viene con R
tinytex::install_tinytex()                                     # solo si no tienes LaTeX
```

Desde la raíz del repo:

```bash
# Un punto del análisis (imprime resultados en consola)
Rscript proyecto/R/02_kmedias.R

# Compilar el reporte
cd proyecto/reporte
Rscript -e 'knitr::knit("reporte_zorros.Rnw"); tinytex::latexmk("reporte_zorros.tex", clean = FALSE)'

# Verificar el límite de 8 páginas: el segundo {} es la página donde termina el cuerpo
grep 'newlabel{fin-reporte}' reporte_zorros.aux
```

Para Claude Code, los hooks necesitan además `jq` en el PATH.

## Flujo de trabajo en equipo

1. `git pull`.
2. Lee `docs/ESTADO.md` y la última entrada de `docs/DEVLOG.md`.
3. Trabaja. Cualquier cambio de análisis va en `proyecto/R/` y el reporte lo toma de ahí.
4. Cierra la sesión con `/cierre` en Claude Code, o a mano: entrada en el DEVLOG con tu nombre,
   `ESTADO.md` al día y las decisiones nuevas registradas.
5. Haz commit con tu propia identidad de git y luego `git push`.
