#!/usr/bin/env bash
set -euo pipefail
#######################################################################
#                       🔐 SSH CONNECT MANAGER                        #
#               Gestionnaire sécurisé de connections SSH              #
#    Chiffrement AES-256 • Base de données SQLite • Interface GUM     #
#              LICENCE : GPLv3 / COPYRIGHT : Jotenakis                #
#######################################################################

# Variables principales
VERSION="1.0"
DATA_DIR="${HOME}/.local/share/sshmanager"
DB_FILE="${DATA_DIR}/connections.db"
CANARY_FILE="${DATA_DIR}/canary"
mkdir -p "${DATA_DIR}"

#---------------------------------------------------------------------------------------------------------------------------------------------
# shellcheck disable=SC2034
define_colors() {
Noir="\e[0;30m"
Rouge="\e[0;31m"
Vert="\e[0;32m"
Jaune="\e[0;33m"
Bleu="\e[0;34m"
Violet="\e[0;35m"
Cyan="\e[0;36m"
Blanc="\e[0;37m"
Reset="\033[0m"
# Couleurs gum
NoirGum=0
RougeGum=1
VertGum=2
JauneGum=3
BleuGum=4
VioletGum=5
CyanGum=6
BlancGum=7
export GUM_CONFIRM_SELECTED_BACKGROUND=$VertGum
export GUM_CONFIRM_SELECTED_FOREGROUND=$NoirGum
export GUM_CONFIRM_UNSELECTED_BACKGROUND=$NoirGum
export GUM_CONFIRM_UNSELECTED_FOREGROUND=$BlancGum
export GUM_CONFIRM_SHOW_HELP=false
export GUM_CHOOSE_SHOW_HELP=false
export GUM_INPUT_SHOW_HELP=false

# echo -e "$Noir noir $Rouge rouge $Vert vert $Jaune jaune $Bleu bleu $Violet violet $Cyan cyan $Blanc blanc"
# gum style --foreground $NoirGum --bold "Gum Noir"
# gum style --foreground $RougeGum --bold "Gum Rouge"
# gum style --foreground $VertGum --bold "Gum Vert"
# gum style --foreground $JauneGum --bold "Gum Jaune"
# gum style --foreground $BleuGum --bold "Gum Bleu"
# gum style --foreground $VioletGum --bold "Gum Violet"
# gum style --foreground $CyanGum --bold "Gum Cyan"
# gum style --foreground $BlancGum --bold "Gum Blanc"
}

