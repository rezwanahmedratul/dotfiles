#!/bin/bash

CONFIG_NUM=$1
CONFIG="$HOME/dotfiles/.config/shadowsocks/config${CONFIG_NUM}.json"

# Check if config exists
if [ ! -f "$CONFIG" ]; then
    notify-send -u critical -i dialog-error "Shadowsocks Error" "Config ${CONFIG_NUM} not found!"
    exit 1
fi

# Check if already running
PID=$(pgrep -f "ss-local -c $CONFIG")

if [ -n "$PID" ]; then
    if pkill -f "ss-local -c $CONFIG"; then
        notify-send -i network-vpn "Shadowsocks" "Config ${CONFIG_NUM} stopped" -u normal
    else
        notify-send -u critical -i dialog-error "Shadowsocks Error" "Failed to stop config ${CONFIG_NUM}"
    fi
else
    # Try to start
    ss-local -c "$CONFIG" >/tmp/ss-local-${CONFIG_NUM}.log 2>&1 &
    sleep 0.5

    # Check if it actually started
    if pgrep -f "ss-local -c $CONFIG" > /dev/null; then
        notify-send -i network-vpn "Shadowsocks" "Config ${CONFIG_NUM} started" -u low
    else
        ERROR_MSG=$(tail -n 5 /tmp/ss-local-${CONFIG_NUM}.log)
        notify-send -u critical -i dialog-error "Shadowsocks Failed" "Config ${CONFIG_NUM} failed:\n${ERROR_MSG}"
    fi
fi