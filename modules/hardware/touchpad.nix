# Touchpad configuration
# Uses libinput for precise touchpad control with natural scrolling and tap-to-click.

{ config, lib, pkgs, ... }:

{
  services.libinput = {
    # Enable the libinput input device handler
    enable = true;
    touchpad = {
      # Reverse scroll direction (like macOS touchpads)
      naturalScrolling = true;
      # Tap with one finger to left-click
      tapping = true;
      # Adaptive acceleration profile for precise cursor control
      accelProfile = "adaptive";
      # Touchpad sensitivity (negative = slower, positive = faster)
      accelSpeed = "-0.39";
      # Disable touchpad while typing to prevent accidental cursor movement
      disableWhileTyping = true;
    };
  };
}