#---------------------------------------------------------------------------------------------------------------------------------------------
check_dependencies() { # vérif dépendances fortes
  local missing=()
  command -v gum >/dev/null 2>&1 || missing+=("gum")
  command -v sqlite3 >/dev/null 2>&1 || missing+=("sqlite3")
  command -v openssl >/dev/null 2>&1 || missing+=("openssl")
  command -v expect >/dev/null 2>&1 || missing+=("expect")
  command -v ssh >/dev/null 2>&1 || missing+=("ssh")

  if [ ${#missing[@]} -gt 0 ]; then # il y a des manquants
    if command -v gum >/dev/null 2>&1; then # on va afficher les manquants avec gum
      gum style --border double --border-foreground $RougeGum --padding "1 2" --margin "1" "$(gum style --foreground $RougeGum --bold "  PAQUETS MANQUANTS ${missing[*]}  ")"

      echo ""
      gum style --foreground $VertGum --bold "📦 Installation selon ta distribution GNU/Linux 📦"
      echo ""

      local nix_pkgs="" arch_pkgs=""
      for pkg in "${missing[@]}"; do
        case "$pkg" in
          sqlite3)
            nix_pkgs+="sqlite "
            arch_pkgs+="sqlite "
            ;;
          *)
            nix_pkgs+="$pkg "
            arch_pkgs+="$pkg "
            ;;
        esac
      done

      # FEDORA
      gum style --border rounded --border-foreground $BleuGum --padding "0 1" "$(gum style --foreground $BleuGum --bold ' Fedora')"
      echo "    $(gum style --foreground $JauneGum "sudo dnf install ${missing[*]}")"
      echo ""

      # DEBIAN
      gum style --border rounded --border-foreground $BleuGum --padding "0 1" "$(gum style --foreground $BleuGum --bold ' Debian,  Ubuntu et dérivés')"
      local needs_gum_repo=false
      local deb_pkgs=""
      for pkg in "${missing[@]}"; do
        [ "$pkg" = "gum" ] && needs_gum_repo=true || deb_pkgs+="$pkg "
      done
      if [ "$needs_gum_repo" = true ]; then
        gum style --foreground $BlancGum "  Dépôt Charm (pour gum):"
        echo "    $(gum style --foreground $JauneGum "echo 'deb [trusted=yes] https://repo.charm.sh/apt/ /' | sudo tee /etc/apt/sources.list.d/charm.list")"
        echo "    $(gum style --foreground $JauneGum "sudo apt update")"
        deb_pkgs+="gum"
      fi
      gum style --foreground $BlancGum "  Installation:"
      echo "    $(gum style --foreground $JauneGum "sudo apt install ${deb_pkgs}")"
      echo ""

      # OPENSUSE
      gum style --border rounded --border-foreground $BleuGum --padding "0 1" "$(gum style --foreground $BleuGum --bold ' openSUSE')"
      echo "    $(gum style --foreground $JauneGum "sudo zypper install ${missing[*]}")"
      echo ""

      # ARCH
      gum style --border rounded --border-foreground $BleuGum --padding "0 1" "$(gum style --foreground $BleuGum --bold '󰣇 Arch et dérivés')"
      echo "    $(gum style --foreground $JauneGum "sudo pacman -S ${arch_pkgs}")"
      echo ""

      # NIXOS
      gum style --border rounded --border-foreground $BleuGum --padding "0 1" "$(gum style --foreground $BleuGum --bold ' NixOS')"
      gum style --foreground $BlancGum "  Temporaire:"
      echo "    $(gum style --foreground $JauneGum "nix-shell -p ${nix_pkgs}")"
      gum style --foreground $BlancGum "  Permanent (configuration.nix):"
      echo "    $(gum style --foreground $JauneGum "environment.systemPackages = with pkgs; [ ${nix_pkgs}];")"
      echo ""

    else # on affiche les manquants de manière basique sans gum mais en couleur.
      echo -e "$Rouge  Paquets manquants : ${missing[*]}  $Reset"
      echo ""
      echo -e "📦$Vert Installation selon ta distribution GNU/Linux$Reset 📦"
      echo ""
      echo -e "$Bleu Fedora$Reset"
      echo -e "$Jaune    sudo dnf install ${missing[*]}$Reset"
      echo
      echo -e "$Bleu Debian,  Ubuntu et dérivés$Reset"
      echo -e "$Jaune    sudo apt install ${missing[*]}$Reset"
      echo
      echo -e "$Bleu openSUSE$Reset"
      echo -e "$Jaune    sudo zypper install ${missing[*]}$Reset"
      echo
      echo -e "󰣇$Bleu Arch et dérivés$Reset"
      echo -e "$Jaune    sudo pacman -S ${missing[*]}$Reset"
      echo
      echo -e "$Bleu NixOS$Reset"
      echo -e "$Jaune    nix-shell -p ${missing[*]} ou éditer configuration.nix$Reset"
    fi

    exit 1
  fi
}

#---------------------------------------------------------------------------------------------------------------------------------------------
show_banner() { # bannière principale du script
  clear
  gum style \
    --border double \
    --border-foreground $BleuGum \
    --padding "0 4" \
    --margin "1 0" \
    --align center \
    "$(gum style --foreground $VertGum --bold '🔐 SSH CONNECT MANAGER')" \
    "" \
    "$(gum style --foreground $NoirGum "Gestionnaire sécurisé de connections SSH - version ${VERSION}")" \
    "$(gum style --foreground $NoirGum 'Chiffrement AES-256 • Base de données SQLite • Interface GUM')" \
    "$(gum style --foreground $NoirGum "LICENCE : GPLv3 / COPYRIGHT : Jotenakis")"
}

#---------------------------------------------------------------------------------------------------------------------------------------------
encrypt_field() { # chiffrement d'un élément
  local plaintext="${1}"
  if [ -n "${plaintext}" ]; then
    echo -n "${plaintext}" | openssl enc -aes-256-cbc -pbkdf2 -iter 100000 -salt -pass "pass:${MASTER_PASSPHRASE}" -a
  fi
}

#---------------------------------------------------------------------------------------------------------------------------------------------
decrypt_field() { # déchiffrement d'un élément
  local ciphertext="${1}"
  if [ -n "${ciphertext}" ]; then
    local tmpfile
    tmpfile=$(mktemp)
    echo "${ciphertext}" > "${tmpfile}"
    openssl enc -aes-256-cbc -d -pbkdf2 -iter 100000 -pass "pass:${MASTER_PASSPHRASE}" -a -in "${tmpfile}" 2>/dev/null
    local result=$?
    rm -f "${tmpfile}"
    return $result
  fi
}

