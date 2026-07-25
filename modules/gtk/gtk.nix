{ config, pkgs, lib, ... }:

{
  home.pointerCursor = {
    name = "static";
    package = pkgs.static-cursor;
    gtk.enable = true;
    x11.enable = true;
  };

  xresources.properties = {
   " Xft.dpi" = 96;
  };
  gtk = {
    enable = true;
    gtk3.extraConfig = {
      "gtk-cursor-blink" = false;
    };
    gtk3 = {
      bookmarks = [
        "file:///home/xmb03/Pictures"
        "file:///home/xmb03/Documents"
        "file:///home/xmb03/Apps"
        "file:///home/xmb03/Projects"
      ];
    };
  };

  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      monospace = [ "JetBrainsMono Nerd Font Mono" ];
      sansSerif  = [ "JetBrainsMono Nerd Font" ];
      serif      = [ "JetBrainsMono Nerd Font" ];
    };
  };
}
