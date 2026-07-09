{ config, pkgs, lib, ... }:

{
  boot.supportedFilesystems = [ "ntfs" ];

  fileSystems."/mnt/win/win-c" = {
    device = "/dev/disk/by-uuid/38087FA8087F6432";
    fsType = "ntfs3";
    options = [ "rw" "uid=1000" "gid=100" "umask=002" "nofail" ];
  };

  fileSystems."/mnt/win/win-d" = {
    device = "/dev/disk/by-uuid/60AA662CAA65FEC2";
    fsType = "ntfs3";
    options = [ "rw" "uid=1000" "gid=100" "umask=002" "nofail" ];
  };

  users.users.qbittorrent = {
    extraGroups = [ "users" ];
  };

  systemd.tmpfiles.settings."win-symlinks" = {
    "/home/xmb03/win/win-c"."L" = {
      argument = "/mnt/win/win-c";
      mode = "0755";
      user = "xmb03";
      group = "users";
    };
    "/home/xmb03/win/win-d"."L" = {
      argument = "/mnt/win/win-d";
      mode = "0755";
      user = "xmb03";
      group = "users";
    };
  };
}
