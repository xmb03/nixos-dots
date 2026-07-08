# Rofi wallpaper picker script
# Lets the user browse and select wallpapers via a Rofi grid interface,
# then sets the wallpaper and triggers Stylix color regeneration.

{ config, pkgs, lib, ... }:

let
  wallpaperScript = pkgs.writeShellScriptBin "rofi-wallpaper" ''
    CACHE="$HOME/.cache/wallpaper-current"
    WALL_DIR="$HOME/Pictures/Wallpapers"

    restore() {
      if [ -f "$CACHE" ]; then
        path=$(cat "$CACHE")
        [ -f "$path" ] && ${pkgs.feh}/bin/feh --bg-fill "$path"
      fi
      exit 0
    }

    [ "$1" = "--restore" ] && restore

    if [ ! -d "$WALL_DIR" ]; then
      ${pkgs.libnotify}/bin/notify-send "Error" "Directory $WALL_DIR not found."
      exit 1
    fi

    ROFI_DATA=""
    for pic in "$WALL_DIR"/*; do
      if [ -f "$pic" ]; then
        filename=$(basename "$pic")
        ROFI_DATA+="''${filename}\0icon\x1f''${pic}\n"
      fi
    done

    CHOICE=$(echo -en "$ROFI_DATA" | ${pkgs.rofi}/bin/rofi -dmenu -i -p "Wallpaper" \
      -show-icons -theme-str '
            listview {
                columns: 3;
                lines: 3;
                cycle: true;
            }
            element {
                orientation: vertical;
                padding: 10px;
            }
            element-icon {
                size: 8em;
            }
            element-text {
                horizontal-align: 0.5;
            }
        ')

    if [ -n "$CHOICE" ]; then
      FULL_PATH="$WALL_DIR/$CHOICE"
      ${pkgs.feh}/bin/feh --bg-fill "$FULL_PATH"
      mkdir -p "$(dirname "$CACHE")"
      echo "$FULL_PATH" > "$CACHE"
      ${pkgs.libnotify}/bin/notify-send "Обои изменены"
    fi
  '';
in
{
  # Install the wallpaper script into the user's PATH
  home.packages = [ wallpaperScript ];
}
