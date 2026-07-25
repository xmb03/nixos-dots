{ config, pkgs, lib, ... }:

{
  environment.systemPackages = [ pkgs.static-cursor ];

  environment.variables = {
    XCURSOR_THEME = "static";
  };

  services.libinput.mouse = {
    accelProfile = "flat";
    accelSpeed = "-0.39";
  };
}
