#!/usr/bin/env bash
dirs=(/run/current-system/sw/share/applications \
      /etc/profiles/per-user/"$USER"/share/applications \
      ~/.local/share/applications)

# .desktop à exclure
blacklist=(okularApplication kcm_ org.kde.akonadi kitty-open xdg-desktop-portal PrintQueue polkit-kde org.kde.plasma wheelmap breezestyle com.brave appimage geoclue google-maps \
org.freedesktop ktelnet kwincompositing kwalletmanager5 openstreetmap drkonqi ConfigurePrinter gwenview_importer kcolorschemeeditor kiod6 klipper imv footclient foot-server \
keditfiletype knighttimed org.kde.kwin ksshaskpass startcenter ksecretd krdpserver kfontinst xsltfilter umpv xplr kaccess kdesystemsettings kcmspellchecking)

while IFS= read -r desktop_file; do
  exec_line=$(rg --no-line-number '^Exec=' "$desktop_file" | head -1 | cut -d= -f2- | sed 's/%[uUdDFk]//g')
  cmd=$(echo "$exec_line" | cut -d' ' -f1)
  echo "Lancement de $exec_line..."
  if [[ "$cmd" == "btop" ]]; then
    kitty -e "$exec_line" 2>/dev/null
  else
    eval "$exec_line" 2>/dev/null
  fi
done < <({
  find "${dirs[@]}" -name "*.desktop" \( -type f -o -type l \) -exec rg -l '^Exec=' {} + 2>/dev/null
} | sed 's|.*/||' | sort -u | rg -v -F -f <(printf '%s\n' "${blacklist[@]}") \
| fzf --prompt="Fuzzy Launcher 🚀 " --layout=reverse --header 'ENTRÉE=lance ECHAP=quitte'| xargs -I {} find "${dirs[@]}" -name "{}" | head -1)
