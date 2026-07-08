{ config, pkgs, lib, ... }:

{
  programs.yazi = {
    enable = true;
    plugins = {
      diff = pkgs.yaziPlugins.diff;
      git = pkgs.yaziPlugins.git;
      smart-enter = pkgs.yaziPlugins.smart-enter;
      chmod = pkgs.yaziPlugins.chmod;
      compress = pkgs.yaziPlugins.compress;
    };

    settings = {
      mgr = {
        show_hidden = true;
        sort_dir_first = true;
        linemode = "size";
      };

      preview = {
        max_width = 1200;
        max_height = 1200;
      };

      opener = {
        edit = [
          ( { run = ''vim "$@"''; desc = "vim"; for = "unix"; block = true; } )
        ];
      };
    };

    keymap = {
      mgr.prepend_keymap = [
        ( { on = [ "g" "g" ]; run = "escape --select"; desc = "Go to top"; } )
        ( { on = [ "G" ]; run = "escape --select -1"; desc = "Go to bottom"; } )
      ];
    };
  };
}
