# Native prompt, no fork.
#
# Reproduces the oh-my-posh theme byte for byte (black block: OS icon,
# user@host, path; second line: exit code + ❯) and the transient prompt
# (the line collapses to "❯ " once accepted), which is the only thing the
# oh-my-posh setup was kept for.
#
# Enabled with ZSH_PROMPT=native; ZSH_PROMPT=omp keeps oh-my-posh.
# Cost: ~1 ms per prompt instead of ~13 ms (no Go binary spawned).

# glyphs
typeset -g _NP_SEP=$'\ue0b4'
typeset -g _NP_IC_OS=$'\uf17c'
typeset -g _NP_IC_USER=$'\uf007'
typeset -g _NP_IC_DIR=$'\uf413'

# black block, blue text: identical colouring to the oh-my-posh config
typeset -g _NP_BLOCK="%K{black}%F{blue} ${_NP_IC_OS} %f%F{black}${_NP_SEP}%K{black}%F{blue}${_NP_IC_USER} %n@%m %f%F{black}${_NP_SEP}%K{black}%F{blue}${_NP_IC_DIR}  %~ %f%F{black}${_NP_SEP}%k%f"

# transient prompt: "❯ " in the theme's accent colour
typeset -g _NP_TRANSIENT="%F{blue}❯%f "

_np_precmd() {
	local code=$?
	# exit code only when non-zero, then the accent arrow on its own line
	if (( code )); then
		PROMPT="${_NP_BLOCK}"$'\n'"%F{blue}${code}❯%f "
	else
		PROMPT="${_NP_BLOCK}"$'\n'"%F{blue}❯%f "
	fi
	RPROMPT=''
}

# called when the line is accepted: redraw it with the transient prompt, which
# is what makes the long prompt collapse before the command runs
_np_line_finish() {
	PROMPT="${_NP_TRANSIENT}"
	zle reset-prompt
}

autoload -Uz add-zsh-hook
add-zsh-hook precmd _np_precmd
zle -N zle-line-finish _np_line_finish
_np_precmd
