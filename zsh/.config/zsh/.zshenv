# evalcache
ZSH_EVALCACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/evalcache"

# RUST
export RUSTUP_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/rustup"
export CARGO_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/cargo"

# GO
export GOPATH="${XDG_DATA_HOME:-$HOME/.local/share}/go"
export GOBIN="${XDG_BIN_HOME:-$HOME/.local/bin}"

# PATH
typeset -U PATH
export PATH="$HOME/scripts:$GOBIN:$CARGO_HOME/bin:/usr/local/go/bin:$PATH"

# ENV
. "$ZDOTDIR/.exports"

# recompilation toutes les 2880 min (2 jours)
_compinit_with_ttl() {
        setopt local_options
        local zcompdump="$ZDOTDIR/.zcompdump"
        local zcomp_ttl=2880

        if [[ ! -f "$zcompdump" ]]; then # n'existe pas
                compinit -d "$zcompdump"
                return 0
        fi
        if [[ -n "$(find "$zcompdump" -mmin "+$zcomp_ttl" -print -quit 2>/dev/null)" ]]; then # trop vieux
                rm -f "$zcompdump"
                compinit -d "$zcompdump"
                return 0
        fi
        compinit -C -D -d "$zcompdump" # on charge au plus rapide
		return 0
}

# en VCONSOLE pas d'icones, prompt basic sans ohmyposh
_vconsole() {
	if [[ "$TERM" = "linux" ]]; then
		alias eza='eza --git --header --group-directories-first --color=always':
		alias ls='eza'
		alias ll='ls -lh'
		alias la='ls -alh'
		alias lt='\eza -T --color -L 4'
		precmd() { echo }
		PROMPT='%B%F{green}%n%F{white}:%F{blue}%~ '$'
''%F{blue}>%F{reset} '
	else
		alias eza='eza --git --header --group-directories-first --color-scale all --color=always --icons'
		alias ls='eza'
		alias ll='ls -lh'
		alias la='ls -alh'
		alias lt='\eza -T --color --icons -L 4'	
	fi
}
