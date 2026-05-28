#!/usr/bin/env bash
set -euo pipefail

RPROFILE_SITE="${RPROFILE_SITE:-/etc/R/Rprofile.site}"
RENviron_SITE="${RENviron_SITE:-/etc/R/Renviron.site}"
RESTART_RSTUDIO="${RESTART_RSTUDIO:-1}"

remove_line() {
  local file="$1"
  local pattern="$2"

  if [[ ! -f "$file" ]]; then
    echo "Arquivo nao encontrado: $file"
    return 0
  fi

  if ! grep -Eq "$pattern" "$file"; then
    echo "Nada para alterar em: $file"
    return 0
  fi

  cp "$file" "${file}.bak.$(date +%Y%m%d%H%M%S)"
  sed -Ei "/$pattern/d" "$file"
  echo "Linha removida de: $file"
}

remove_line "$RPROFILE_SITE" '^[[:space:]]*Sys\.setenv\(RETICULATE_PYTHON[[:space:]]*='
remove_line "$RENviron_SITE" '^[[:space:]]*RETICULATE_PYTHON[[:space:]]*='

if [[ "$RESTART_RSTUDIO" == "1" ]] && command -v systemctl >/dev/null 2>&1; then
  if systemctl list-unit-files | grep -q '^rstudio-server\.service'; then
    systemctl restart rstudio-server
    echo "Servico reiniciado: rstudio-server"
  fi
fi
