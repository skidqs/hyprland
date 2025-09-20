iDIR="$HOME/.config/swaync/images"

if ! command -v kitty &> /dev/null; then
  notify-send -i "$iDIR/error.png" "Need Kitty:" "Kitty terminal not found. Please install Kitty terminal."
  exit 1
fi

if command -v paru &> /dev/null || command -v yay &> /dev/null; then
  # Arch-based
  if command -v paru &> /dev/null; then
    kitty -T update paru -Syu
    notify-send -i "$iDIR/ja.png" -u low 'Arch-based system' 'has been updated.'
  else
    kitty -T update yay -Syu
    notify-send -i "$iDIR/ja.png" -u low 'Arch-based system' 'has been updated.'
  fi
elif command -v dnf &> /dev/null; then
  kitty -T update sudo dnf update --refresh -y
  notify-send -i "$iDIR/ja.png" -u low 'Fedora system' 'has been updated.'
elif command -v apt &> /dev/null; then
  kitty -T update sudo apt update && sudo apt upgrade -y
  notify-send -i "$iDIR/ja.png" -u low 'Debian/Ubuntu system' 'has been updated.'
elif command -v zypper &> /dev/null; then
  kitty -T update sudo zypper dup -y
  notify-send -i "$iDIR/ja.png" -u low 'openSUSE system' 'has been updated.'
else
  notify-send -i "$iDIR/error.png" -u critical "Unsupported system" "This script does not support your distribution."
  exit 1
fi