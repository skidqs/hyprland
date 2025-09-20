#!/bin/bash

MAX=100
STEP=5

get_vol() {
    pactl get-sink-volume @DEFAULT_SINK@ | awk '{print $5}' | head -n1 | tr -d '%'
}

get_mute() {
    pactl get-sink-mute @DEFAULT_SINK@ | awk '{print $2}'
}

set_vol() {
    pactl set-sink-volume @DEFAULT_SINK@ "$1%"
}

toggle_mute() {
    pactl set-sink-mute @DEFAULT_SINK@ toggle
}

inc_vol() {
    vol=$(get_vol)
    muted=$(get_mute)
    ((vol+=STEP))
    if [ $vol -gt $MAX ]; then vol=$MAX; fi
    set_vol $vol
    if [ "$muted" = "yes" ]; then
        pactl set-sink-mute @DEFAULT_SINK@ 0
    fi
}

dec_vol() {
    vol=$(get_vol)
    ((vol-=STEP))
    if [ $vol -le 0 ]; then
        vol=0
        pactl set-sink-mute @DEFAULT_SINK@ 1
    fi
    set_vol $vol
}

case $1 in
    --toggle)
        toggle_mute
        ;;
    --inc)
        inc_vol
        ;;
    --dec)
        dec_vol
        ;;
esac
