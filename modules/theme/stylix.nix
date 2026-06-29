{ config, pkgs, lib, ... }:

{
  stylix = {
    enable = true;
    autoEnable = true;
    polarity = "dark";
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";
    image = null;

    fonts = {
      monospace = {
        name = "JetBrainsMono Nerd Font Mono";
        package = pkgs.jetbrains-mono;
      };
      sansSerif = {
        name = "JetBrainsMono Nerd Font";
        package = pkgs.jetbrains-mono;
      };
      serif = {
        name = "JetBrainsMono Nerd Font";
        package = pkgs.jetbrains-mono;
      };
      emoji = {
        name = "Noto Color Emoji";
        package = pkgs.noto-fonts-color-emoji;
      };
    };

    opacity = {
      applications = 0.95;
      terminal = 0.90;
      desktop = 1.0;
      popups = 0.95;
    };

    cursor = {
      name = "Bibata-Modern-Classic";
      package = pkgs.bibata-cursors;
      size = 24;
    };
  };
}
