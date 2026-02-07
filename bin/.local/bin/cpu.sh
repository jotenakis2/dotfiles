#!/usr/bin/env bash

read -r _ user nice system idle iowait irq softirq steal _ _ _ < /proc/stat
prev_total=$((user + nice + system + idle + iowait + irq + softirq + steal))
prev_idle=$((idle + iowait))

sleep 1

read -r _ user nice system idle iowait irq softirq steal _ _ _ < /proc/stat

total=$((user + nice + system + idle + iowait + irq + softirq + steal))
idle_total=$((idle + iowait))

diff_total=$((total - prev_total))
diff_idle=$((idle_total - prev_idle))

((diff_total > 0)) && cpu=$((100 * (diff_total - diff_idle) / diff_total)) || cpu=0

echo "$cpu"
