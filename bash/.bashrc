[[ $- == *i* ]] || return
PS1='\n\[\e[1;33m\]\u\[\e[0m\]:\[\e[1;34m\]\w\[\e[0m\]\n❯ '

HISTFILE="${XDG_DATA_HOME:-$HOME/.local/share}/bash/history"
HISTSIZE=10000
HISTFILESIZE=10000
shopt -s histappend
mkdir -p -- "${HISTFILE%/*}"

source "$HOME/.local/share/blesh/ble.sh" --noattach
source "$HOME/.config/sheldon/olivier/aliases"

eval "$(zoxide init bash)"

source /etc/profile.d/bash_completion.sh

ble-attach
