# i3 window manager configuration
# A tiling window manager with custom keybindings, theming, and
# integration with i3status-rust for the status bar.

{ config, pkgs, lib, ... }:
{
  xsession.windowManager.i3 = {
    enable = true;
    package = pkgs.i3;

    config = {
      # Super/Windows key as the main modifier
      modifier = "Mod4";

      # Floating window defaults
      floating = {
        border = 1;
        titlebar = false;
        modifier = "Mod4";
      };

      # Tiled window defaults
      window = {
        border = 1;
        titlebar = false;
        hideEdgeBorders = "none";
        # Set pixel border for all windows, no border for Firefox
        commands = [
          { command = "border pixel 1"; criteria = { class = "^.*$"; }; }
          { command = "border none";   criteria = { class = "(?i)firefox"; }; }
        ];
      };

      # Window border colors (matched to Stylix theme)
      colors = let
        bg = config.lib.stylix.colors.withHashtag.base00;
      in {
        unfocused = {
          border = lib.mkForce bg;
          childBorder = lib.mkForce bg;
        };
        focusedInactive = {
          border = lib.mkForce bg;
          childBorder = lib.mkForce bg;
        };
        placeholder = {
          border = lib.mkForce bg;
          childBorder = lib.mkForce bg;
        };
      };

      # Status bar(s)
      bars = [
        # Combine Stylix theme colors with custom bar settings
        (config.stylix.targets.i3.exportedBarConfig // {
          fonts = {
            names = [ "JetBrainsMono Nerd Font" ];
            style = "Regular";
            size = 10.0;
          };
          # Bar position on screen
          position = "bottom";
          # Use i3status-rust for status content
          statusCommand = "${pkgs.i3status-rust}/bin/i3status-rs ~/.config/i3status-rust/config-default.toml";
          # Show system tray icons on the primary monitor
          trayOutput = "primary";
        })
      ];

      # Startup programs (run at i3 startup)
      startup = [
        # Keyboard repeat rate and delay
        { command = "xset r rate 200 50"; always = true; notification = false; }
        # Desktop Entry autostart (XDG autostart)
        { command = "dex --autostart --environment i3"; notification = false; }
        # Restore last wallpaper on login
        { command = "rofi-wallpaper --restore"; always = true; notification = false; }
        # xss-lock — слушает сигнал блокировки от logind, запускает i3lock
        { command = "${pkgs.xss-lock}/bin/xss-lock -- ${pkgs.i3lock}/bin/i3lock -n -c 000000"; always = true; notification = false; }
        # NetworkManager system tray applet
        { command = "nm-applet"; notification = false; }
      ];

      # Keyboard shortcuts (keybindings)
      keybindings = {
        # Screenshots (maim saves to ~/Pictures, copies to clipboard, shows notification)
	"Print" = let
  maim = "${pkgs.maim}/bin/maim";
  xclip = "${pkgs.xclip}/bin/xclip";
  notify = "${pkgs.libnotify}/bin/notify-send";
in "exec sh -c '${maim} ~/Pictures/$(date +%Y%m%d_%H%M%S).png && ${maim} | ${xclip} -selection clipboard -t image/png && ${notify} \"Screenshot\" \"Full screen captured\" --icon=camera-photo'";
        "Mod4+Shift+s" = let
  maim = "${pkgs.maim}/bin/maim";
  xclip = "${pkgs.xclip}/bin/xclip";
  notify = "${pkgs.libnotify}/bin/notify-send";
in "exec sh -c 'FILE=~/Pictures/$(date +%Y%m%d_%H%M%S).png && ${maim} -s \"$FILE\" && ${xclip} -selection clipboard -t image/png -i \"$FILE\" && ${notify} \"Screenshot\" \"Area captured\" --icon=camera-photo'";
        # Application launchers
        "Mod4+w"         = "exec firefox";
        "Mod4+d"         = "exec rofi -show drun";
        "Mod4+v"         = "exec env CM_LAUNCHER=rofi clipmenu -p Clip";
        "Mod4+Tab"       = "exec rofi -show";
        "Mod4+p"         = "exec powermenu";
        "Mod4+a"         = "exec rofi-wallpaper";
        "Mod4+Shift+a"   = "exec rofi-theme";
        "Mod4+r"         = "mode resize";

        # Volume control
        "XF86AudioRaiseVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ +10% && killall -SIGUSR1 i3status-rs";
        "XF86AudioLowerVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ -10% && killall -SIGUSR1 i3status-rs";
        "XF86AudioMute"       = "exec pactl set-sink-mute @DEFAULT_SINK@ toggle && killall -SIGUSR1 i3status-rs";

        # Media controls
        "XF86AudioPlay"  = "exec playerctl play-pause";
        "XF86AudioNext"  = "exec playerctl next";
        "XF86AudioPrev"  = "exec playerctl previous";

        # Terminal
        "Mod4+t"         = "exec kitty";
        "Mod4+q"         = "kill";  # Close focused window

        # Focus navigation (vim-style)
        "Mod4+j"         = "focus left";
        "Mod4+k"         = "focus down";
        "Mod4+l"         = "focus up";
        "Mod4+semicolon" = "focus right";
        "Mod4+Left"      = "focus left";
        "Mod4+Down"      = "focus down";
        "Mod4+Up"        = "focus up";
        "Mod4+Right"     = "focus right";

        # Move windows (vim-style)
        "Mod4+Shift+j"         = "move left";
        "Mod4+Shift+k"         = "move down";
        "Mod4+Shift+l"         = "move up";
        "Mod4+Shift+semicolon" = "move right";
        "Mod4+Shift+Left"      = "move left";
        "Mod4+Shift+Down"      = "move down";
        "Mod4+Shift+Up"        = "move up";
        "Mod4+Shift+Right"     = "move right";

        # Layout management
        "Mod4+h"               = "split h";      # Horizontal split
        "Mod4+f"               = "fullscreen toggle";
        "Mod4+s"               = "layout stacking";
        "Mod4+e"               = "layout toggle split";
        "Mod4+Shift+space"     = "floating toggle";
        "Mod4+space"           = "focus mode_toggle";

        # Workspace navigation (0-10)
        "Mod4+1"               = "workspace number 1";
        "Mod4+2"               = "workspace number 2";
        "Mod4+3"               = "workspace number 3";
        "Mod4+4"               = "workspace number 4";
        "Mod4+5"               = "workspace number 5";
        "Mod4+6"               = "workspace number 6";
        "Mod4+7"               = "workspace number 7";
        "Mod4+8"               = "workspace number 8";
        "Mod4+9"               = "workspace number 9";
        "Mod4+0"               = "workspace number 10";

        # Move windows to workspaces
        "Mod4+Shift+1"         = "move container to workspace number 1";
        "Mod4+Shift+2"         = "move container to workspace number 2";
        "Mod4+Shift+3"         = "move container to workspace number 3";
        "Mod4+Shift+4"         = "move container to workspace number 4";
        "Mod4+Shift+5"         = "move container to workspace number 5";
        "Mod4+Shift+6"         = "move container to workspace number 6";
        "Mod4+Shift+7"         = "move container to workspace number 7";
        "Mod4+Shift+8"         = "move container to workspace number 8";
        "Mod4+Shift+9"         = "move container to workspace number 9";
        "Mod4+Shift+0"         = "move container to workspace number 10";

        # i3 management
        "Mod4+Shift+c"         = "reload";   # Reload config
        "Mod4+Shift+r"         = "restart";  # Restart i3
        "Mod4+Shift+e"         = "exec i3-nagbar -t warning -m 'You pressed the exit shortcut. This will end your X session.' -B 'Yes, exit i3' 'i3-msg exit'";
      };

      # Custom modes (multi-key combinations)
      modes = {
        # Resize mode (enter with Mod4+r)
        resize = {
          h            = "resize shrink width 10 px or 10 ppt";
          j            = "resize grow height 10 px or 10 ppt";
          k            = "resize shrink height 10 px or 10 ppt";
          l            = "resize grow width 10 px or 10 ppt";
          Left         = "resize shrink width 10 px or 10 ppt";
          Down         = "resize grow height 10 px or 10 ppt";
          Up           = "resize shrink height 10 px or 10 ppt";
          Right        = "resize grow width 10 px or 10 ppt";
          Return       = "mode default";
          Escape       = "mode default";
          "Mod4+r"     = "mode default";
        };
      };
    };
  };
}
