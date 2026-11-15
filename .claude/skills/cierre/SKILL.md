---
name: cierre
description: Cierre de sesión de trabajo del proyecto de zorros. Actualiza docs/DEVLOG.md, docs/ESTADO.md y docs/DECISIONES.md y propone un mensaje de commit. Usar cuando la persona diga /cierre, "cerremos", "terminamos por hoy" o similar.
---

# Cierre de sesión

Sigue estos pasos en orden. Todo en español.

## 1. Reunir lo que pasó
- Autor: `git config user.name` (si no está configurado, pregunta el nombre a la persona).
- `git status --short` y `git diff --stat` (si aún no hay commits, `git status` basta).
- Lo hecho en la conversación: scripts creados o cambiados, resultados numéricos clave (k, tamaños, BIC, ARI, % de variación del MDS…) y decisiones tomadas.

## 2. `docs/DEVLOG.md`
Si ya hay entrada de hoy para esta sesión, complétala; si no, créala **arriba** de las demás (debajo del encabezado):

```
## AAAA-MM-DD — Sesión N: <tema corto>

**Autor:** <nombre de la persona> (con <agente>)

**Objetivo:** <qué se buscaba>

**Hecho:**
- <acciones concretas, con archivos>

**Resultados clave:** <números y hallazgos que irán al reporte>

**Pendiente / bloqueos:** <lo que quedó a medias o dudas para el profe>

**Siguiente paso:** <una acción concreta para la próxima sesión>
```

N es la sesión anterior + 1 (numeración global del equipo, no por persona). Haz `git pull` antes para no repetir un número. Solo hechos verificados: si algo no se corrió o falló, dilo.

## 3. `docs/ESTADO.md`
- Cambia las marcas (⬜ → 🟨 → ✅) según lo que realmente quedó hecho y verificado.
- Agrega tareas nuevas que hayan surgido; no borres las existentes.
- Actualiza la fecha de "Última actualización".

## 4. `docs/DECISIONES.md`
Agrega al final las decisiones de método de la sesión que aún no estén registradas (`- AAAA-MM-DD — decisión. porqué.`).

## 5. Commit propuesto
Muestra a la persona:
- Resumen de 3–5 líneas de la sesión.
- Mensaje de commit propuesto en español (`tipo: resumen` + viñetas).

**No hagas commit** salvo que la persona lo confirme explícitamente. Si lo confirma: `git pull --rebase`, commit y `git push`. Si no hay `user.name`/`user.email` configurados en git, avísale en vez de intentarlo.
