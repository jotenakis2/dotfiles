#!/usr/bin/env bash

# affiche des couleurs dans le terminal avec le code ansi associé

echo
echo
echo
for code in {0..255}
	do echo -e "\e[38;5;${code}m"'         \e[0m   \\e[38;5;'"$code"m""
done
echo
echo '\e[0;30m'" - $(printf '\e[0;30mBlack\e[0m')"
echo '\e[0;31m'" - $(printf '\e[0;31mRed\e[0m')"
echo '\e[0;32m'" - $(printf '\e[0;32mGreen\e[0m')"
echo '\e[0;33m'" - $(printf '\e[0;33mYellow\e[0m')"
echo '\e[0;34m'" - $(printf '\e[0;34mBlue\e[0m')"
echo '\e[0;35m'" - $(printf '\e[0;35mPurple\e[0m')"
echo '\e[0;36m'" - $(printf '\e[0;36mCyan\e[0m')"
echo '\e[0;37m'" - $(printf '\e[0;37mWhite\e[0m')"

echo '\e[1;30m'" - $(printf '\e[1;30mbold Black\e[0m')"
echo '\e[1;31m'" - $(printf '\e[1;31mbold Red\e[0m')"
echo '\e[1;32m'" - $(printf '\e[1;32mbold Green\e[0m')"
echo '\e[1;33m'" - $(printf '\e[1;33mbold Yellow\e[0m')"
echo '\e[1;34m'" - $(printf '\e[1;34mbold Blue\e[0m')"
echo '\e[1;35m'" - $(printf '\e[1;35mbold Purple\e[0m')"
echo '\e[1;36m'" - $(printf '\e[1;36mbold Cyan\e[0m')"
echo '\e[1;37m'" - $(printf '\e[1;37mbold White\e[0m')"

echo '\e[0;90m'" - $(printf '\e[0;90mhigh intensity Black\e[0m')"
echo '\e[0;91m'" - $(printf '\e[0;91mhigh intensity Red\e[0m')"
echo '\e[0;92m'" - $(printf '\e[0;92mhigh intensity Green\e[0m')"
echo '\e[0;93m'" - $(printf '\e[0;93mhigh intensity Yellow\e[0m')"
echo '\e[0;94m'" - $(printf '\e[0;94mhigh intensity Blue\e[0m')"
echo '\e[0;95m'" - $(printf '\e[0;95mhigh intensity Purple\e[0m')"
echo '\e[0;96m'" - $(printf '\e[0;96mhigh intensity Cyan\e[0m')"
echo '\e[0;97m'" - $(printf '\e[0;97mhigh intensity White\e[0m')"






echo
for x in {0..5}; do echo --- && for z in 0 10 60 70; do for y in {30..37}; do y=$((y + z)) && printf '\e[%d;%dm%-12s\e[0m' "$x" "$y" "$(printf ' \\e[%d;%dm] ' "$x" "$y")" && printf ' '; done && printf '\n'; done; done

