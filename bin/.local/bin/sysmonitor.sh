#!/usr/bin/env bash
set -euo pipefail
# Script qui affiche
#      0%  󱇯   5%    37%    47°C  󰂀  70%     0Mo/s     0Mo/s    dim.11 00:01  󰤮
# avec mise en page, icônes variables et couleurs variables en fct des valeurs.


#-----------------------------------------------------------------------------
# dossier de recherche
datadir="/home/mbanjieu/.local/bin"
# filtre de la commande sensors, pour affichage d une température
FiltreSensor="WiFi/BT Module Temp:"
# filtre pour chercher le device de la batterie
FiltreBatt="batt"
# mise en forme
spaceafter="  "
padd="%5s"
#paddnet="%6d"
seuilcpu=90    # %
seuilmem=90    # %
seuilswap=80   # %
seuilload=150  # %
seuilnet=1024  # ko/s
seuilsensor=55 #°C
seuilbatt=20   # %
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
	cpu_icon=""
	load_icon="󱇯"
	mem_icon=""
	swap_icon=""
	sensors_icon=""
	tx_icon=""
	rx_icon=""
	icon100="󰁹"
	icon090="󰂂"
	icon080="󰂁"
	icon070="󰂀"
	icon060="󰁿"
	icon050="󰁾"
	icon040="󰁽"
	icon030="󰁼"
	icon020="󰁻"
	icon010="󰁺"
	icon000="󰂃"
	return 0
}

#-------------------------------------------------------
# shellcheck disable=SC2059
sensor(){
    local colorsensor
    if [ -n "$sensor" ]; then # le sensor a été trouvé
		[ "$sensor" -ge "$seuilsensor"  ] && colorsensor="$Rouge" || colorsensor="$Bleu"
       	sensor=$(printf "$padd" "$sensor")
		sensors_str="${colorsensor}${sensors_icon}${Reset}${sensor}°C${spaceafter}"
	else
		sensors_str=""
	fi
	return 0
}


#-------------------------------------------------------
# shellcheck disable=SC2059
battery(){
	local batt_icon
   	if [ -n "$batt" ]; then # si la batterie a été trouvée
		if [ "$batt" -eq 100 ]; then
		    batt_icon=$icon100
		elif [ "$batt" -ge 90 ]; then
		    batt_icon=$icon090
		elif [ "$batt" -ge 80 ]; then
		    batt_icon=$icon080
		elif [ "$batt" -ge 70 ]; then
		    batt_icon=$icon070
		elif [ "$batt" -ge 60 ]; then
		    batt_icon=$icon060
		elif [ "$batt" -ge 50 ]; then
		    batt_icon=$icon050
		elif [ "$batt" -ge 40 ]; then
		    batt_icon=$icon040
		elif [ "$batt" -ge 30 ]; then
		    batt_icon=$icon030
		elif [ "$batt" -ge 20 ]; then
		    batt_icon=$icon020
		elif [ "$batt" -ge 10 ]; then
		    batt_icon=$icon010
		else
		    batt_icon=$icon000
		fi
		[ "$batt" -le "$seuilbatt"  ] && colorbatt="$Rouge" || colorbatt="$Bleu"
		batt=$(printf "$padd" "$batt")
		if [ "$state" = "charging" ]; then
			colorbatt="$Vert"
			batt_icon="󰂄"
		fi
		batt_str="${colorbatt}${batt_icon}${Reset}${batt}%${spaceafter}"
	else
		batt_str=""
	fi
	return 0
}

#-------------------------------------------------------
format_net_value(){
	local value=$1
	if [ "$value" -ge 1024 ]; then
		awk "BEGIN {printf \"%6.1fMo/s\", $value / 1024}"
	else
		printf "%6dko/s" "$value"
	fi
}

