#!/usr/bin/env bash
# shellcheck enable=all
#
# zsh-plugins.sh — clone and update the zsh plugins used by ~/.config/zsh.
#
# There is no plugin manager: .zshrc sources these git checkouts directly
# (zsh-defer) and adds the completions directory to fpath. This script is the
# only place that touches the network.
#
# Usage:
#   zsh-plugins.sh install   clone what is missing (fresh machine)
#   zsh-plugins.sh update    pull every checkout (default)
#   zsh-plugins.sh status    show each checkout's version and state

set -euo pipefail

readonly PROG="${0##*/}"
readonly DATA_DIR="${XDG_DATA_HOME:-${HOME}/.local/share}/zsh"
readonly REPO_DIR="${DATA_DIR}/repos/github.com"

# The list lives next to this script because .zshrc reads the same file to
# detect what is missing: one source of truth for both sides.
SCRIPT_DIR="$(cd -- "$(dirname -- "$(readlink -f -- "${BASH_SOURCE[0]}")")" && pwd)"
readonly SCRIPT_DIR
readonly PLUGIN_LIST="${SCRIPT_DIR}/plugins.list"

die() {
  printf 'Erreur : %s\n' "$*" >&2
  exit 1
}

usage() {
  printf 'Usage : %s [install|update|status]\n\n' "${PROG}"
  printf '  install  clone les plugins manquants\n'
  printf '  update   met à jour les dépôts (défaut)\n'
  printf '  status   affiche l état de chaque dépôt\n'
}

command -v git >/dev/null 2>&1 || die "git introuvable dans le PATH"

[[ -r ${PLUGIN_LIST} ]] || die "liste de plugins introuvable : ${PLUGIN_LIST}"

PLUGINS=()
while IFS= read -r line; do
  [[ -z ${line} || ${line} == \#* ]] && continue
  PLUGINS+=("${line}")
done <"${PLUGIN_LIST}"
(( ${#PLUGINS[@]} )) || die "liste de plugins vide : ${PLUGIN_LIST}"

changed=0   # dépôts qui ont réellement bougé (conditionne l'invalidation du cache)

action="${1:-update}"
case "${action}" in
  -h | --help | help) usage; exit 0 ;;
  install | update | status) ;;
  *) die "action inconnue : ${action} (voir --help)" ;;
esac

mkdir -p "${REPO_DIR}"

# One install/update at a time: .zshrc starts this detached from every shell that
# finds plugins missing, so two of them can overlap. flock is released when the
# process exits, so a killed run never blocks the next one.
if [[ ${action} != status ]] && command -v flock >/dev/null 2>&1; then
  exec 9>"${DATA_DIR}/.zsh-plugins.lock"
  if ! flock -n 9; then
    printf 'une installation est déjà en cours dans un autre shell — rien à faire\n'
    exit 0
  fi
fi

clone_or_pull() {
  local slug="$1" path="${REPO_DIR}/$1" url="https://github.com/$1"
  local branch head

  if [[ ! -d ${path}/.git ]]; then
    if [[ ${action} == status ]]; then
      printf '  %-28s absent\n' "${slug}"
      return 0
    fi
    printf '  %-28s clone…\n' "${slug}"
    git clone --quiet "${url}" "${path}"
    printf '  %-28s cloné\n' "${slug}"
    # a fresh checkout brings new completions: the dump must be rebuilt, exactly
    # as after an update
    changed=$((changed + 1))
    return 0
  fi

  branch=$(git -C "${path}" rev-parse --abbrev-ref HEAD 2>/dev/null || echo master)
  # checkouts cloned by a tool (or in detached HEAD) may have no upstream branch:
  # `git pull` cannot be used, we fetch and fast-forward explicitly
  [[ ${branch} == HEAD ]] && branch=master

  if [[ ${action} == install ]]; then
    printf '  %-28s déjà présent\n' "${slug}"
    return 0
  fi

  if [[ ${action} == status ]]; then
    local date
    head=$(git -C "${path}" rev-parse --short HEAD)
    date=$(git -C "${path}" log -1 --format=%cs)
    printf '  %-28s %s (%s) %s\n' "${slug}" "${head}" "${date}" "${branch}"
    return 0
  fi

  local before
  before=$(git -C "${path}" rev-parse HEAD)

  if ! git -C "${path}" fetch --quiet origin; then
    printf '  %-28s ÉCHEC du fetch\n' "${slug}" >&2
    return 1
  fi
  if ! git -C "${path}" merge --ff-only --quiet "origin/${branch}" 2>/dev/null; then
    local dirty
    dirty=$(git -C "${path}" status --porcelain)
    if [[ -z ${dirty} ]]; then
      git -C "${path}" reset --hard --quiet "origin/${branch}"
    else
      printf '  %-28s modifié localement, non mis à jour\n' "${slug}" >&2
      return 1
    fi
  fi
  # so that a plain `git pull` works by hand later
  git -C "${path}" branch --set-upstream-to="origin/${branch}" "${branch}" >/dev/null 2>&1 || true
  head=$(git -C "${path}" rev-parse --short HEAD)
  if [[ ${head} != "${before:0:7}" ]]; then
    changed=$((changed + 1))
    printf '  %-28s mis à jour (%s → %s)\n' "${slug}" "${before:0:7}" "${head}"
  else
    printf '  %-28s déjà à jour (%s)\n' "${slug}" "${head}"
  fi
}

printf 'dépôts : %s\n\n' "${REPO_DIR}"
for plugin in "${PLUGINS[@]}"; do
  clone_or_pull "${plugin}"
done

if [[ ${action} != status ]]; then
  if ((changed)); then
    # the completion dump was built from the previous checkout state: drop it so
    # the next shell rebuilds it (the compinit TTL would otherwise keep it for
    # two days and the new completions would not appear)
    zdotdir="${ZDOTDIR:-${HOME}/.config/zsh}"
    rm -f "${zdotdir}/zcompdump" "${zdotdir}/zcompdump.zwc"
    printf '\n%d dépôt(s) mis à jour → dump de complétions invalidé.\n' "${changed}"
    printf 'Ouvre un nouveau shell zsh : le shell courant garde les complétions déjà chargées.\n'
  else
    printf '\nAucun changement : dump de complétions conservé.\n'
  fi
fi
