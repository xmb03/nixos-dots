{ config, pkgs, ... }:
{
  services.picom = {
    enable = true;
    backend = "glx";
    vSync = true;

    shadow = false;
    fade = false;
    inactiveOpacity = 1.0;
    activeOpacity = 1.0;
    opacityRules = [ ];

    settings = {
      blur = {
        method = "none";
        size = 0;
        deviation = 0.0;
      };
      blur-background = false;
      blur-background-frame = false;
      blur-strength = 0;
      no-fading-openclose = true;
      no-fading-destroyed-argb = true;
      mark-wmwin-focused = true;
      mark-ovredir-focused = true;
      detect-rounded-corners = false;
      detect-client-opacity = false;
      glx-no-stencil = true;
      glx-no-rebind-pixmap = true;
      xrender-sync-fence = true;
      respect-prop-shadow = false;
      no-dnd-shadow = true;
      no-dock-shadow = true;
      clear-shadow = false;
      frame-opacity = 1.0;
      inactive-opacity-override = false;
      use-ewmh-active-win = false;
    };
  };
}
