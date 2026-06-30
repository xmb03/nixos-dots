{ config, lib, pkgs, ... }:

{
  services.xserver.xrandrHeads = [
    {
      output = "DP-0";
      primary = true;
    }
  ];
}
