{ config, lib, pkgs, ... }:

{
  services.xserver.xrandrHeads = [
    {
      output = "DP-0";
      primary = true;
      monitorConfig = ''
        Modeline "1920x1200_165.00" 586.75 1920 2096 2304 2688 1200 1203 1209 1324 -hsync +vsync
        Option "PreferredMode" "1920x1200_165.00"
      '';
    }
  ];
}
