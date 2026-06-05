setopt +o nomatch interactive_comments
zmodload zsh/parameter

# evalcache
ZSH_EVALCACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/evalcache"

# zsh-patina
export ZSH_PATINA_CONFIG_PATH="$HOME/.config/zsh/patina/config.toml"

# sheldon 
export SHELDON_CONFIG_DIR="$HOME/.config/zsh/sheldon"
export SHELDON_DATA_DIR="$HOME/.local/share/zsh"
export SHELDON_CONFIG_FILE="$SHELDON_CONFIG_DIR/plugins.toml"

# RUST
export RUSTUP_HOME=/opt/rustup
export CARGO_HOME=/opt/cargo

# GO
export GOROOT=/opt/go
export GOPATH=/opt/go/workspace
export GOBIN=/opt/go/workspace/bin

# PATH
typeset -U PATH
export PATH="$HOME/.local/bin:$HOME/Projects/scripts:$GOROOT/bin:$GOBIN:$CARGO_HOME/bin:${PATH}"

# ENV
. "$ZDOTDIR/exports"

# recompilation toutes les 2880 min (2 jours)
_compinit_with_ttl() {
        setopt local_options
        local zcompdump="$ZDOTDIR/zcompdump"
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
		if command -v eza &>/dev/null; then 
			alias eza='eza --git --header --group-directories-first --color --group'
			alias ls='eza'
			alias lt='\eza -T --color -L 4'
		else
			alias ls='ls --color=always --group-directories-first'
			alias lt='tree -L 4'
		fi
		alias ll='ls -lh'
		alias la='ls -alh'
	
		precmd() { echo }
		PROMPT='%B%F{green}%n%F{white}:%F{blue}%~ '$'
''%F{blue}>%F{reset} '

	else
		if command -v eza &>/dev/null; then
			alias eza='eza --git --header --group-directories-first --color-scale all --color --icons --group'
			alias ls='eza'
			alias lt='\eza -T --color -L 4'
		else
			alias ls='ls --color=always --group-directories-first'
			alias lt='tree -L 4'
		fi		
		alias ll='ls -lh'
		alias la='ls -alh'
	fi
}
