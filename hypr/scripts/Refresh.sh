SCRIPTSDIR=$HOME/.config/hypr/scripts
UserScripts=$HOME/.config/hypr/UserScripts

file_exists() {
    if [ -e "$1" ]; then
        return 0
    else
        return 1
    fi
}

_ps=(waybar rofi swaync ags)
for _prs in "${_ps[@]}"; do
    if pidof "${_prs}" >/dev/null; then
        pkill "${_prs}"
    fi
done

killall -SIGUSR2 waybar 

for pid in $(pidof waybar rofi swaync ags swaybg); do
    kill -SIGUSR1 "$pid"
done

sleep 1
waybar &

sleep 0.5
swaync > /dev/null 2>&1 &

swaync-client --reload-config

sleep 1
if file_exists "${UserScripts}/RainbowBorders.sh"; then
    ${UserScripts}/RainbowBorders.sh &
fi

exit 0