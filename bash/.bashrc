[[ $- == *i* ]] || return
PS1='\n\[\e[1;33m\]\u\[\e[0m\]:\[\e[1;34m\]\w\[\e[0m\]\n❯ '

HISTFILE="${XDG_DATA_HOME:-$HOME/.local/share}/bash/history"
HISTSIZE=10000
HISTFILESIZE=10000
shopt -s histappend
mkdir -p -- "${HISTFILE%/*}"

if [[ "$TERM" = "linux" ]]; then
	alias eza='eza --git --header --group-directories-first --color=always':
	alias ls='eza'
	alias ll='ls -lh'
	alias la='ls -alh'
	alias lt='\eza -T --color -L 4'
else
	alias eza='eza --git --header --group-directories-first --color-scale all --color=always --icons'
	alias ls='eza'
	alias ll='ls -lh'
	alias la='ls -alh'
	alias lt='\eza -T --color --icons -L 4'
fi

source "$HOME/.local/share/blesh/ble.sh" --noattach
source "$HOME/.config/sheldon/olivier/aliases.sh"

eval "$(zoxide init bash)"

source /etc/profile.d/bash_completion.sh

ble-attach
