# shellcheck disable=SC2034,SC2148,SC2296,SC2250,SC2312,SC2154,SC2004
# This file is *sourced by zsh* from .zshrc, not executed by sh/bash, and
# The linter has no zsh mode: the codes above are that mismatch, not defects:
#   SC2148  no shebang: it is not a script;
#   SC2296  zsh-only expansions — ${(z)…}, ${(@)…:#}, ${~pat} — are not sh;
#   SC2250  braces style, a rule for shell scripts (the file predates it);
#   SC2312  $(cmd | cmd) pipelines: their status is deliberately ignored;
#   SC2154  zsh's special arrays functions/commands/builtins "not assigned";
#   SC2004  $ in zsh arithmetic subscripts.
# Syntax is validated with `zsh -n`, which is the authoritative check here.
# Colours as literal ANSI sequences: 9 $(tput) calls = 9 forks (~8 ms
# of extra load time). \e[0m = sgr0, \e[3Nm = setaf N.
C_BLACK=$'\e[30m'
C_RED=$'\e[31m'
C_GREEN=$'\e[32m'
C_YELLOW=$'\e[33m'
C_BLUE=$'\e[34m'
C_MAGENTA=$'\e[35m'
C_CYAN=$'\e[36m'
C_WHITE=$'\e[37m'
C_BOLD=$'\e[1m'
C_RESET=$'\e[0m'

# ----------------------------------------------------------------------------------------------------------
distrodate() {
	# shellcheck disable=SC2012
	ls -lct /etc | tail -1 | awk '{print $6, $7, $8}'
}

# ----------------------------------------------------------------------------------------------------------
heure() {
	local hr jour
	hr=$(date '+%T')
	jour=$(date '+%A %d %B %Y')
	echo "${hr}, le ${jour}"
}

# ----------------------------------------------------------------------------------------------------------
nocomm() {
  # shellcheck disable=SC2312
  rg -v "^\s*(#|//|;)" --color=never "$@" | rg . | bat -p --file-name "$*"
}

