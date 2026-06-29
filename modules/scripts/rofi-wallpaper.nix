{ config, pkgs, lib, ... }:

let
  wallpaperScript = pkgs.writeShellScriptBin "rofi-wallpaper" ''
    WALL_DIR="$HOME/Pictures/Wallpapers"
    CACHE_FILE="$HOME/.cache/current_wallpaper"

    apply_wallpaper() {
      local path="$1"
      feh --bg-fill "$path"
    }

    if [ "$1" == "--reset" ]; then
      if [ -f "$CACHE_FILE" ]; then
        SAVED_WALL=$(cat "$CACHE_FILE")
        apply_wallpaper "$SAVED_WALL"
        exit 0
      else
        echo "No cached wallpaper found."
        exit 1
      fi
    fi

    if [ ! -d "$WALL_DIR" ]; then
      notify-send "Error" "Directory $WALL_DIR not found."
      exit 1
    fi

    ROFI_DATA=""
    for pic in "$WALL_DIR"/*; do
      if [ -f "$pic" ]; then
        filename=$(basename "$pic")
        ROFI_DATA+="''${filename}\0icon\x1f''${pic}\n"
      fi
    done

    CHOICE=$(echo -en "$ROFI_DATA" | rofi -dmenu -i -p "Wallpaper" \
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
      echo "$FULL_PATH" >"$CACHE_FILE"
      apply_wallpaper "$FULL_PATH"
    fi
  '';
in
{
  home.packages = [ wallpaperScript ];

  xdg.configFile."i3/scripts/rofi-wallpaper".source = "${wallpaperScript}/bin/rofi-wallpaper";

  xsession.windowManager.i3.extraConfig = ''
    exec_always --no-startup-id ln -sf ${wallpaperScript}/bin/rofi-wallpaper ~/.config/i3/scripts/rofi-wallpaper
  '';
}
