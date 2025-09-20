SCRIPTSDIR=$HOME/.config/hypr/scripts
UserScripts=$HOME/.config/hypr/UserScripts

file_exists() {
    if [ -e "$1" ]; then
        return 0
    else
        return 1
    fi
}

_ps=(rofi)
for _prs in "${_ps[@]}"; do
    if pidof "${_prs}" >/dev/null; then
        pkill "${_prs}"
    fi
done

${SCRIPTSDIR}/WallustSwww.sh &

swaync-client --reload-config

sleep 1
if file_exists "${UserScripts}/RainbowBorders.sh"; then
    ${UserScripts}/RainbowBorders.sh &
fi


exit 0