terminal=kitty
wallDIR="$HOME/.config/rofi/wallpapers"
SCRIPTSDIR="$HOME/.config/hypr/scripts"
wallpaper_current="$HOME/.config/hypr/wallpaper_effects/.wallpaper_current"
iDIR="$HOME/.config/swaync/images"
FPS=60
TYPE="any"
DURATION=2
BEZIER=".43,1.19,1,.4"
SWWW_PARAMS="--transition-fps $FPS --transition-type $TYPE --transition-duration $DURATION --transition-bezier $BEZIER"
rofi_theme="$HOME/.config/rofi/config-wallpaper.rasi"

if ! command -v bc &>/dev/null; then
  notify-send -i "$iDIR/error.png" "bc missing" "Install package bc first"
  exit 1
fi

focused_monitor=$(hyprctl monitors -j | jq -r '.[] | select(.focused) | .name')
if [[ -z "$focused_monitor" ]]; then
  notify-send -i "$iDIR/error.png" "E-R-R-O-R" "Could not detect focused monitor"
  exit 1
fi

scale_factor=$(hyprctl monitors -j | jq -r --arg mon "$focused_monitor" '.[] | select(.name == $mon) | .scale')
monitor_height=$(hyprctl monitors -j | jq -r --arg mon "$focused_monitor" '.[] | select(.name == $mon) | .height')
icon_size=$(echo "scale=1; ($monitor_height * 3) / ($scale_factor * 150)" | bc)
adjusted_icon_size=$(echo "$icon_size" | awk '{if ($1 < 15) $1 = 20; if ($1 > 25) $1 = 25; print $1}')
rofi_override="element-icon{size:${adjusted_icon_size}%;}"

kill_wallpaper_for_video() {
  swww kill 2>/dev/null
  pkill mpvpaper 2>/dev/null
  pkill swaybg 2>/dev/null
  pkill hyprpaper 2>/dev/null
}

kill_wallpaper_for_image() {
  pkill mpvpaper 2>/dev/null
  pkill swaybg 2>/dev/null
  pkill hyprpaper 2>/dev/null
}

menu() {
  mapfile -d '' PICS < <(find -L "${wallDIR}" -type f \( \
    -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" -o \
    -iname "*.bmp" -o -iname "*.tiff" -o -iname "*.webp" -o \
    -iname "*.mp4" -o -iname "*.mkv" -o -iname "*.mov" -o -iname "*.webm" \) -print0)

  # Add random entry
  RANDOM_PIC="${PICS[$((RANDOM % ${#PICS[@]}))]}"
  RANDOM_PIC_NAME=". random"
  printf "%s\x00icon\x1f%s\n" "$RANDOM_PIC_NAME" "$RANDOM_PIC"

  # Show all files
  IFS=$'\n' sorted_options=($(sort <<<"${PICS[*]}"))
  for pic_path in "${sorted_options[@]}"; do
    pic_name=$(basename "$pic_path")
    if [[ "$pic_name" =~ \.gif$ ]]; then
      cache_gif="$HOME/.cache/gif_preview/${pic_name}.png"
      mkdir -p "$(dirname "$cache_gif")"
      [[ -f "$cache_gif" ]] || magick "$pic_path[0]" -resize 1920x1080 "$cache_gif"
      printf "%s\x00icon\x1f%s\n" "$pic_name" "$cache_gif"
    elif [[ "$pic_name" =~ \.(mp4|mkv|mov|webm)$ ]]; then
      cache_vid="$HOME/.cache/video_preview/${pic_name}.png"
      mkdir -p "$(dirname "$cache_vid")"
      [[ -f "$cache_vid" ]] || ffmpeg -v error -y -i "$pic_path" -ss 00:00:01.000 -vframes 1 "$cache_vid"
      printf "%s\x00icon\x1f%s\n" "$pic_name" "$cache_vid"
    else
      printf "%s\x00icon\x1f%s\n" "$(echo "$pic_name" | cut -d. -f1)" "$pic_path"
    fi
  done
}

modify_startup_config() {
  local selected_file="$1"
  local startup_config="$HOME/.config/hypr/UserConfigs/Startup_Apps.conf"
  if [[ "$selected_file" =~ \.(mp4|mkv|mov|webm)$ ]]; then
    sed -i '/^\s*exec-once\s*=\s*swww-daemon\s*--format\s*xrgb\s*$/s/^/\#/' "$startup_config"
    sed -i '/^\s*#\s*exec-once\s*=\s*mpvpaper\s*.*$/s/^#\s*//;' "$startup_config"
  else
    sed -i '/^\s*#\s*exec-once\s*=\s*swww-daemon\s*--format\s*xrgb\s*$/s/^\s*#//;' "$startup_config"
    sed -i '/^\s*exec-once\s*=\s*mpvpaper\s*.*$/s/^/\#/' "$startup_config"
  fi
  selected_file="${selected_file/#$HOME/\$HOME}"
  sed -i "s|^\$livewallpaper=.*|\$livewallpaper=\"$selected_file\"|" "$startup_config"
}

apply_image_wallpaper() {
  local image="$1"
  kill_wallpaper_for_image
  [[ $(pgrep -x "swww-daemon") ]] || swww-daemon --format xrgb &
  swww img -o "$focused_monitor" "$image" $SWWW_PARAMS
  "$SCRIPTSDIR/WallustSwww.sh"
  sleep 2
  "$SCRIPTSDIR/Refresh.sh"
}

apply_video_wallpaper() {
  local video="$1"
  if ! command -v mpvpaper &>/dev/null; then
    notify-send -i "$iDIR/error.png" "E-R-R-O-R" "mpvpaper not found"
    return 1
  fi
  kill_wallpaper_for_video
  mpvpaper '*' -o "load-scripts=no no-audio --loop" "$video" &
}

if pidof rofi >/dev/null; then pkill rofi; fi
choice=$(menu | rofi -i -show -dmenu -config $rofi_theme -theme-str $rofi_override)
choice=$(echo "$choice" | xargs)
[[ "$choice" == "$RANDOM_PIC_NAME" ]] && choice=$(basename "$RANDOM_PIC")
selected_file=$(find "$wallDIR" -iname "$(basename "$choice" | cut -d. -f1).*" -print -quit)
[[ -z "$selected_file" ]] && { echo "File not found: $choice"; exit 1; }

modify_startup_config "$selected_file"
if [[ "$selected_file" =~ \.(mp4|mkv|mov|webm)$ ]]; then
  apply_video_wallpaper "$selected_file"
else
  apply_image_wallpaper "$selected_file"
fi
