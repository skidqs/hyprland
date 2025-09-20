pkill yad || true

if pidof rofi > /dev/null; then
  pkill rofi
fi

keybinds_conf="$HOME/.config/hypr/configs/Keybinds.conf"
user_keybinds_conf="$HOME/.config/hypr/UserConfigs/UserKeybinds.conf"
laptop_conf="$HOME/.config/hypr/UserConfigs/Laptops.conf"
rofi_theme="$HOME/.config/rofi/config-keybinds.rasi"
msg='☣️ NOTE ☣️: Clicking with Mouse or Pressing ENTER will have NO function'

keybinds=$(cat "$keybinds_conf" "$user_keybinds_conf" | grep -E '^bind')

if [[ -f "$laptop_conf" ]]; then
    laptop_binds=$(grep -E '^bind' "$laptop_conf")
    keybinds+=$'\n'"$laptop_binds"
fi

if [[ -z "$keybinds" ]]; then
    echo "no keybinds found."
    exit 1
fi

display_keybinds=$(echo "$keybinds" | sed 's/\$mainMod/SUPER/g')

echo "$display_keybinds" | rofi -dmenu -i -config "$rofi_theme" -mesg "$msg"