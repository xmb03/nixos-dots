{ config, pkgs, ... }:

let
  zextract-wasm = pkgs.fetchurl {
    url = "https://github.com/codingfragments/zellij-zextract/releases/latest/download/zextract.wasm";
    hash = "sha256-LnneanEAK2IcBo6kIyuzyuPt9nb/mSjL0+AC22eh/BA=";
  };
in {
  programs.zellij = {
    enable = true;
    settings = {
      default_layout = "compact";
      default_shell = "zsh";
      pane_frames = false;
      simplified_ui = false;
      auto_update_check = false;
      scrollback_editor = "vim";
      copy_command = "xclip -selection clipboard";
    };

    extraConfig = ''
      keybinds {
          shared_except "locked" {
              bind "Ctrl x" {
                  LaunchOrFocusPlugin "file://${zextract-wasm}" {
                      floating true;
                  };
              }
          }
      }
    '';
  };
}
