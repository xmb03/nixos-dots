{ config, pkgs, lib, ... }:

{
  programs.rofi = {
    enable = true;
    package = pkgs.rofi;
    pass.enable = true;
  };
}
