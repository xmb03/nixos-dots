{ config, pkgs, lib, ... }:

let
  themeScript = pkgs.writeShellScriptBin "rofi-theme" ''
    ICONS_DIR="/home/xmb03/.config/nixos/assets/theme-icons"
    STYLIX_FILE="/home/xmb03/.config/nixos/modules/theme/stylix.nix"
    FLAKE_DIR="/home/xmb03/.config/nixos"

    SCHEMES_DIR=$(find /nix/store -maxdepth 1 -name '*base16-schemes*' -type d -print -quit 2>/dev/null)/share/themes
    if [ ! -d "$SCHEMES_DIR" ]; then
      ${pkgs.libnotify}/bin/notify-send "Error" "Themes directory not found."
      exit 1
    fi

    ROFI_DATA=""
    for scheme in "$SCHEMES_DIR"/*.yaml; do
      name=$(basename "$scheme" .yaml)
      icon="$ICONS_DIR/$name.png"
      if [ ! -f "$icon" ]; then
        continue
      fi
      ROFI_DATA+="''${name}\0icon\x1f''${icon}\n"
    done

    CHOICE=$(echo -en "$ROFI_DATA" | ${pkgs.rofi}/bin/rofi -dmenu -i -p "Theme" \
      -show-icons -theme-str '
            window {
                width: 900px;
                padding: 10px;
            }
            listview {
                columns: 4;
                lines: 3;
                cycle: true;
            }
            element {
                orientation: vertical;
                padding: 3px;
            }
            element-icon {
                size: 6em;
            }
            element-text {
                horizontal-align: 0.5;
                vertical-align: 0.5;
            }
        ')

    if [ -n "$CHOICE" ]; then
      sed -i "s|base16Scheme = \".*\"|base16Scheme = \"\''${pkgs.base16-schemes}/share/themes/''${CHOICE}.yaml\"|" "$STYLIX_FILE"

      cd "$FLAKE_DIR" || exit 1
      exec ${pkgs.kitty}/bin/kitty -e sh -c '
        cd /home/xmb03/.config/nixos || exit 1
        nixos-rebuild switch --flake .#nixos --offline --impure --elevate=sudo
      '
    fi
  '';
in
{
  home.packages = [ themeScript ];
}
