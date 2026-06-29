{ config, pkgs, lib, ... }:

{
  imports = [
    ./modules/wm/i3.nix
    ./modules/wm/i3-settings.nix
    ./modules/term/kitty.nix
    ./modules/shell/bash.nix
    ./modules/shell/zsh.nix
    ./modules/apps/rofi.nix
    ./modules/apps/zathura.nix
    ./modules/gtk/gtk.nix
    ./modules/services/redshift.nix
    ./modules/services/greenclip.nix
    ./modules/services/udiskie.nix
    ./modules/scripts/rofi-wallpaper.nix
  ];

  home = {
    username = "xmb03";
    homeDirectory = "/home/xmb03";
    stateVersion = "26.05";
  };

  home.packages = with pkgs; [
    # WM utils
    i3status-rust
    rofi
    rofi-calc
    feh
    dunst
    xss-lock
    i3lock
    xdotool
    xclip
    flameshot

    # Media
    redshift
    pulsemixer
    playerctl

    # System
    udiskie
    dex
    libnotify

    # Terminal
    kitty
    zathura

    # Fonts
    jetbrains-mono
    nerd-fonts.jetbrains-mono

    # Shell
    zsh
    zsh-autosuggestions
    zsh-syntax-highlighting

    # Utils
    file
    tree
    bat
    btop
    fastfetch
  ];

  programs.home-manager.enable = true;
}
