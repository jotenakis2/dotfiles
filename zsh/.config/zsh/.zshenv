# evalcache
ZSH_EVALCACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/evalcache"

# RUST
export RUSTUP_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/rustup"
export CARGO_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/cargo"

# GO
export GOPATH="${XDG_DATA_HOME:-$HOME/.local/share}/go"
export GOBIN="${XDG_BIN_HOME:-$HOME/.local/bin}"

# PATH
export PATH="$GOBIN:$CARGO_HOME/bin:/usr/local/bin:/usr/bin:/bin"
typeset -U path

# ENV
. "$ZDOTDIR/.exports"
