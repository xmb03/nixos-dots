{ config, pkgs, lib, ... }:

let
  staticCursor = pkgs.callPackage ../../cursors/static {};
in {
  environment.systemPackages = [ staticCursor ];

  services.xserver.displayManager.lightdm.greeters.gtk.cursorTheme = {
    name = "static";
    package = staticCursor;
  };

  services.xserver.displayManager.sessionCommands = ''
    ${pkgs.xorg.xrdb}/bin/xrdb -merge <<< "Xcursor.theme: static"
  '';
}
