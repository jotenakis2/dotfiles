#!/usr/bin/env bash

# Check erreurs systemd et journalctl critique

# Couleurs pour l'affichage
RED='\033[0;31m'
YELLOW='\033[1;33m'
GRAY='\e[0;30m'
NC='\033[0m' # No Color
file="$HOME/.cache/current_errors"
known_errors="$HOME/.cache/std_errors"

# Récupérer les unités en échec (colonne 1, on vire le ● si présent)
failed_units=$(systemctl --failed --no-legend --no-pager | awk '{print $1}' | sed 's/^●//')

# Compter le nombre d'unités en échec
count=$(echo "$failed_units" | grep -vc '^$')

# Récupérer les erreurs du boot actuel et dédupliquer
journalctl -b 0 -p err --no-pager -q 2>&1 | awk '!seen[substr($0, index($0, $4))]++' >"$file"

# Normaliser : extraire message seul, virer PIDs/numéros/IPs/coordonnées
normalize() {
  sed -E 's/^[a-zéû.]+ [0-9]+ [0-9:]+ [^ ]+ //; s/\[[0-9]+\]//g; s/\([0-9]+\)//g; s/ -?[0-9]+\)/)/g; s/\[.*x[0-9]+.*\]/[...]/g'
}

# Compter uniquement les lignes avec date (nouvelles erreurs uniques)
current_normalized=$(normalize <"$file")
known_normalized=$(normalize <"$known_errors")

# Matcher ligne par ligne en ignorant les lignes connues
new_errors=""
while IFS= read -r line; do
  # Ne garder que les lignes avec un pattern "service:" ou "kernel:" (accepte . dans le nom)
  if [[ "$line" =~ ^[a-z._-]+[0-9]*[:\[] ]]; then
    if ! echo "$known_normalized" | grep -Fxq "$line"; then
      new_errors+="$line"$'\n'
    fi
  fi
done <<<"$current_normalized"

boot_errors=$(echo "$new_errors" | grep -vc '^$')

# Affichage des unités en échec
if [ "$count" -gt 0 ]; then
  echo -e "${RED}⚠ ALERTE : $count unité(s) systemd en échec${NC}"
  echo -e "${YELLOW}Unités concernées :${NC}"
  echo "$failed_units" | while read -r unit; do
    [ -n "$unit" ] && echo -e "  ${RED}●${NC} $unit"
  done
  echo ""
  exit_code=1
else
  echo -e "${GRAY}✓ Aucune unité systemd en échec${NC}"
  exit_code=0
fi

# Affichage des erreurs de boot nouvelles
if [ "$boot_errors" -gt 0 ]; then
  echo -e "${RED}⚠ $boot_errors erreur(s) nouvelle(s) détectée(s) - voir $file ${NC}"
  echo -e "${YELLOW}Nouvelles erreurs :${NC}"
  echo "$new_errors" | head -n 10 | sed 's/^/  /'
  exit_code=1
else
  echo -e "${GRAY}✓ Aucune nouvelle erreur détectée${NC}"
  echo
fi

exit "$exit_code"
