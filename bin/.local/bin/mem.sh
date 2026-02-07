#!/usr/bin/env bash
###########################################################################################################################################################
# script pour remplacer la commande free en utilisant /proc/meminfo (et données de /sys) avec une meilleure lisibilité et plus de détails.
# LICENCE GPLv3
# AUTHOR jotenakis

###########################################################################################################################################################
set -euo pipefail
# init variables
version=2.3                                                     # numéro de version du script
export LC_NUMERIC=C                                             # pour éviter pb de symbole de la décimale
name="$(basename "$0")"                                         # nom du script
ZRAM_DETECTED=false                                             # gestion ZRAM
ZSWAP_DETECTED=false                                            # gestion ZSWAP
SIMPLE=false                                                    # affichage simplifié
HELP=false                                                      # affichage aide
VER=false                                                       # affichage version
NOEXPLAIN=false                                                 # affichage sans explications
FREE=false                                                      # affichage comme la commande free
NOCOLOR=false                                                   # affichage non coloré
FORCE_MIB=false                                                 # affichage "tout en MiB"
cols=110                                                        # largeur par défaut
Rouge="" ; Vert="" ; Jaune="" ; Bleu="" ; Cyan="" ; Reset=""    # par défaut pas de couleur

# fonction principale
main(){
    gestion-options "$@"
    [[ ${NOCOLOR} == false ]] && define_colors
    [[ ${HELP} == true ]]     && help
    [[ ${VER} == true ]]      && ver
    { ${HELP} || ${VER}; }    && exit 0
    check_dependance
    detect_swap
    compute_meminfo
    [[ ${FREE} == true ]] && display_as_free
    display_RAM
    if [[ -n "${swap_devices}" ]]; then
    	display_SWAP
    else
    	echo -e "\n${Cyan}Note\n  ${Vert}${name} n'a pas détecté d'espace d'échange (swap).${Reset}"
    fi
    return 0
}
###########################################################################################################################################################



