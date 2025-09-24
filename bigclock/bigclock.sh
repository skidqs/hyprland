#!/bin/bash
tput civis
trap 'tput cnorm' EXIT

while true; do
    current_time=$(date +"%I:%M %P" | tr '[:lower:]' '[:upper:]')
    lines=$(tput lines)
    cols=$(tput cols)
    
    toilet_output=$(toilet -f mono12 "$current_time")
    toilet_height=$(echo "$toilet_output" | wc -l)
    start_line=$(( (lines - toilet_height) / 2 ))
    
    tput home
    tput ed
    
    for ((i=0; i<start_line; i++)); do
        echo
    done
    
    while IFS= read -r line; do
        line_length=${#line}
        padding=$(( (cols - line_length) / 2 ))
        printf "%*s\e[38;2;136;136;136m%s\e[0m\n" $padding "" "$line"
    done <<< "$toilet_output"
    
    sleep 1
done
