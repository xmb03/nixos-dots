# Monitor configuration
# Sets display resolution and refresh rate based on AC power state.

{ config, pkgs, lib, ... }:

{
  services.xserver.displayManager.sessionCommands = ''
    RATE=$(${pkgs.coreutils}/bin/cat /sys/class/power_supply/AC/online 2>/dev/null || echo 0)
    if [ "$RATE" = "1" ]; then
      ${pkgs.xrandr}/bin/xrandr --output eDP-1 --mode 1920x1200 --rate 165
    else
      ${pkgs.xrandr}/bin/xrandr --output eDP-1 --mode 1920x1200 --rate 60.09
    fi
  '';
}
