{ config, pkgs, lib, ... }:

{
  home.packages = [ pkgs.localsend ];
}