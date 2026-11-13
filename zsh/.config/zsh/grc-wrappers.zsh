# ---------------------------------------------------------------------------
# Minimal grc wrappers — replaces `source /etc/grc.zsh`.
#
# /etc/grc.zsh (grc package, owned by root) defines 42 functions:
#   - ~4 ms at load: fork `tty -s` + building the hash of the commands in
#     PATH for its ~60 `$+commands[…]` tests;
#   - ~40 ms per call (grc is a Python script), including on commands that
#     already colour themselves natively (systemctl, journalctl, ip).
# It is not modified here: pacman rewrites it on every package update.
#
# Here: a list calibrated on the zsh history (~22k lines), no fork at
# load, no PATH test. Keeps only the commands where grc adds a colour you
# do not get elsewhere (call counts from the history):
#   ps 224 · curl 130 · lsblk 40 · stat 23 · sensors 22 · findmnt 22 · sysctl 18
#   id 15 · whois 15 · nmap 14 · lsmod 13 · make 12 · lspci 7 · ss 7
#
# Deliberately left out:
#   systemctl (288 calls) and ip (53) → systemd and iproute2 already colour on a tty
#   df (20) → duf · diff (7) → GNU diff --color=auto (see alias)
#   docker* (0 calls), env/uptime/blkid/tune2fs/ld/showmount (≤4 calls)
#
# Add a command: add its name to _GRC_CMDS.
# Disable everything: comment out the source line in _load_deferred (.zshrc).
# ---------------------------------------------------------------------------

# stdin, not stdout: zsh-defer runs the deferred bundle with stdout redirected
# (verified: [[ -t 1 ]] is false inside _load_deferred, [[ -t 0 ]] is true). It is
# also the test /etc/grc.zsh uses (`tty -s`); as a builtin, so fork-free.
[[ -t 0 ]] || return 0
[[ -x /usr/bin/grc ]] || return 0

typeset -ga _GRC_CMDS=(
	lsblk sensors findmnt id whois nmap lspci ss
)

for _grc_c in $_GRC_CMDS; do
	# function body: grc runs the command in a subprocess, so no recursion is
	# possible on the function itself
	functions[$_grc_c]="grc --colour=auto $_grc_c \"\$@\""
done
unset _grc_c
