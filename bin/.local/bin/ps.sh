#!/usr/bin/env zsh

# gestionnaire de processus

# Valeurs par défaut
SORT="-%cpu"
LIMIT=0
NEWBIE=0
INTERVAL=2
AUTO_LIMIT=1

# Parse des arguments
while [[ $# -gt 0 ]]; do
  case $1 in
    --pid)
      SORT="pid"
      shift
      ;;
    --cpu)
      SORT="-%cpu"
      shift
      ;;
    --mem)
      SORT="-rss"
      shift
      ;;
    --newbie)
      NEWBIE=1
      shift
      ;;
    --watch)
      if [[ $2 =~ ^[0-9]+$ ]]; then
        INTERVAL=$2
        shift
      fi
      shift
      ;;
    --[0-9]*)
      LIMIT="${1#--}"
      AUTO_LIMIT=0
      shift
      ;;
    *)
      echo "Usage: $(basename $0) [--pid|--cpu|--mem] [--newbie] [--watch [interval]] [--10|--20|--40|...]"
	  echo
      echo "  --watch n  : affichage toutes les n secondes (0: affichage unique sans rafraîchissement)."
      echo "  --xy       : affiche xy processus."
      echo "  --newbie   : affichage simplifié."
      echo "  par défaut : rafraîchissement toutes les 2 secondes, tri par cpu, nb de processus adapté à la hauteur du terminal."
      exit 1
      ;;
  esac
done

# Fonction d'affichage
display_ps() {
  # Récupère la largeur et hauteur du terminal et le nombre de CPUs
  WIDTH=${COLUMNS:-$(tput cols)}
  HEIGHT=${LINES:-$(tput lines)}
  NCPU=$(nproc)
  
  # Calcul automatique de la limite si non spécifiée
  if [ $AUTO_LIMIT -eq 1 ]; then
    LIMIT=$((HEIGHT - 5))
    [ $LIMIT -lt 1 ] && LIMIT=10
  fi

  # Commande ps avec awk
  if [ $NEWBIE -eq 1 ]; then
    # Mode newbie : sans PPID ni NICE ni %MEM
    ps --pid 2 -N --ppid 2 -N -o pid,user:10,rss,%cpu,cmd --sort=$SORT --cols=500 2>/dev/null | awk -v limit=$LIMIT -v width=$WIDTH -v ncpu=$NCPU -v sort="$SORT" '
BEGIN{
  RED="\033[1;31m"
  RESET="\033[0m"
}
NR==1{
  if(sort=="pid")
    printf RED "%7s" RESET " %-10s %8s %8s %-30s %s\n", $1,$2,"MEM(Mo)","%CPU","COMMAND","OPTIONS"
  else if(sort=="-rss")
    printf "%7s %-10s " RED "%8s" RESET " %8s %-30s %s\n", $1,$2,"MEM(Mo)","%CPU","COMMAND","OPTIONS"
  else
    printf "%7s %-10s %8s " RED "%8s" RESET " %-30s %s\n", $1,$2,"MEM(Mo)","%CPU","COMMAND","OPTIONS"
  next
}
/ps --pid|awk|grep|grcat-wrapped|grc-wrapped|python3.*grc/{
  next
}
{
  ram=$3/1024
  cpu=$4
  line=sprintf("%7d %-10s %8.1f %8.1f ", $1,$2,ram,cpu/ncpu)
  cmd=$5
  sub(/^.*\//,"",cmd)
  line=line sprintf("%-30s", cmd)
  for(i=6;i<=NF;i++) line=line " " $i
  print substr(line,1,width)
  total_ram+=ram
  total_cpu+=cpu
  count++
  if(limit>0 && count==limit) exit
}
END{
  print ""
  printf "%7s %-10s %8.1f %8.1f %s\n", "","TOTAL:",total_ram,total_cpu/ncpu,"("count" processus)"
}' | grcat conf.ps
  else
    # Mode normal : avec PPID et NICE
    ps --pid 2 -N --ppid 2 -N -o pid,ppid,user:10,nice,rss,%cpu,%mem,cmd --sort=$SORT --cols=500 2>/dev/null | awk -v limit=$LIMIT -v width=$WIDTH -v ncpu=$NCPU -v sort="$SORT" '
BEGIN{
  RED="\033[1;31m"
  RESET="\033[0m"
}
NR==1{
  if(sort=="pid")
    printf RED "%7s" RESET " %7s %-10s %4s %8s %8s %5s %-30s %s\n", $1,$2,$3,$4,"MEM(Mo)","%CPU",$7,"COMMAND","OPTIONS"
  else if(sort=="-rss")
    printf "%7s %7s %-10s %4s " RED "%8s" RESET " %8s %5s %-30s %s\n", $1,$2,$3,$4,"MEM(Mo)","%CPU",$7,"COMMAND","OPTIONS"
  else
    printf "%7s %7s %-10s %4s %8s " RED "%8s" RESET " %5s %-30s %s\n", $1,$2,$3,$4,"MEM(Mo)","%CPU",$7,"COMMAND","OPTIONS"
  next
}
/ps --pid|awk|grep|grcat-wrapped|grc-wrapped|python3.*grc/{
  next
}
{
  ram=$5/1024
  cpu=$6
  mem=$7
  line=sprintf("%7d %7d %-10s %4s %8.1f %8.1f %5s ", $1,$2,$3,$4,ram,cpu/ncpu,mem)
  cmd=$8
  sub(/^.*\//,"",cmd)
  line=line sprintf("%-30s", cmd)
  for(i=9;i<=NF;i++) line=line " " $i
  print substr(line,1,width)
  total_ram+=ram
  total_cpu+=cpu
  total_mem+=mem
  count++
  if(limit>0 && count==limit) exit
}
END{
  print ""
  printf "%7s %7s %-10s %4s %8.1f %8.1f %5.1f %s\n", "","","TOTAL:","",total_ram,total_cpu/ncpu,total_mem,"("count" processus)"
}' | grcat conf.ps
  fi
}

# Exécution
if [ $INTERVAL -eq 0 ]; then
  # Affichage unique
  display_ps
else
  # Mode watch par défaut
  while true; do
    clear
    display_ps
    sleep $INTERVAL
  done
fi
