export PATH="$HOME/.cargo/bin:$HOME/.local/bin:/var/lib/snapd/snap/bin:/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin"
[ -f "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh" ] && source "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh"
eval "$($HOME/.local/bin/oh-my-posh -c $HOME/.config/ohmyposh/config.json init zsh)"
eval "$(atuin init zsh)"
eval "$(zoxide init zsh)"
eval "$(batman --export-env)"
plug "zsh-users/zsh-autosuggestions"
plug "zap-zsh/supercharge"
plug "zsh-users/zsh-syntax-highlighting"
plug "Aloxaf/fzf-tab"
plug "zap-zsh/sudo"
source /etc/grc.zsh
source "$HOME"/.aliases
source "$HOME"/.exports
source "$HOME"/.functions
setopt correct
SPROMPT='Corriger %B%F{red}%U%R%b%f%u en %F{green}%r%f%u ? [%B%F{blue}y%f%bes|%B%F{blue}n%f%bo|%B%F{blue}e%f%bdit|%B%F{blue}a%f%bbort] '
# Load and initialise completion system
autoload -Uz compinit
compinit
