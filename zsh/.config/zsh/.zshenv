# ~/.zshenv — read by EVERY zsh: interactive, scripts, subshells.
# Environment only here (PATH, exported variables).
# Everything interactive (bindkey, compinit, prompt, deferred loading)
# lives in .zshrc, so a plain `zsh script.zsh` does not pay for it.

# zsh/parameter is not loaded here: zsh 5.9 loads it on its own at the first
# access to $commands/$functions/$aliases/… (verified: `zmodload` alone lists only
# zsh/main, then zsh/parameter shows up after `${+commands[ls]}`).

setopt +o nomatch

# cache for generated init scripts (mise, patina, fzf, sheldon)
# → see _cached_init / _source_sheldon in .zshrc: zstat on the binary,
#   no fork (replaces _evalcache, which forked md5 on every shell)
ZSH_INIT_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/initcache"

# zsh-patina
export ZSH_PATINA_CONFIG_PATH="$HOME/.config/zsh/patina/config.toml"

# sheldon
export SHELDON_CONFIG_DIR="$HOME/.config/zsh/sheldon"
export SHELDON_DATA_DIR="$HOME/.local/share/zsh"
export SHELDON_CONFIG_FILE="$SHELDON_CONFIG_DIR/plugins.toml"

# RUST
#export RUSTUP_HOME="${HOME}/.rustup"
#export CARGO_HOME="${HOME}/.cargo"
#export CARGO_TARGET_DIR="${HOME}/.cargo/cargo-target"

# GO
#export GOROOT="${HOME}/.go"
#export GOPATH="${HOME}/.go/workspace"
#export GOBIN="${HOME}/.go/workspace/bin"

# PATH
typeset -U PATH
#export PATH="$HOME/.local/bin:$HOME/Projects/scripts:$GOROOT/bin:$GOBIN:$CARGO_HOME/bin:${PATH}"

# ENV
. "$ZDOTDIR/exports.sh"