#---------------------------------------------------------------------------------------------------------------------------------------------
ask_master_passphrase() { # gestion du mot de passe principal utilisé pour chiffrer les secrets des connections ssh
  if [ -f "${DB_FILE}" ] && [ -f "${CANARY_FILE}" ]; then
    gum style --foreground $VertGum " Une base de données existe  merci de saisir la passphrase principale :"
    echo ""

    local attempts=0
    while [ $attempts -lt 3 ]; do
      MASTER_PASSPHRASE=$(gum input --cursor.foreground=$BleuGum --password --placeholder "Ta passphrase principale" --prompt "󰌆  ")
      [ -z "${MASTER_PASSPHRASE}" ] && {
        gum style --foreground $RougeGum " Passphrase principale requise."
        exit 1
      }

      local canary_encrypted
      canary_encrypted=$(cat "${CANARY_FILE}")
      local canary_decrypted
      canary_decrypted=$(decrypt_field "${canary_encrypted}") || true

      if [ "${canary_decrypted}" = "SSH_MANAGER_CANARY_OK" ]; then
        gum style --foreground $VertGum "✓ Passphrase principale correcte."
        sleep 0.5
        return 0
      else
        attempts=$((attempts + 1))
        if [ $attempts -lt 3 ]; then
          gum style --foreground $RougeGum " Passphrase principale incorrecte. Tentative ${attempts}/3."
        else
          gum style --foreground $RougeGum " Trop de tentatives. Sortie."
          exit 1
        fi
      fi
    done
  else
    gum style --foreground $VertGum "✨ Première utilisation : choisis une passphrase principale forte et mémorise-la !"
    echo ""

    MASTER_PASSPHRASE=$(gum input --cursor.foreground=$BleuGum --password --placeholder "Ta passphrase principale" --prompt "󰌆  ")
    [ -z "${MASTER_PASSPHRASE}" ] && {
      gum style --foreground $RougeGum " Passphrase principale requise."
      exit 1
    }

    local canary_encrypted
    canary_encrypted=$(encrypt_field "SSH_MANAGER_CANARY_OK")
    echo "${canary_encrypted}" > "${CANARY_FILE}"

    gum style --foreground $VertGum "✓ Passphrase principale configurée."
    sleep 0.5
  fi
}

#---------------------------------------------------------------------------------------------------------------------------------------------
init_db() { # création de la bdd SQLite pour stocker les différentes connections ssh
  sqlite3 "${DB_FILE}" <<'EOF'
CREATE TABLE IF NOT EXISTS connections (
  id                  INTEGER PRIMARY KEY AUTOINCREMENT,
  name                TEXT NOT NULL UNIQUE,
  user                TEXT NOT NULL,
  host                TEXT NOT NULL,
  port                INTEGER NOT NULL DEFAULT 22,
  passwd_encrypted    TEXT,
  tags                TEXT,
  key_auth            INTEGER NOT NULL DEFAULT 0,
  ssh_key_path        TEXT,
  key_passphrase_encrypted TEXT
);
EOF
}

