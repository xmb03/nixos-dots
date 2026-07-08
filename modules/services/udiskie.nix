# Udiskie automatic USB mount service
# Automatically mounts USB drives and other removable media when connected.

{ config, pkgs, lib, ... }:

{
  services.udiskie = {
    # Enable the udiskie service for automatic device mounting
    enable = true;
  };
}
