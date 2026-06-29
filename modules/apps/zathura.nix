{ config, pkgs, lib, ... }:

{
  programs.zathura = {
    enable = true;
    options = {
      recolor = "true";
      recolor-keephue = "true";
    };
  };
}