#---------------------------------------------------------------------------------------------------------------------------------------------
list_ssh_keys() { # affichage des clés ssl existantes
  local ssh_dir="${HOME}/.ssh"
  [ ! -d "${ssh_dir}" ] && return 1

  local keys=()
  for key in "${ssh_dir}"/id_* "${ssh_dir}"/*.pem; do
    [ -f "${key}" ] && [[ ! "${key}" =~ \.pub$ ]] && keys+=("${key}")
  done

  [ ${#keys[@]} -eq 0 ] && return 1
  printf "%s\n" "${keys[@]}"
}

#---------------------------------------------------------------------------------------------------------------------------------------------
prompt_connection_fields() { # collecte des champs d'une connection ssh NOM, USER, HOTE, PORT, PASS, TAG, AUTH_METHOD, CHEMIN_CLE_SSH, PASSPHRASE_CLE_SSH
  # valeurs par défaut des champs
  local def_name="${1:-}" def_user="${2:-}" def_host="${3:-}" def_port="${4:-22}"
  local def_passwd_enc="${5:-}" def_tags="${6:-}" def_key_auth="${7:-0}"
  local def_ssh_key_path="${8:-}" def_key_pass_enc="${9:-}"

  # saisie des champs
  name=$(gum input --cursor.foreground=$BleuGum --placeholder "Nom" --value "${def_name}" --prompt "Nom de la connection > ") || return 1
  user=$(gum input --cursor.foreground=$BleuGum --placeholder "User SSH" --value "${def_user}" --prompt "Utilisateur > ") || return 1
  host=$(gum input --cursor.foreground=$BleuGum --placeholder "Host/IP" --value "${def_host}" --prompt "Hôte > ") || return 1
  port=$(gum input --cursor.foreground=$BleuGum --placeholder "22" --value "${def_port}" --prompt "Port > "); port=${port:-22}
  tags=$(gum input --cursor.foreground=$BleuGum --placeholder "Tags" --value "${def_tags}" --prompt "Tag > ") || true

  local auth_default="Mot de passe"; [ "${def_key_auth}" -eq 1 ] && auth_default="Clé SSH"
  local auth_choice
  auth_choice=$(gum choose --cursor.foreground=$BleuGum "Mot de passe" "Clé SSH" --header "Type d'authentification ? (actuel: ${auth_default})")

  key_auth=0; passwd_encrypted=""; ssh_key_path=""; key_passphrase_encrypted=""

  if [ "${auth_choice}" = "Mot de passe" ]; then # authentification par mot de passe
    key_auth=0 # pass
    local clear_passwd_def=""; [ -n "${def_passwd_enc}" ] && clear_passwd_def=$(decrypt_field "${def_passwd_enc}")
    local clear_passwd
    # saisie du mot de passe en clair
    clear_passwd=$(gum input --cursor.foreground=$BleuGum --cursor.foreground=$BleuGum --password --placeholder "Mot de passe serveur" --value "${clear_passwd_def}" --prompt "Mot de passe > ") || true
    # chiffrement du pass
    passwd_encrypted=$(encrypt_field "${clear_passwd}")
  else # authentification par clé ssl
    key_auth=1 # SSH key
    # on liste les clés si besoin en cherchant dans .ssh
    local available_keys
    mapfile -t available_keys < <(list_ssh_keys)

    if [ ${#available_keys[@]} -gt 0 ]; then # on a trouvé des clé ssh dans ~/.ssh
      available_keys+=("Autre (saisir manuellement)")
      local key_choice
      key_choice=$(printf "%s\n" "${available_keys[@]}" | gum choose --cursor.foreground=$BleuGum --header "Sélectionne ta clé SSH") || return 1

      if [ "${key_choice}" = "Autre (saisir manuellement)" ]; then
        ssh_key_path=$(gum input --cursor.foreground=$BleuGum --placeholder "Chemin clé SSH" --value "${def_ssh_key_path}" --prompt "Chemin complet > ") || true
      else
        ssh_key_path="${key_choice}"
      fi
    else # on n'a pas trouvé de clé ssh dans ~/.ssh
      gum style --foreground $VertGum "Aucune clé trouvée dans ~/.ssh/"
      ssh_key_path=$(gum input --cursor.foreground=$BleuGum --placeholder "Chemin clé SSH" --value "${def_ssh_key_path}" --prompt "Chemin complet > ") || true
    fi

    local clear_key_pass_def=""
    # on déchiffre la passphrase de la connection si elle existe (cas édition). sinon rien (cas création) donc ça reste vide.
    [ -n "${def_key_pass_enc}" ] && clear_key_pass_def=$(decrypt_field "${def_key_pass_enc}")
    # saisie de la passphrase de la connection
    local clear_key_pass
    clear_key_pass=$(gum input --cursor.foreground=$BleuGum --password --placeholder "Passphrase de la clé ssh (laisser vide si aucune)" --value "${clear_key_pass_def}" --prompt "Passphrase de la clé ssh > ") || true
    # on chiffre la passphrase de la conncetion
    key_passphrase_encrypted=$(encrypt_field "${clear_key_pass}")
  fi
}

#---------------------------------------------------------------------------------------------------------------------------------------------
create_connection() { # création d'une connection ssh en appelant la fonction de collecte des champs
  prompt_connection_fields || return 0

  # Ces lignes échappent les apostrophes dans toutes les variables avant de les insérer en base SQLite (sécurité)
  local name_esc="${name//\'/\'\'}"
  local user_esc="${user//\'/\'\'}"
  local host_esc="${host//\'/\'\'}"
  local tags_esc="${tags//\'/\'\'}"
  local passwd_enc_esc="${passwd_encrypted//\'/\'\'}"
  local ssh_key_path_esc="${ssh_key_path//\'/\'\'}"
  local key_pass_enc_esc="${key_passphrase_encrypted//\'/\'\'}"

  # stockage de la connection dans la base SQLite
  sqlite3 "${DB_FILE}" <<EOF
INSERT INTO connections (name, user, host, port, passwd_encrypted, tags, key_auth, ssh_key_path, key_passphrase_encrypted)
VALUES ('${name_esc}', '${user_esc}', '${host_esc}', ${port}, '${passwd_enc_esc}', '${tags_esc}', ${key_auth}, '${ssh_key_path_esc}', '${key_pass_enc_esc}');
EOF
  gum style --foreground $VertGum "'${name}' créée."
  sleep 1
}

list_connections() { # on affiche les connections stockées dans la base SQLite
  sqlite3 -separator '|' "${DB_FILE}" "SELECT id,name,user,host,port,IFNULL(tags,''),key_auth FROM connections ORDER BY name;"
}

#---------------------------------------------------------------------------------------------------------------------------------------------
choose_connection() { # sélection d'une connection de la base SQLite, en sortie on récupère l'id de la connection
  local entries; mapfile -t entries < <(list_connections)
  [ ${#entries[@]} -eq 0 ] && { gum style --foreground 1 " Aucune connection."; return 1; }

  local menu_items=()
  for line in "${entries[@]}"; do
    IFS='|' read -r id name user host port tags key_auth <<<"$line"
    local auth_icon="🔑"; [ "$key_auth" -eq 0 ] && auth_icon="🔓"
    menu_items+=("#${id} ${name} (${user}@${host}:${port}) [${tags}] ${auth_icon}")
  done

  local choice
  choice=$(printf "%s\n" "${menu_items[@]}" | gum choose --cursor.foreground=$BleuGum --header "$(gum style --foreground $VertGum --bold '󱘖 Connections') \
  $(gum style --foreground $NoirGum '(󰹺 naviguer • ⏎ valider • 󱊷 quitter)')" --height 20) || return 1
  echo "$choice" | sed -E 's/^#([0-9]+).*/\1/' # choose_connection contient alors l'id.
}

