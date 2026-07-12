# Home Manager user configuration
# This file manages user-level settings: desktop environment, applications, theming.
# Imported by flake.nix as "users.xmb03".

{ config, pkgs, lib, ... }:

{
  # Import home-manager modules from the modules directory
  imports = [
    ./modules/wm/i3.nix              # i3 window manager config (keybindings, bar, gaps)
    ./modules/wm/i3-settings.nix     # i3status-rust bar settings (blocks, icons)
    ./modules/wm/picom.nix           # Picom compositor (vsync, no effects)
    ./modules/apps/rofi.nix          # Rofi launcher config (theme, drun, pass)
    ./modules/apps/yazi.nix          # Yazi file manager config (plugins)
    ./modules/term/kitty.nix         # Kitty terminal emulator settings
    ./modules/term/zellij.nix        # Zellij terminal multiplexer
    ./modules/shell/zsh.nix          # Zsh shell config (aliases, history, plugins)
    ./modules/zathura/zathura.nix    # Zathura PDF viewer settings
    ./modules/gtk/gtk.nix            # GTK theme, fontconfig, bookmarks
    ./modules/services/redshift.nix  # Redshift blue-light filter
    ./modules/services/clipmenu.nix  # Clipmenu clipboard manager
    ./modules/services/udiskie.nix   # Udiskie automatic USB mount
    ./modules/scripts/powermenu.nix  # Rofi-based power menu script
    ./modules/scripts/rofi-wallpaper.nix # Rofi wallpaper picker script
    ./modules/scripts/rofi-theme.nix     # Rofi Stylix palette picker
    ./modules/firefox/default.nix    # Firefox config, extensions, textfox theme
    ./modules/editor/vim.nix         # Vim config, plugins, settings
    ./modules/editor/neovim.nix      # Neovim config, plugins, settings
    ./modules/apps/basalt.nix        # Tui obsidian in terminal
  ];

  # Home Manager user metadata
  home = {
    username = "xmb03";
    homeDirectory = "/home/xmb03";
    # Must match the release version from the first install
    stateVersion = "26.05";
  };

  # Stylix theming targets (auto-color from wallpaper)
  stylix.targets = {
    zathura.enable = true;  # Dark theme for PDF viewer
    kitty.enable = true;    # Terminal colors from wallpaper
    zellij.enable = true;   # Zellij theme from wallpaper
    i3.enable = true;       # i3 bar and border colors
    rofi.enable = true;   # Stylix-managed rofi theme
    yazi.enable = true;     # Yazi file manager colors
    neovim.enable = true;   # Neovim colors from Stylix
    gtk.enable = true;      # GTK application theming
    dunst.enable = true;    # Notification daemon colors
    firefox = {
      enable = true;
      profileNames = [ "default" ];
      colorTheme.enable = true;  # Firefox UI colors match wallpaper
    };
  };

  # User-level packages (installed via home-manager)
  home.packages = with pkgs; [
    # System utilities
    xdotool          # X11 automation (keyboard/mouse simulation)
    xclip            # Clipboard management from CLI
    zsh              # Z shell (primary shell)
    file             # File type detection
    tree             # Directory tree viewer
    bat              # Cat replacement with syntax highlighting
    btop             # System resource monitor (top replacement)
    fastfetch        # System info display (neofetch replacement)
    git              # Version control

    # Desktop components
    i3status-rust    # Status bar for i3 (keyboard, volume, network, time)
    rofi             # Application launcher (drun, clipboard, wallpaper)
    rofi-calc        # Rofi calculator plugin
    feh              # Image viewer / wallpaper setter
    dunst            # Notification daemon
    xss-lock         # Screen lock on suspend
    i3lock           # Screen locker utility
    maim             # Screenshot tool (fullscreen, region, window)
    slop             # Required by maim -s for region selection
    pulsemixer       # PulseAudio volume mixer (CLI)
    playerctl        # Media player control from CLI
    udiskie          # Automatic USB drive mounting
    dex              # Desktop file execution (autostart)
    libnotify        # Desktop notification library

    # Network
    networkmanagerapplet  # NetworkManager system tray icon

    # Communication / Productivity
    opencode         # AI coding assistant CLI
    localsend        # Local file sharing (LAN, no internet needed)
    telegram-desktop # Telegram messaging app
    mpv
    rofimoji            # Emoji picker with Russian support
    obs-studio

    # python
    python3
    # rust
    rustlings
  ];

  # Enable home-manager (must be set for the user)
  programs.home-manager.enable = true;

  home.sessionVariables = {
    EDITOR = "vim";
  };
}
