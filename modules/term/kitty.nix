# Kitty terminal emulator configuration
# A fast, GPU-accelerated terminal with custom padding and no window decorations.

{ config, pkgs, ... }:

{
  programs.kitty = {
    enable = true;

    settings = {
      # Auto-detect bold, italic, and bold-italic font variants
      bold_font = "auto";
      italic_font = "auto";
      bold_italic_font = "auto";

      # Terminal inner padding (space between text and window edges)
      window_padding_width = 9;
      # Remove title bar and window decorations for a clean look
      hide_window_decorations = "yes";
      # Disable the terminal bell sound
      enable_audio_bell = "no";
      # Don't prompt for confirmation when closing multiple windows
      confirm_os_window_close = 0;

      # Launch zellij automatically on kitty start
      shell = "zellij --layout welcome";
    };
  };
}