#---------------------------------------------------------------------------------------------------------------------------------------------
view_connection_details() { # affichage des détails d'une connection choisie
  local id; id=$(choose_connection) || return 0

  local row
  row=$(sqlite3 -separator '|' "${DB_FILE}" "SELECT name,user,host,port,IFNULL(passwd_encrypted,''),IFNULL(tags,''),key_auth,IFNULL(ssh_key_path,''),IFNULL(key_passphrase_encrypted,'') FROM connections WHERE id=$id;")
  IFS='|' read -r name user host port passwd_enc tags key_auth ssh_key_path key_pass_enc <<<"$row"

  show_banner
  gum style --border rounded --border-foreground $BleuGum --padding "0 1" "$(gum style --foreground $VertGum --bold "📋 Détails de la connection numéro ${id}")"
  echo ""

  gum style --foreground $JauneGum "Nom :" && echo "  $(gum style --foreground $BlancGum --bold "${name}")"
  gum style --foreground $JauneGum "User :" && echo "  $(gum style --foreground $BlancGum "${user}")"
  gum style --foreground $JauneGum "Host :" && echo "  $(gum style --foreground $BlancGum "${host}")"
  gum style --foreground $JauneGum "Port :" && echo "  $(gum style --foreground $BlancGum "${port}")"
  gum style --foreground $JauneGum "Tags :" && echo "  $(gum style --foreground $BlancGum "${tags:-<aucun>}")"
  if [ "${key_auth}" -eq 0 ]; then # auth par pass
    gum style --foreground $JauneGum "Type d'authentification :" && echo "  $(gum style --foreground $BlancGum "Mot de passe")"
    local has_passwd="non"; [ -n "${passwd_enc}" ] && has_passwd="oui"
    gum style --foreground $JauneGum "Mot de passe stocké :" && echo "  $(gum style --foreground $BlancGum "${has_passwd}")"
  else # auth par clé
    gum style --foreground $JauneGum "Type d'authentification :" && echo "  $(gum style --foreground $BlancGum "Clé SSH 🔑")"
    gum style --foreground $JauneGum "Chemin clé :" && echo "  $(gum style --foreground $BlancGum "${ssh_key_path:-<non spécifié>}")"
    local has_key_pass="non"; [ -n "${key_pass_enc}" ] && has_key_pass="oui"
    gum style --foreground $JauneGum "Passphrase clé stockée :" && echo "  $(gum style --foreground $BlancGum "${has_key_pass}")"
  fi
  local ssh_cmd="ssh -p ${port}"
  [ -n "${ssh_key_path}" ] && ssh_cmd+=" -i ${ssh_key_path}"
  ssh_cmd+=" ${user}@${host}"
  gum style --foreground $JauneGum "Commande SSH équivalente:"
  echo "  $(gum style --foreground $BlancGum "${ssh_cmd}")"
  echo ""

  # on affiche les secrets en clair si l'utilisateur le demande
  if gum confirm "Afficher les secrets déchiffrés ?"; then # oui il demande
    echo ""
    if [ "${key_auth}" -eq 0 ]; then
      if [ -n "${passwd_enc}" ]; then
        gum style --foreground $JauneGum "🔓 Mot de passe serveur:"
        local clear_passwd
        clear_passwd=$(decrypt_field "${passwd_enc}") || clear_passwd="<erreur déchiffrement>"
        echo "  $(gum style --foreground $BlancGum "${clear_passwd}")"
      fi
    else
      if [ -n "${key_pass_enc}" ]; then
        gum style --foreground $JauneGum "🔓 Passphrase clé SSH:"
        local clear_key_pass
        clear_key_pass=$(decrypt_field "${key_pass_enc}") || clear_key_pass="<erreur déchiffrement>"
        echo "  $(gum style --foreground $BlancGum "${clear_key_pass}")"
      else
        gum style --foreground $BlancGum "Clé sans passphrase."
      fi
    fi
  else # non il ne veut pas
    gum style --foreground $VertGum "Secrets non affichés."
  fi

  echo ""
  gum style --foreground $NoirGum "Appuie sur Entrée pour continuer..."
  read -r
}

