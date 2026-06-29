{ config, lib, pkgs, ... }:

{
  services.xserver.xrandrHeads = [
    {
      output = "DP-0";
      primary = true;
      monitorConfig = "1920x1200_165.00";
    }
  ];
}
