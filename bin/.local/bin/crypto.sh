#!/usr/bin/env bash

set -euo pipefail

# Script pour afficher les top cryptos avec évolutions
# Nécessite: gum, curl, jq, bc
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
	# Couleurs gum
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

define_colors
export LC_NUMERIC=C
API_BASE="https://api.coingecko.com/api/v3"

# Demander le nombre de cryptos à afficher
gum style --border rounded --padding "0 1" --border-foreground $BleuGum "Combien de cryptos afficher ?"
NB_CRYPTOS=$(gum choose --cursor.foreground=$BleuGum --header.foreground=$BleuGum --show-help=false --header "Choix ?" "10" "20" "30" "40" "50")

if [ -z "$NB_CRYPTOS" ]; then
    echo "Annulé"
    exit 0
fi
clear
gum style --border double --padding "1 2" --border-foreground $VertGum --foreground $JauneGum --align center " 󰠓 Top $NB_CRYPTOS Cryptos - Market Data 󰡪 "

# Récupération des données
gum spin --spinner dot --title "Récupération des données..." -- sleep 0.5

DATA=$(curl -s "${API_BASE}/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=150&page=1&sparkline=false&price_change_percentage=1h,24h,7d,14d,30d,200d,1y")

# En-tête du tableau avec séparateurs
printf "\n"
printf "\033[36m\033[1m%-5s\033[90m│\033[36m%-9s\033[90m│\033[36m%12s\033[90m│\033[36m%11s\033[90m│\033[36m%11s\033[90m│\033[36m%11s\033[90m│\033[36m%11s\033[90m│\033[36m%11s\033[90m│\033[36m%11s\033[90m│\033[36m%11s\033[90m│\033[36m%11s\033[90m│\033[36m%-9s\033[90m│\033[36m%-6s\033[0m\n" \
  'Rank' 'Crypto' 'Prix USD' 'MCap (B)' '1h %' '24h %' '7d %' '14d %' '30d %' '200d %' '1y %' 'Crypto' 'Link'
printf "\033[90m%s\033[0m\n" "─────┼─────────┼────────────┼───────────┼───────────┼───────────┼───────────┼───────────┼───────────┼───────────┼───────────┼─────────┼──────"

# Fonction pour colorer les pourcentages
color_pct() {
    local val=$1
    if [[ "$val" == "null" || -z "$val" ]]; then
        printf "%11s" "N/A"
        return
    fi
    
    local formatted
    formatted=$(printf '%9.1f%%' "$val")
    
    if (( $(echo "$val >= 0" | bc -l 2>/dev/null || echo 0) )); then
        printf "\033[32m%11s\033[0m" "$formatted"
    else
        printf "\033[31m%11s\033[0m" "$formatted"
    fi
}

# Fonction pour colorer le prix selon 24h%
color_price() {
    local price=$1
    local pct24h=$2
    
    if [[ "$pct24h" == "null" || -z "$pct24h" ]]; then
        printf "%12s" "$price"
    elif (( $(echo "$pct24h > 0" | bc -l 2>/dev/null || echo 0) )); then
        printf "\033[32m%12s\033[0m" "$price"
    elif (( $(echo "$pct24h < 0" | bc -l 2>/dev/null || echo 0) )); then
        printf "\033[31m%12s\033[0m" "$price"
    else
        printf "%12s" "$price"
    fi
}

# Fonction pour créer un hyperlien terminal
make_link() {
    local url=$1
    local text=$2
    printf "\033]8;;%s\033\\%s\033]8;;\033\\" "$url" "$text"
}

# Filtrage complet : stablecoins USD, wrapped, staking, bridged, RWA tokens (mais on garde les stablecoins or)
FILTER="usdt|usdc|usde|usd1|usdf|usdg|busd|dai|usdd|tusd|usdp|gusd|usds|pyusd|fdusd|frax|buidl|bnsol|rlusd|bfusd|^w[a-z]|^st[a-z]|^cb[a-z]|^r[a-z]eth|weeth|wbeth|^wbt|bsc-usd|^e[a-z]eth|^sa[a-z]|^aeth|figr|heloc|_usd|^susd|jitosol|^m$"

# Traitement des données avec détection de doublons
count=0
declare -A seen_symbols

echo "$DATA" | jq -r '.[] | [
    .market_cap_rank,
    .id,
    .symbol,
    .current_price,
    .market_cap,
    .price_change_percentage_1h_in_currency,
    .price_change_percentage_24h_in_currency,
    .price_change_percentage_7d_in_currency,
    .price_change_percentage_14d_in_currency,
    .price_change_percentage_30d_in_currency,
    .price_change_percentage_200d_in_currency,
    .price_change_percentage_1y_in_currency
] | @tsv' | while IFS=$'\t' read -r rank coin_id symbol price mcap pct1h pct24h pct7d pct14d pct30d pct200d pct1y; do
    
    # Filtrer les dérivés
    if echo "$symbol" | grep -qiE "$FILTER"; then
        continue
    fi
    
    # Filtrer les doublons de symboles
    if [[ -n "${seen_symbols[$symbol]:-}" ]]; then
        continue
    fi
    seen_symbols[$symbol]=1
    
    count=$((count + 1))
    if [ "$count" -gt "$NB_CRYPTOS" ]; then
        break
    fi
    
    # Formatage market cap en milliards
    mcap_b=$(echo "scale=2; $mcap / 1000000000" | bc)
    
    # Formatage du prix
    if (( $(echo "$price < 1" | bc -l) )); then
        price_fmt=$(printf "%.6f" "$price")
    elif (( $(echo "$price < 100" | bc -l) )); then
        price_fmt=$(printf "%.2f" "$price")
    else
        price_fmt=$(printf "%.0f" "$price")
    fi
    
    # Symbole en majuscules
    symbol_upper=$(echo "$symbol" | tr '[:lower:]' '[:upper:]')
    
    # URL CoinGecko
    coingecko_url="https://www.coingecko.com/en/coins/$coin_id"
    
    # Affichage de la ligne avec séparateurs - Crypto au début ET à la fin
    printf "%-5s\033[90m│\033[33m%-9s\033[90m│\033[0m" "$rank" "$symbol_upper"
    color_price "\$$price_fmt" "$pct24h"
    printf "\033[90m│\033[0m%11s\033[90m│\033[0m" "\$$mcap_b"
    
    color_pct "$pct1h"
    printf "\033[90m│\033[0m"
    color_pct "$pct24h"
    printf "\033[90m│\033[0m"
    color_pct "$pct7d"
    printf "\033[90m│\033[0m"
    color_pct "$pct14d"
    printf "\033[90m│\033[0m"
    color_pct "$pct30d"
    printf "\033[90m│\033[0m"
    color_pct "$pct200d"
    printf "\033[90m│\033[0m"
    color_pct "$pct1y"
    printf "\033[90m│\033[33m%-9s\033[90m│\033[34m%s\033[0m\n" "$symbol_upper" "$(make_link "$coingecko_url" "🔗")"
done

printf "\n"
printf "\033[90mDernière mise à jour: %s\033[0m\n" "$(date '+%Y-%m-%d %H:%M:%S')"
printf "\n"
