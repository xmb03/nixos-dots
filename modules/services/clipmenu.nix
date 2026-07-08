{ config, pkgs, lib, ... }:

{
  home.packages = [ pkgs.clipmenu ];

  systemd.user.services.clipmenud = {
    Unit = {
      Description = "Clipmenu daemon";
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs.clipmenu}/bin/clipmenud";
      Restart = "on-failure";
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
}
