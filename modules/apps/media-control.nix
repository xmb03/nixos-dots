{ config, pkgs, lib, ... }:

{
  home.packages = [ pkgs.pulsemixer pkgs.playerctl ];
}