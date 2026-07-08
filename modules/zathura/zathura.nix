# Zathura PDF viewer configuration
# A lightweight document viewer with dark theme support and clipboard integration.

{ config, pkgs, ... }:

{
  programs.zathura = {
    enable = true;

    options = {
      # Integration with the system clipboard (for copying text)
      "selection-clipboard" = "clipboard";

      # Recolor document pages to dark theme (dark background, light text)
      "recolor" = true;

      # Preserve original colors of images/diagrams while inverting
      # only the background and text (useful for books with illustrations)
      "recolor-keephue" = true;
    };
  };
}
