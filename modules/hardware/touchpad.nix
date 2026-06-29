{ config, lib, pkgs, ... }:

{
  services.libinput = {
    enable = true;
    touchpad = {
      naturalScrolling = true;
      accelProfile = "adaptive";
      accelSpeed = "-0.39";
      disableWhileTyping = true;
    };
  };
}