#-------------------------------------------------------
# shellcheck disable=SC2059
display(){
	local cpu_str mem_str load_str tx_str rx_str wifi_str
	local colorcpu colormem colorload colortx colorrx tx_formatted rx_formatted

	# couleurs icones vs valeurs seuils : Rouge KO/Bleu OK
	# Formatage adaptatif du CPU
	if awk "BEGIN {exit !($cpu < 10)}"; then
	    cpu=$(awk "BEGIN {printf \"%4.1f\", $cpu}")  # < 10% : 1 décimale
	else
	    cpu=$(awk "BEGIN {printf \"%4.0f\", $cpu}")  # >= 10% : 0 décimale
	fi
	# Comparaison pour la couleur
	awk "BEGIN {exit !($cpu >= $seuilcpu)}" && colorcpu="$Rouge" || colorcpu="$Bleu"


	[ "$load_pct" -ge "$seuilload"  ] && colorload="$Rouge" || colorload="$Bleu"
	[ "$mem_pct" -ge "$seuilmem"  ] && colormem="$Rouge" || colormem="$Bleu"
	[ "$swap_pct" -ge "$seuilswap"  ] && colorswap="$Rouge" || colorswap="$Bleu"
	[ "$tx" -ge "$seuilnet"  ] && colortx="$Rouge" || colortx="$Bleu"
	[ "$rx" -ge "$seuilnet"  ] && colorrx="$Rouge" || colorrx="$Bleu"

	# Padde les valeurs à une largeur fixe
	[ -n "$cpu" ] && cpu=$(printf "$padd" "$cpu")
	[ -n "$load_pct" ] && load_pct=$(printf "$padd" "$load_pct")
	[ -n "$mem_pct" ] && mem_pct=$(printf "$padd" "$mem_pct")
	[ -n "$swap_pct" ] && swap_pct=$(printf "$padd" "$swap_pct")
	
	# Formatage adaptatif réseau
	[ -n "$tx" ] && tx_formatted=$(format_net_value "$tx")
	[ -n "$rx" ] && rx_formatted=$(format_net_value "$rx")

    # création des chaines colorées et mise en page à afficher
	cpu_str="${colorcpu}${cpu_icon}${Reset}${cpu}%${spaceafter}"
	load_str="${colorload}${load_icon}${Reset}${load_pct}%${spaceafter}"
	mem_str="${colormem}${mem_icon}${Reset}${mem_pct}%${spaceafter}"
	swap_str="${colorswap}${swap_icon}${Reset}${swap_pct}%${spaceafter}"
	tx_str="${colortx}${tx_icon}${Reset}${tx_formatted}${spaceafter}"
	rx_str="${colorrx}${rx_icon}${Reset}${rx_formatted}${spaceafter}"
	wifi_str="${wifi}${spaceafter}"

	# affichage
	battery
	sensor
	echo -e "${cpu_str}${load_str}${mem_str}${swap_str}${sensors_str}${batt_str}${tx_str}${rx_str}${wifi_str}"
	return 0
}
#-------------------------------------------------------


########################################################################################################
# Corps du script                                                                                      #
########################################################################################################
#check_deps "sensors" "upower"

#--- début Cpu
# méthode basée sur calcul kernel /proc/stat à 2 instants
read -r _ u n s i w ir si st _ _ _ < /proc/stat
pt=$((u+n+s+i+w+ir+si+st)); pi=$((i+w))


#---Charge
load=$(awk '{print $1}' /proc/loadavg) # charge 1 min
load_pct=$(awk "BEGIN {printf \"%.0f\", ($load / $(nproc)) * 100}") # charge 1min / nb de processeurs * 100

#---Memory & swap
read -r mem_total mem_avail swap_total swap_avail < <(
    awk '/MemTotal/ {mem_total=$2}
         /MemAvailable/ {mem_avail=$2}
         /SwapTotal/ {swap_total=$2}
         /SwapFree/ {swap_avail=$2}
         END {print mem_total, mem_avail, swap_total, swap_avail}' /proc/meminfo
)
mem_pct=$(( (mem_total - mem_avail) * 100 / mem_total ))
[[ $swap_total -gt 0 ]] && swap_pct=$(( (swap_total - swap_avail) * 100 / swap_total )) || swap_pct=0

#---Temperature
sensor=$(sensors 2>/dev/null | grep "$FiltreSensor" || true)
sensor=$(echo "$sensor" | grep -oP '\+\K[0-9]+' || true) # on filtre la sortie de sensors pour récupérer une température

#---Réseau
lan="$(ip route | awk '/^default/ {print $5}')" # on récupère l'interface de la route par défaut (wlan0, eth0, ...)
if [ -n "$lan" ]; then
    net_rx1=$(cat "/sys/class/net/$lan/statistics/rx_bytes" || true)
    net_tx1=$(cat "/sys/class/net/$lan/statistics/tx_bytes" || true)
    sleep 0.5
    net_rx2=$(cat "/sys/class/net/$lan/statistics/rx_bytes" || true)
    net_tx2=$(cat "/sys/class/net/$lan/statistics/tx_bytes" || true)
    rx=$(( (net_rx2 - net_rx1) * 2 / 1024 ))
    tx=$(( (net_tx2 - net_tx1) * 2 / 1024 ))
else
	sleep 0.5
    rx=0
    tx=0
fi

#--- fin Cpu (on profite de la demi-seconde du réseau)
read -r _ u n s i w ir si st _ _ _ < /proc/stat
t=$((u+n+s+i+w+ir+si+st)); it=$((i+w))
if ((t-pt>0)); then
    cpu=$(awk "BEGIN {printf \"%.1f\", 100*(${t}-${pt}-${it}+${pi})/(${t}-${pt})}")
else
    cpu="0.0"
fi

#---Wifi
wifi="$("$datadir"/wifi-status.sh --icon-only)" || wifi="" # on récupère l'icone du wifi via script wifi-status.sh, sinon chaine vide.

#---Batt
dev_batt="$(upower -e | grep -i "$FiltreBatt" || true)" # on récupère le device de la batterie
if [ -n "$dev_batt" ]; then  # on récupère la valeur de batterie restante sinon chaine vide.
	batt="$(upower -i "$dev_batt" | grep percentage | grep -o "[0-9]*")"
	state="$(upower -i "$dev_batt" | grep "state" | awk '{print $2}')"
else
	batt=""
fi

#----------------
define_default_colors
define_icons
display
#----------------
