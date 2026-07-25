{ config, pkgs, lib, ... }:

{
  home.packages = [ pkgs.maim pkgs.slop ];
}