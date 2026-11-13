###################### COLORS #####################################################################################################################

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

# sudo — literal ANSI sequences: $(tput …) cost ~19 ms of forking at
# startup (5 command substitutions at ~3.5 ms each), on the critical path.
if [ -t 1 ] && [ -n "${TERM:-}" ]; then
  export SUDO_PROMPT=$'\e[41;1m[sudo]\e[0m \e[36mpassword for\e[0m \e[35m%p\e[0m: '
else
  export SUDO_PROMPT="[sudo] password for %p: "
fi

# man
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export MANROFFOPT="-c"



###################### MISC #######################################################################################################################

export ZSH_AUTOSUGGEST_MANUAL_REBIND=1


# CTRL-T fzf with a bat preview
export FZF_CTRL_T_OPTS="
  --walker-skip .git,node_modules,target
  --preview 'bat -n --color=always {}'
  --bind 'ctrl-/:change-preview-window(down|hidden|)'"

# ALT-C with a tree view
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

###################### TELEMETRY ##################################################################################################################
# Global opt-out for tools that honour these variables (Claude Code, etc.).
export DISABLE_TELEMETRY=1
export DO_NOT_TRACK=1
# Claude Code: also cuts non-essential traffic (telemetry, feature flags).
export CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC=1
# Superwhisper: empty DSN, the Sentry client is disabled at startup
# (useful for the settings TUI launched from a shell).
export SW_SENTRY_DSN=
