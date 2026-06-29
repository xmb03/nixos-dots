{ config, pkgs, lib, ... }:

{
  xdg.configFile."greenclip/config.toml".text = ''
    enable_image_support = true
    max_history_length = 50
    trim_space_from_selection = true
  '';
}
