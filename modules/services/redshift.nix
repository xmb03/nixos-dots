{ config, pkgs, lib, ... }:

{
  services.redshift = {
    enable = true;
    latitude = "55.7558";
    longitude = "37.6173";
    temperature = {
      day = 6500;
      night = 3500;
    };
    settings = {
      redshift = {
        dusk-time = "20:00";
        dawn-time = "07:00";
        fade = 1;
      };
    };
  };
}
