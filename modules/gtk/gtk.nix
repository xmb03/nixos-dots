# GTK configuration
# Manages GTK theme settings, file manager bookmarks, and fontconfig defaults.

{ config, pkgs, lib, ... }:

{

  xresources.properties = {
   " Xft.dpi" = 96;
  };
  gtk = {
    enable = true;
    cursorTheme = {
      name = "static";
    };
    gtk3.extraConfig = {
      "gtk-cursor-blink" = false;
    };
    gtk3 = {
      # Default file manager bookmarks (shown in sidebar)
      bookmarks = [
        "file:///home/xmb03/Pictures"
        "file:///home/xmb03/Documents"
        "file:///home/xmb03/Apps"
        "file:///home/xmb03/Projects"
      ];
    };
  };

  # Fontconfig configuration (system-wide font selection)
  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      # Use JetBrainsMono Nerd Font for all font categories
      monospace = [ "JetBrainsMono Nerd Font Mono" ];
      sansSerif  = [ "JetBrainsMono Nerd Font" ];
      serif      = [ "JetBrainsMono Nerd Font" ];
    };
  };
}
