terminal=kitty
wallDIR="$HOME/Pictures/wallpapers"
SCRIPTSDIR="$HOME/.config/hypr/scripts"
wallpaper_current="$HOME/.config/hypr/wallpaper_effects/.wallpaper_current"
wallpaper_modified="$HOME/.config/hypr/wallpaper_effects/.wallpaper_modified"
sddm_simple="/usr/share/sddm/themes/simple_sddm_2"

rofi_wallust="$HOME/.config/rofi/wallust/colors-rofi.rasi"
sddm_theme_conf="$sddm_simple/theme.conf"

iDIR="$HOME/.config/swaync/images"
iDIRi="$HOME/.config/swaync/icons"

mode="effects"
if [[ "$1" == "--normal" ]]; then
    mode="normal"
elif [[ "$1" == "--effects" ]]; then
    mode="effects"
fi

color0=$(grep -oP 'color1:\s*\K#[A-Fa-f0-9]+' "$rofi_wallust")
color1=$(grep -oP 'color0:\s*\K#[A-Fa-f0-9]+' "$rofi_wallust")
color7=$(grep -oP 'color14:\s*\K#[A-Fa-f0-9]+' "$rofi_wallust")
color10=$(grep -oP 'color10:\s*\K#[A-Fa-f0-9]+' "$rofi_wallust")
color12=$(grep -oP 'color12:\s*\K#[A-Fa-f0-9]+' "$rofi_wallust")
color13=$(grep -oP 'color13:\s*\K#[A-Fa-f0-9]+' "$rofi_wallust")
foreground=$(grep -oP 'foreground:\s*\K#[A-Fa-f0-9]+' "$rofi_wallust")

if [[ "$mode" == "normal" ]]; then
    wallpaper_path="$wallpaper_current"
else
    wallpaper_path="$wallpaper_modified"
fi

$terminal -e bash -c "
echo 'Enter your password to update SDDM wallpapers and colors';

# Update the colors in the SDDM config
sudo sed -i \"s/HeaderTextColor=\\\"#.*\\\"/HeaderTextColor=\\\"$color13\\\"/\" \"$sddm_theme_conf\"
sudo sed -i \"s/DateTextColor=\\\"#.*\\\"/DateTextColor=\\\"$color13\\\"/\" \"$sddm_theme_conf\"
sudo sed -i \"s/TimeTextColor=\\\"#.*\\\"/TimeTextColor=\\\"$color13\\\"/\" \"$sddm_theme_conf\"
sudo sed -i \"s/DropdownSelectedBackgroundColor=\\\"#.*\\\"/DropdownSelectedBackgroundColor=\\\"$color13\\\"/\" \"$sddm_theme_conf\"
sudo sed -i \"s/SystemButtonsIconsColor=\\\"#.*\\\"/SystemButtonsIconsColor=\\\"$color13\\\"/\" \"$sddm_theme_conf\"
sudo sed -i \"s/SessionButtonTextColor=\\\"#.*\\\"/SessionButtonTextColor=\\\"$color13\\\"/\" \"$sddm_theme_conf\"
sudo sed -i \"s/VirtualKeyboardButtonTextColor=\\\"#.*\\\"/VirtualKeyboardButtonTextColor=\\\"$color13\\\"/\" \"$sddm_theme_conf\"
sudo sed -i \"s/HighlightBackgroundColor=\\\"#.*\\\"/HighlightBackgroundColor=\\\"$color12\\\"/\" \"$sddm_theme_conf\"
sudo sed -i \"s/LoginFieldTextColor=\\\"#.*\\\"/LoginFieldTextColor=\\\"$color12\\\"/\" \"$sddm_theme_conf\"
sudo sed -i \"s/PasswordFieldTextColor=\\\"#.*\\\"/PasswordFieldTextColor=\\\"$color12\\\"/\" \"$sddm_theme_conf\"

sudo sed -i \"s/DropdownBackgroundColor=\\\"#.*\\\"/DropdownBackgroundColor=\\\"$color1\\\"/\" \"$sddm_theme_conf\"
sudo sed -i \"s/HighlightTextColor=\\\"#.*\\\"/HighlightTextColor=\\\"$color10\\\"/\" \"$sddm_theme_conf\"

sudo sed -i \"s/PlaceholderTextColor=\\\"#.*\\\"/PlaceholderTextColor=\\\"$color7\\\"/\" \"$sddm_theme_conf\"
sudo sed -i \"s/UserIconColor=\\\"#.*\\\"/UserIconColor=\\\"$color7\\\"/\" \"$sddm_theme_conf\"
sudo sed -i \"s/PasswordIconColor=\\\"#.*\\\"/PasswordIconColor=\\\"$color7\\\"/\" \"$sddm_theme_conf\"

# Copy wallpaper to SDDM theme
sudo cp \"$wallpaper_path\" \"$sddm_simple/Backgrounds/default\"

notify-send -i \"$iDIR/ja.png\" \"SDDM\" \"Background SET\"
"