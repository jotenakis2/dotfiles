#!/usr/bin/env bash

export LC_NUMERIC=C

#--- Définition des couleurs ----------------------------------------------------------------------------------------------------------
# shellcheck disable=SC2034
define_colors() {
  Noir="\e[0;30m"
  Rouge="\e[0;31m"
  Vert="\e[0;32m"
  Jaune="\e[0;33m"
  Bleu="\e[0;34m"
  Violet="\e[0;35m"
  Cyan="\e[0;36m"
  Blanc="\e[0;37m"
  Reset="\033[0m"

  NoirGum=0
  RougeGum=1
  VertGum=2
  JauneGum=3
  BleuGum=4
  VioletGum=5
  CyanGum=6
  BlancGum=7

  export GUM_CONFIRM_SELECTED_BACKGROUND=$VertGum
  export GUM_CONFIRM_SELECTED_FOREGROUND=$NoirGum
  export GUM_CONFIRM_UNSELECTED_BACKGROUND=$NoirGum
  export GUM_CONFIRM_UNSELECTED_FOREGROUND=$BlancGum
  export GUM_CONFIRM_SHOW_HELP=false
  export GUM_CHOOSE_SHOW_HELP=false
  export GUM_INPUT_SHOW_HELP=false
}

#--- Fonctions communes -------------------------------------------------------------------------------------------------------------------

################################################
cleanup_ram() {
  pkill -f "stress-ng --vm" 2>/dev/null
  wait 2>/dev/null
}

################################################
cleanup_cpu() {
  pkill yes 2>/dev/null
  wait 2>/dev/null
}

################################################
cancel_prompt() {
  gum style --foreground $RougeGum --bold "Annulé par l'utilisateur"
  exit 0
}

#--- Fonctions RAM ------------------------------------------------------------------------------------------------------------------------

################################################
get_mem_info() {
  total_mem=$(awk '/^MemTotal:/{printf "%.0f", $2/1024/1024}' /proc/meminfo)
  swap_total=$(awk '/^SwapTotal:/{printf "%.0f", $2/1024/1024}' /proc/meminfo)
  base_mem=$(awk '/^MemTotal:|^MemAvailable:/{a[$1]=$2} END {printf "%.0f", (a["MemTotal:"]-a["MemAvailable:"])/1024/1024}' /proc/meminfo)
  base_mem_percent=$(( base_mem * 100 / total_mem ))
}

################################################
get_swap_usage() {
  local swap_free
  swap_free=$(awk '/^SwapFree:/{printf "%.0f", $2/1024/1024}' /proc/meminfo)
  swap_used=$(( swap_total - swap_free ))
  swap_used_percent=$(awk -v used="$swap_used" -v total="$swap_total" 'BEGIN {if(total>0) printf "%.0f", (used*100/total); else print "0"}')
}

################################################
get_zswap_info() {
  zswap=$(awk '/^Zswap:/{printf "%.2f", $2/1024/1024}' /proc/meminfo)
  zswapped=$(awk '/^Zswapped:/{printf "%.2f", $2/1024/1024}' /proc/meminfo)
}

################################################
get_current_ram() {
  current_used=$(awk '/^MemTotal:|^MemAvailable:/{a[$1]=$2} END {printf "%.0f", (a["MemTotal:"]-a["MemAvailable:"])/1024/1024}' /proc/meminfo)
  current_percent=$(( current_used * 100 / total_mem ))
}

################################################
get_color_for_percent() {
  local percent=$1
  if [[ $percent -le 80 ]]; then
    echo "$Vert"
  elif [[ $percent -le 120 ]]; then
    echo "$Jaune"
  else
    echo "$Rouge"
  fi
}

################################################
display_header_ram() {
  gum style --foreground $CyanGum "Paliers             : $(gum style --foreground $VertGum --bold "$nb_stage")"
  gum style --foreground $CyanGum "RAM totale          : $(gum style --foreground $VertGum --bold "${total_mem}Go")"
  gum style --foreground $CyanGum "RAM utilisée        : $(gum style --foreground $JauneGum --bold "${base_mem}Go") $(gum style --foreground $BleuGum "(${base_mem_percent}%)")"
  gum style --foreground $CyanGum "Swap total          : $(gum style --foreground $BleuGum --bold "${swap_total}Go")"
  gum style --foreground $CyanGum "Swap utilisé        : $(gum style --foreground $BleuGum --bold "${swap_used}Go (${swap_used_percent}%)")"
  gum style --foreground $CyanGum "Zswap               : $(gum style --foreground $BleuGum --bold "${zswap}Go")"
  gum style --foreground $CyanGum "Zswapped            : $(gum style --foreground $BleuGum --bold "${zswapped}Go")"
  echo
  gum style --foreground $BleuGum --bold "Cycle progressif vers ${maxramstress}% RAM = ${max_target}Go (paliers de ${increment}%)"
  echo
}

################################################
display_table_header_ram() {
  printf "\n${Cyan}%-7s %-14s %-21s %-14s %-21s %-15s %-18s${Reset}\n" \
    "Target" "Target(Go)" "RAM Used" "Stress(Go)" "Swap Used" "Zswap(Go)" "Zswapped(Go)"
  echo "───────────────────────────────────────────────────────────────────────────────────────────────────────────"
}