#---------------------------------------------------------------------------------------------------------------------------------------------
edit_connection() { # édition des détails d'une connection choisie
  local id; id=$(choose_connection) || return 0
  local row
  # Récupération des données existantes dans la base SQLite avec WHERE id=$id
  row=$(sqlite3 -separator '|' "${DB_FILE}" "SELECT name,user,host,port,IFNULL(passwd_encrypted,''),IFNULL(tags,''),key_auth,IFNULL(ssh_key_path,''),IFNULL(key_passphrase_encrypted,'') FROM connections WHERE id=$id;")
  IFS='|' read -r def_name def_user def_host def_port def_passwd_enc def_tags def_key_auth def_ssh_key_path def_key_pass_enc <<<"$row"

  # Appelle la fonction de saisie en lui passant les 9 valeurs existantes comme paramètres.
  # Ça pré-remplit tous les champs gum input avec les anciennes valeurs.
  # L'utilisateur peut modifier ce qu'il veut.
  # À la sortie de prompt_connection_fields contiennent les nouvelles valeurs (modifiées ou non).
  prompt_connection_fields "$def_name" "$def_user" "$def_host" "$def_port" "$def_passwd_enc" "$def_tags" "$def_key_auth" "$def_ssh_key_path" "$def_key_pass_enc" || return 0

  # Echappement SQL par sécurité
  local name_esc="${name//\'/\'\'}"
  local user_esc="${user//\'/\'\'}"
  local host_esc="${host//\'/\'\'}"
  local tags_esc="${tags//\'/\'\'}"
  local passwd_enc_esc="${passwd_encrypted//\'/\'\'}"
  local ssh_key_path_esc="${ssh_key_path//\'/\'\'}"
  local key_pass_enc_esc="${key_passphrase_encrypted//\'/\'\'}"

  # Mise à jour de la base SQLite
  sqlite3 "${DB_FILE}" <<EOF
UPDATE connections SET
  name='${name_esc}',
  user='${user_esc}',
  host='${host_esc}',
  port=${port},
  passwd_encrypted='${passwd_enc_esc}',
  tags='${tags_esc}',
  key_auth=${key_auth},
  ssh_key_path='${ssh_key_path_esc}',
  key_passphrase_encrypted='${key_pass_enc_esc}'
WHERE id=$id;
EOF
  gum style --foreground $VertGum "#${id} mise à jour."
  sleep 1
}

#---------------------------------------------------------------------------------------------------------------------------------------------
delete_connection() { # suppression d'une connection choisie
  local id; id=$(choose_connection) || return 0
  if gum confirm "Supprimer #${id} ?"; then
    sqlite3 "${DB_FILE}" "DELETE FROM connections WHERE id=${id};"
    gum style --foreground $VertGum "#${id} supprimée."
    sleep 1
  fi
}

