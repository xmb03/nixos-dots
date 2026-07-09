# Zsh shell configuration
# Manages shell history, autosuggestions, syntax highlighting, aliases,
# and custom utility scripts for an enhanced command-line experience.

{ config, pkgs, lib, ... }:

{
  # Add custom directories to the PATH environment variable
  home.sessionPath = [
    "$HOME/.npm-global/bin"
  ];

  # Additional shell packages and custom scripts
  home.packages = [
    # Zsh completion system (automatically configured by home-manager)
    pkgs.zsh-completions

    # Custom "y" command: copies file content to clipboard
    # Usage: y <filename>
    (pkgs.writeShellScriptBin "yc" ''
      if [ -f "$1" ]; then
        cat "$1" | ${pkgs.xclip}/bin/xclip -selection clipboard
        echo "Copied!"
      else
        echo "File not found."
      fi
    '')
  ];

  # Zsh shell configuration
  programs.zsh = {
    enable = true;

    # Enable built-in shell completion handling
    enableCompletion = true;

    # Shell history settings
    history = {
      size = 10000;                        # Maximum history entries in memory
      save = 10000;                        # Maximum history entries saved to file
      path = "${config.home.homeDirectory}/.zsh_history";
      share = true;                        # Share history across shell sessions
    };

    # Autosuggestions (suggest commands based on history)
    autosuggestion = {
      enable = true;
      highlight = "fg=8";                  # Autosuggestion color
    };

    # Syntax highlighting for commands as you type
    syntaxHighlighting = {
      enable = true;
      styles = {
        command = "fg=2,bold";             # Green, bold for valid commands
        builtin = "fg=6";                  # Cyan for built-in commands
        alias   = "fg=3";                  # Yellow for aliases
        path    = "fg=4";                  # Blue for file paths
        error   = "fg=1";                  # Red for invalid commands
      };
    };

    # Local shell variables (custom prompt)
    localVariables = {
      PROMPT = "%F{4}>%f ";               # Blue ">" prompt symbol
    };

    # Custom shell aliases
    shellAliases = {
      up    = "cd ~/.config/nixos && git add . && nixos-rebuild switch --elevate=sudo --flake .#nixos";
      c     = "clear";
      cat   = "bat";                       # Use bat instead of cat
      b     = "bat";                       # Shorthand for bat
      l     = "ls -lh --color=auto";       # Long listing with human-readable sizes
      la    = "ls -lha --color=auto";      # Long listing including hidden files
      ".."  = "cd ..";
      "..." = "cd ../..";
      f     = "fastfetch";                 # System info display
      mem   = "free -h";                   # Memory usage
      disk  = "df -h";                     # Disk usage
      top   = "btop";                      # System monitor
      m     = "mpv";                       # Media player
      p     = "python";
      dn    = "sudo nix-collect-garbage --delete-older-than 30d";
      tgw   = "steam-run ~/nixtest/apps/TgWsProxy_linux_amd64";
      v     = "vim";
      n     = "nvim";
      yb = "yazi ~/Documents/xmb03";
    };
  };
}
