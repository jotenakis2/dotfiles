###################### COLORS #####################################################################################################################
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

if [ -t 1 ] && [ -n "${TERM:-}" ]; then
  export SUDO_PROMPT=$'\e[41;1m[sudo]\e[0m \e[36mpassword for\e[0m \e[35m%p\e[0m: '
else
  export SUDO_PROMPT="[sudo] password for %p: "
fi

export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export MANROFFOPT="-c"
export ZSH_AUTOSUGGEST_MANUAL_REBIND=1
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=236'
export FZF_CTRL_T_OPTS="
  --walker-skip .git,node_modules,target
  --preview 'bat -n --color=always {}'
  --bind 'ctrl-/:change-preview-window(down|hidden|)'"
export FZF_ALT_C_OPTS="
  --walker-skip .git,node_modules,target
  --preview 'eza --color=always --icons -T -L 4 {}'"

# TELEMETRY 
# Global opt-out for tools that honour these variables (Claude Code, etc.).
export DISABLE_TELEMETRY=1
export DO_NOT_TRACK=1
# Claude Code: also cuts non-essential traffic (telemetry, feature flags).
export CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC=1
# Superwhisper: empty DSN, the Sentry client is disabled at startup
# (useful for the settings TUI launched from a shell).
export SW_SENTRY_DSN=







#export LIBVA_DRIVER_NAME=dummy
#export IMSETTINGS_INTEGRATE_DESKTOP=no
#export IMSETTINGS_DISABLE_DESKTOP_CHECK=1
#export GTK_IM_MODULE=simple 
#export QT_IM_MODULE=wayland
#export VISUAL="vim"
#export EDITOR="$VISUAL"



###################### DOCUMENTATION ###############################################################################################################
# ZSH_AUTOSUGGEST_MANUAL_REBIND=1
#      disables automatic re-binding of the zsh-autosuggestions widgets on every precmd. Notable perf gain at startup and between commands.
# IMSETTINGS_INTEGRATE_DESKTOP=no
#      stops the imsettings daemon from forcing the desktop's input method (IBus, SCIM…) integration. Useful when you manage the IM yourself.
# IMSETTINGS_DISABLE_DESKTOP_CHECK=1
#      disables imsettings' desktop check, so it cannot overwrite your IM variables based on the detected environment. 
# GTK_IM_MODULE=simple
#      forces GTK apps onto the basic input module (no IBus/Fcitx). Handy when you need no complex IM and want to avoid freezes or slow GTK app startup.
# QT_IM_MODULE=wayland
#      forces Qt apps onto the native Wayland input protocol. Recommended under KDE/Wayland to avoid input and cursor positioning issues.