#---------------------------------------------------------------------------------------------------------------------------------------------
ssh_connect() { # connection ssh à partir d'une connection choisie dans la base SQLite
  local id; id=$(choose_connection) || return 0
  local row
  # Récupération des données existantes dans la base SQLite avec WHERE id=$id
  row=$(sqlite3 -separator '|' "${DB_FILE}" "SELECT user,host,port,IFNULL(passwd_encrypted,''),key_auth,IFNULL(ssh_key_path,''),IFNULL(key_passphrase_encrypted,'') FROM connections WHERE id=$id;")
  IFS='|' read -r user host port passwd_enc key_auth ssh_key_path key_pass_enc <<<"$row"

  clear
  gum style --foreground $BleuGum "Connection ${user}@${host}:${port} ..."

  if [ "${key_auth}" -eq 0 ]; then # authentification par mot de passe
    local clear_passwd
    # on déchiffre le mot de passe de la connection
    clear_passwd=$(decrypt_field "$passwd_enc")

    # Ce bloc automatise la connection SSH avec injection du mot de passe
    # expect { } : bloc de patterns à surveiller dans la sortie du terminal
    # on surveille les valeurs password et Password.
    # {send "${clear_passwd}\r"; exp_continue} : quand détecté, envoie le mot de passe + retour chariot (\r)
    # interact : rend le contrôle à l'utilisateur. Une fois connecté, tu reprends la main sur le terminal SSH comme si tu avais tapé manuellement
    expect <<EOF
spawn ssh -p ${port} -o StrictHostKeyChecking=no ${user}@${host}
expect {
  "password:" {send "${clear_passwd}\r"; exp_continue}
  "Password:" {send "${clear_passwd}\r"; exp_continue}
}
interact
EOF
  else # authentification par clé ssh
    # on construit la commande de connection
    local ssh_cmd="ssh -p ${port}"
    [ -n "${ssh_key_path}" ] && ssh_cmd+=" -i ${ssh_key_path}"
    ssh_cmd+=" -o StrictHostKeyChecking=no ${user}@${host}"

    if [ -n "${key_pass_enc}" ]; then # la passphrase de la clé ssh existe (non vide)
      local clear_key_pass
      # on déchiffre la passphrase de la clé ssh de la connection
      clear_key_pass=$(decrypt_field "$key_pass_enc")

      local askpass_script
      askpass_script=$(mktemp)
      # on crée un script bash temporaire de connection ssh avec injection de la passphrase ssh. ###################
      cat > "${askpass_script}" <<'ASKPASS'
#!/usr/bin/env bash
echo "PASSPHRASE_PLACEHOLDER"
ASKPASS
      sed -i "s|PASSPHRASE_PLACEHOLDER|${clear_key_pass}|" "${askpass_script}"
      chmod +x "${askpass_script}"
      ##############################################################################################################

      # shellcheck disable=SC2086
      SSH_ASKPASS="${askpass_script}" SSH_ASKPASS_REQUIRE=force setsid -w ${ssh_cmd} # on éxecute le script temporaire de connection et on le supprime.
      rm -f "${askpass_script}"
    else # pas de passphrase ssh on execute la commande directement.
      eval "${ssh_cmd}"
    fi
  fi
}

#---------------------------------------------------------------------------------------------------------------------------------------------
export_connections() { # export de la base dans un fichier texte .sql
  local file
  file=$(gum input --cursor.foreground=$BleuGum --placeholder "Fichier .sql" --prompt "Nom du fichier avec chemin complet > ") || return 0
  [ -z "${file}" ] && return 0

  {
    echo "-- SSH Manager Export v${VERSION}"
    echo "-- $(date)"
    echo ""
    echo "CREATE TABLE IF NOT EXISTS connections ("
    echo "  id                  INTEGER PRIMARY KEY AUTOINCREMENT,"
    echo "  name                TEXT NOT NULL UNIQUE,"
    echo "  user                TEXT NOT NULL,"
    echo "  host                TEXT NOT NULL,"
    echo "  port                INTEGER NOT NULL DEFAULT 22,"
    echo "  passwd_encrypted    TEXT,"
    echo "  tags                TEXT,"
    echo "  key_auth            INTEGER NOT NULL DEFAULT 0,"
    echo "  ssh_key_path        TEXT,"
    echo "  key_passphrase_encrypted TEXT"
    echo ");"
    echo ""
    sqlite3 "${DB_FILE}" "SELECT 'INSERT OR IGNORE INTO connections (name,user,host,port,passwd_encrypted,tags,key_auth,ssh_key_path,key_passphrase_encrypted) VALUES (' ||
      quote(name) || ',' ||
      quote(user) || ',' ||
      quote(host) || ',' ||
      port || ',' ||
      quote(IFNULL(passwd_encrypted,'')) || ',' ||
      quote(IFNULL(tags,'')) || ',' ||
      key_auth || ',' ||
      quote(IFNULL(ssh_key_path,'')) || ',' ||
      quote(IFNULL(key_passphrase_encrypted,'')) || ');'
    FROM connections;"
  } > "${file}"

  gum style --foreground $VertGum "Exporté vers ${file}."
  sleep 1
}

