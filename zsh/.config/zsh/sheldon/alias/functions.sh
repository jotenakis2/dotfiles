# ----------------------------------------------------------------------------------------------------------
distrodate() {
	# shellcheck disable=SC2312,SC2012
	ls -lct /etc | tail -1 | awk '{print $6, $7, $8}'
}

# ----------------------------------------------------------------------------------------------------------
heure() {
	local hr
	local date
	hr=$(date '+%T')
	date=$(date '+%A %d %B %Y')
	echo "${hr}, le ${date}"
}

# ----------------------------------------------------------------------------------------------------------
nocomm() {
  # shellcheck disable=SC2312
  rg -v "^\s*(#|//|;)" --color=never "$@" | rg . | bat -p --file-name "$@"
}

# ----------------------------------------------------------------------------------------------------------
path() {
    local p="$1"
    [[ -z "${p}" ]] && p="${PATH}"
    echo "${p}" | tr ':' '\n'
}

# ----------------------------------------------------------------------------------------------------------
logfwRT() {
	# shellcheck disable=SC2312
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
	# shellcheck disable=SC2312
  journalctl --no-hostname -b 0 -p3 --no-pager -q 2>&1 | awk '{key=substr($0,index($0,$4)); if(!seen[key]++) print $0}'
}

# ----------------------------------------------------------------------------------------------------------
help() { # help coloré
	# shellcheck disable=SC2312
    "$@" --help 2>&1 | bathelp
}

