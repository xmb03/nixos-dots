# Redshift blue-light filter configuration
# Automatically adjusts screen color temperature to reduce eye strain
# during evening and nighttime hours.

{ config, pkgs, lib, ... }:

{
  services.redshift = {
    # Enable the redshift service
    enable = true;

    # Location coordinates (Moscow, Russia)
    latitude = "55.7558";
    longitude = "37.6173";

    # Color temperature in Kelvin (lower = warmer/redder)
    temperature = {
      day = 6500;    # Neutral daylight temperature
      night = 3500;  # Warm nighttime temperature (reduces blue light)
    };

    # Advanced settings
    settings = {
      redshift = {
        # Manual dusk/dawn times (used when geolocation is unavailable)
        dusk-time = "20:00";
        dawn-time = "07:00";
        # Transition duration in seconds (1 = smooth 1-second fade)
        fade = 1;
      };
    };
  };
}