#---------------------------------------------------------------------------------------------------------------------------------------------
import_connections() { # import d'un fichier texte .sql dans la base
  local file
  file=$(gum input --cursor.foreground=$BleuGum --placeholder "Fichier .sql" --prompt "Nom du fichier avec chemin complet > ") || return 0
  [ ! -f "${file}" ] && { gum style --foreground $RougeGum "Fichier introuvable."; return 1; }

  if gum confirm "Importer '${file}' ? (les doublons seront ignorés)"; then
    sqlite3 "${DB_FILE}" < "${file}"
    gum style --foreground $VertGum "Import terminé."
    sleep 1
  fi
}

#---------------------------------------------------------------------------------------------------------------------------------------------
show_help() { # Affichage de l'aide
  show_banner
  gum style --border rounded --border-foreground $BleuGum --padding "0 1" "$(gum style --foreground $VertGum --bold "📖 Aide SSH CONNECT MANAGER")"
  echo ""

  gum style --foreground $JauneGum --bold " Description"
  echo "  • Programme de gestion de connections ssh"
  echo "  • Utilisation d'une base de données SQLite pour stocker toutes les données"
  echo "  • Authentification par mot de passe ou clé SSH (avec ou sans passphrase)"
  echo "  • Ne nécessite pas d'agent-ssh, le programme est autonome"
  echo "  • Les identifiants secrets sont stockés chiffrés"
  echo "  • Les secrets n'apparaisent en clair qu'à la demande de l'utilisateur"
  echo "  • Passphrase principale : créée initialement et demandée au démarrage de l'application pour chiffrer et déchiffrer les secrets"
  echo "  • Chiffrement AES-256-CBC avec PBKDF2 (100k itérations)"
  echo ""

  gum style --foreground $JauneGum --bold "󱘖 Menu Se connecter"
  echo "  Connection SSH automatique avec injection des identifiants sans les divulguer"
  echo ""

  gum style --foreground $JauneGum --bold " Menu Créer"
  echo "  Ajoute une nouvelle connection SSH dans la base"
  echo ""

  gum style --foreground $JauneGum --bold " Menu Éditer"
  echo "  Modifie une connection existante"
  echo ""

  gum style --foreground $JauneGum --bold " Menu Voir"
  echo "  Affiche les infos de connection et les secrets déchiffrés (optionnel)"
  echo ""

  gum style --foreground $JauneGum --bold "󰆴 Menu Supprimer"
  echo "  Supprime une connection de la base"
  echo ""

  gum style --foreground $JauneGum --bold "󰈇 Menus Exporter / 󰋺 Importer"
  echo "  Sauvegarde/restaure les connections au format SQL"
  echo ""

  gum style --foreground $JauneGum --bold " Fichiers/Dossier"
  echo "  • Répertoire des données : ${DATA_DIR}"
  echo "  • Base de données SQLite : ${DB_FILE}"
  echo "  • Canary (pour validation passphrase principale) : ${CANARY_FILE}"
  gum style --foreground $NoirGum "Appuie sur Entrée pour continuer..."
  read -r
}

#---------------------------------------------------------------------------------------------------------------------------------------------
main_menu() { # affichage du menu principal permettant de choisir les actions
  while true; do
    show_banner
    local choice
    # sélection dans une liste gum avec header et pas d'aide.
    choice=$(gum choose --cursor.foreground=$BleuGum --header \
    "$(gum style --foreground $VertGum --bold '󰍜 Menu principal') $(gum style --foreground $NoirGum '(󰹺 naviguer • ⏎ valider • 󱊷 quitter)')" \
    "󱘖 Se connecter" \
    " Créer une connection" \
    " Éditer une connection" \
    " Voir les détails d'une connection" \
    "󰆴 Supprimer une connection" \
    "󰈇 Exporter les connections" \
    "󰋺 Importer des connections" \
    "󰋖 Aide" \
    "󰩈 Quitter") || break

    case "${choice}" in
      "󱘖 Se connecter") ssh_connect ;;
      " Créer une connection") create_connection ;;
      " Éditer une connection") edit_connection ;;
      " Voir les détails d'une connection") view_connection_details ;;
      "󰆴 Supprimer une connection") delete_connection ;;
      "󰈇 Exporter les connections") export_connections ;;
      "󰋺 Importer des connections") import_connections ;;
      "󰋖 Aide") show_help ;;
      "󰩈 Quitter") break ;;
    esac
  done
}




#---------------------------------------------------------------------------------------------------------------------------------------------
clear
define_colors
check_dependencies
show_banner
ask_master_passphrase
clear
init_db
main_menu
#---------------------------------------------------------------------------------------------------------------------------------------------
