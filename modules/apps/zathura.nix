{ config, pkgs, lib, ... }:

{
  programs.zathura = {
    enable = true;
    options = {
      recolor = "true";
      recolor-keephue = "true";
    };
  };

  xdg.configFile."zathura/zathurarc".text = ''
    include "~/.cache/wal/colors-zathurarc"

    set recolor "true"
    set recolor-keephue "true"
  '';
}
