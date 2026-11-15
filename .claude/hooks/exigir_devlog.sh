#!/bin/bash
# Stop: si hay código del proyecto (.R/.Rnw) con cambios sin commit y más nuevo
# que docs/DEVLOG.md, no deja terminar el turno hasta que el devlog se actualice.
# Se usa git (y no solo fechas) para que un clon recién hecho no dispare el bloqueo.
input=$(cat)
# Evita ciclos: si ya se bloqueó una vez en este turno, deja pasar.
[ "$(echo "$input" | jq -r '.stop_hook_active')" = "true" ] && exit 0

cd "$CLAUDE_PROJECT_DIR" || exit 0
[ -f docs/DEVLOG.md ] || exit 0

cambios=""
for f in $(git status --porcelain -- proyecto 2>/dev/null | awk '{print $NF}' | grep -E '\.(R|Rnw)$'); do
  [ "$f" -nt docs/DEVLOG.md ] && cambios="$cambios $f"
done
[ -z "$cambios" ] && exit 0

jq -n --arg r "Contrato de sesión: cambiaste$cambios pero docs/DEVLOG.md no está al día. Crea o amplía la entrada de hoy ($(date +%F)) con autor, lo hecho y el siguiente paso. Actualiza también docs/ESTADO.md y docs/DECISIONES.md si aplica." \
  '{decision: "block", reason: $r}'
exit 0
