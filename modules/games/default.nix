{ config, pkgs, lib, ... }:

{
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  programs.gamemode.enable = true;

  services.flatpak.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  systemd.services.flatpak-add-flathub = {
    description = "Add Flathub flatpak remote";
    wantedBy = [ "multi-user.target" ];
    after = [ "network-online.target" ];
    requires = [ "network-online.target" ];
    path = [ pkgs.flatpak ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStartPre = [
        "${pkgs.bash}/bin/bash -c '${pkgs.flatpak}/bin/flatpak remote-delete --user flathub 2>/dev/null; true'"
        "${pkgs.flatpak}/bin/flatpak remote-add --if-not-exists --system flathub https://flathub.org/repo/flathub.flatpakrepo"
      ];
      ExecStart = "${pkgs.flatpak}/bin/flatpak remote-modify --system flathub --url=https://mirrors.ustc.edu.cn/flathub/";
    };
  };

  environment.systemPackages = with pkgs; [
    mangohud
    protonup-qt
    steamcmd
    steam-tui
    steam-run
    protontricks
    winetricks
    wineWow64Packages.staging
  ];

}
