# shellcheck disable=SC2034
C_BLACK=$(tput setaf 0)
C_RED=$(tput setaf 1)
C_GREEN=$(tput setaf 2)
C_YELLOW=$(tput setaf 3)
C_BLUE=$(tput setaf 4)
C_MAGENTA=$(tput setaf 5)
C_CYAN=$(tput setaf 6)
C_WHITE=$(tput setaf 7)
C_RESET=$(tput sgr0)

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
  if [[ -x ~/.local/bin/wanip.sh ]]; then
  	ipv4=$(~/.local/bin/wanip.sh)
  else
  	ipv4=$(curl --silent -4 https://ifconfig.me)
  fi
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
	# shellcheck disable=SC2181
	if [[ $? -eq 0 ]]; then
	    time_ms=$(echo "$out" | grep -oP 'time=\K[0-9.]+')
	    time_int=$(printf "%.0f" "$time_ms")
	    echo "ping $host => OK (${time_int}ms)"
	else
	    echo "ping $host => FAILED"
	fi
}
# ----------------------------------------------------------------------------------------------------------
speed(){
	speedtest-go -u decimal-bytes --saving-mode --mask-isp | grep -E 'Download|Upload' || true
}
resolved(){
	/usr/bin/resolvectl status | awk '/^Global$/{p=1; next} /^[A-Z]/{p=0} p'
}
ipconf(){
	local temp='' iface='n/a' ip='n/a' gate='n/a' channel='' str='n/a'
	temp=$(/usr/bin/ip -br addr show up | grep UP)
	if [[ -n "${temp}" ]]; then
		iface=$(echo "${temp}" | awk '{print $1}')
		ip=$(echo "${temp}" | awk '{print $3}')
		channel=$(iw dev "${iface}" link | awk '/freq:/ { print $2; exit }')
	fi
	gate=$(ip route | awk '/^default/ {print $3}')
	[[ -n "${channel}" ]] && str="${channel}Mhz" 
	echo "Iface: ${iface:-n/a} | IP: ${ip:-n/a} | Gate: ${gate:-n/a} | Wifi: ${str}"	
}
# ----------------------------------------------------------------------------------------------------------
internet() {
	clear

	_SECTION " IP CONFIG " "-" "${C_BLUE}"
	ipconf
	_SECTION " DNS CONFIG " "-" "${C_BLUE}"
	resolved
	_SECTION " IP WAN TEST " "-" "${C_BLUE}"
	myip
	_SECTION " PING TEST " "-" "${C_BLUE}"
	testping 9.9.9.9
	testping 1.1.1.1
	testping google.com
	testping free.fr
	_SECTION " DNS TEST " "-" "${C_BLUE}"
	dnstest.sh
	_SECTION " SPEED TEST " "-" "${C_BLUE}"
	speed
	_SECTION "" "-" "${C_BLUE}"
	echo "${C_RED}ENTREE pour quitter...${C_RESET}"
	read -r
}

# ----------------------------------------------------------------------------------------------------------

fzf-history() { # historique à la mode atuin sans synchro
  setopt localoptions noglobsubst noposixstrings pipefail
  local raw key selected num
  # modif apporté à raw et num pour avoir l'index en gris

  #ORIGINAL raw=$(fc -rl 1 | fzf --no-sort --exact -n2..,.. --bind='ctrl-r:toggle-sort' --expect=tab,enter --query="${BUFFER}" +m --height=60% --no-scrollbar || true)
  raw=$(fc -rl 1 | awk '{gsub(/^[[:space:]]+/, ""); match($0, /^[0-9]+/); num=int(substr($0, RSTART, RLENGTH)); cmd=substr($0, RLENGTH+2); formatted=sprintf("%05d", num); print "\033[38;5;238m"formatted"\033[0m "cmd}' | fzf --no-sort --exact -n2..,.. --bind='ctrl-r:toggle-sort' --expect=tab,enter --query="${BUFFER}" +m --height=70% --no-scrollbar --ansi || true)
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

view() {
    local f=${1-}
	local nocomm=${2-}
	
    [[ $# -eq 0 ]] && { printf 'view: paramètre manquant "fichier" ' ; return 1 ; }
    [[ ! -e ${f} ]] && { printf 'view: fichier introuvable: %s\n' "${f}" >&2; return 1; }

    case ${f} in
        *.md|*.markdown|*.mdown|*.mkd)
            glow -p -- "${f}"
            ;;
        *.json|*.yml|*.yaml)
        	yq < "${f}"
        	;;
        *)	
        # shellcheck disable=SC2015
           	[[ "${nocomm:-}" != "-n" ]] && \bat -pfSn --squeeze-blank -- "${f}" || rg -v "^\s*(#|//|;)" --color=never "$@" | rg . | bat -p --file-name "$@"
           ;;
    esac
}

