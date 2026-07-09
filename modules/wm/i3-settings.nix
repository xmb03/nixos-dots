# i3status-rust bar configuration
# A modern, fast status bar for i3 displaying keyboard layout, volume,
# network status, music, time, and a power menu button.

{ config, pkgs, lib, ... }:

{
  programs.i3status-rust = {
    # Enable the i3status-rust status bar
    enable = true;

    bars.default = {
      # Use the "native" theme (minimal, follows system colors)
      theme = "native";
      # Icon set (Font Awesome 4 compatible)
      icons = "awesome4";

      # Global settings including Stylix theme overrides
      settings = {
        icons = {
          icons = "awesome4";
          # Custom overrides for specific icons
          overrides = {
            # Use a custom unicode character for the power-off icon
            "power-off" = builtins.readFile ./power-char;
          };
        };

        # Apply Stylix colors + battery overrides (good/warning/critical)
        theme = {
          theme = "native";
          overrides = config.lib.stylix.i3status-rust.bar // {
            good_bg = "#22AA22";
            good_fg = "#000000";
            info_bg = "#AAAA22";
            info_fg = "#000000";
            warning_bg = "#AAAA22";
            warning_fg = "#000000";
            critical_bg = "#AA2222";
            critical_fg = "#000000";
          };
        };
      };

      # Status bar blocks (displayed left to right)
      blocks = [
        # Keyboard layout indicator
        {
          block = "keyboard_layout";
          driver = "xkbevent";
          format = " ⌨  $layout ";
          mappings = {
            "English (US)" = "EN";
            "Russian (N/A)" = "RU";
          };
          # Click to switch keyboard layout
          click = [{
            button = "left";
            cmd = "${pkgs.xdotool}/bin/xdotool key alt+shift";
          }];
        }

        # Screen backlight / brightness control
        {
          block = "backlight";
          format = " $icon $brightness ";
        }

        # Battery percentage and time remaining (скрыт при зарядке)
        {
          block = "battery";
          interval = 30;
          driver = "sysfs";
          format = " $icon $percentage $time ";
          charging_format = "";
          full_format = "";
          info = 80.0;
          good = 80.0;
          warning = 40.0;
          critical = 20.0;
        }

        # Audio volume with pipewire support
        {
          block = "sound";
          format = " $icon { $volume|} ";
          show_volume_when_muted = true;
          driver = "pipewire";
        }

        # Now-playing music info (MPRIS-compatible players)
        {
          block = "music";
          format = " $icon {$combo.str(max_w:25) $prev $play $next |}";
          click = [{
            button = "left";
            cmd = "~/.config/rofi/nowplaying/nowplaying.sh";
            update = false;
          }];
        }

        # Network connectivity indicator
        {
          block = "net";
          interval = 5;
          format = " $icon ";
          format_alt = " $icon $speed_down.eng(prefix:K)↓ $speed_up.eng(prefix:K)↑ ";
          inactive_format = " $icon ✗ ";
          missing_format = " ✗ ";
          click = [{
            button = "right";
            cmd = "${pkgs.kitty}/bin/kitty -e nmtui";
            update = false;
          }];
        }

        # Clock / time display
        {
          block = "time";
          interval = 5;
          format = " $icon $timestamp.datetime(f:'%R') ";
        }

        # Custom power menu button (triggers powermenu script)
        {
          block = "custom";
          command = "echo '{\"icon\":\"power-off\",\"text\":\"\"}'";
          json = true;
          interval = 86400;
          format = " $icon ";
          click = [{
            button = "left";
            cmd = "powermenu";
          }];
        }
      ];
    };
  };
}
