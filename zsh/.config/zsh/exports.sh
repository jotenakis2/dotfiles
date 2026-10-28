###################### COULEURS #####################################################################################################################

# grep
#export GREP_COLORS="mt=1;38;2;180;190;254"
alias grep='grep --color'

# fzf tokyonight
export FZF_DEFAULT_OPTS="--height 100% --border --ansi --no-info --highlight-line \
    --color=bg+:#283457 \
    --color=border:#27a1b9 \
    --color=fg:#c0caf5 \
    --color=gutter:#16161e \
    --color=header:#ff9e64 \
    --color=hl+:#2ac3de \
    --color=hl:#2ac3de \
    --color=info:#545c7e \
    --color=marker:#ff007c \
    --color=pointer:#ff007c \
    --color=prompt:#2ac3de \
    --color=query:#c0caf5:regular \
    --color=scrollbar:#27a1b9 \
    --color=spinner:#ff007c "

   # --color=bg+:#283457 \
   # --color=bg:#16161e \
   #--color=separator:#ff9e64 \

# fzf catppuccin
# export FZF_DEFAULT_OPTS="--height 100% --border --ansi --no-info --highlight-line \
#   --color=bg+:#313244 \
#   --color=bg:#1e1e2e \
#   --color=border:#cba6f7 \
#   --color=fg:#cdd6f4 \
#   --color=gutter:#1e1e2e \
#   --color=header:#fab387 \
#   --color=hl+:#94e2d5 \
#   --color=hl:#94e2d5 \
#   --color=info:#6c7086 \
#   --color=marker:#cba6f7 \
#   --color=pointer:#cba6f7 \
#   --color=prompt:#b4befe \
#   --color=query:#cdd6f4:regular \
#   --color=scrollbar:#cba6f7 \
#   --color=separator:#fab387 \
#   --color=spinner:#cba6f7"

# sudo
if [ -t 1 ] && [ -n "${TERM:-}" ]; then
  export SUDO_PROMPT="$(tput setab 1 setaf 7 bold)[sudo]$(tput sgr0) $(tput setaf 6)password for$(tput sgr0) $(tput setaf 5)%p$(tput sgr0): "
else
  export SUDO_PROMPT="[sudo] password for %p: "
fi

# man
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export MANROFFOPT="-c"



###################### DIVERS #######################################################################################################################

export ZSH_AUTOSUGGEST_MANUAL_REBIND=1
export POSH_NO_UPDATECHECK=1


# CTRL T fzf avec preview bat
export FZF_CTRL_T_OPTS="
  --walker-skip .git,node_modules,target
  --preview 'bat -n --color=always {}'
  --bind 'ctrl-/:change-preview-window(down|hidden|)'"

# ALT C avec affichage en arbre
export FZF_ALT_C_OPTS="
  --walker-skip .git,node_modules,target
  --preview 'eza --color=always --icons -T -L 4 {}'"


#export LIBVA_DRIVER_NAME=dummy
#export IMSETTINGS_INTEGRATE_DESKTOP=no
#export IMSETTINGS_DISABLE_DESKTOP_CHECK=1
#export GTK_IM_MODULE=simple 
#export QT_IM_MODULE=wayland
#export VISUAL="vim"
#export EDITOR="$VISUAL"



###################### DOCUMENTATIONS ###############################################################################################################
# ZSH_AUTOSUGGEST_MANUAL_REBIND=1
#      désactive le re-binding automatique des widgets zsh-autosuggestions à chaque precmd. Gain de perf notable au démarrage et entre chaque commande.
# POSH_NO_UPDATECHECK=1
#      désactive la vérification de mise à jour d'oh-my-posh au démarrage, évite une requête réseau et accélère l'init du prompt.
# IMSETTINGS_INTEGRATE_DESKTOP=no
#      empêche le démon imsettings de forcer l'intégration du gestionnaire de méthode de saisie (IBus, SCIM…) imposée par le bureau. Utile si tu veux gérer l'IM toi-même.
# IMSETTINGS_DISABLE_DESKTOP_CHECK=1
#      désactive la vérification du bureau par imsettings, évite qu'il écrase tes variables IM selon l'environnement détecté. 
# GTK_IM_MODULE=simple
#      force les applis GTK à utiliser le module de saisie basique (pas d'IBus/Fcitx). Pratique si tu n'utilises pas de langue nécessitant un IM complexe et que tu veux éviter des freezes ou lenteurs au démarrage des applis GTK.
# QT_IM_MODULE=wayland
#      force les applis Qt à utiliser le protocole natif Wayland pour la saisie. Recommandé sous KDE/Wayland pour éviter les problèmes de saisie et de positionnement du curseur.
