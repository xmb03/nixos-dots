# Rofi power menu script
# Provides a graphical power menu with grid layout for shutdown/reboot/suspend/etc.

{ config, pkgs, lib, ... }:

let
  # Create a "powermenu" shell script using Nix's writeShellScriptBin
  powermenuScript = pkgs.writeShellScriptBin "powermenu" ''
    # Show a Rofi menu with power options in a 3-column grid
    selected=$(echo -e "Lock\nLogout\nSuspend\nHibernate\nReboot\nShutdown" \
      | ${pkgs.rofi}/bin/rofi -dmenu -i -p "Power" \
        -theme-str 'window { width: 750px; location: center; anchor: center; padding: 20px; }' \
        -theme-str 'listview { spacing: 15px; padding: 5px; columns: 3; lines: 2; cycle: true; dynamic: false; fixed-columns: true; fixed-height: true; }' \
        -theme-str 'element { orientation: vertical; padding: 40px; spacing: 0px; border-radius: 0px; }' \
        -theme-str 'element-text { horizontal-align: 0.5; vertical-align: 0.5; }')

    # Execute the selected action
    case $selected in
      *Lock)      ${pkgs.i3lock}/bin/i3lock -c 000000 ;;
      *Logout)    ${pkgs.i3}/bin/i3-msg exit ;;
      *Suspend)   ${pkgs.systemd}/bin/systemctl suspend ;;
      *Hibernate) ${pkgs.systemd}/bin/systemctl hibernate ;;
      *Reboot)    ${pkgs.systemd}/bin/systemctl reboot ;;
      *Shutdown)  ${pkgs.systemd}/bin/systemctl poweroff ;;
    esac
  '';
in
{
  # Install the powermenu script into the user's PATH
  home.packages = [ powermenuScript ];
}
