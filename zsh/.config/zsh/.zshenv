# ~/.zshenv — lu par TOUS les zsh : interactifs, scripts, sous-shells.
# Ne garder ici que l'environnement (PATH, variables exportées).
# Tout ce qui est interactif (bindkey, compinit, prompt, chargements différés)
# vit dans .zshrc, pour ne pas être payé par chaque `zsh script.zsh`.

# zsh/parameter n'est pas chargé ici : zsh 5.9 le charge tout seul au premier
# accès à $commands/$functions/$aliases/… (vérifié : `zmodload` seul ne liste que
# zsh/main, puis zsh/parameter apparaît après `${+commands[ls]}`).

setopt +o nomatch

# cache des scripts d'init générés (mise, oh-my-posh, patina, fzf, sheldon)
# → cf _cached_init / _source_sheldon dans .zshrc : zstat sur le binaire,
#   aucun fork (remplace _evalcache, qui forkait md5 à chaque shell)
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
