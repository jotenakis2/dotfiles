# ~/.zshrc — interactive only (the environment lives in .zshenv)

# zsh/parameter: neither here nor in .zshenv, zsh 5.9 loads it at first access
# to $commands/$functions/$aliases/… (fzf, patina and friends load it themselves)
zmodload -F zsh/stat b:zstat    # mtime without forking
zmodload zsh/datetime           # $EPOCHSECONDS without forking
setopt interactive_comments

# emacs mode so Home/End can be bound
bindkey -e
bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line

# fpath
fpath=(~/.local/share/zsh/completions $fpath)

# History & correct
[[ -d "${HOME}/.local/share/zsh" ]] || mkdir -p "${HOME}/.local/share/zsh"
HISTFILE="$HOME/.local/share/zsh/zsh_history"
HISTSIZE=50000      # in-memory list for the session (Ctrl-R search)
SAVEHIST=5000       # what is written to the file: capped for startup time
                    # (1 MB of history = ~8 ms more before the prompt)
setopt EXTENDED_HISTORY
setopt SHARE_HISTORY
setopt INC_APPEND_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_SAVE_NO_DUPS

# auto correction
setopt correct
SPROMPT='Corriger %B%F{red}%U%R%b%f%u en %F{green}%r%f%u ? [%B%F{blue}y%f%bes|%B%F{blue}n%f%bo|%B%F{blue}e%f%bdit|%B%F{blue}a%f%bbort]'

# sheldon plugin manager (see ~/.config/zsh/sheldon/plugins.toml)
# Only the synchronous part is loaded here: grc, zsh-defer, fpath completions.
# `sheldon source` output is cached and only regenerated when
# plugins.toml or plugins.lock changes: the rest of the time, 2 zstat (builtin)
# instead of a sheldon fork (~10-14 ms on the critical path).
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
# sheldon only downloads and updates the plugins here: at runtime it added
# nothing but zsh-defer and the completions path, so we point at the checkouts
# directly (no fork, no cache, no dependency on the binary at startup) and fall
# back to `sheldon source` if they are missing. sheldon stays for updates:
#   sheldon lock --update
_sheldon_repos="$SHELDON_DATA_DIR/repos/github.com"
if [[ -r $_sheldon_repos/romkatv/zsh-defer/zsh-defer.plugin.zsh ]]; then
	source "$_sheldon_repos/romkatv/zsh-defer/zsh-defer.plugin.zsh"
	fpath=("$_sheldon_repos/zsh-users/zsh-completions/src" $fpath)
else
	_source_sheldon
fi

