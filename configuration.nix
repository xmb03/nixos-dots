{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./modules/hardware/monitor.nix
    ./modules/hardware/touchpad.nix
    ./modules/theme/stylix.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Moscow";

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true;
  };

  services.xserver = {
    enable = true;
    displayManager.startx.enable = true;
    windowManager.i3 = {
      enable = true;
      package = pkgs.i3;
    };
  };

  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  services.libinput.enable = true;

  services.openssh.enable = true;

  networking.firewall.allowedTCPPorts = [ 22 ];
  networking.firewall.enable = false;

  users.users.xmb03 = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    shell = pkgs.zsh;
  };

  environment.systemPackages = with pkgs; [
    git
    curl
    wget
    gcc
    unzip
  ];

  programs.zsh.enable = true;
  system.stateVersion = "26.05";
}
