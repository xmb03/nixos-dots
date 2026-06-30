{ config, pkgs, lib, ... }:

{
  programs.kitty = {
    enable = true;

    settings = {
      font_family = "JetBrainsMono Nerd Font Mono";
      bold_font = "auto";
      italic_font = "auto";
      bold_italic_font = "auto";
      font_size = "12.0";
      window_padding_width = "9";
      hide_window_decorations = "yes";
      enable_audio_bell = "no";
      confirm_os_window_close = "0";
    };

    extraConfig = ''
      include ~/.cache/wal/colors-kitty.conf
    '';
  };
}