################################################
apply_stress_ram() {
  local stress_gb=$1

  pkill -f "stress-ng --vm" 2>/dev/null
  sleep 0.2

  if [[ $stress_gb -gt 0 ]]; then
    stress-ng --vm 1 --vm-bytes "${stress_gb}G" --vm-keep &>/dev/null &
  fi

  sleep 5
}

################################################
display_metrics_ram() {
  local percent=$1
  local target_usage=$2
  local stress_gb=$3
  local color=$4

  printf "${color}%-7s${Reset} %-14s %-11s${Bleu}%-10s${Reset} %-14s %-11s${Bleu}%-10s${Reset} %-15s %-18s\n" \
    "${percent}%" \
    "${target_usage}Go" \
    "${current_used}Go" \
    "(${current_percent}%)" \
    "${stress_gb}Go" \
    "${swap_used}Go" \
    "(${swap_used_percent}%)" \
    "${zswap}Go" \
    "${zswapped}Go"

  sleep 3
}

################################################
run_stress_phase_ram() {
  local start=$1
  local end=$2
  local step=$3

  for percent in $(seq "$start" "$step" "$end"); do
    local target_usage=$(( total_mem * percent / 100 ))
    local stress_gb=$(( target_usage - base_mem ))
    [[ $stress_gb -lt 0 ]] && stress_gb=0

    apply_stress_ram "$stress_gb"

    get_current_ram
    get_swap_usage
    get_zswap_info

    local color
    color=$(get_color_for_percent "$percent")
    display_metrics_ram "$percent" "$target_usage" "$stress_gb" "$color"
  done
}

#--- Fonctions CPU ------------------------------------------------------------------------------------------------------------------------

################################################
display_header_cpu() {
  gum style --foreground $CyanGum "Paliers             : $(gum style --foreground $VertGum --bold "$nb_stage_cpu")"
  gum style --foreground $CyanGum "Cores totaux        : $(gum style --foreground $VertGum --bold "$ncores")"
  echo
  gum style --foreground $BleuGum --bold "Cycle progressif de 0% à 100% CPU (paliers de ${increment_cpu}%)"
  echo
}

################################################
display_table_header_cpu() {
  printf "\n${Cyan}%-10s %-20s${Reset}\n" "Target" "Cores actifs"
  echo "────────────────────────────────────────"
}

################################################
display_metrics_cpu() {
  local percent=$1
  local active_cores=$2
  local color=$3

  printf "${color}%-10s${Reset} %-20s\n" \
    "${percent}%" \
    "${active_cores}/${ncores}"

  sleep 5
}

################################################
run_stress_phase_cpu() {
  local start=$1
  local end=$2
  local step=$3

  for percent in $(seq "$start" "$step" "$end"); do
    local active_cores=$(( ncores * percent / 100 ))
    [[ $active_cores -eq 0 && $percent -gt 0 ]] && active_cores=1

    pkill yes 2>/dev/null
    sleep 0.1

    for ((i=0; i<active_cores; i++)); do
      yes > /dev/null &
    done

    local color
    color=$(get_color_for_percent "$percent")
    display_metrics_cpu "$percent" "$active_cores" "$color"
  done
}

#--- Benchmark RAM ------------------------------------------------------------------------------------------------------------------------

benchmark_ram() {
  trap cancel_prompt INT
  cleanup_ram
  sleep 1

  gum style \
    --border double \
    --border-foreground $BleuGum \
    --padding "0 4" \
    --margin "1 0" \
    --align center \
    "$(gum style --foreground $VertGum --bold '󱐋 Stress RAM')"

  gum style --foreground $CyanGum "RAM stress maximum en % de la RAM totale (100% = RAM totale, 200% = RAM+swap)"
  maxramstress=$(gum input --cursor.foreground=$BleuGum --placeholder "Ex: 200, 250" --prompt "➜ RAM stress max (%) : " --value "250")
  maxramstress=${maxramstress:-250}

  echo
  gum style --foreground $CyanGum "Nombre de paliers pour monter progressivement de 0% à ${maxramstress}%"
  nb_stage=$(gum input --cursor.foreground=$BleuGum --placeholder "Ex: 5, 10, 20" --prompt "➜ Nombre de paliers : " --value "10")
  nb_stage=${nb_stage:-10}

  echo
  gum style --foreground $CyanGum "Nombre de fois que le cycle montée/descente sera répété"
  nb_cycles=$(gum input --cursor.foreground=$BleuGum --placeholder "Ex: 1, 3, 5" --prompt "➜ Nombre de cycles : " --value "1")
  nb_cycles=${nb_cycles:-1}

  echo
  gum style --foreground $VertGum "✓ RAM stress max : ${maxramstress}%"
  gum style --foreground $VertGum "✓ Paliers        : ${nb_stage}"
  gum style --foreground $VertGum "✓ Cycles         : ${nb_cycles}"
  echo

  get_mem_info
  get_swap_usage
  get_zswap_info

  max_target=$(( total_mem * maxramstress / 100 ))
  increment=$(( maxramstress / nb_stage ))

  display_header_ram

  if ! gum confirm "Lancer le stress ?"; then
    gum style --foreground $RougeGum "Annulé"
    return
  fi

  trap cleanup_ram EXIT INT TERM

  gum spin --spinner dot --title "Démarrage du stress..." -- sleep 2

  display_table_header_ram

  for cycle in $(seq 1 "$nb_cycles"); do
    if [[ $nb_cycles -gt 1 ]]; then
      gum style --foreground $CyanGum --bold "=== Cycle $cycle/$nb_cycles - Montée ==="
    fi

    run_stress_phase_ram 0 "$maxramstress" "$increment"

    if [[ $nb_cycles -gt 1 ]]; then
      gum style --foreground $CyanGum --bold "=== Cycle $cycle/$nb_cycles - Descente ==="
    fi

    run_stress_phase_ram "$maxramstress" 0 "-$increment"
  done

  cleanup_ram
  echo
  gum style --foreground $VertGum --bold "✓ Terminé, appuyer sur ENTRÉE pour revenir au menu..."
  read -r
}

