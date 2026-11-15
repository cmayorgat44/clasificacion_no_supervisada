#!/bin/bash
# PostToolUse (Edit|Write): revisa que los .R y .Rnw editados se puedan parsear.
# Con exit 2 el error regresa a Claude para que lo corrija.
f=$(jq -r '.tool_input.file_path // empty')
[ -f "$f" ] || exit 0

case "$f" in
  *.R)
    out=$(Rscript -e 'invisible(parse(commandArgs(TRUE)[1]))' "$f" 2>&1) ;;
  *.Rnw)
    # Extrae el código entre "<<...>>=" y "@" y lo parsea (sin evaluar nada).
    out=$(Rscript -e 'l <- readLines(commandArgs(TRUE)[1]); dentro <- FALSE; cod <- character()
      for (x in l) { if (grepl("^<<.*>>=", x)) dentro <- TRUE else if (grepl("^@", x)) dentro <- FALSE else if (dentro) cod <- c(cod, x) }
      invisible(parse(text = cod))' "$f" 2>&1) ;;
  *)
    exit 0 ;;
esac

if [ $? -ne 0 ]; then
  echo "Error de sintaxis de R en $f:" >&2
  echo "$out" >&2
  exit 2
fi
exit 0