# ----------------------------------------------------------------------------------------------------------

LOG() { # journalctl sans "audit" polluant
    local -a t=()
    local line
    while IFS= read -r line; do # on récupère tous les TRANSPORT systemd sauf "audit"
        t+=("${line}")
    done < <(journalctl -F _TRANSPORT 2>/dev/null | grep -vx 'audit')

    [[ ${#t[@]} -eq 0 ]] && return 0

    local -a args=("_TRANSPORT=${t[0]}")
    local i
    for ((i=1; i<${#t[@]}; i++)); do
        args+=("+")
        args+=("_TRANSPORT=${t[i]}")
    done

    journalctl "$@" "${args[@]}"
}

# ----------------------------------------------------------------------------------------------------------

_SECTION() {
    local msg
    local fillertype
    local color

    [[ $# -eq 0 ]] && return 1
	
    msg="$1"
    fillertype="$2"
    color="$3"

    local term_cols
    term_cols="${COLUMNS}" || return 1

    print -- "${color}"
    (( term_cols -= 2 ))

    local str_len=${#msg}
    if (( str_len >= term_cols )); then
        print -- "${msg}"
        print -n -- "${C_RESET}"
        printf '\n'
        printf '>>>>>>>>>> %s\n' "${msg}" >> "${LOG_FILE:-/dev/null}"
        return 0
    fi

    local filler_len=$(( (term_cols - str_len) / 2 ))
    local ch=${fillertype:0:1}
    local filler=""
    local i

    for (( i = 0; i < filler_len; i++ )); do
        filler+="${ch}"
    done

    printf '%s%s%s' "${filler}" "${msg}" "${filler}"
    if (( (term_cols - str_len) % 2 != 0 )); then
        printf '%s' "${ch}"
    fi
    printf '\n'
    print -n -- "${C_RESET}"
    printf '\n'
    printf '>>>>>>>>>> %s\n' "${msg}" >> "${LOG_FILE:-/dev/null}"
    return 0
}

# ----------------------------------------------------------------------------------------------------------

maj(){ # maj globale pour Omarchy	
	if ! sudo -n true 2>/dev/null; then
	    printf "\n%b[🔐 SUDO]%b Autorisation requise pour %b%s%b : " "${C_RED}" "${C_RESET}" "${C_BOLD}" "${USER}" "${C_RESET}"
	    sudo -v -p ""
	fi
	local start
	start=${SECONDS}
	clear
	_SECTION "  Mise à jour des PLUGINS OMARCHY SHELL  " "*" "${C_MAGENTA}"
	omarchy plugin update -y | rg 'Updated'
	echo
	_SECTION "  Mise à jour des FLATPAK  " "*" "${C_MAGENTA}"
	flatpak update -y
	echo
	_SECTION "  Mise à jour d'OMARCHY  " "*" "${C_MAGENTA}"
	omarchy update -y
	echo
	_SECTION "" "*" "${C_MAGENTA}"

	local duration
	duration=$(( SECONDS - start))
	echo ">>> La mise à jour a duré ${duration}s."
}

# ----------------------------------------------------------------------------------------------------------

rm(){
	if command -v zap &>/dev/null; then
		zap -t -v "$@"
	else
		rm -Iv --preserve-root "$@"
	fi
}

# ----------------------------------------------------------------------------------------------------------

cp(){
	if command -v zap &>/dev/null; then
		zap -c -v "$@"
	else
		cp -iv "$@"
	fi
}

# ----------------------------------------------------------------------------------------------------------

mv(){
	if command -v zap &>/dev/null; then
		zap -m -v "$@"
	else
		mv -iv "$@"
	fi
}

# ----------------------------------------------------------------------------------------------------------

psp(){
	psim --fullcmd --0 -pn "$@"
}

# ----------------------------------------------------------------------------------------------------------

psm(){
	psim --fullcmd --0 -mn "$@"
}

# ----------------------------------------------------------------------------------------------------------

psc(){
	psim --fullcmd --0 -cn "$@"
}

# ----------------------------------------------------------------------------------------------------------

omarchy-plugins() {
	local json
	json="$(command omarchy plugin list --json)" || return

	jq -r '
		def origin:
			if .firstParty then "builtin"
			elif .clonedFrom != "" then "fork"
			else "external"
			end;

		["STATE", "ORIGIN", "KINDS", "ID", "NAME"],
		(
			.[] |
			[
				(if .enabled then "on" else "off" end),
				origin,
				(.kinds | join(",")),
				.id,
				.name
			]
		) |
		@tsv
	' <<<"$json" |
	column -t -s $'\t'
}

source "$HOME"/.local/share/omarchy/default/zsh/functions/functions.zsh
