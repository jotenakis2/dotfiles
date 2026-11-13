# ~/.zshrc — interactif uniquement (l'environnement est dans .zshenv)

# zsh/parameter : ni ici ni dans .zshenv, zsh 5.9 le charge au premier accès
# à $commands/$functions/$aliases/… (fzf, patina et consorts s'en chargent seuls)
zmodload -F zsh/stat b:zstat    # mtime sans fork
zmodload zsh/datetime           # $EPOCHSECONDS sans fork
setopt interactive_comments

# emacs mode pour bind touche début/fin
bindkey -e
bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line

# fpath
fpath=(~/.local/share/zsh/completions $fpath)

# History & correct
[[ -d "${HOME}/.local/share/zsh" ]] || mkdir -p "${HOME}/.local/share/zsh"
HISTFILE="$HOME/.local/share/zsh/zsh_history"
HISTSIZE=50000      # liste en mémoire pendant la session (recherche Ctrl-R)
SAVEHIST=5000       # ce qui est écrit dans le fichier : plafonné pour le démarrage
                    # (1 Mo d'historique = ~8 ms de plus avant le prompt)
setopt EXTENDED_HISTORY
setopt SHARE_HISTORY
setopt INC_APPEND_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_SAVE_NO_DUPS

# correction auto
setopt correct
SPROMPT='Corriger %B%F{red}%U%R%b%f%u en %F{green}%r%f%u ? [%B%F{blue}y%f%bes|%B%F{blue}n%f%bo|%B%F{blue}e%f%bdit|%B%F{blue}a%f%bbort]'

# sheldon plugin manager (cf ~/.config/zsh/sheldon/plugins.toml)
# Ne charge ici que le synchrone : grc, zsh-defer, fpath completions.
# La sortie de `sheldon source` est mise en cache et n'est régénérée que si
# plugins.toml ou plugins.lock change : le reste du temps, 2 zstat (builtin)
# au lieu d'un fork de sheldon (~10-14 ms sur le chemin critique).
_source_sheldon() {
	command -v sheldon >/dev/null 2>&1 || return 0
	local cache="$ZSH_INIT_CACHE_DIR/sheldon.zsh"
	local -a cm pm lm

	zstat -A pm +mtime -- "$SHELDON_CONFIG_FILE" 2>/dev/null
	zstat -A lm +mtime -- "$SHELDON_DATA_DIR/plugins.lock" 2>/dev/null
	if [[ -s $cache ]] && zstat -A cm +mtime -- "$cache" 2>/dev/null; then
		if (( ${cm[1]:-0} >= ${pm[1]:-0} && ${cm[1]:-0} >= ${lm[1]:-0} )); then
			source "$cache"
			return 0
		fi
	fi

	[[ -d $ZSH_INIT_CACHE_DIR ]] || mkdir -p "$ZSH_INIT_CACHE_DIR"
	sheldon source 2>/dev/null >| "$cache"
	if [[ -s $cache ]]; then
		source "$cache"
	else
		rm -f "$cache"
	fi
}
_source_sheldon

# ---------------------------------------------------------------------------
# Cache d'un script d'init binaire, versionné par la mtime du binaire.
# Remplace _evalcache (qui fork md5 à chaque shell) : zstat est un builtin,
# donc coût quasi nul quand le cache est à jour.
#   _cached_init mise activate zsh
# ---------------------------------------------------------------------------
_cached_init() {
	local name=${1:t}
	local bin
	bin=$(command -v -- "$1") || { eval "$*"; return }
	local cache="$ZSH_INIT_CACHE_DIR/$name.zsh"
	local -a bm cm

	zstat -A bm +mtime -- "$bin" 2>/dev/null || { eval "$*"; return }
	if [[ -s $cache ]]; then
		zstat -A cm +mtime -- "$cache" 2>/dev/null
		if [[ ${cm[1]:-0} -ge ${bm[1]:-0} ]]; then
			source "$cache"
			return
		fi
	fi

	[[ -d $ZSH_INIT_CACHE_DIR ]] || mkdir -p "$ZSH_INIT_CACHE_DIR"
	eval "$*" >| "$cache"
	zcompile "$cache" 2>/dev/null
	source "$cache"
}