#--- Benchmark CPU ------------------------------------------------------------------------------------------------------------------------

benchmark_cpu() {
  trap cancel_prompt INT
  cleanup_cpu
  sleep 1

  ncores=$(nproc)

  gum style \
    --border double \
    --border-foreground $BleuGum \
    --padding "0 4" \
    --margin "1 0" \
    --align center \
    "$(gum style --foreground $VertGum --bold ' Stress CPU')"

  gum style --foreground $CyanGum "Nombre de paliers pour monter progressivement de 0% à 100%"
  nb_stage_cpu=$(gum input --cursor.foreground=$BleuGum --placeholder "Ex: 5, 10, 20" --prompt "➜ Nombre de paliers : " --value "10")
  nb_stage_cpu=${nb_stage_cpu:-10}

  echo
  gum style --foreground $CyanGum "Nombre de fois que le cycle montée/descente sera répété"
  nb_cycles_cpu=$(gum input --cursor.foreground=$BleuGum --placeholder "Ex: 1, 3, 5" --prompt "➜ Nombre de cycles : " --value "1")
  nb_cycles_cpu=${nb_cycles_cpu:-1}

  echo
  gum style --foreground $VertGum "✓ Paliers : ${nb_stage_cpu}"
  gum style --foreground $VertGum "✓ Cycles  : ${nb_cycles_cpu}"
  echo

  increment_cpu=$(( 100 / nb_stage_cpu ))

  display_header_cpu

  if ! gum confirm "Lancer le stress ?"; then
    gum style --foreground $RougeGum "Annulé"
    return
  fi

  trap cleanup_cpu EXIT INT TERM

  gum spin --spinner dot --title "Démarrage du stress..." -- sleep 2

  display_table_header_cpu

  for cycle in $(seq 1 "$nb_cycles_cpu"); do
    if [[ $nb_cycles_cpu -gt 1 ]]; then
      gum style --foreground $CyanGum --bold "=== Cycle $cycle/$nb_cycles_cpu - Montée ==="
    fi

    run_stress_phase_cpu 0 100 "$increment_cpu"

    if [[ $nb_cycles_cpu -gt 1 ]]; then
      gum style --foreground $CyanGum --bold "=== Cycle $cycle/$nb_cycles_cpu - Descente ==="
    fi

    run_stress_phase_cpu 100 0 "-$increment_cpu"
  done

  cleanup_cpu
  echo
  gum style --foreground $VertGum --bold "✓ Terminé, appuyer sur ENTRÉE pour revenir au menu..."
  read -r
}

#--- Menu principal -----------------------------------------------------------------------------------------------------------------------

main_menu() {
  while true; do
    clear
    gum style \
      --border double \
      --border-foreground $BleuGum \
      --padding "0 4" \
      --margin "1 0" \
      --align center \
      "$(gum style --foreground $VertGum --bold '⚡ Stress System')"

    local choice
    choice=$(gum choose --cursor.foreground=$BleuGum --header \
      "$(gum style --foreground $VertGum --bold '󰍜 Menu principal') $(gum style --foreground $NoirGum '(󰹺 naviguer • ⏎ valider • 󱊷 quitter)')" \
      "  Stress RAM" \
      "  Stress CPU" \
      "󰩈 Quitter") || break

    case "${choice}" in
      "  Stress RAM") benchmark_ram ;;
      "  Stress CPU") benchmark_cpu ;;
      "󰩈 Quitter") break ;;
    esac
  done
}

#--- Corps du script ----------------------------------------------------------------------------------------------------------------------

if ! command -v gum &> /dev/null; then
  echo -e "${Rouge}Erreur: gum n'est pas installé${Reset}"
  exit 1
fi
if ! command -v stress-ng &> /dev/null; then
  echo -e "${Rouge}Erreur: stress-ng n'est pas installé${Reset}"
  exit 1
fi

define_colors
main_menu
gum style --foreground $VertGum --bold "Au revoir !"
