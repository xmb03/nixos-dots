{ config, pkgs, lib, ... }:

{
  home.packages = [ pkgs.btop ];
}