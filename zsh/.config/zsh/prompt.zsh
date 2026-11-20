# Native prompt, no fork.
#
# Black block with user@host and path; second line with the exit code
# (only when non-zero) and the ❯ arrow. When a line is accepted it collapses to
# that ❯ arrow: the transient prompt.
#
# The path is an OSC 8 hyperlink to its own directory: ctrl+shift+clic in kitty
# opens it (xdg-open -> the registered inode/directory handler).
#
# Cost: ~1-5 ms per prompt, nothing spawned.

# glyphs
typeset -g _NP_SEP=$'\ue0b4'
typeset -g _NP_IC_USER=$'\uf007'
typeset -g _NP_IC_DIR=$'\uf413'

# zsh prompt escapes have no italic and no link (only %B bold, %U underline,
# %S standout): SGR and OSC have to go through raw ANSI. The %{ %} delimiters are
# not cosmetic — they tell zsh the sequence takes no cell, otherwise every prompt
# shifts right.
typeset -g _NP_IT_ON=$'%{\e[3m%}'
typeset -g _NP_IT_OFF=$'%{\e[23m%}'
typeset -g _NP_LINK_OFF=$'%{\e[24m\e]8;;\a%}'

# black block, blue icons and host (italic), cyan user, blue path
# The path lives between HEAD and TAIL because its hyperlink is built at each
# prompt from $PWD; HEAD brings its own foreground/background.
typeset -g _NP_BLOCK_HEAD="%F{blue}${_NP_IC_USER}%f%F{cyan} %n%f%F{blue}@${_NP_IT_ON}%m${_NP_IT_OFF} %f%F{black}${_NP_SEP}%K{black}%F{blue}${_NP_IC_DIR}  "
typeset -g _NP_BLOCK_TAIL=" %f%F{black}${_NP_SEP}%k%f"

# transient prompt: "❯ " in the theme's accent colour
typeset -g _NP_TRANSIENT="%F{cyan}❯%f "

# a blank line above the prompt keeps it clear of the previous command's output.
# It only starts once a command has actually run (preexec), so a fresh terminal
# opens on the prompt itself and not on an empty line. The transient prompt below
# repeats it for the same reason: without it the collapse would overwrite the blank
# line and history would come out with commands stacked on each other.
typeset -g _NP_LEAD=0

# REPLY = file:// URI of a directory, fork-free (no $( ) : a subshell is exactly
# the 2-3 ms this prompt exists to avoid). Only the characters that break a URI are
# escaped; UTF-8 is left alone, file managers accept it, and %-escaping raw bytes
# without a subshell would cost far more. '%' goes first, so a path containing '%}'
# cannot close the prompt's %{ %} delimiters.
_np_file_url() {
	local s=$1
	s=${s//\%/%25}
	s=${s// /%20}
	s=${s//\#/%23}
	s=${s//\?/%3F}
	s=${s//&/%26}
	s=${s//+/%2B}
	s=${s//\"/%22}
	s=${s//\'/%27}
	s=${s//</%3C}
	s=${s//>/%3E}
	s=${s//\\/%5C}
	s=${s//^/%5E}
	s=${s//\`/%60}
	s=${s//\{/%7B}
	s=${s//\}/%7D}
	s=${s//\|/%7C}
	s=${s//\[/%5B}
	s=${s//\]/%5D}
	s=${s//$'\t'/%09}
	s=${s//$'\n'/%0A}
	REPLY="file://${s}"
	# prompt expansion scans this string again: every '%' has to be doubled, or
	# '%20' is read as a prompt escape and the URI reaches the terminal mangled
	REPLY=${REPLY//\%/%%}
}

_np_precmd() {
	local code=$? lead='' link_on
	(( _NP_LEAD )) && lead=$'\n'
	# the path: OSC 8 around %~, underlined like a URL
	_np_file_url "$PWD"
	link_on=$'%{\e]8;;'"${REPLY}"$'\a\e[4m%}'
	local block="${_NP_BLOCK_HEAD}${link_on}%~${_NP_LINK_OFF}${_NP_BLOCK_TAIL}"
	# exit code only when non-zero, then the accent arrow on its own line
	if (( code )); then
		PROMPT="${lead}${block}"$'\n'"%F{red}${code}❯%f "
	else
		PROMPT="${lead}${block}"$'\n'"%F{cyan}❯%f "
	fi
	RPROMPT=''
}

_np_preexec() { _NP_LEAD=1 }

# kitty tab title. kitty's own shell integration is not loaded here
# (shell_integration includes no-rc), so the shell publishes the title itself
# with OSC 2: the command while it runs, the directory name once the prompt is
# back. kitty redraws the tab on every title change, which is what keeps the
# label from going stale after a command exits.
_kitty_tab_title() {
	[[ -t 1 ]] || return 0
	local label
	if [[ -n ${1-} ]]; then
		local -a words=( ${(z)1} )
		label=${words[1]-}
	fi
	if [[ -z $label ]]; then
		label=${PWD:t}
		[[ $PWD == $HOME ]] && label='~'
	fi
	printf '\e]2;%s\a' "$label" >/dev/tty
}

# called when the line is accepted: redraw it with the transient prompt, which
# is what makes the long prompt collapse before the command runs. The leading
# newline is repeated here once commands have run, so the blank line stays above
# the command in scrollback instead of being overwritten by the collapse.
_np_line_finish() {
	local lead=''
	(( _NP_LEAD )) && lead=$'\n'
	PROMPT="${lead}${_NP_TRANSIENT}"
	zle reset-prompt
}

autoload -Uz add-zsh-hook
add-zsh-hook precmd _np_precmd
add-zsh-hook preexec _np_preexec
[[ -n ${KITTY_WINDOW_ID-} ]] && add-zsh-hook precmd _kitty_tab_title
[[ -n ${KITTY_WINDOW_ID-} ]] && add-zsh-hook preexec _kitty_tab_title
zle -N zle-line-finish _np_line_finish
_np_precmd
