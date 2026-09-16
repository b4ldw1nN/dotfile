#!/usr/bin/env bash
# Broadcast current hyprshell colors to all active foot terminals and signal foot server

CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}"
HYPRSHELL_DIR="$CONFIG_DIR/hyprshell"

if [ -f "$HYPRSHELL_DIR/colors.sh" ]; then
    source "$HYPRSHELL_DIR/colors.sh"
    FG="${FOREGROUND:-#f0f3f8}"
    BG="${TERMINAL_BG:-$BACKGROUND}"

    # OSC 10 (foreground) & OSC 11 (background)
    SEQ="\033]10;${FG}\007\033]11;${BG}\007"

    # OSC 4 (ANSI colors 0..15)
    for i in {0..15}; do
        var="COLOR$i"
        val="${!var}"
        if [ -n "$val" ]; then
            SEQ="${SEQ}\033]4;${i};${val}\007"
        fi
    done

    # Broadcast to all writable pseudo-terminals
    for pt in /dev/pts/[0-9]*; do
        if [ -w "$pt" ]; then
            printf "%b" "$SEQ" > "$pt" 2>/dev/null || true
        fi
    done
fi

# Signal foot to switch theme (USR2 -> USR1 forces state toggle)
pkill -SIGUSR2 foot 2>/dev/null || true
pkill -SIGUSR1 foot 2>/dev/null || true
