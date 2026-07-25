{ config, pkgs, lib, ... }:

{
  home.packages = [ pkgs.opencode ];

  xdg.configFile."opencode/opencode.jsonc" = {
    text = builtins.toJSON {
      "$schema" = "https://opencode.ai/config.json";
      autoupdate = "notify";
      shell = "/bin/zsh";
      model = "{env:OPENCODE_MODEL}";
      plugin = [
        "opencode-browser-control"
        "opencode-skill-creator"
        "opencode-plugin-preload-skills"
        "opencode-notify-tool"
      ];
    };
  };
}
