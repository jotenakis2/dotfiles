#!/usr/bin/env bash

# mise à jour de iptvnator appimage

set -euo pipefail
RESET="\033[0m"
RED="\033[1;31m"
YELLOW="\033[1;33m"
BLUE="\033[1;34m"
GREEN="\033[1;32m"
APPIMAGES_DIR="$HOME/AppImages"

clear
echo
echo -e "$YELLOW>>> Script de mise à jour de IPTVnator <<<$RESET"
echo
mkdir -p "$APPIMAGES_DIR"
cd "$APPIMAGES_DIR"

LATEST_URL=$(curl -s https://api.github.com/repos/4gray/iptvnator/releases/latest | grep -o 'https://github.com/4gray/iptvnator/releases/download/[^"]*linux-x86_64\.AppImage')

if [[ -z "$LATEST_URL" ]]; then 
	echo -e "$RED Erreur : pas de ARM64 $RESET" >&2
	exit 1
fi

FILENAME=$(basename "$LATEST_URL")
echo -e "$GREEN $RESET Dernière version disponible sur github : ${BLUE}$FILENAME${RESET}."
if [[ ! -f "$FILENAME" ]]; then
	echo -e "$GREEN $RESET Téléchargement en cours..."
	curl -L -o "$FILENAME" "$LATEST_URL" >/dev/null 2>&1
	chmod +x "$FILENAME"
	CURRENT=$(ls "$APPIMAGES_DIR/$FILENAME")
	echo -e "$GREEN $RESET Nouvelle version téléchargée (${BLUE}${CURRENT}${RESET})."
else
	CURRENT=$(ls "$APPIMAGES_DIR/$FILENAME")
	echo -e "$YELLOW $RESET Dernière version déjà installée (${BLUE}${CURRENT}${RESET})."
fi
echo -en "$GREEN $RESET Symlink $BLUE" && ln -svf "$FILENAME" iptvnator && echo -e "$RESET"
eza -l --no-user --no-permissions --no-filesize --color --icons "$APPIMAGES_DIR"
