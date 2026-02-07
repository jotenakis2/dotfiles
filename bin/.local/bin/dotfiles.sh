#!/usr/bin/env bash
# shellcheck disable=SC2250
set -euo pipefail

DOTDIR="$HOME/dotfiles"
mkdir -p "$DOTDIR"

# "package" => "chemin_relatif_à_HOME [chemin2 ...]"
declare -A pkgs=(
#  ["atuin"]=".config/atuin"
#  ["fastfetch"]=".config/fastfetch"
#  ["btop"]=".config/btop"
#  ["micro"]=".config/micro"
#  ["kitty"]=".config/kitty"
#  ["zsh"]=".zshrc"
#  ["bat"]=".config/bat"
#  ["tealdeer"]=".config/tealdeer"
#  ["shellcheck"]=".shellcheckrc"
#  ["bottom"]=".config/bottom"
#  ["foot"]=".config/foot"
#  ["iptvnator"]=".iptvnator"             
#  ["ohmyposh"]=".config/ohmyposh"
#  ["procs"]=".config/procs"
#  ["stormy"]=".config/stormy"
#  ["yazi"]=".config/yazi"
#  ["zed"]=".config/zed"
#  ["fedupdate"]=".config/fedupdate .local/share/fedupdate"
#  ["pyradio"]=".config/pyradio .local/share/pyradio"
  ["exports"]=".exports"
  ["functions"]=".functions"
  
)

stow_pkgs=()

for pkg in "${!pkgs[@]}"; do
  IFS=' ' read -ra paths <<< "${pkgs[$pkg]}"
  copied_any=false

  for path in "${paths[@]}"; do
    src="$HOME/$path"

    if [[ ! -e "$src" ]]; then
      echo "Skip: $src"
      continue
    fi

    # Reproduire exactement l’arborescence à partir de $HOME
    if [[ "$path" == .*/* ]]; then
      # .config/xxx, .local/share/xxx, etc.
      mkdir -p "$DOTDIR/$pkg/$(dirname "$path")"
      dest="$DOTDIR/$pkg/$path"
    else
      # fichiers ou dossiers à la racine (~/.zshrc, ~/.iptvnator, ~/.shellcheckrc...)
      mkdir -p "$DOTDIR/$pkg"
      dest="$DOTDIR/$pkg/$(basename "$path")"
    fi

    if [[ -d "$src" ]]; then
      rsync -a --exclude='.git*' "$src/" "$dest/"
    else
      cp -v "$src" "$dest"
    fi

    copied_any=true
  done

  if $copied_any; then
    stow_pkgs+=("$pkg")
  fi
done

cat > "$DOTDIR/.stow-local-ignore" << 'EOF'
.git
README.md
*.swp
.DS_Store
EOF

cd "$DOTDIR"

echo "=== DRY-RUN ==="
stow -nv --adopt "${stow_pkgs[@]}"

echo -e "\nValidez ? (y/n)"
read -r REPLY
[[ "$REPLY" != "y" ]] && exit 0

stow --adopt -v "${stow_pkgs[@]}"

echo "Terminé."