# ---------------------------------------------------------------------------
# mise: `mise activate zsh` defines the mise() wrapper plus the precmd/chpwd
# hooks, and its tail runs `mise hook-env --force` (~30 ms) to seed the
# environment. We keep the definitions and replay that environment from a
# cache, regenerated only when the mise config, the binary or the PATH
# directories change.
# ---------------------------------------------------------------------------
_mise_env_write() { # full env for $HOME, minus mise's opaque session state
	local env="$ZSH_INIT_CACHE_DIR/mise-env.zsh"
	mise hook-env --force -s zsh --cd "$HOME" 2>/dev/null |
		grep -vE '^export __MISE_(DIFF|SESSION)=' >| "$env"
	zcompile "$env" 2>/dev/null

	# Sidecar list of the PATH entries this env defines. The startup check must
	# only validate mise's own directories: the rest of PATH contains entries
	# from exports.sh and other tools, some of them legitimately missing, and a
	# false positive there would trigger a full recompute on every shell.
	local -a lines pdirs mkeep
	local l md=${MISE_DATA_DIR:-$HOME/.local/share/mise}
	lines=( ${(f)"$(<$env)"} )
	for l in ${(M)lines:#export PATH=*}; do
		l=${l#export PATH=\'}
		pdirs+=( ${(s.:.)${l%\'}} )
	done
	# mise re-exports the whole PATH, including entries it does not own (ours
	# come from exports.sh, and some of those are legitimately absent on this
	# machine). Only mise's own directories are worth checking.
	for l in ${(u)pdirs}; do
		[[ $l == $md/* ]] && mkeep+=( $l )
	done
	print -rl -- $mkeep >| "$ZSH_INIT_CACHE_DIR/mise-env.dirs"
}

_load_mise() {
	(( $+commands[mise] )) || return 0
	local bin=${commands[mise]}
	local act="$ZSH_INIT_CACHE_DIR/mise-activate.zsh"
	local env="$ZSH_INIT_CACHE_DIR/mise-env.zsh"
	local -a deps
	local f d regen=0

	[[ -d $ZSH_INIT_CACHE_DIR ]] || mkdir -p "$ZSH_INIT_CACHE_DIR"

	# 1) definitions only: drop the seeding hook-env call and the two state
	#    exports that follow it (we set them ourselves once env is applied)
	if [[ ! -s $act || $bin -nt $act ]]; then
		mise activate zsh --cd "$HOME" 2>/dev/null |
			grep -vE '^(_mise_hook --force$|export __MISE_ZSH_ACTIVATE_(PATH|ENV)=)' >| "$act"
		zcompile "$act" 2>/dev/null
	fi
	source "$act"

	# 2) a mise config in (or above) the current directory makes the cached
	#    environment wrong: it must be computed for this directory
	d=$PWD
	while true; do
		for f in .mise.toml mise.toml .tool-versions; do
			[[ -f $d/$f ]] && regen=2
		done
		if (( regen == 2 )) || [[ $d == / ]]; then
			break
		fi
		d=${d:h}
	done

	if (( regen == 2 )); then
		eval "$(mise hook-env --force -s zsh --shell-pid $$ 2>/dev/null)"
	else
		deps=( "$HOME/.config/mise/config.toml" /etc/mise/conf.d/*.toml(N) "$bin" )
		[[ -s $env ]] || regen=1
		if (( ! regen )); then
			for f in $deps; do
				if [[ -e $f && $f -nt $env ]]; then
					regen=1
					break
				fi
			done
		fi
		(( regen )) && _mise_env_write
		source "$env"

		# `mise upgrade` can move a tool to a new versioned path
		# (go/1.27.4 -> go/1.28.0) without touching the watched files, so
		# check that the PATH entries this env defines still exist
		local -a mdirs
		local mdl="$ZSH_INIT_CACHE_DIR/mise-env.dirs"
		if [[ -s $mdl ]]; then
			mdirs=( ${(f)"$(<$mdl)"} )
			for f in $mdirs; do
				if [[ ! -d $f ]]; then
					_mise_env_write
					source "$env"
					break
				fi
			done
		fi
	fi

	# 3) state the precmd hook compares against: without it the first prompt
	#    would run hook-env again and cancel the saving
	export __MISE_ZSH_ACTIVATE_PATH="$PATH"
	export __MISE_ZSH_ACTIVATE_ENV="$(_mise_hook_env_state)"
}

# ---------------------------------------------------------------------------
# compinit : recompilation complète tous les 2 jours, sinon lecture du dump
# (+ .zwc compilé, ~2 ms au lieu de 5-8).
# ---------------------------------------------------------------------------
_compinit_with_ttl() {
	setopt local_options
	local zcompdump="$ZDOTDIR/zcompdump"
	local zcomp_ttl=2880   # minutes
	local -a mt

	autoload -Uz compinit
	if [[ -f $zcompdump ]] && zstat -A mt +mtime -- "$zcompdump" 2>/dev/null \
		&& (( EPOCHSECONDS - mt[1] <= zcomp_ttl * 60 )); then
		compinit -C -D -d "$zcompdump"
		return 0
	fi
	compinit -d "$zcompdump" && zcompile "$zcompdump" 2>/dev/null
	return 0
}

# ---------------------------------------------------------------------------
# en VCONSOLE pas d'icones, prompt basic sans ohmyposh
# ---------------------------------------------------------------------------
_vconsole() {
	zstyle ':fzf-tab:*' use-fzf-default-opts yes
	zstyle ':fzf-tab:complete:eza:*' fzf-preview 'eza -1 --color=always $realpath'

	if [[ "$TERM" = "linux" ]]; then # TTY
		if command -v eza &>/dev/null; then
			alias eza='eza --git --header --group-directories-first --color always --group -b'
			alias ls='eza'
			alias lt='\eza -T --color -L 4'
		else
			alias ls='ls --color=always --group-directories-first'
			alias lt='tree -L 4'
		fi
		precmd() { echo }
		PROMPT='%B%F{green}%n%F{white}:%F{blue}%~ '$'\n''%F{blue}>%F{reset} '

	else # terminal graphique
		if command -v eza &>/dev/null; then
			alias eza='eza --git --header --group-directories-first --color-scale all --color always --icons always --group -b --hyperlink=auto'
			alias ls='eza'
			alias lt='eza -T -L 4'
		else
			alias ls='ls --color=always --group-directories-first --hyperlink=auto'
			alias lt='tree -L 4'
		fi
	fi

	alias ll='ls -lh'
	alias la='ls -Alh'
	alias l='ls -A1'

	# Intégration fzf (^R historique, ^T fichiers, Alt-C cd) chargée à la demande :
	# son source coûte ~5 ms au démarrage et ces touches servent rarement. Les
	# widgets ci-dessous chargent puis délèguent ; l'intégration rebinde ensuite les
	# touches sur ses propres widgets (le stub n'est utilisé qu'une fois).
	# Tab n'est PAS touché ici : l'intégration capture `bindkey '^I'` au chargement
	# pour son repli, il faut donc que ce soit encore le binding de fzf-tab.
	_fzf_integration() {
		(( ${+_FZF_INTEGRATION_LOADED} )) && return 0
		typeset -g _FZF_INTEGRATION_LOADED=1
		_cached_init fzf --zsh
	}
	_fzf_lazy_history() { _fzf_integration; zle fzf-history-widget }
	_fzf_lazy_file() { _fzf_integration; zle fzf-file-widget }
	_fzf_lazy_cd() { _fzf_integration; zle fzf-cd-widget }
	zle -N _fzf_lazy_history
	zle -N _fzf_lazy_file
	zle -N _fzf_lazy_cd
	bindkey '^R' _fzf_lazy_history
	bindkey '^T' _fzf_lazy_file
	bindkey '\ec' _fzf_lazy_cd
}

# ---------------------------------------------------------------------------
# Tout le différé passe par UN SEUL zsh-defer.
# Chaque zsh-defer supplémentaire déclenche un rendu complet du prompt par
# oh-my-posh (7-12 ms) : 10 tâches = ~70 ms de rendus inutiles au démarrage.
# ---------------------------------------------------------------------------
_load_deferred() {
	local d=$SHELDON_DATA_DIR/repos/github.com
	local f

	# colorisation grc : wrappers minimaux (14 commandes au lieu des 42 de
	# /etc/grc.zsh), calibrés sur l'historique — cf grc-wrappers.zsh.
	# Différé car inutile avant la 1re commande tapée.
	source "$ZDOTDIR/grc-wrappers.zsh"

	# complétions d'abord (fzf-tab s'y accroche)
	_compinit_with_ttl

	# plugins déjà clonés par sheldon, chargés ici (cf plugins.toml)
	source "$d/Aloxaf/fzf-tab/fzf-tab.plugin.zsh"
	source "$d/zsh-users/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh"
	source "$d/z-shell/zsh-zoxide/zsh-zoxide.plugin.zsh"

	# alias + fonctions perso (tous les fichiers du dossier)
	for f in "$ZDOTDIR"/sheldon/alias/*.sh(N); do
		source "$f"
	done

	# zsh n'utilise un .zwc que s'il est plus récent que le source et ne le
	# régénère jamais lui-même : on recompile ici (différé, donc après le prompt)
	# quand un fichier a été édité ou remplacé. `-nt` est un builtin : aucun coût
	# quand tout est à jour ; un seul zcompile quand ça vient de changer.
	#   - fichiers d'alias (sheldon/alias/*.sh)
	#   - script d'init de oh-my-posh (~/.cache/oh-my-posh/init.*.zsh), régénéré
	#     par omp à chaque mise à jour
	# Les autres .zwc sont entretenus là où ils sont produits : ceux de
	# ~/.cache/zsh/initcache/*.zsh par _cached_init, zcompdump.zwc par
	# _compinit_with_ttl. sheldon.zsh n'est volontairement pas compilé (0 gain).
	_recompile_caches() {
		local f
		for f in "$ZDOTDIR"/sheldon/alias/*.sh(N) \
			"${XDG_CACHE_HOME:-$HOME/.cache}"/oh-my-posh/init.*.zsh(N); do
			[[ $f.zwc -nt $f ]] || zcompile "$f" 2>/dev/null
		done
	}
	_recompile_caches

	# coloration syntaxique
	_cached_init zsh-patina activate

	# gestionnaire de versions + prompt
	_load_mise
	[[ $TERM != "linux" ]] && _cached_init oh-my-posh init zsh --config "$HOME/.config/zsh/ohmyposh/config.json"

	# oh-my-posh met en cache la configuration RÉSOLUE pour chaque session
	# (~/.cache/oh-my-posh/zsh.$POSH_SESSION_ID.omp.cache) : une modification de
	# config.json n'y est donc pas vue, ni dans les terminaux déjà ouverts ni dans
	# leurs sous-shells (qui héritent du POSH_SESSION_ID). On jette le cache de la
	# session s'il est plus ancien que la config ; omp le reconstruit au prompt.
	if [[ -n ${POSH_SESSION_ID:-} && -n ${TERM:-} && $TERM != linux ]]; then
		local _omp_cfg="$HOME/.config/zsh/ohmyposh/config.json"
		local _omp_cache="$HOME/.cache/oh-my-posh/zsh.${POSH_SESSION_ID}.omp.cache"
		[[ $_omp_cfg -nt $_omp_cache ]] && rm -f "$_omp_cache"
	fi

	# alias eza/ls, fzf --zsh, prompt TTY
	_vconsole
}

zsh-defer _load_deferred

# VLC 3 est un client X11 (XWayland) : Qt5 ignore donc le scale Wayland et son
# UI est deux fois trop petite. On force le facteur, comme GDK_SCALE pour GTK.
vlc() { QT_SCALE_FACTOR=${QT_SCALE_FACTOR:-2} command vlc "$@"; }
