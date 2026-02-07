#!/usr/bin/env bash
set -euo pipefail
# Script qui affiche un éphéméride :
#   lun.12 01:16  󱣖  +3°C(+1°C) ⛅️  ↖10km/h    08:26    17:39    Tatiana 
# avec mise en page.

cache_file="/tmp/wttr_cache"
cache_file_fete="/tmp/fete_cache"
cache_duration=600  # 10 minutes pour la météo

#-----------------------------------------------------------------------------
# mise en forme
spaceafter="   "
space="  "
padd="%14s"
#-----------------------------------------------------------------------------




########################################################################################################
# Fonctions                                                                                            #
########################################################################################################
check_deps() {
    local missing=()
    for cmd in "$@"; do
        if ! command -v "$cmd" &>/dev/null; then
            missing+=("$cmd")
        fi
    done
    if [ ${#missing[@]} -gt 0 ]; then
        echo -n "Manque: ${missing[*]} "
        return 1
    else
        return 0
    fi
}

#-------------------------------------------------------
# shellcheck disable=SC2034
define_default_colors(){
	Noir="\033[0;30m"
	Rouge="\033[0;31m"
	Vert="\033[0;32m"
	Jaune="\033[0;33m"
	Bleu="\033[0;34m"
	Violet="\033[0;35m"
	Cyan="\033[0;36m"
	Blanc="\033[0;37m"
	Reset="\033[0m"
	#
	iconcolor="$Bleu"
	return 0
}

#-------------------------------------------------------
define_icons(){
	heure_icon=""
	weather_icon=""
	sunrise_icon=""
	sunset_icon=""
	fete_icon=""
	return 0
}


#-------------------------------------------------------
# shellcheck disable=SC2059
display(){
	local heure_str weather_str sun_str fete_str

	# Padde les valeurs à une largeur fixe
	[ -n "$heure" ] && heure=$(printf "$padd" "$heure")
	
    # création des chaines colorées et mise en page à afficher
	[ -n "$heure" ] && heure_str="${iconcolor}${heure_icon}${Reset}$heure${spaceafter}" || heure_str=""
    [ -n "$weather" ] && weather_str="${iconcolor}${weather_icon}${Reset}${space}${weather}${spaceafter}" || weather_str=""
    sun_str="${iconcolor}${sunrise_icon}${Reset}${space}${sunrise}${spaceafter}${iconcolor}${sunset_icon}${Reset}${space}${sunset}${spaceafter}"
	[ -n "$fete" ] && fete_str="${iconcolor}${fete_icon}${Reset}${space}${fete}${spaceafter}" || fete_str=""

	# affichage
	echo -e "${heure_str}${weather_str}${sun_str}${fete_str}"
	return 0
}
#-------------------------------------------------------


########################################################################################################
# Corps du script                                                                                      #
########################################################################################################
#check_deps "date" "curl" "printf"

#---Heure
heure="$(date '+%a%e %H:%M')" # ex: 'mer. 7 20:34'

# météo
city="${1:-Cugnaux}"
if [[ ! -f "$cache_file" ]] || (( $(date +%s) - $(stat -c %Y "$cache_file") > cache_duration )); then
    if ! curl -sf --max-time 5 "wttr.in/${city}?format=%t(%f)+%c+%w|%S|%s" > "$cache_file.tmp"; then
        rm -f "$cache_file.tmp" 2>/dev/null
    else
        mv "$cache_file.tmp" "$cache_file" 2>/dev/null
    fi
fi
raw=$(cat "$cache_file" 2>/dev/null || echo "N/A|N/A|N/A")
weather=$(echo "$raw" | cut -d'|' -f1)
sunrise=$(echo "$raw" | cut -d'|' -f2)
sunset=$(echo "$raw" | cut -d'|' -f3)
sunrise="${sunrise%:*}" # on enlève les secondes
sunset="${sunset%:*}"   # idem

# Fête
today_midnight=$(date -d "00:00:00" +%s)
if [[ ! -f "$cache_file_fete" ]] || (( $(stat -c %Y "$cache_file_fete") < today_midnight )); then
    if curl -s "https://fetedujour.fr" | grep -n 'Fête du jour :' | tail -1 | cut -d: -f2- | cut -d'>' -f4 | cut -d'<' -f1 | sed 's/^ *//' > "$cache_file_fete.tmp"; then
        mv "$cache_file_fete.tmp" "$cache_file_fete" 2>/dev/null
    else
        rm -f "$cache_file_fete.tmp" 2>/dev/null
    fi
fi
fete=$(cat "$cache_file_fete" 2>/dev/null || echo "N/A")

#----------------
define_default_colors
define_icons
display
#----------------
