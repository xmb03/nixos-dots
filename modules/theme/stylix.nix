{ config, pkgs, ... }:

{
  stylix = {
    # Enable Stylix system-wide theming
    enable = true;

    # Use grayscale-dark base16 scheme (black & white theme)
    base16Scheme = "${pkgs.base16-schemes}/share/themes/grayscale-dark.yaml";

    # Color polarity preference (dark or light)
    polarity = "dark";

    # Font configuration for themed applications
    fonts = {
      sizes = {
        applications = 11;
        desktop = 10;
        popups = 10;
        terminal = 11;
      };

      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font";
      };
      sansSerif = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font";
      };
    };
  };
}
