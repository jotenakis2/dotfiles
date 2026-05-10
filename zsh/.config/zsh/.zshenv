setopt +o nomatch interactive_comments
zmodload zsh/parameter

# evalcache
ZSH_EVALCACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/evalcache"

# RUST
export RUSTUP_HOME="/opt/rustup"
export CARGO_HOME="/opt/cargo"

# GO
export GOROOT=/opt/go
export GOPATH=/opt/go/workspace
export GOBIN=/opt/go/workspace/bin

# PATH
typeset -U PATH
export PATH="$HOME/git/scripts:$PATH"

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
		alias eza='eza --git --header --group-directories-first --color'
		alias ls='eza'
		alias ll='ls -lh'
		alias la='ls -alh'
		alias lt='\eza -T --color -L 4'
		precmd() { echo }
		PROMPT='%B%F{green}%n%F{white}:%F{blue}%~ '$'
''%F{blue}>%F{reset} '
	else
		alias eza='eza --git --header --group-directories-first --color-scale all --color --icons'
		alias ls='eza'
		alias ll='ls -lh'
		alias la='ls -alh'
		alias lt='\eza -T --color --icons -L 4'	
	fi
}
