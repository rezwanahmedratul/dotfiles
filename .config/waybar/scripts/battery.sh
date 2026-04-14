#!/bin/bash

cap=$(cat /sys/class/power_supply/BAT0/capacity 2>/dev/null)

energy_now=$(cat /sys/class/power_supply/BAT0/energy_now 2>/dev/null)
energy_full=$(cat /sys/class/power_supply/BAT0/energy_full 2>/dev/null)

if [[ -n "$energy_now" && -n "$energy_full" ]]; then
    cap=$(( energy_now * 100 / energy_full ))
fi

status=$(cat /sys/class/power_supply/AC/online 2>/dev/null)
temp=$(sensors | awk '/Package id 0/ {print $4}' | tr -d '+')
fan=$(sensors | awk '/fan1:/ {print $2}')
power=$(cat /sys/class/power_supply/BAT0/power_now 2>/dev/null)

if [[ -n "$power" ]]; then
    watt=$(awk "BEGIN {printf \"%.1f\", $power/1000000}")
else
    watt="N/A"
fi

if [[ "$status" == "1" ]]; then
    direction="↓"
else
    direction="↑"
fi

if [[ "$status" == "1" ]]; then
    icon="󱐋${cap}%"
else
    icon="${cap}%"
fi

echo "{\"text\": \"$icon\", \"tooltip\": \" $temp | 󰈐 $fan RPM | 󱐋 ${watt}W$direction\"}"
