LOGFILE="$(dirname "$0")/dispatch.log"

APP=$1

TARGET_WORKSPACE=$2

if [[ -z "$APP" || -z "$TARGET_WORKSPACE" ]]; then
    echo "Usage: $0 <application_command> <target_workspace_number>" >> "$LOGFILE" 2>&1
    exit 1
fi

echo "Starting dispatch of '$APP' to workspace $TARGET_WORKSPACE at $(date)" >> "$LOGFILE"

hyprctl dispatch workspace "$TARGET_WORKSPACE" >> "$LOGFILE" 2>&1
sleep 0.4

$APP & disown
pid=$!

echo "Launched '$APP' with PID $pid" >> "$LOGFILE"

for i in {1..30}; do
    win=$(hyprctl clients -j | jq -r --arg APP "$APP" '
        .[] | select(.class | test($APP;"i")) | .address' 2>>"$LOGFILE")

    if [[ -n "$win" ]]; then
        echo "Found window $win for app '$APP', moving to workspace $TARGET_WORKSPACE" >> "$LOGFILE"

        hyprctl dispatch movetoworkspace "$TARGET_WORKSPACE,address:$win" >> "$LOGFILE" 2>&1
        exit 0
    fi
    sleep 0.3
done

echo "ERROR: Window for '$APP' was NOT found or dispatched properly to workspace $TARGET_WORKSPACE at $(date)" >> "$LOGFILE"

exit 1