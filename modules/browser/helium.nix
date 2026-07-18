{ config, pkgs, inputs, lib, ... }:

{
  imports = [ inputs.helium-flake.nixosModules.default ];

  programs.helium = {
    enable = true;

    flags = [ "--ozone-platform-hint=auto" ];

    policies = {
      ExtensionInstallForcelist = [
        "hfjbmagddngcpeloejdejnfgbamkjaeg" # vimium C
        "pkehgijcmpdhfbdbbnkijodmdjhbjlgp"
        "eimadpbcbfnmbkopoojfekhnkhdbieeh"
        "mpiodijhokgodhhofbcjdecpffjipkle"
        "hnjlnpipbcbgllcjgbcjfgepmeomdcog" # font changer
        "eljapbgkmlngdpckoiiibecpemleclhh" # ninja font
        "cnojnbdhbhnkbcieeekonklommdnndci"
        "nngceckbapebfimnlniiiahkandclblb"
      ];

      DefaultSearchProviderEnabled = true;
      DefaultSearchProviderName = "DuckDuckGo";
      DefaultSearchProviderSearchURL = "https://duckduckgo.com/?q={searchTerms}";

      ApplicationLocale = "en-US";

      BookmarkBarEnabled = false;

      RestoreOnStartup = 5;

      PasswordManagerEnabled = true;
    };
  };
}
