# fpath
fpath=(~/.local/share/zsh/completions $fpath)

# History & correct
HISTFILE="$HOME"/.local/share/zsh/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt EXTENDED_HISTORY SHARE_HISTORY HIST_IGNORE_ALL_DUPS HIST_IGNORE_SPACE correct
SPROMPT='Corriger %B%F{red}%U%R%b%f%u en %F{green}%r%f%u ? [%B%F{blue}y%f%bes|%B%F{blue}n%f%bo|%B%F{blue}e%f%bdit|%B%F{blue}a%f%bbort]'

# sheldon plugin manager (cf ~/.config/sheldon/plugins.toml)
if command -v sheldon >/dev/null 2>&1; then
	eval "$(sheldon source)"
fi

# coloration syntaxique 
if command -v zsh-patina >/dev/null 2>&1; then
	eval "$(zsh-patina activate)"
fi

# autocompletion
autoload -Uz compinit
zsh-defer compinit_with_ttl

# terminal screen saver
if command -v drift >/dev/null 2>&1; then
    _evalcache drift shell-init zsh
fi

# config fzf-tab
zsh-defer zstyle ':fzf-tab:*' use-fzf-default-opts yes
zsh-defer zstyle ':fzf-tab:complete:z:*' fzf-preview 'eza -1 --color=always $realpath'
zsh-defer zstyle ':fzf-tab:complete:eza:*' fzf-preview 'eza -1 --color=always $realpath'
