# NixOS system-level configuration
# This file manages system-wide settings: bootloader, networking, services, packages, users.
# Help is available in the configuration.nix(5) man page and on https://nixos.org/manual.

{ config, pkgs, ... }:

{
  # Import additional NixOS module files
  imports = [
    ./hardware-configuration.nix  # Auto-generated hardware scan (disk, kernel modules)
    ./nvidia.nix                   # NVIDIA GPU driver configuration
    ./modules/theme/stylix.nix     # System-level Stylix theming
    ./modules/hardware/monitor.nix # Monitor/resolution settings via xrandr
    ./modules/hardware/touchpad.nix# Touchpad configuration via libinput
    ./modules/services/networkmanager.nix  # NetworkManager + networking tweaks
    ./modules/hardware/power.nix         # Power management (auto-cpufreq, thermald, NVIDIA PM, powertop)
    ./modules/hardware/win.nix           # Windows NTFS partitions mount
    ./modules/services/ollama.nix        # Ollama LLM server with CUDA
    ./modules/services/qbittorrent.nix
  ];

  # Boot configuration
  # ------------------
  # systemd-boot as the EFI boot loader (lightweight, simple)
  boot.loader.systemd-boot.enable = true;
  # Allow the bootloader to modify EFI variables (needed for updates)
  boot.loader.efi.canTouchEfiVariables = true;
  systemd.services.systemd-udev-settle.enable = false;

  # Use the latest available Linux kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Networking
  # ----------
  # Hostname used on the network
  networking.hostName = "xmb03";
  networking.nftables.enable = true;

  # Time configuration
  # ------------------
  time.timeZone = "Europe/Moscow";

  # Nix features
  # ------------
  # Enable flakes and nix-command experimental features
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    max-substitution-jobs = 128;
    http-connections = 128;
    sandbox = true;

    substituters = [
      "https://cache.nixos.org"
      "https://mirrors.ustc.edu.cn/nix-channels/store"
    ];

    auto-optimise-store = true;
  };

  # Internationalization
  # --------------------
  # Default system locale (English for system messages)
  i18n.defaultLocale = "en_US.UTF-8";
  # Additional locale settings for Russian region (date, currency, numbers)
  i18n.extraLocaleSettings = {
    LC_ADDRESS      = "ru_RU.UTF-8";
    LC_IDENTIFICATION = "ru_RU.UTF-8";
    LC_MEASUREMENT  = "ru_RU.UTF-8";
    LC_MONETARY     = "ru_RU.UTF-8";
    LC_NAME         = "ru_RU.UTF-8";
    LC_NUMERIC      = "ru_RU.UTF-8";
    LC_PAPER        = "ru_RU.UTF-8";
    LC_TELEPHONE    = "ru_RU.UTF-8";
    LC_TIME         = "ru_RU.UTF-8";
  };

  # X11 / Display server
  # --------------------
  # Keyboard layout: US and Russian, toggle with Alt+Shift
  services.xserver.xkb = {
    layout = "us,ru";
    variant = ",";
    options = "grp:alt_shift_toggle";
  };

  # Enable the X11 windowing system and setting dpi
  services.xserver = {
    # dpi scale
    dpi = 96;

    deviceSection = '' Option "UseEdidDpi" "False" Option "DPI" "96 x 96" ''; 
  }; 

  # xserver enable
  services.xserver.enable = true;
  # Display Manager (login screen) lightDM 
  services.xserver.displayManager.lightdm.enable = true;
  services.displayManager.autoLogin = {
    enable = true;
    user = "xmb03";
  };

  # Enable i3 as additional window manager option
  services.xserver.windowManager.i3.enable = true;

  # Printing
  # --------
  services.printing.enable = true;

  # Audio (PipeWire)
  # ----------------
  # Disable PulseAudio server (PipeWire acts as a PulseAudio replacement)
  services.pulseaudio.enable = false;
  # RealtimeKit for low-latency audio
  security.rtkit.enable = true;
  # PipeWire configuration for audio
  services.pipewire = {
    enable = true;
    # ALSA support for legacy applications
    alsa.enable = true;
    alsa.support32Bit = true;
    # PulseAudio-compatible socket for PA clients
    pulse.enable = true;
  };

  # Shell
  # -----
  # Enable Zsh as a system-wide shell option
  programs.zsh.enable = true;

  # User accounts
  # -------------
  users.users."xmb03" = {
    isNormalUser = true;
    description = "xmb03";
    # Default shell for this user
    shell = pkgs.zsh;
    # User groups: networkmanager for network control, wheel for sudo access
    extraGroups = [ "networkmanager" "wheel" ];
    # User-specific system packages
    packages = with pkgs; [ ];
  };

  # Package management
  # ------------------
  # Allow unfree packages (e.g., NVIDIA drivers, Steam, some codecs)
  nixpkgs.config.allowUnfree = true;

  # System-wide packages (available to all users)
  environment.systemPackages = with pkgs; [
    wget    # HTTP download utility
    curl    # URL transfer tool
    unzip   # ZIP archive extractor
    gcc     # GNU C compiler
    p7zip   # 7-Zip archive tool
    steam-run # Steam runtime for running games
  ];

  # State version
  # -------------
  # Tracks which NixOS release was initially installed.
  # Do NOT change this value after the first install.
  system.stateVersion = "26.05";
}
