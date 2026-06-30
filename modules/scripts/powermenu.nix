{ config, pkgs, lib, ... }:

let
  powermenuScript = pkgs.writeShellScriptBin "powermenu" ''
    selected=$(echo -e "\uf023 Lock\n"\uf2f6" Logout\n"\uf186" Suspend\n"\uf2dc" Hibernate\n"\uf01e" Reboot\n"\uf011" Shutdown" | rofi -dmenu -i -p "Power" -theme ~/.config/rofi/powermenu.rasi)

    case $selected in
      *Lock)      loginctl lock-session ;;
      *Logout)    i3-msg exit ;;
      *Suspend)   systemctl suspend ;;
      *Hibernate) systemctl hibernate ;;
      *Reboot)    systemctl reboot ;;
      *Shutdown)  systemctl poweroff ;;
    esac
  '';
in
{
  home.packages = [ powermenuScript ];

  xdg.configFile."i3/scripts/powermenu".source = "${powermenuScript}/bin/powermenu";
}
