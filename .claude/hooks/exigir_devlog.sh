#!/bin/bash
# Stop: si hay código del proyecto (.R/.Rnw) más nuevo que docs/DEVLOG.md,
# no deja terminar el turno hasta que el devlog se actualice.
input=$(cat)
# Evita ciclos: si ya se bloqueó una vez en este turno, deja pasar.
[ "$(echo "$input" | jq -r '.stop_hook_active')" = "true" ] && exit 0

cd "$CLAUDE_PROJECT_DIR" || exit 0
[ -f docs/DEVLOG.md ] || exit 0

cambios=$(find proyecto \( -name '*.R' -o -name '*.Rnw' \) -newer docs/DEVLOG.md 2>/dev/null)
[ -z "$cambios" ] && exit 0

lista=$(echo "$cambios" | tr '\n' ' ')
jq -n --arg r "Contrato de sesión: cambiaste $lista pero docs/DEVLOG.md no está al día. Crea o amplía la entrada de hoy ($(date +%F)) con lo hecho y el siguiente paso. Actualiza también docs/ESTADO.md y docs/DECISIONES.md si aplica." \
  '{decision: "block", reason: $r}'
exit 0