# ----------------------------------------------------------------------------------------------------------
myip() {
  local ipv4 ipv6
  ipv4=$(curl --silent -4 https://ifconfig.me)
  ipv6=$(curl --silent -6 https://ifconfig.co)
  [[ -z ${ipv4} ]] && ipv4=$(curl --silent -4 https://ifconfig.co)
  [[ -z ${ipv6} ]] && ipv6=$(curl --silent -6 https://ifconfig.me) 

  [[ -z ${ipv4} ]] && echo "No IPv4 internet connectivity" || echo "IPv4: ${ipv4}"
  [[ -z ${ipv6} ]] && echo "No IPv6 internet connectivity" || echo "IPv6: ${ipv6}"
}

# ----------------------------------------------------------------------------------------------------------
testping(){
	local host="$1"
	[[ -z "${host:-}" ]] && host="free.fr"
	out=$(LANG=LC /usr/bin/ping -c 1 -W 1 "${host}" 2>/dev/null)
	if [[ $? -eq 0 ]]; then
	    time_ms=$(echo "$out" | grep -oP 'time=\K[0-9.]+')
	    time_int=$(printf "%.0f" "$time_ms")
	    echo "ping $host => OK (${time_int}ms)"
	else
	    echo "ping $host => FAILED"
	fi
}
# ----------------------------------------------------------------------------------------------------------
dns(){
	dnsleaktest.sh
}
speed(){
	speedtest-go -u decimal-bytes --saving-mode --no-upload | grep Download || true	
}
resolved(){
	/usr/bin/resolvectl status | awk '/^Global$/{p=1; next} /^[A-Z]/{p=0} p'
}
ipconf(){
	/usr/bin/ip -br addr show up | grep UP || echo "no iface UP"
}
# ----------------------------------------------------------------------------------------------------------
internet() {
	clear
	bleu=$(tput setaf 3); reset=$(tput sgr0) ; bold=$(tput bold)

	echo "${bleu}${bold}--------------------------- IPCONF ------------------------------------------------------------------------${reset}"
		ipconf
	echo "${bleu}${bold}--------------------------- IP WAN ------------------------------------------------------------------------${reset}"
		myip 
	echo "${bleu}${bold}--------------------------- PING 1 ------------------------------------------------------------------------${reset}"
		testping 9.9.9.9
	echo "${bleu}${bold}--------------------------- DNS  1 ------------------------------------------------------------------------${reset}"
		resolved
	echo "${bleu}${bold}--------------------------- PING 2 ------------------------------------------------------------------------${reset}"
		testping google.com
	echo "${bleu}${bold}--------------------------- DNS  2 ------------------------------------------------------------------------${reset}"
		dns
	echo "${bleu}${bold}--------------------------- SPEED  ------------------------------------------------------------------------${reset}"
		speed
	echo "${bleu}${bold}-----------------------------------------------------------------------------------------------------------${reset}"
}

# ----------------------------------------------------------------------------------------------------------
fzf-history() { # historique à la mode atuin sans synchro
  setopt localoptions noglobsubst noposixstrings pipefail
  local raw key selected num
  # modif apporté à raw et num pour avoir l'index en gris

  #ORIGINAL raw=$(fc -rl 1 | fzf --no-sort --exact -n2..,.. --bind='ctrl-r:toggle-sort' --expect=tab,enter --query="${BUFFER}" +m --height=60% --no-scrollbar || true)
  raw=$(fc -rl 1 | awk '{gsub(/^[[:space:]]+/, ""); match($0, /^[0-9]+/); num=int(substr($0, RSTART, RLENGTH)); cmd=substr($0, RLENGTH+2); formatted=sprintf("%05d", num); print "\033[38;5;238m"formatted"\033[0m "cmd}' | fzf --no-sort --exact -n2..,.. --bind='ctrl-r:toggle-sort' --expect=tab,enter --query="${BUFFER}" +m --height=60% --no-scrollbar --ansi || true)
  key=$(head -1 <<<"${raw}")
  selected=$(tail -1 <<<"${raw}")
  zle reset-prompt

  if [[ -n "${selected}" ]]; then
    #ORIGINAL num=$(awk '{print $1}' <<< "${selected}")
    num=$(echo "${selected}" | sed 's/\x1b\[[0-9;]*m//g' | awk '{print $1}' | sed 's/^0*//' || true)
    [[ -n "${num}" ]] || return 0
    # shellcheck disable=SC2296
    BUFFER="${(z)history[${num}]}"
    BUFFER="${BUFFER% }"
    zle end-of-line
    zle redisplay
    [[ ${key} = enter ]] && zle accept-line
  fi
}
zle -N fzf-history                    # définit la fonction fzf-history comme un widget ZSH
bindkey '^R' fzf-history              # bind sur CTRL R
bindkey '^[[A' fzf-history            # et bind sur Flèche haut
bindkey "^[[1;5A" up-line-or-history  # CTRL Flèche haut pour fonctionnement normal sans fzf

# ----------------------------------------------------------------------------------------------------------
function psp {
	psim --0 -pn "$@"
}
function psm {
	psim --0 -mn "$@"
}
function psc {
	psim --0 -cn "$@"
}
# ----------------------------------------------------------------------------------------------------------

function cd() { # remplace cd par une liste fzf des dossiers dans le dossier courant et valide la sélection avec z 'zoxide'
  if [[ $# -gt 0 ]]; then
    z "$@"
  else
    local dir
    # shellcheck disable=SC2086,SC2312
    dir=$(fd --type directory --hidden --exclude .git ${1:-.} | fzf +m --preview 'eza -T -L 4 --color=always --icons {} | head -30' --preview-window 'right:45%:wrap' --height 50%) && z "${dir}"
  fi
}

# ----------------------------------------------------------------------------------------------------------

view() {
    local f=${1-}

    [[ $# -eq 0 ]] && { printf 'view: paramètre manquant "fichier" ' ; return 1 ; }
    [[ ! -e ${f} ]] && { printf 'view: fichier introuvable: %s\n' "${f}" >&2; return 1; }

    case ${f} in
        *.md|*.markdown|*.mdown|*.mkd)
            glow -p -- "${f}"
            ;;
        *)
           	/opt/cargo/bin/bat -pfSn --squeeze-blank -- "${f}"
           ;;
    esac
}

# ----------------------------------------------------------------------------------------------------------
# >>> elio shell integration >>>
elio() {
    case "${1-}" in
        shell|-*)
            command elio "$@"
            return $?
            ;;
    esac

    local arg tmp cwd status_code
    for arg in "$@"; do
        case "$arg" in
            --chooser-file|--chooser-file=*)
                command elio "$@"
                return $?
                ;;
        esac
    done

    tmp="$(mktemp -t "elio-cwd.XXXXXX")" || return
    command elio --cwd-file "$tmp" "$@"
    status_code=$?

    if [ -s "$tmp" ]; then
        cwd="$(cat -- "$tmp")"
        /usr/bin/rm -f -- "$tmp"
        if [ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && [ -d "$cwd" ]; then
            cd -- "$cwd" || return $?
        fi
    else
        /usr/bin/rm -f -- "$tmp"
    fi

    return "$status_code"
}
# <<< elio shell integration <<<