# ---------------------------------------------------------------------------
# Cache for a binary's init script, versioned by the binary's mtime.
# Replaces _evalcache (which forked md5 on every shell): zstat is a builtin,
# so the cost is near zero while the cache is fresh.
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
	#    exports that follow it (we set them ourselves once env is applied).
	#    The generated script also snapshots PATH, so an install or uninstall
	#    (which only touches the installs directory) must invalidate it too.
	if [[ ! -s $act || $bin -nt $act ||
		${MISE_DATA_DIR:-$HOME/.local/share/mise}/installs -nt $act ]]; then
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
# compinit: full rebuild every 2 days, otherwise read the dump
# (+ compiled .zwc, ~2 ms instead of 5-8).
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
# on the VCONSOLE: no icons, plain prompt
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

	else # graphical terminal
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

	# fzf integration (^R history, ^T files, Alt-C cd) loaded on demand:
	# sourcing it costs ~5 ms at startup and those keys are rarely used. The
	# widgets below load it then delegate; the integration then rebinds the
	# keys to its own widgets (the stub is only used once).
	# Tab is NOT touched here: the integration captures `bindkey '^I'` on load
	# for its fallback, so it must still be the fzf-tab binding.
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
# Everything deferred goes through ONE SINGLE zsh-defer.
# Every extra zsh-defer triggers a full prompt render (7-12 ms):
# 10 tasks = ~70 ms of useless renders at startup.
# ---------------------------------------------------------------------------
_load_deferred() {
	local d=$SHELDON_DATA_DIR/repos/github.com
	local f

	# grc coloring: minimal wrappers (14 commands instead of the 42 from
	# /etc/grc.zsh), calibrated on the history — see grc-wrappers.zsh.
	# Deferred because it is useless before the first typed command.
	source "$ZDOTDIR/grc-wrappers.zsh"

	# completions first (fzf-tab hooks into them)
	_compinit_with_ttl

	# plugins already cloned by sheldon, loaded here (see plugins.toml)
	# fzf-tab: ~2.7 ms at startup but only needed from the first Tab. The stub
	# sources the plugin (which then rebinds ^I to its own widget) and dispatches
	# the current keypress to that widget.
	source "$d/zsh-users/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh"

	# fzf-tab with the same lazy treatment: the first Tab loads it, later Tabs go
	# straight to its widget (see the stub below)
	_fzf_tab_lazy() {
		if (( ! ${+_FZF_TAB_LOADED} )); then
			typeset -g _FZF_TAB_LOADED=1
			# fzf-tab records whatever ^I is bound to when it loads as its
			# fallback widget: point it back at the builtin first, otherwise it
			# records this stub and recurses into it (job table full)
			bindkey '^I' expand-or-complete
			source "$SHELDON_DATA_DIR/repos/github.com/Aloxaf/fzf-tab/fzf-tab.plugin.zsh" || {
				zle expand-or-complete
				return
			}
			# re-inject the Tab: it now hits fzf-tab's own ^I binding, which
			# keeps the completion in the top-level widget (calling
			# fzf-tab-complete from inside a widget does nothing)
			zle -U $'\t'
			return
		fi
		zle fzf-tab-complete
	}
	zle -N _fzf_tab_lazy
	bindkey '^I' _fzf_tab_lazy
	# zoxide: the zsh-zoxide plugin only added an evalcache shim around
	# `zoxide init zsh` (which forks md5 on every shell, ~6 ms). Calling init
	# directly gives the same z/zi functions and chpwd hook, cached by
	# _cached_init like the other generated scripts.
	_cached_init zoxide init zsh

	# aliases + custom functions (every file in the folder)
	for f in "$ZDOTDIR"/sheldon/alias/*.sh(N); do
		source "$f"
	done

	# zsh only uses a .zwc when it is newer than the source, and never
	# regenerates it itself: we recompile here (deferred, so after the prompt)
	# when a file was edited or replaced. `-nt` is a builtin: no cost
	# while everything is current; a single zcompile when it just changed.
	#   - alias files (sheldon/alias/*.sh)
	# The other .zwc files are maintained where they are produced: those in
	# ~/.cache/zsh/initcache/*.zsh by _cached_init, zcompdump.zwc by
	# _compinit_with_ttl. sheldon.zsh is deliberately not compiled (no gain).
	_recompile_caches() {
		local f
		for f in "$ZDOTDIR"/sheldon/alias/*.sh(N); do
			[[ $f.zwc -nt $f ]] || zcompile "$f" 2>/dev/null
		done
	}
	_recompile_caches

	# syntax highlighting
	_cached_init zsh-patina activate

	# version manager + prompt
	_load_mise
	# prompt: native and fork-free, see prompt.zsh (the TTY branch of _vconsole
	# keeps its own plain prompt)
	if [[ $TERM != "linux" ]]; then
		source "$ZDOTDIR/prompt.zsh"
	fi

	# eza/ls aliases, fzf --zsh, TTY prompt
	_vconsole
}

zsh-defer _load_deferred

# VLC 3 is an X11 client (XWayland): Qt5 therefore ignores Wayland scaling and its
# UI comes out twice too small. We force the factor, like GDK_SCALE for GTK.
vlc() { QT_SCALE_FACTOR=${QT_SCALE_FACTOR:-2} command vlc "$@"; }
