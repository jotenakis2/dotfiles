# ---------------------------------------------------------------------------
# Wrappers grc minimaux — remplace `source /etc/grc.zsh`.
#
# /etc/grc.zsh (paquet grc, appartenant à root) définit 42 fonctions :
#   - ~4 ms au chargement : fork `tty -s` + construction du hash des commandes
#     du PATH pour ses ~60 tests `$+commands[…]` ;
#   - ~40 ms à chaque appel (grc est un script Python), y compris sur des
#     commandes déjà colorées nativement (systemctl, journalctl, ip).
# Il n'est pas modifié ici : pacman le réécrit à chaque mise à jour du paquet.
#
# Ici : liste calibrée sur l'historique zsh (~22k lignes), aucun fork au
# chargement, aucun test de PATH. Ne garde que les commandes où grc apporte une
# couleur qu'on ne trouve pas ailleurs (appels dans l'historique) :
#   ps 224 · curl 130 · lsblk 40 · stat 23 · sensors 22 · findmnt 22 · sysctl 18
#   id 15 · whois 15 · nmap 14 · lsmod 13 · make 12 · lspci 7 · ss 7
#
# Écartées volontairement :
#   systemctl (288 appels) et ip (53) → systemd et iproute2 colorent déjà en tty
#   df (20) → duf · diff (7) → GNU diff --color=auto (cf alias)
#   docker* (0 appel), env/uptime/blkid/tune2fs/ld/showmount (≤4 appels)
#
# Ajouter une commande : ajouter son nom dans _GRC_CMDS.
# Tout désactiver : commenter le source dans _load_deferred (.zshrc).
# ---------------------------------------------------------------------------

# stdin, pas stdout : zsh-defer exécute le bundle différé avec stdout redirigé
# (vérifié : [[ -t 1 ]] est faux dans _load_deferred, [[ -t 0 ]] vrai). C'est
# aussi le test qu'utilise /etc/grc.zsh (`tty -s`) ; en builtin, donc sans fork.
[[ -t 0 ]] || return 0
[[ -x /usr/bin/grc ]] || return 0

typeset -ga _GRC_CMDS=(
	lsblk sensors findmnt id whois nmap lspci ss
)

for _grc_c in $_GRC_CMDS; do
	# corps de fonction : grc lance la commande en sous-processus, donc aucune
	# récursion possible sur la fonction elle-même
	functions[$_grc_c]="grc --colour=auto $_grc_c \"\$@\""
done
unset _grc_c
