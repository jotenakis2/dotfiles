# fpath
fpath=(~/.local/share/zsh/completions $fpath)

# History & correct
[[ -d "${HOME}/.local/share/zsh" ]] || mkdir -p "${HOME}/.local/share/zsh"
HISTFILE="$HOME/.local/share/zsh/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000
setopt EXTENDED_HISTORY SHARE_HISTORY HIST_IGNORE_ALL_DUPS HIST_IGNORE_SPACE correct
SPROMPT='Corriger %B%F{red}%U%R%b%f%u en %F{green}%r%f%u ? [%B%F{blue}y%f%bes|%B%F{blue}n%f%bo|%B%F{blue}e%f%bdit|%B%F{blue}a%f%bbort]'

# sheldon plugin manager (cf ~/.config/sheldon/plugins.toml)
if command -v sheldon >/dev/null 2>&1; then
	eval "$(sheldon source)"
fi

# autocompletion
autoload -Uz compinit
zsh-defer _compinit_with_ttl

# config fzf-tab
zsh-defer zstyle ':fzf-tab:*' use-fzf-default-opts yes
zsh-defer zstyle ':fzf-tab:complete:z:*' fzf-preview 'eza -1 --color=always $realpath'
zsh-defer zstyle ':fzf-tab:complete:eza:*' fzf-preview 'eza -1 --color=always $realpath'

# mode vconsole (prompt basic, pas d'icones)
zsh-defer _vconsole
