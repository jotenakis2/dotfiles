
# ----------------------------------------------------------------------------------------------------------
distrodate() {
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
  journalctl --no-hostname -b 0 -p3 --no-pager -q 2>&1 | awk '{key=substr($0,index($0,$4)); if(!seen[key]++) print $0}'
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
  [[ -z ${ipv4} ]] && echo "No IPv4 internet connectivity" || echo "IPv4: ${ipv4}"
  [[ -z ${ipv6} ]] &&	echo "No IPv6 internet connectivity" || echo "IPv6: ${ipv6}"
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
	speedtest-go
	echo ""
	ip a
	echo ""
}

# ----------------------------------------------------------------------------------------------------------
fzf-history() {
  setopt localoptions noglobsubst noposixstrings pipefail
  local raw key selected num

  raw=$(fc -rl 1 | fzf --no-sort --exact -n2..,.. --bind='ctrl-r:toggle-sort' --expect=tab,enter --query="${BUFFER}" +m --height=60% --no-scrollbar || true)
  key=$(head -1 <<<"${raw}")
  selected=$(tail -1 <<<"${raw}")
  zle reset-prompt

  if [[ -n "${selected}" ]]; then
    num=$(awk '{print $1}' <<< "${selected}")
    [[ -n "${num}" ]] || return 0
    BUFFER="${(z)history[$num]}"
    BUFFER="${BUFFER% }"
    zle end-of-line
    zle redisplay
    [[ ${key} = enter ]] && zle accept-line
  fi
}
zle -N fzf-history                                            # définit la fonction fzf-history comme un widget ZSH
bindkey '^R' fzf-history                                      # bind sur CTRL R
bindkey '^[[A' fzf-history                                    # et bind sur Flèche haut
bindkey "^[[1;5A" up-line-or-history

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
