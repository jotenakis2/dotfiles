# ----------------------------------------------------------------------------------------------------------
distrodate() {
  \ls -lct /etc | tail -1 | awk '{print $6, $7, $8}'
}

# ----------------------------------------------------------------------------------------------------------
heure() {
  echo "$(\date '+%T'), le $(date '+%A %d %B %Y')"
}

# ----------------------------------------------------------------------------------------------------------
nocomm() {
  \rg -v "^\s*(#|//|;)" --color=never "$1" | bat -p --file-name "$1"
}

# ----------------------------------------------------------------------------------------------------------
path() {
    local p="$1"
    [ -z "$p" ] && p="$PATH"
    echo "$p" | tr ':' '\n'
}

# ----------------------------------------------------------------------------------------------------------
logfwRT() {
  journalctl -f -n50 |
    awk '/filter_IN/ {
      gsub(/ MAC=[^ ]*/, "");
      gsub(/ LEN=[^ ]*/, "");
      gsub(/ TOS=[^ ]*/, "");
      gsub(/ PREC=[^ ]*/, "");
      gsub(/ ID=[^ ]*/, "");
      gsub(/ TTL=[^ ]*/, "");
      gsub(/ DF[^ ]*/, "");
      gsub(/ OUT=[^ ]*/, "");
      gsub(/ TC=[^ ]*/, "");
      gsub(/ HOPLIMIT=[^ ]*/, "");
      gsub(/ FLOWLBL=[^ ]*/, "");
      printf "%-2s %-8s %-15s %-15s %-15s %-15s %-15s %-45s %-45s \n",
             $2, $1, $3, $6, $9, $10, $11, $7, $8
    }'
}

# ----------------------------------------------------------------------------------------------------------
logerror() { # erreurs dédupliquées sur le boot en cours
  journalctl --no-hostname -b 0 -p3 --no-pager -q 2>&1 |
    awk '{key=substr($0,index($0,$4)); if(!seen[key]++) print $0}'
}

# ----------------------------------------------------------------------------------------------------------
help() { # help coloré
    "$@" --help 2>&1 | bathelp
}

# ----------------------------------------------------------------------------------------------------------
myip() {
  local ipv4 ipv6
  ipv4=$(curl --silent -4 https://icanhazip.com/)
  ipv6=$(curl --silent -6 https://icanhazip.com/)
  [[ -z $ipv4 ]] && echo "No IPv4 internet connectivity" || echo "IPv4: $ipv4"
  [[ -z $ipv6 ]] &&	echo "No IPv6 internet connectivity" || echo "IPv6: $ipv6"
}

# ----------------------------------------------------------------------------------------------------------
internet() {
	myip 
	echo ""
	ping -c5 9.9.9.9
	echo ""
	resolvectl status
	echo ""
	dnsleaktest.sh
	echo ""
	speedtest-cli
	echo ""
	ip a
	echo ""
}

# ----------------------------------------------------------------------------------------------------------
fzf-history() {
  setopt localoptions noglobsubst noposixstrings pipefail
  local raw key selected num cmd                              # sortie brute de fzf, touche frappée, ligne choisie, index de la ligne choisie, commande choisie
  
  # j'affiche une liste fzf qui liste les dernières commande de l'historique et fzf attend TAB, ENTREE (ou ECHAP)
  # fzf "exact" pas "fuzzy", sans tri, cherche à partir du 2ème champ (le 1er est l'index), refuse la multi sélection 
  raw=$(fc -rl 1 | fzf --no-sort --exact -n2..,.. --bind='ctrl-r:toggle-sort' --expect=tab,enter --query="${BUFFER}" +m --height=60% --no-scrollbar || true)												
 
  # récupèration des données et préparation
  key=$(head -1 <<<"${raw}")                                  # je récupère la touche tapée (TAB ou ENTREE)
  selected=$(tail -1 <<<"${raw}")                             # je récupère la ligne choisie
  zle reset-prompt                                            # je force la réinitialisation du prompt (prompt OK même si ESC)

  # traitement de la sélection si non vide
  if [[ -n "${selected}" ]]; then												
    num=$(awk '{print $1}' <<< "${selected}")                 # je récupère l'index de la commande choisie,
    cmd=$(fc -ln "${num}" "${num}" | sed 's/[[:space:]]*$//' || true) # je récupère la commande choisie uniquement et je dégage les espaces en bout de commande,
    BUFFER="${cmd} "                                          # le buffer est maintenant ma commande avec un espace,
    zle end-of-line                                           # je force le déplacement du curseur à la fin du buffer par sécurité pour éviter incompatibilité avec autres plugins,
    #CURSOR=${#BUFFER}                                         # je déplace le curseur à la fin du buffer,
    zle redisplay                                             # je rafraichit l'affichage,
    [[ ${key} = enter ]] && zle accept-line                   # si ENTREE alors j'accepte la commande et l'éxécute.
  fi
}
zle -N fzf-history                                            # définit la fonction fzf-history comme un widget ZSH
bindkey '^R' fzf-history                                      # bind sur CTRL R
bindkey '^[[A' fzf-history                                    # et bind sur Flèche haut


# ----------------------------------------------------------------------------------------------------------
function psp {
	psim --0 -pnO "$@"
}
function psm {
	psim --0 -mnO "$@"
}
function psc {
	psim --0 -cnO "$@"
}
