{ config, pkgs, lib, ... }:

{
  xsession.windowManager.i3 = {
    enable = true;
    package = pkgs.i3;

    extraConfig = ''
      set $mod Mod4
      font pango:monospace 8

      # ====== FLOATING / TILING ======
      set $refresh_i3status killall -SIGUSR1 i3status
      floating_modifier $mod
      tiling_drag modifier titlebar

      # ====== WORKSPACES ======
      set $ws1 "1"
      set $ws2 "2"
      set $ws3 "3"
      set $ws4 "4"
      set $ws5 "5"
      set $ws6 "6"
      set $ws7 "7"
      set $ws8 "8"
      set $ws9 "9"
      set $ws10 "10"

      # ====== KEYBOARD ======
      exec_always --no-startup-id xset r rate 200 50

      # ====== MONITOR ======
      exec_always --no-startup-id xrandr --output DP-0 --primary --mode "1920x1200_165.00"

      # ====== BORDERS ======
      default_border pixel 1
      default_floating_border pixel 1
      smart_borders no_gaps
      hide_edge_borders none
      for_window [class="^.*"] border pixel 1
      for_window [class="(?i)firefox"] border none

      # ====== WINDOW COLORS (pywal via Xresources) ======
      set_from_resource $color0 i3wm.color0 #000000
      set_from_resource $color1 i3wm.color1 #ff0000
      set_from_resource $color2 i3wm.color2 #00ff00
      set_from_resource $color3 i3wm.color3 #ffff00
      set_from_resource $color4 i3wm.color4 #0000ff
      set_from_resource $color5 i3wm.color5 #ff00ff
      set_from_resource $color6 i3wm.color6 #00ffff
      set_from_resource $color7 i3wm.color7 #ffffff
      set_from_resource $color8 i3wm.color8 #808080
      set_from_resource $color9 i3wm.color9 #ff5555
      set_from_resource $color10 i3wm.color10 #55ff55
      set_from_resource $color11 i3wm.color11 #ffff55
      set_from_resource $color12 i3wm.color12 #5555ff
      set_from_resource $color13 i3wm.color13 #ff55ff
      set_from_resource $color14 i3wm.color14 #55ffff
      set_from_resource $color15 i3wm.color15 #f0f0f0

      client.focused          $color4 $color4 $color15 $color4 $color4
      client.focused_inactive $color8 $color8 $color15 $color8 $color8
      client.unfocused        $color0 $color0 $color8  $color0 $color0
      client.urgent           $color1 $color1 $color15 $color1 $color1
      client.placeholder      $color8 $color8 $color15 $color8 $color8
      client.background       $color0

      # ====== BAR ======
      set_from_resource $bg      i3wm.color0 #000000
      set_from_resource $fg      i3wm.color7 #ffffff
      set_from_resource $primary i3wm.color1 #ff0000
      set_from_resource $dark    i3wm.color8 #808080
      set_from_resource $urgent  i3wm.color9 #ff5555

      bar {
          status_command i3status-rs ~/.config/i3/i3status-rs/config.toml
          position bottom
          tray_output primary

          colors {
              background $bg
              statusline $fg
              separator  $dark

              focused_workspace  $primary $primary $fg
              active_workspace   $dark    $dark    $fg
              inactive_workspace $bg      $bg      $dark
              urgent_workspace   $urgent  $urgent  $fg
          }
      }

      # ====== AUTOSTART ======
      exec_always --no-startup-id dunst
      exec_always --no-startup-id xss-lock -- i3lock -n
      exec_always --no-startup-id sleep 1 && xrdb -merge ~/.Xresources
      exec_always --no-startup-id redshift
      exec_always --no-startup-id udiskie
      exec_always --no-startup-id ~/.config/i3/scripts/rofi-wallpaper --reset
      exec --no-startup-id dex --autostart --environment i3
      exec --no-startup-id nm-applet

      # ====== SCREENSHOTS ======
      bindsym Print exec --no-startup-id flameshot full -c
      bindsym Mod4+Shift+s exec --no-startup-id flameshot gui

      # ====== BROWSER ======
      bindsym $mod+w exec firefox

      # ====== ROFI ======
      bindsym $mod+d exec rofi -show drun
      bindsym $mod+v exec rofi -modi "clipboard:greenclip print" -show clipboard
      bindsym $mod+Tab exec --no-startup-id "rofi -show"

      # ====== POWER MENU ======
      bindsym $mod+p exec ~/.config/i3/scripts/powermenu

      # ====== WALLPAPER ======
      bindsym $mod+a exec ~/.config/i3/scripts/rofi-wallpaper

      # ====== VOLUME ======
      bindsym XF86AudioRaiseVolume exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ +10% && $refresh_i3status
      bindsym XF86AudioLowerVolume exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ -10% && $refresh_i3status
      bindsym XF86AudioMute exec --no-startup-id pactl set-sink-mute @DEFAULT_SINK@ toggle && $refresh_i3status

      # ====== LAUNCHERS ======
      bindsym $mod+t exec i3-sensible-terminal
      bindsym $mod+q kill

      # ====== FOCUS ======
      bindsym $mod+j focus left
      bindsym $mod+k focus down
      bindsym $mod+l focus up
      bindsym $mod+semicolon focus right
      bindsym $mod+Left focus left
      bindsym $mod+Down focus down
      bindsym $mod+Up focus up
      bindsym $mod+Right focus right

      # ====== MOVE ======
      bindsym $mod+Shift+j move left
      bindsym $mod+Shift+k move down
      bindsym $mod+Shift+l move up
      bindsym $mod+Shift+semicolon move right
      bindsym $mod+Shift+Left move left
      bindsym $mod+Shift+Down move down
      bindsym $mod+Shift+Up move up
      bindsym $mod+Shift+Right move right

      # ====== LAYOUT ======
      bindsym $mod+h split h
      bindsym $mod+f fullscreen toggle
      bindsym $mod+s layout stacking
      bindsym $mod+e layout toggle split
      bindsym $mod+Shift+space floating toggle
      bindsym $mod+space focus mode_toggle

      # ====== WORKSPACES ======
      bindsym $mod+1 workspace number $ws1
      bindsym $mod+2 workspace number $ws2
      bindsym $mod+3 workspace number $ws3
      bindsym $mod+4 workspace number $ws4
      bindsym $mod+5 workspace number $ws5
      bindsym $mod+6 workspace number $ws6
      bindsym $mod+7 workspace number $ws7
      bindsym $mod+8 workspace number $ws8
      bindsym $mod+9 workspace number $ws9
      bindsym $mod+0 workspace number $ws10

      # ====== MOVE TO WORKSPACE ======
      bindsym $mod+Shift+1 move container to workspace number $ws1
      bindsym $mod+Shift+2 move container to workspace number $ws2
      bindsym $mod+Shift+3 move container to workspace number $ws3
      bindsym $mod+Shift+4 move container to workspace number $ws4
      bindsym $mod+Shift+5 move container to workspace number $ws5
      bindsym $mod+Shift+6 move container to workspace number $ws6
      bindsym $mod+Shift+7 move container to workspace number $ws7
      bindsym $mod+Shift+8 move container to workspace number $ws8
      bindsym $mod+Shift+9 move container to workspace number $ws9
      bindsym $mod+Shift+0 move container to workspace number $ws10

      # ====== SESSION ======
      bindsym $mod+Shift+c reload
      bindsym $mod+Shift+r restart
      bindsym $mod+Shift+e exec "i3-nagbar -t warning -m 'You pressed the exit shortcut. Do you really want to exit i3? This will end your X session.' -B 'Yes, exit i3' 'i3-msg exit'"

      # ====== RESIZE ======
      mode "resize" {
              bindsym j resize shrink width 10 px or 10 ppt
              bindsym k resize grow height 10 px or 10 ppt
              bindsym l resize shrink height 10 px or 10 ppt
              bindsym semicolon resize grow width 10 px or 10 ppt
              bindsym Left resize shrink width 10 px or 10 ppt
              bindsym Down resize grow height 10 px or 10 ppt
              bindsym Up resize shrink height 10 px or 10 ppt
              bindsym Right resize grow width 10 px or 10 ppt

              bindsym Return mode "default"
              bindsym Escape mode "default"
              bindsym $mod+r mode "default"
      }
      bindsym $mod+r mode "resize"
    '';
  };
}