# ----------------------------------------------------------------------------------------------------------
showpath() { # $PATH, or any colon-separated string: one entry per line
    if (( $# )); then
        print -rl -- ${(s.:.)1}
    else
        print -rl -- ${(s.:.)PATH}
    fi
}
# ----------------------------------------------------------------------------------------------------------
showfpath() { # $fpath, or any space-separated string: one entry per line
    if (( $# )); then
        print -rl -- ${=1}
    else
        print -rl -- "${(@)fpath}"
    fi
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
logerror() { # deduplicated errors for the current boot
	# shellcheck disable=SC2312
  journalctl --no-hostname -b 0 -p3 --no-pager -q 2>&1 | awk '{key=substr($0,index($0,$4)); if(!seen[key]++) print $0}'
}

# ----------------------------------------------------------------------------------------------------------
help() { # colored help
	#shellcheck disable=SC2312
	if (( $# == 0 )); then
		print -r -- "usage: help COMMANDE [ARG…]" >&2
		return 1
	fi
	local cmd=$1
	shift
	local -a words

	# Resolve the alias: `help ls` must document what `ls` really runs
	# (eza), not /usr/bin/ls. Compound aliases (`;`, `|`) are skipped.
	if [[ -n ${aliases[$cmd]} && ${aliases[$cmd]} != *[';|&<>']* ]]; then
		words=( "${(@z)aliases[$cmd]}" )
		# no recursion risk: a word coming from an array expansion is never
		# subject to alias expansion
		"${words[@]}" --help "$@" 2>&1 | \bat --plain --language=help
	elif (( $+functions[$cmd] )); then
		# shell functions have no --help: `help view` used to run
		# `view --help`, i.e. an error about a file named "--help".
		functions "$cmd" | \bat --plain --file-name "functions $cmd"
	elif (( $+commands[$cmd] )); then
		# explicit path rather than the `bathelp` alias: a function sourced
		# from a .zwc (zcompile) is parsed outside alias scope. The full path
		# also avoids a builtin of the same name shadowing the real command.
		"${commands[$cmd]}" --help "$@" 2>&1 | \bat --plain --language=help
	elif (( $+builtins[$cmd] )); then
		if (( $+functions[run-help] )); then
			run-help "$cmd" 2>&1 | \bat --plain --language=help
		else
			print -u2 "help: $cmd est une commande interne de zsh (voir « man zshbuiltins »)"
			return 1
		fi
	else
		print -u2 "help: commande introuvable: $cmd"
		return 1
	fi
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
	local host="$1" out time_ms time_int
	[[ -z "${host:-}" ]] && host="free.fr"
	out=$(LC_ALL=C /usr/bin/ping -c 1 -W 1 "${host}" 2>/dev/null)
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
		channel=$(iw dev "${iface}" link 2>/dev/null | awk '/freq:/ { print $2; exit }')
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
# Interactive history — two deliberately different behaviours:
#   Up arrow   → fzf-history (below): grey number, Tab = insert without running;
#   CTRL-R     → fzf-history-widget, provided by the `fzf --zsh` integration loaded
#                further down in _load_deferred, which overrides the bind below.
fzf-history() { # atuin-style history without sync
  setopt localoptions noglobsubst noposixstrings pipefail extendedglob
  local raw key selected num n

  # fc -rl 1 prints one entry per line, multi-line commands being escaped
  # there as a literal `\n`: the awk un-escapes them (real newline) and
  # emits each entry NUL-separated (--read0), prefixed with the event number and
  # a tab. Same mechanism as fzf's official integration, so multi-line
  # entries are displayed across several lines.
  #   Format of a raw line is `%5s%c ` (Src/builtin.c, fclist): the event
  #   number, then `*` when the entry is HIST_FOREIGN — a command run in
  #   another shell and imported through SHARE_HISTORY — then a space.
  #   That asterisk must not reach the list as text, but the information is
  #   worth keeping: such entries get a discreet grey marker in the displayed
  #   field instead (grey 244, faint enough to read as a margin mark). Local
  #   entries get two spaces, so every line stays aligned. The marker lives in
  #   field 2 only — field 1 stays the bare number, which is all fzf returns.
  #   The glyph must exist in the terminal font and be one cell wide, or the
  #   alignment breaks: Maple Mono NF (kitty) has ⇄ U+21C4, ┆ U+2506, ▪, •, ↪,
  #   but NOT ⧉ U+29C9. Change `mark` to switch; the fallback below knows the
  #   common ones.
  #   --with-nth=2..  : the list only shows the command (the number stays in
  #                     field 1, hidden);
  #   --accept-nth=1  : fzf returns only the number, single-line output with no
  #                     ambiguity against the --expect key line; the command is
  #                     then re-read from ${history[n]}, the only exact source of \n.
  raw=$(fc -rl 1 | awk '
    BEGIN { mark = "⇄" }
    { cmd = $0; sub(/^[ \t]*[0-9]+\*?[ \t]+/, "", cmd)
      foreign = ($1 ~ /\*$/)
      num = $1; sub(/\*$/, "", num)
      gsub(/\\n/, "\n", cmd)
      prefix = foreign ? sprintf("%c[38;5;244m%s%c[0m ", 27, mark, 27) : "  "
      printf "%04d\t%s%s%c", num, prefix, cmd, 0 }' |
    fzf --read0 --with-nth=2.. --accept-nth=1 --delimiter=$'\t' \
      --no-sort --exact \
      --bind='ctrl-r:toggle-sort' --expect=tab,enter \
      --query="${BUFFER}" +m --height=70% --no-scrollbar --ansi || true)

  key=${raw%%$'\n'*}
  if [[ ${raw} != *$'\n'* ]]; then     # Esc / nothing selected: buffer untouched
    zle reset-prompt
    return 0
  fi
  selected=${raw#*$'\n'}
  zle reset-prompt
  [[ -z ${selected} ]] && return 0

  # number from field 1 (colours stripped), then the entry really re-read
  # from the zsh history: that is what restores the real newlines of
  # multi-line commands, which fc output escapes as `\n`.
  num=${selected%%$'\t'*}
  num=${num//$'\033'\[[0-9;]##m/}
  if [[ ${num} == [0-9]## ]]; then
    n=$(( 10#${num} ))
    if [[ -n ${history[$n]} ]]; then
      BUFFER=${history[$n]}
      CURSOR=${#BUFFER}
      zle redisplay
      [[ ${key} == enter ]] && zle accept-line
      return 0
    fi
  fi
  # fallback: use the displayed text as is, minus a leftover `NNNN` / `NNNN*`
  # prefix or the grey ⧉ marker of a foreign entry
  BUFFER=${selected#*$'\t'}
  if [[ ${BUFFER} =~ '^[0-9]+[*]? +' ]]; then
    BUFFER=${BUFFER#${MATCH}}
  fi
  if [[ ${BUFFER} =~ $'^(\e\\[[0-9;]*m)*[⇄⧉┆▪▫↪] ' ]]; then
    BUFFER=${BUFFER#${MATCH}}
  fi
  CURSOR=${#BUFFER}
  zle redisplay
  [[ ${key} == enter ]] && zle accept-line
}
zle -N fzf-history                    # registers fzf-history as a ZLE widget
# previous version (lookup by number + (z)) backed up in
# ~/.local/share/zsh-backups/functions.sh-20261113-215345.bak
bindkey '^R' fzf-history              # overwritten by the fzf integration (see header)
bindkey '^[[A' fzf-history            # also bound to the Up arrow
bindkey "^[[1;5A" up-line-or-history  # Ctrl-Up for normal behaviour without fzf

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
           	[[ "${nocomm:-}" != "-n" ]] && \bat -pfSn --squeeze-blank -- "${f}" || rg -v "^\s*(#|//|;)" --color=never -- "${f}" | rg . | bat -p --file-name "${f}"
           ;;
    esac
}

# ----------------------------------------------------------------------------------------------------------

LOG() { # journalctl without the noisy "audit" transport
    local -a t=()
    local line
    while IFS= read -r line; do # collect every systemd TRANSPORT except "audit"
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

    local term_cols=${COLUMNS:-80}
    (( term_cols -= 2 ))
    (( term_cols > 0 )) || term_cols=78

    print -- "${color}"

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

maj(){ # full Omarchy update	
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

# zap only understands its own flags (-c -m -d -t -s -f -r -v,
# --no-preserve-root, --version). Anything else (`cp -a`, `mv -n`, `cp -t`,
# `rm -d`, `--preserve=…`) makes it abort with "unknown shorthand flag" or
# "conflicting modes" where coreutils would have worked, so those calls are
# handed to the real command instead.
_zap_safe() { # $1: accepted-options pattern, rest: the user's arguments
	setopt localoptions extendedglob # for the `##` in the patterns below
	local pat=$1 a
	shift
	for a in "$@"; do
		[[ $a == -* ]] || continue
		# ${~pat} is matched as a glob on purpose: it is the allowed-options
		# pattern, not a literal.
		# shellcheck disable=SC2053
		[[ $a == ${~pat} ]] || return 1
	done
	return 0
}

# ----------------------------------------------------------------------------------------------------------

rm(){
	if command -v zap &>/dev/null && _zap_safe '-[frRv]##|--recursive|--force|--verbose' "$@"; then
		zap -t -v "$@"
	else
		# `command` is mandatory: a bare `rm` here would call this function again
		# and abort with "maximum nested function level reached".
		command rm -Iv --preserve-root "$@"
	fi
}

# ----------------------------------------------------------------------------------------------------------

cp(){
	if command -v zap &>/dev/null && _zap_safe '-[frRv]##|--recursive|--force|--verbose' "$@"; then
		zap -c -v "$@"
	else
		command cp -iv "$@"
	fi
}

# ----------------------------------------------------------------------------------------------------------

mv(){
	if command -v zap &>/dev/null && _zap_safe '-[fv]##|--force|--verbose' "$@"; then
		zap -m -v "$@"
	else
		command mv -iv "$@"
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

# ----------------------------------------------------------------------------------------------------------

s() { # replay the previous command line with sudo, without eval
	local line
	local -a reply

	line=$(fc -ln -1)
	line=${line#"${line%%[![:blank:]]*}"}
	_sudo_words "$line" || return 1
	sudo "${reply[@]}"
}

# Shared with s(): turn an already-typed command line into the words to hand to
# sudo. Sets `reply`; prints the reason and returns 1 when the line cannot be
# replayed under sudo. Kept separate so it can be tested without a tty.
_sudo_words() {
	local line=$1
	local -a words
	local -a meta
	local -A seen
	local w n=0

	words=( "${(@z)line}" )
	words=( "${(@)words:#}" ) # drop empty words (empty line, trailing blanks)
	if (( ${#words} == 0 )); then
		print -u2 's: aucune commande précédente'
		return 1
	fi

	# The command word is resolved the way the parser would. `ll` is an alias
	# for `ls -lh`, itself an alias for eza, and `alias sudo='\sudo '` only
	# works because its trailing space makes zsh alias-expand the next word —
	# which is exactly why `sudo ll` typed by hand succeeds. Words rebuilt from
	# a string are never alias-expanded by zsh, so do it here, one level at a
	# time; `seen` reproduces zsh's "alias already in use" stop, which is what
	# keeps `alias eza='eza --git'` from looping forever.
	while (( n++ < 10 )) && [[ -n ${aliases[${words[1]}]} && -z ${seen[${words[1]}]} ]]; do
		seen[${words[1]}]=1
		words=( "${(@z)aliases[${words[1]}]}" "${words[@]:1}" )
	done
	# `sudo foo`: rerunning it under sudo means dropping the redundant word.
	# (`case` rather than `[[ $x == (a|b) ]]`: the latter is a zsh-only glob
	# that makes shellcheck abort, while `case` is understood by both.)
	case ${words[1]} in
		sudo) words=( "${words[@]:1}" ) ;;
		*) ;;
	esac
	if (( ${#words} == 0 )); then
		print -u2 's: aucune commande à relancer'
		return 1
	fi

	# sudo only sees executables: zsh functions and builtins are invisible to
	# it. So `s` follows sudo's rule: when a binary of that name exists, run it
	# (that is what makes `s` work after `id`, `ss`, `df`…, whose grc wrappers
	# are display-only), and refuse only when there is no binary at all.
	local bin=${commands[${words[1]}]}
	if [[ -z ${bin} ]]; then
		print -u2 "s: « ${words[1]} » n'est pas un exécutable : le wrapper s ne peut relancer qu'un binaire"
		print -u2 '   (sudo ne voit ni les fonctions shell ni les commandes internes)'
		return 1
	fi
	# Explain only when a real function is bypassed. The grc colour wrappers
	# (`grc --colour=auto <cmd>`, see grc-wrappers.zsh) only add colour, which
	# nobody expects from a root command. Note that `$functions[…]` hands back
	# the body indented with a tab, hence the leading-blank stripping.
	local body=${functions[${words[1]}]}
	body=${body#"${body%%[![:blank:]]*}"}
	if [[ -n ${body} && ${body%%$'\n'*} != 'grc --colour=auto '* ]]; then
		print -u2 "s: fonction shell « ${words[1]} » ignorée, sudo lance ${bin}"
	fi

	# `eval "sudo …"` only escalated the first word: after `true; rm -rf x`,
	# the part following `;` ran as the user, without any prompt. Splitting the
	# words puts everything under sudo, hence a compound line is refused
	# outright instead of being half-executed.
	for w in "${words[@]}"; do
		case $w in
			';'|';;'|'|'|'||'|'&'|'&&'|'>'|'>>'|'<'|'<<'|'|&'|'('|')') meta=1 ;;
			*) ;;
		esac
	done
	# '$(' and '`' are searched as literal text here, never expanded.
	# shellcheck disable=SC2016
	if (( ${#meta} )) || [[ $line == *'$('* || $line == *'`'* ]]; then
		print -u2 's: commande composée, relance-la explicitement :'
		print -u2 "    sudo ${(j: :)words}"
		return 1
	fi
	reply=( "${words[@]}" )
}
