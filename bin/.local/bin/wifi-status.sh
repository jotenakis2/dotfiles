#!/usr/bin/env bash

# status wifi via iwd


set -euo pipefail
[ $# -ge 1 ] && args="$1" || args=""
INTERFACE="wlan0"
ICON_FULL="󰤨"
ICON_HIGH="󰤥"
ICON_MED="󰤢"
ICON_LOW="󰤟"
ICON_NONE="󰤫"
ICON_DISC="󰤮"
ICON_ERR=""
RESET="\033[0m"
CYAN="\033[0;36m"
RED="\033[0;31m"
YELLOW="\033[0;33m"
BLUE="\033[0;34m"
BOLD="\033[0;37m"
GREEN="\033[0;32m"

# --- FONCTIONS ----------------------------------------------------------------------------------
need_cmd() {
  if ! command -v -- "$1" >/dev/null 2>&1; then
    printf 'Error: required command not found: %s\n' "$1" >&2
    exit 1
  fi
}
#------------------------------------------------
convert_time() {
	if [[ -n "$TIME" ]]; then
	    HOURS=$((TIME / 3600))
	    MINUTES=$(((TIME % 3600) / 60))
	    if [[ $HOURS -gt 0 ]]; then
	        FORMATTED="${HOURS}h${MINUTES}min"
	    else
	        FORMATTED="${MINUTES}min"
	    fi
	else
	    FORMATTED="n/a"
	fi
}
#------------------------------------------------
get_ping() {
	need_cmd ping
	fileping="$HOME/.cache/ping.error"
	ping_out=$(timeout 0.3s ping -c 1 free.fr 2>/dev/null)
	if [ $? -eq 0 ]; then
	    COLORP="$GREEN"
	    ping=""
	    # extrait le nombre après time=/temps= (FR/EN, espaces normaux ou insécables)
	    ping_ms=$(printf '%s\n' "$ping_out" | awk 'match($0, /(time|temps)=([0-9.]+)/, m){print m[2]}')
	    ping_ms="(${ping_ms}ms)"
	else
	    COLORP="$RED"
	    ping=""
	    ping_ms=""
	    echo "$(date '+%T'), le $(date '+%A %d %B %Y')" >> "$fileping"
	fi
}
#------------------------------------------------
get_signal_level() { # puissance wifi
    [[ $1 -ge -55 ]] && echo "full" && return
    [[ $1 -ge -65 ]] && echo "high" && return
    [[ $1 -ge -75 ]] && echo "med" && return
    [[ $1 -ge -85 ]] && echo "low" && return
    echo "none"
}
#------------------------------------------------
network_data_fetch() {
	need_cmd drill
	need_cmd ip
	GATEWAY=$(ip route | awk '/^default/ {print $3}' | head -n1)
	DRILL=$(timeout 0.4s drill example.com)
	DNS=$(echo "$DRILL" | grep SERVER | cut -d' ' -f3 | cut -d':' -f1-4) # si IPV6 je coupe l'affichage aux 4 1ers blocs
	[ "$GATEWAY" != "" ] && COLORG=$GREEN || COLORG=$RED
	[ "$DNS" != "" ] && COLORDNS=$GREEN || COLORDNS=$RED
	# extraction données ping
	get_ping
}
#------------------------------------------------
iwd_data_fetch() {
	need_cmd iwctl
	OUTPUT=$(iwctl station "$INTERFACE" show)
	STATE=$(echo "$OUTPUT" | awk '/^\s*State/ {print $2}')
	NETWORK=$(echo "$OUTPUT" | awk '/^\s*Connected network/ {print $3}')
	IPV4=$(echo "$OUTPUT" | awk '/^\s*IPv4 address/ {print $3}')
	FREQ=$(echo "$OUTPUT" | awk '/^\s*Frequency/ {print $2}')
	CHANNEL=$(echo "$OUTPUT" | awk '/^\s*Channel/ {print $2}')
	RSSI=$(echo "$OUTPUT" | awk '/^\s*RSSI/ {print $2}')
	TIME=$(echo "$OUTPUT" | awk '/^\s*ConnectedTime/ {print $2}')

	[ "$RSSI" = "" ] && RSSIunit="" || RSSIunit="${RSSI}dBm"
	[ "$STATE" = "connected" ] && STATE="connecté"
	[ "$STATE" = "disconnected" ] && STATE="déconnecté"
	[ "$RSSI" !=  "" ] && COLORSSI=$GREEN || COLORSSI=$RED

	if [ "$IPV4" != "" ]; then
		COLORIP=$GREEN
	else
		COLORIP=$RED
		need_cmd ip
		IPV4=$(ip -4 addr show wlan0 | awk '/inet / {print $2}' | cut -d'/' -f1) # si iwd ne renvoie pas d'IP on check avec ip a
	fi
	if [ "$NETWORK" != "" ]; then
		COLORN=$GREEN
		NETWORK="$NETWORK  "
	else
		COLORN=$RED
	fi
	if [ "$FREQ" = "" ]; then
		FREQunit=""
		COLORFREQ=$RED
		COLORF=$RED
	else
		FREQunit="${FREQ}Hz"
		COLORFREQ=$GREEN
		[[ $FREQ == 2* ]] && COLORF=$YELLOW || COLORF=$GREEN
	fi
	if [ "$CHANNEL" = "" ]; then
		COLORCHAN=$RED
		COLORC=$RED
	else
		COLORCHAN=$GREEN
	    (( CHANNEL <= 14 )) && COLORC=$YELLOW || COLORC=$GREEN
	fi
	
	if [[ "$STATE" != "connecté" ]]; then
	   BARS="${ICON_DISC}"
	   COLORSTATE=$RED
	   COLORBARS=$RED
	else
	    COLORSTATE=$GREEN
		if [[ -z "$RSSI" ]]; then # connecté mais pas de RSSI ???
		    echo "$ICON_ERR: err. iwctl"
		    exit 1
		fi
		case $(get_signal_level "$RSSI") in
		    full) BARS="${ICON_FULL}"; COLORBARS=$GREEN ;;
		    high) BARS="${ICON_HIGH}"; COLORBARS=$YELLOW ;;
		    med)  BARS="${ICON_MED}" ; COLORBARS=$BLUE ;;
		    low)  BARS="${ICON_LOW}" ; COLORBARS=$CYAN ;;
		    none) BARS="${ICON_NONE}"; COLORBARS=$RED ;;
		esac
	fi
}
#------------------------------------------------
full_display() {
	local flag
	local ansi
	flag=$1
	ansi="-e"
	# extraction données réseaux
	network_data_fetch 
	if [ "$flag" = "--details-nocolor" ]; then # on reset les couleurs
		COLORSTATE=""
		COLORBARS=""
		COLORC=""
		COLORF=""
		COLORP=""
		COLORIP=""
		COLORDNS=""
		COLORCHAN=""
		COLORFREQ=""
		COLORSSI=""
		COLORN=""
		COLORG=""
		RESET=""
		BOLD=""
		ansi=""
		GREEN=""
	fi
	ping="${COLORP}$ping${RESET}"
	hr=$(date '+%T')
	echo $ansi "Connection internet 󰀂     ($hr)"
	echo $ansi " ${COLORSTATE}$RESET  État: ${COLORSTATE}${STATE}${RESET} ${COLORBARS}${BARS}${RESET} "
	echo $ansi " ${COLORP}$RESET  Ping: $ping  $ping_ms"
	echo $ansi " ${COLORN}$RESET  HotSpot: ${BOLD}$NETWORK${RESET}"
	echo $ansi " ${COLORIP}$RESET  IP: ${BOLD}$IPV4${RESET}"
	echo $ansi " ${COLORG}$RESET  Passerelle: $GATEWAY"
	echo $ansi " ${COLORDNS}$RESET  DNS: $DNS"
	echo $ansi " ${COLORFREQ}$RESET  Bande: ${COLORF}${FREQunit}${RESET}"
	echo $ansi " ${COLORCHAN}$RESET  Canal: ${COLORC}$CHANNEL${RESET}"
	echo $ansi " ${COLORSSI}$RESET  Puissance: ${COLORBARS}${RSSIunit}${RESET}"
	if [ "$STATE" = "connecté" ]; then
		convert_time
		echo $ansi " ${COLORSTATE}$RESET  Durée de connection: ${FORMATTED}"
	fi
}
# / FONCTIONS ------------------------------------------------------------------------------------



# --- BODY ---------------------------------------------------------------------------------------
iwd_data_fetch
case "$args" in
	"--details"        ) full_display "$args";;
	"--details-nocolor") full_display "$args";;
	"--icon-only"      ) echo -e "${COLORBARS}${BARS}${RESET} ";;
	*                  ) echo -e "${COLORBARS}${BARS}${RESET} (${COLORBARS}${RSSI}${RESET}dBm)";;
esac
exit 0