#------------------------------------------------------------FONCTIONS-------------------------------------------------------------------------------------
define_colors() {
    Rouge=$'\033[0;31m'
    #Noir=$'\033[0;30m'
    Vert=$'\033[0;32m'
    Jaune=$'\033[0;33m'
    Bleu=$'\033[0;34m'
    #Magenta=$'\033[0;35m'
    Cyan=$'\033[0;36m'
    Reset=$'\033[0m'
    return 0
}
#----------------------------------------------------------------------------------------------------------------------------------------------------------
check_dependance(){
    if ! command -v bc >/dev/null 2>&1; then
        echo "/!\ Le paquet bc est requis, veuillez installer avant de relancer ${name}..."
        exit 1
    fi
}
#----------------------------------------------------------------------------------------------------------------------------------------------------------
header_box() {
    local color=$1
    shift
    local text="$*"
    local fg
    case "${color}" in
        red) fg=31;; green) fg=32;; yellow) fg=33;; blue) fg=34;;
        magenta) fg=35;; cyan) fg=36;; white) fg=37;; *) fg=39;;
    esac
    local w=$((cols - 2))
    (( w < 1 )) && return
    local len=${#text}
    (( len > w )) && text=${text:0:w} && len=w
    local padl=$(( (w - len) / 2 ))
    local padr=$(( w - len - padl ))

    local TL=$'\xE2\x95\x94' TR=$'\xE2\x95\x97'
    local BL=$'\xE2\x95\x9A' BR=$'\xE2\x95\x9D'
    local H=$'\xE2\x95\x90' V=$'\xE2\x95\x91'
    local hline
    hline=$(printf '%*s' "${w}" '' | sed "s/ /${H}/g")

    # Si NOCOLOR, pas de codes ANSI
    if ${NOCOLOR}; then
        printf '%s%s%s\n' "${TL}" "${hline}" "${TR}"
        printf '%s%*s%s%*s%s\n' "${V}" "${padl}" '' "${text}" "${padr}" '' "${V}"
        printf '%s%s%s\n' "${BL}" "${hline}" "${BR}"
    else
        printf '\033[%sm%s%s%s\033[0m\n' "${fg}" "${TL}" "${hline}" "${TR}"
        printf '\033[%sm%s%*s%s%*s%s\033[0m\n' "${fg}" "${V}" "${padl}" '' "${text}" "${padr}" '' "${V}"
        printf '\033[%sm%s%s%s\033[0m\n' "${fg}" "${BL}" "${hline}" "${BR}"
    fi
    return 0
}
#----------------------------------------------------------------------------------------------------------------------------------------------------------
ver(){
    echo -e "${Vert}version ${Bleu}v${version}${Reset}"
    [[ ${HELP} == false ]] && exit 0 || return 0
}
#----------------------------------------------------------------------------------------------------------------------------------------------------------
pad_right() {
    local colored width plain pad
    colored="$1"
    width=18
    plain=$(echo "${colored}" | sed 's/\x1b\[[0-9;]*m//g' | xargs)
    pad=$((width - ${#plain}))
    printf '%*s%s' "${pad}" '' "${colored}"
    return 0
}
#----------------------------------------------------------------------------------------------------------------------------------------------------------
help(){
    local color=""
    [[ ${NOCOLOR} == false ]] && color="cyan"
    header_box "${color}" "AIDE"
    echo -e "${Bleu}[Description]${Reset}"
   	echo -e "${Vert}=> ${name} calcule et affiche les données d'occupation de la mémoire virtuelle.${Reset}"
    echo ""
    echo -e "${Vert}=> ${name} n'utilise que les données disponibles dans /proc et /sys.${Reset}"
   	echo ""
    echo -e "${Vert}=> Les unités sont ajustées automatiquement avec un affichage coloré.${Reset}"
    echo -e "   - GiB = Go = giga-octets (facteur 1024), en ${Rouge}rouge${Reset}."
    echo -e "   - MiB = Mo = mega-octets (facteur 1024), en ${Jaune}jaune${Reset}."
    echo -e "   - KiB = Ko = kilo-octets (facteur 1024), en ${Vert}vert${Reset}."
    echo ""
    echo -e "${Bleu}[Options]${Reset}"
   	echo -e "${Jaune}  --simple,    -s, -S${Reset} : affichage concis.${Reset}"
    echo -e "${Jaune}  --nocolor,   -n, -N${Reset} : affichage non coloré.${Reset}"
    echo -e "${Jaune}  --free,      -f, -F${Reset} : affichage comme la commande free.${Reset}"
    echo -e "${Jaune}  --noexplain, -0    ${Reset} : affichage sans explication.${Reset}"
    echo -e "${Jaune}  --mib,       -m, -M${Reset} : affichage forcé en MiB.${Reset}"
   	echo -e "${Jaune}  --help,      -h, -H${Reset} : affichage de l'aide.${Reset}"
   	echo -e "${Jaune}  --version,   -v, -V${Reset} : affichage du numéro de version.${Reset}"
    echo ""
    echo -e "${Bleu}[Dépendance]${Reset}"
   	echo -e "${Jaune}  bc${Reset}, outil de calcul."
    echo ""
    [[ ${VER} == false ]] && exit 0 || return 0
}
#----------------------------------------------------------------------------------------------------------------------------------------------------------
gestion-options(){
    local OPTIND=1 opt  # Reset OPTIND pour réutilisable
    while getopts "fFhHvVsSnN0nM-:help:mib:free:nocolor:noexplain:simple" opt; do
        case ${opt} in
            h|H) HELP=true ;;
            v|V) VER=true ;;
            s|S) SIMPLE=true ;;
            f|F) FREE=true ;;
            0)   NOEXPLAIN=true ;;
            n|N) NOCOLOR=true ;;
            m|M) FORCE_MIB=true ;;
            -)  # Long option
                case "${OPTARG}" in
                    help)      HELP=true ;;
                    version)   VER=true ;;
                    simple)    SIMPLE=true ;;
                    noexplain) NOEXPLAIN=true ;;
                    free)      FREE=true ;;
                    nocolor)   NOCOLOR=true ;;
                    mib)       FORCE_MIB=true ;;
                    *)         echo "erreur inattendue dans getopts" >&2; exit 1 ;;
                esac
                ;;
            ?) echo "erreur, option inconnue : ${opt}."; exit 1 ;;  # Invalid
            *) echo "erreur inattendue dans getopts" >&2; exit 1 ;;
        esac
    done
    shift $((OPTIND-1))
    [[ $# -gt 0 ]] && { echo "erreur, option inconnue : $1" >&2; exit 1; } # Invalid
    ${NOEXPLAIN} && cols=55
    ${HELP} && cols=80
    return 0
}
#----------------------------------------------------------------------------------------------------------------------------------------------------------
format_size() {
    local kb=$1 val cal
    # Si flag -m activé, forcer MiB sans décimale
    if ${FORCE_MIB}; then
        val=$(echo "${kb}/1024" | bc)
        printf "%b%d MiB%b" "${Jaune}" "${val}" "${Reset}"
        return 0
    fi
    # Auto : 1 décimale si GiB, 0 sinon
    if (( kb >= 1048576 )); then
        cal=$(echo "scale=1; ${kb}/1048576" | bc)
        val=$(printf "%.1f" "${cal}")
        printf "%b%.1f GiB%b" "${Rouge}" "${val}" "${Reset}"
    elif (( kb >= 1024 )); then
        val=$(echo "${kb}/1024" | bc)
        printf "%b%d MiB%b" "${Jaune}" "${val}" "${Reset}"
    else
        printf "%b%d KiB%b" "${Vert}" "${kb}" "${Reset}"
    fi
    return 0
}

#----------------------------------------------------------------------------------------------------------------------------------------------------------
compute_meminfo(){
    local -A mem # toutes les données de meminfo sont stockés dans ce tableau associatif local
    local slab kernel_stack page_tables vmalloc_used percpu # pour calcul local de la mémoire kernel
    declare -g mem_total mem_avail mem_free mem_used mem_used_pct mem_free_pct buffers cached anon shmem dirty writeback hardwarecorrupted kernel_mem
    declare -g zswap zswapped swap_total swap_free swapcached swap_used swap_used_pct swap_free_pct
    declare -g sreclaimable
    local temp

    # parsing /proc/meminfo
    while IFS=': ' read -r key value _; do
        mem["${key%%[[:space:]]*}"]="${value%%[[:space:]]*}";
    done < /proc/meminfo

    # stockage data RAM et calculs
    mem_total=${mem[MemTotal]}
    mem_avail=${mem[MemAvailable]}
    mem_free=${mem[MemFree]}
    mem_used=$((mem_total - mem_avail))
    temp=$(echo "scale=1; 100 * ${mem_used} / ${mem_total}" | bc)
    mem_used_pct=$(printf "%.1f" "${temp}")
    temp=$(echo "scale=1; 100 - ${mem_used_pct}" | bc)
    mem_free_pct=$(printf "%.1f" "${temp}")
    [[ "${mem_used_pct}" = "100.0" ]] && mem_used_pct="100."
    [[ "${mem_free_pct}" = "0.0" ]]   && mem_free_pct="0.00"
    buffers=${mem[Buffers]}
    cached=${mem[Cached]}
    anon=${mem[AnonPages]}
    shmem=${mem[Shmem]}
    dirty=${mem[Dirty]}
    writeback=${mem[Writeback]}
    hardwarecorrupted=${mem[HardwareCorrupted]}
    # Mémoire kernel complète
    slab=${mem[Slab]}
    kernel_stack=${mem[KernelStack]}
    page_tables=${mem[PageTables]}
    vmalloc_used=${mem[VmallocUsed]:-0}
    percpu=${mem[Percpu]:-0}
    sreclaimable=${mem[SReclaimable]:-0}
    kernel_mem=$((slab + kernel_stack + page_tables + vmalloc_used + percpu))

    # stockage data SWAP et calculs
    zswap=${mem[Zswap]:-0}
    zswapped=${mem[Zswapped]:-0}
    swap_total=${mem[SwapTotal]}
    swap_free=${mem[SwapFree]}
    swapcached=${mem[SwapCached]}
    swap_used=$((swap_total - swap_free))
    if (( swap_total > 0 )); then
    	temp=$(echo "scale=1; (${swap_used} * 100.0) / ${swap_total}" | bc)
        swap_used_pct=$(printf "%.1f" "${temp}")
        temp=$(echo "scale=1; 100 - ${swap_used_pct}" | bc)
        swap_free_pct=$(printf "%.1f" "${temp}")
        [[ "${swap_used_pct}" = "100.0" ]] && swap_used_pct="100."
        [[ "${swap_free_pct}" = "0.0" ]]   && swap_free_pct="0.00"
        [[ "${swap_used_pct}" = "0.0" ]]   && swap_used_pct="0.00"
        [[ "${swap_free_pct}" = "100.0" ]] && swap_free_pct="100."
    fi
    return 0
}
#----------------------------------------------------------------------------------------------------------------------------------------------------------
detect_swap(){ # detect swap, zswap et zram
    declare -g swap_devices=""
    declare -g zram_size comp_algo_zram comp_algo_zswap
    declare -g zram_data zram_used
    local syszram num_zram filename zswap_status
    if [[ -f /proc/swaps ]]; then # on lit /proc/swaps
        while read -r filename _ _ _ _; do
            if [[ "${filename}" != "Filename" ]]; then # pour ignorer le header
                if [[ "${filename}" == /dev/zram* ]]; then
                    ZRAM_DETECTED=true
                    num_zram=${filename##*zram} # on extrait 0 si /dev/zram0
                    syszram="/sys/block/zram${num_zram}"
                    zram_size=$(( $(< "${syszram}/disksize") / 1024 ))
                    read -r zram_data _ zram_used _ < "${syszram}/mm_stat"
                    zram_data=$((zram_data / 1024))
                    zram_used=$((zram_used / 1024))
                    comp_algo_zram=$(grep -oP '\[\K[^\]]+' "/sys/block/zram${num_zram}/comp_algorithm")
                fi
                swap_devices="${swap_devices:+${swap_devices} }${filename}"
            fi
        done < /proc/swaps
    fi
    # Detection zswap
    if [[ -f /sys/module/zswap/parameters/enabled ]]; then
        zswap_status=$(cat /sys/module/zswap/parameters/enabled 2>/dev/null || echo "N")
        if [[ "${zswap_status}" = "Y" ]]; then
        	ZSWAP_DETECTED=true
        	comp_algo_zswap=$(< /sys/module/zswap/parameters/compressor)
        fi
    fi
    return 0
}
#----------------------------------------------------------------------------------------------------------------------------------------------------------
display_RAM_extended(){
    local explain_buffer explain_cache explain_anon explain_shmem explain_kernel explain_dirty explain_writeback explain_corrupted
    local pad1 pad2 pad3 pad4 pad5 pad6 pad7 pad8 c1 c2 c3 c4 c5 c6 c7 c8 d1 d2 d3 d4 d5 d6 d7 d8
    echo ""
    echo -e "${Cyan}Détails${Reset}"
    if ${NOEXPLAIN}; then
        explain_buffer=""
        explain_cache=""
        explain_anon=""
        explain_shmem=""
        explain_kernel=""
        explain_dirty=""
        explain_writeback=""
        explain_corrupted=""
    else
        explain_buffer="(mémoire utilisée pour optimiser les entrées/sorties des disques)"
        explain_cache="(mémoire utilisée pour mettre en cache les fichiers lus)"
        explain_anon="(mémoire utilisée par les processus/applications)"
        explain_shmem="(mémoire partagée, tmpfs et certains GPU intégrés)"
        explain_kernel="(mémoire utilisée par le noyau Linux)"
        explain_dirty="(mémoire en attente d'écriture sur les disques)"
        explain_writeback="(mémoire en cours d'écriture sur les disques)"
        explain_corrupted="(mémoire marquée comme corrompue par le noyau Linux)"
    fi
    # construction
    pad1="Tampons         "
    pad2="Cache           "
    pad3="Anonyme         "
    pad4="Partagée        "
    pad5="Noyau           "
    pad6="Attente         "
    pad7="Écriture        "
    pad8="Corrompue       "
    c1="$(format_size "${buffers}")"           ; d1=$(pad_right "${c1}")
    c2="$(format_size "${cached}")"            ; d2=$(pad_right "${c2}")
    c3="$(format_size "${anon}")"              ; d3=$(pad_right "${c3}")
    c4="$(format_size "${shmem}")"             ; d4=$(pad_right "${c4}")
    c5="$(format_size "${kernel_mem}")"        ; d5=$(pad_right "${c5}")
    c6="$(format_size "${dirty}")"             ; d6=$(pad_right "${c6}")
    c7="$(format_size "${writeback}")"         ; d7=$(pad_right "${c7}")
    c8="$(format_size "${hardwarecorrupted}")" ; d8=$(pad_right "${c8}")
    # affichage
    printf "  %s: %s   %s\n" "${pad1}" "${d1}" "${explain_buffer}"
    printf "  %s: %s   %s\n" "${pad2}" "${d2}" "${explain_cache}"
    printf "  %s: %s   %s\n" "${pad3}" "${d3}" "${explain_anon}"
    printf "  %s: %s   %s\n" "${pad4}" "${d4}" "${explain_shmem}"
    printf "  %s: %s   %s\n" "${pad5}" "${d5}" "${explain_kernel}"
    printf "  %s: %s   %s\n" "${pad6}" "${d6}" "${explain_dirty}"
    printf "  %s: %s   %s\n" "${pad7}" "${d7}" "${explain_writeback}"
    printf "  %s: %s   %s\n" "${pad8}" "${d8}" "${explain_corrupted}"
    return 0
}

#----------------------------------------------------------------------------------------------------------------------------------------------------------
display_RAM(){
    local color="" pad1 pad2 pad3 pad4 c1 c2 c3 c4 d1 d2 d3 d4
    [[ ${NOCOLOR} == false ]] && color="cyan"
    header_box "${color}" "Mémoire vive (RAM)"
    # construction
    pad1="Totale            "
    pad2="Utilisée          "
    pad3="Disponible        "
    pad4="Libre             "
    c1="$(format_size "${mem_total}")" ; d1=$(pad_right "${c1}")
    c2="$(format_size "${mem_used}")"  ; d2=$(pad_right "${c2}")
    c3="$(format_size "${mem_avail}")" ; d3=$(pad_right "${c3}")
    c4="$(format_size "${mem_free}")"  ; d4=$(pad_right "${c4}")
    # affichage
    printf "%s: %s\n" "${pad1}" "${d1}"
    printf "%s: %s   ${Bleu}%-4s%%${Reset}\n" "${pad2}" "${d2}" "${mem_used_pct}"
    printf "%s: %s   ${Bleu}%-4s%%${Reset}\n" "${pad3}" "${d3}" "${mem_free_pct}"
    printf "%s: %s\n" "${pad4}" "${d4}"
    [[ ${SIMPLE} == false ]] && display_RAM_extended
    return 0
}
#----------------------------------------------------------------------------------------------------------------------------------------------------------
display_swap_comp() { # zram ou zswap
    local back="$1" comp_algo="$2" pool_max="$3" pool_used="$4" data="$5"
    local explain_pool="$6" explain_used="$7" explain_data="$8"
    local dev temp c1 c2 c3 c4 c5 c6 c7 d1 d2 d3 d4 d5 d6 d7

    # gestion multi swap
    for dev in ${swap_devices}; do
        temp=$(pad_right "${Bleu}${dev}${Reset}")
        printf " Périphérique     : %s %s\n" "${temp}" "${explain_device}"
    done

    # construction
    c1="${Bleu}${back}(${comp_algo})${Reset}" ; d1=$(pad_right "${c1}")
    c2=$(format_size "${swapcached}")         ; d2=$(pad_right "${c2}")
    c3=$(format_size "${pool_max}")           ; d3=$(pad_right "${c3}")
    c4=$(format_size "${pool_used}")          ; d4=$(pad_right "${c4}")
    # affichage
    printf " Compression      : %s   %s\n" "${d1}" "${explain_comp}"
    printf " Swap en cache    : %s   %s\n" "${d2}" "${explain_cached}"
    printf " Pool ${back} max   : %s   %s\n" "${d3}" "${explain_pool}"
    printf " Pool ${back}       : %s   %s\n" "${d4}" "${explain_used}"

    # gestion ratio de compression
    if (( data > 0 )); then
        c5=$(format_size "${data}") ; d5=$(pad_right "${c5}")
        printf " Données ${back}    : %s   %s\n" "${d5}" "${explain_data}"
        if (( pool_used > 0 )); then
            local ratio
            d6=$(echo "scale=1; ${data} / ${pool_used}" | bc) ; ratio=$(printf "%.1f" "${d6}")
            c7="${Bleu}x${ratio}${Reset}" ; d7=$(pad_right "${c7}")
            printf " Efficacité       : %s   %s\n" "${d7}" "${explain_ratio}"
        fi
    fi
    return 0
}
#----------------------------------------------------------------------------------------------------------------------------------------------------------
display_SWAP_extended(){
    local pc_zswap pool_zswap ratio
    local explain_cached explain_pool explain_zswap explain_zswapped explain_ratio
    local explain_zramsize explain_zram explain_zrammed explain_device explain_comp
    echo
    if ${NOEXPLAIN}; then # on n'affiche pas d'explications
        explain_cached=""
        explain_pool=""
        explain_zswap=""
        explain_zswapped=""
        explain_zram=""
        explain_zrammed=""
        explain_ratio=""
        explain_zramsize=""
        explain_device=""
        explain_comp=""
    else
        explain_cached="(données en échange et en mémoire)"
        explain_pool="(mémoire utilisable par zswap)"
        explain_zswap="(mémoire utilisée par zswap)"
        explain_zswapped="(valeur non compressée des données en zswap)"
        explain_zram="(mémoire utilisée par zram)"
        explain_zrammed="(valeur non compressée des données en zram)"
        explain_ratio="(taux de compression)"
        explain_zramsize="(mémoire utilisable par zram)"
        explain_device=""
        explain_comp="(dispositif de compression d'échange en mémoire)"
    fi
    echo -e "${Cyan}Détails${Reset}"
    if ${ZSWAP_DETECTED}; then
        pc_zswap="$(cat /sys/module/zswap/parameters/max_pool_percent)"
        pool_zswap=$(( pc_zswap * mem_total / 100 ))
        display_swap_comp "Zswap" "${comp_algo_zswap}" "${pool_zswap}" "${zswap}" "${zswapped}" "${explain_pool}" "${explain_zswap}" "${explain_zswapped}"
    fi
    if ${ZRAM_DETECTED}; then
        display_swap_comp "Zram " "${comp_algo_zram}" "${zram_size}" "${zram_used}" "${zram_data}" "${explain_zramsize}" "${explain_zram}" "${explain_zrammed}"
    fi
    return 0
}
#----------------------------------------------------------------------------------------------------------------------------------------------------------
display_SWAP(){
    local color="" pad1 pad2 pad3 c1 c2 c3 d1 d2 d3
    echo ""
    [[ ${NOCOLOR} == false ]] && color="cyan"
    header_box "${color}" "Espace d'échange (SWAP)"
    # construction
    pad1="Total             "
    pad2="Utilisé           "
    pad3="Disponible        "
    c1="$(format_size "${swap_total}")" ; d1=$(pad_right "${c1}")
    c2="$(format_size "${swap_used}")"  ; d2=$(pad_right "${c2}")
    c3="$(format_size "${swap_free}")"  ; d3=$(pad_right "${c3}")
    # affichage
    printf "%s: %s\n" "${pad1}" "${d1}"
    printf "%s: %s   ${Bleu}%-4s%%${Reset}\n" "${pad2}" "${d2}" "${swap_used_pct}"
    printf "%s: %s   ${Bleu}%-4s%%${Reset}\n" "${pad3}" "${d3}" "${swap_free_pct}"
    [[ ${SIMPLE} == false ]] && display_SWAP_extended
    return 0
}
#----------------------------------------------------------------------------------------------------------------------------------------------------------
display_as_free() {
    local pad=12 c1 c2 c3 c4 c5 c6 d1 d2 d3 d4 d5 d6 bufcache
    pad_col() {
        local colored="$1"
        local plain
        # shellcheck disable=SC2001
        plain=$(echo "${colored}" | sed 's/\x1b\[[0-9;]*m//g')
        local len=${#plain}
        local spaces=$((pad - len))
        printf '%*s%s' "${spaces}" '' "${colored}"
    }

    # header
    c1=$(pad_col "total")
    c2=$(pad_col "utilisé")
    c3=$(pad_col "libre")
    c4=$(pad_col "partagé")
    c5=$(pad_col "tamp/cache")
    c6=$(pad_col "disponible")
    printf "%-6s%s%s%s%s%s%s\n" "" "${c1}" "${c2}" "${c3}" "${c4}" "${c5}" "${c6}"

	# Mem
	bufcache=$((buffers + cached + sreclaimable)) # la commande free calcule buff/cache = Buffers + Cached + SReclaimable
	c1=$(format_size "${mem_total}") ; d1=$(pad_col "${c1}")
	c2=$(format_size "${mem_used}")  ; d2=$(pad_col "${c2}")
	c3=$(format_size "${mem_free}")  ; d3=$(pad_col "${c3}")
	c4=$(format_size "${shmem}")     ; d4=$(pad_col "${c4}")
	c5=$(format_size "${bufcache}")  ; d5=$(pad_col "${c5}")
	c6=$(format_size "${mem_avail}") ; d6=$(pad_col "${c6}")
    printf "%-6s%s%s%s%s%s%s\n" "Mem :" "${d1}" "${d2}" "${d3}" "${d4}" "${d5}" "${d6}"

	# Swap
	c1=$(format_size "${swap_total}") ; d1=$(pad_col "${c1}")
	c2=$(format_size "${swap_used}")  ; d2=$(pad_col "${c2}")
	c3=$(format_size "${swap_free}")  ; d3=$(pad_col "${c3}")
    printf "%-6s%s%s%s\n" "Swap:" "${d1}" "${d2}" "${d3}"
    exit 0
}
#---------------------------------------------------------/ FONCTIONS--------------------------------------------------------------------------------------



######################################################## Corps du script ##################################################################################
main "$@"
###########################################################################################################################################################
