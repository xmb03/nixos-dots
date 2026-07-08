{ config, pkgs, ... }:

{
  home.packages = [
    (pkgs.rustPlatform.buildRustPackage rec {
      pname = "basalt-tui";
      version = "0.12.6";

      src = pkgs.fetchFromGitHub {
        owner = "erikjuhani";
        repo = "basalt";
        rev = "basalt/v${version}";
        hash = "sha256-MlKrVxNU9PNakIA9hiv5ll7ImkPDekQnassWFO/smkE="; 
      };

      cargoHash = "sha256-sTU0AUwR5xdnqLvrRycxuMk+KNcsEcYU3XvyODKT1Ns=";

      nativeBuildInputs = [ pkgs.pkg-config ];
      buildInputs = [ pkgs.openssl ];
    })
  ];

  xdg.configFile."basalt/config.toml".source = pkgs.writers.writeTOML "basalt-config" {
    experimental_editor = true;

    global = {
      key_bindings = [
        { key = "ctrl+alt+e"; command = "exec:vi %note_path"; }
      ];
    };
  }; 

  home.shellAliases = {
    basalt = "BASALT_EXP_VAULT_PATH=/home/xmb03/Documents/xmb03 basalt"; 
  };
}
