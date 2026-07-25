{ config, pkgs, lib, inputs, ... }:

let
  playwrightMcp = inputs.mcp-servers-nix.packages.${pkgs.stdenv.hostPlatform.system}.playwright-mcp;
in {
  home.packages = [ playwrightMcp ];

  xdg.configFile."opencode/mcp.jsonc" = {
    text = builtins.toJSON {
      mcp = {
        playwright = {
          type = "local";
          command = [
            "${lib.getExe playwrightMcp}"
            "--executable-path"
            "${lib.getExe pkgs.chromium}"
          ];
          enabled = true;
        };
      };
    };
  };

  home.sessionVariables.OPENCODE_CONFIG = "${config.xdg.configHome}/opencode/mcp.jsonc";
}
