{ config, pkgs, lib, ... }:

{
  xdg.configFile."i3/i3status-rs/config.toml".text = ''
    [theme]
    theme = "native"

    [icons]
    icons = "awesome4"

    [[block]]
    block = "keyboard_layout"
    driver = "xkbevent"
    format = " ⌨  $layout "

    [block.mappings]
    "English (US)" = "EN"
    "Russian (N/A)" = "RU"

    [[block.click]]
    button = "left"
    cmd = "xdotool key alt+shift"
    update = true

    [[block]]
    block = "backlight"
    format = " $icon $brightness "

    [[block]]
    block = "sound"
    format = " $icon { $volume|} "
    show_volume_when_muted = true
    driver = "pipewire"

    [[block]]
    block = "time"
    interval = 5
    format = " $icon $timestamp.datetime(f:'%R') "
  '';
}
