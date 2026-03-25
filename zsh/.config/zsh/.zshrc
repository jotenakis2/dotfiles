# History & correct
HISTFILE="$HOME"/.local/share/zsh/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt EXTENDED_HISTORY SHARE_HISTORY HIST_IGNORE_ALL_DUPS HIST_IGNORE_SPACE correct
SPROMPT='Corriger %B%F{red}%U%R%b%f%u en %F{green}%r%f%u ? [%B%F{blue}y%f%bes|%B%F{blue}n%f%bo|%B%F{blue}e%f%bdit|%B%F{blue}a%f%bbort]'

# sheldon zsh plugin manager (cf ~/.config/sheldon/plugins.toml)
eval "$(sheldon source)"

# config fzf-tab
zsh-defer zstyle ':fzf-tab:*' use-fzf-default-opts yes
zsh-defer zstyle ':fzf-tab:complete:z:*' fzf-preview 'eza -1 --color=always $realpath'
zsh-defer zstyle ':fzf-tab:complete:eza:*' fzf-preview 'eza -1 --color=always $realpath'







# autocompletion - recompilation toutes les 24h min ou asynchrone (background)
# () {
# 	  setopt local_options
# 	  local zcompdump="$HOME/.zcompdump"
# 	  local zcomp_ttl=1    # 1 jour
# 
# 	  autoload -Uz compinit
# 	  [[ ! -f "$zcompdump" ]] && {
# 	    compinit -d "$zcompdump"
# 	    echo "création dump car inexistant"
# 	    return 0
# 	  }
# 	  if [[ -n "$(find "$zcompdump" -mtime "+$zcomp_ttl" 2>/dev/null)" ]]; then
# 	    echo "dump ancien on recompile"
# 	    compinit -d "$zcompdump"
# 	    return 0
# 	  fi
# 	  compinit -CD -d "$zcompdump"
# 	  (autoload -Uz compinit; compinit -d "$zcompdump" &)
# }


