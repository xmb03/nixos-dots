{ config, pkgs, lib, ... }:

{
  gtk = {
    enable = true;
    gtk3 = {
      bookmarks = [
        "file:///home/xmb03/Pictures"
        "file:///home/xmb03/Documents"
        "file:///home/xmb03/apps"
        "file:///home/xmb03/Projects"
      ];
    };
  };

  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      monospace = [ "JetBrainsMono Nerd Font Mono" ];
      sansSerif = [ "JetBrainsMono Nerd Font" ];
      serif = [ "JetBrainsMono Nerd Font" ];
    };
  };
}
