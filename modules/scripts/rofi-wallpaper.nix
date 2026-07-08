# Rofi wallpaper picker script
# Lets the user browse and select wallpapers via a Rofi grid interface,
# then sets the wallpaper and triggers Stylix color regeneration.

{ config, pkgs, lib, ... }:

let
  wallpaperScript = pkgs.writeShellScriptBin "rofi-wallpaper" ''
    # Directory containing wallpaper images
    WALL_DIR="$HOME/Pictures/Wallpapers"
    # Stylix asset directory where the wallpaper is stored for rebuild detection
    # Must match the path in modules/theme/stylix.nix
    STYLIX_ASSETS="/home/xmb03/nixtest/modules/theme/assets"
    STYLIX_WALL="$STYLIX_ASSETS/wallpaper.png"

    # Exit with error if wallpaper directory doesn't exist
    if [ ! -d "$WALL_DIR" ]; then
      ${pkgs.libnotify}/bin/notify-send "Error" "Directory $WALL_DIR not found."
      exit 1
    fi

    # Build Rofi data string with icons for each wallpaper
    ROFI_DATA=""
    for pic in "$WALL_DIR"/*; do
      if [ -f "$pic" ]; then
        filename=$(basename "$pic")
        ROFI_DATA+="''${filename}\0icon\x1f''${pic}\n"
      fi
    done

    # Show Rofi menu with wallpaper grid (3 columns, icon + text)
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

    # If a wallpaper was selected, apply it
    if [ -n "$CHOICE" ]; then
      FULL_PATH="$WALL_DIR/$CHOICE"

      # Set wallpaper using feh
      ${pkgs.feh}/bin/feh --bg-fill "$FULL_PATH"

      # Copy wallpaper to Stylix assets for rebuild detection
      mkdir -p "$STYLIX_ASSETS"
      cp "$FULL_PATH" "$STYLIX_WALL"

      # Notify the user to rebuild for new Stylix colors
      ${pkgs.libnotify}/bin/notify-send "Wallpaper set!" "Run: nixos-rebuild switch for new Stylix colors"
    fi
  '';
in
{
  # Install the wallpaper script into the user's PATH
  home.packages = [ wallpaperScript ];
}
