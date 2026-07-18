# Zsh shell configuration
# Manages shell history, autosuggestions, syntax highlighting, aliases,
# and custom utility scripts for an enhanced command-line experience.

{ config, pkgs, lib, ... }:

{
  # Add custom directories to the PATH environment variable
  home.sessionPath = [
    "$HOME/.local/bin"
  ];

  # Additional shell packages and custom scripts
  home.packages = [
    # Zsh completion system (automatically configured by home-manager)
    pkgs.zsh-completions
    pkgs.fd

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

    # histy — interactive TUI for shell history
    # Uses npx -y to auto-fetch latest version from npm (cached after first run)
    (pkgs.writeShellScriptBin "histy" ''
      exec ${pkgs.nodejs}/bin/npx -y histy-cli "$@"
    '')

    # fh — fzf history search: unique commands, newest first, copy to clipboard
    (pkgs.writeShellScriptBin "fh" ''
      cmd=$(sed 's/^[^;]*;//' "$HOME/.zsh_history" | tac | perl -ne 'print if !$c{$_}++' | ${pkgs.fzf}/bin/fzf --no-sort --prompt='History> ' --preview='echo {}' --preview-window=up:3:wrap)
      if [[ -n "$cmd" ]]; then
        printf '%s' "$cmd" | ${pkgs.xclip}/bin/xclip -selection clipboard
        echo "Copied: $cmd"
      fi
    '')

    # fp — fzf process search: show PID+name+exe, preview details, kill on enter
    (pkgs.writeShellScriptBin "fp" ''
      selection=$(ps aux | ${pkgs.fzf}/bin/fzf --header-lines=1 --prompt='Process> ' --preview='echo "PID: {2}"; echo "EXE: $(readlink -f /proc/{2}/exe 2>/dev/null || echo N/A)"; ps -p {2} -o pid,user,%cpu,%mem,rss,args --no-headers 2>/dev/null' --preview-window=up:8:wrap)
      if [[ -n "$selection" ]]; then
        pid=$(echo "$selection" | awk '{print $2}')
        if [[ "$pid" -ne $$ && "$pid" -ne $(ps -o ppid= -p $$) ]]; then
          kill "$pid" 2>/dev/null && echo "Killed PID $pid" || echo "Failed to kill PID $pid"
        fi
      fi
    '')

    # ff — fzf file/directory search from /, copy absolute path to clipboard
    (pkgs.writeShellScriptBin "ff" ''
      selection=$(${pkgs.fd}/bin/fd --type f --type d --hidden -E /proc -E /sys -E /dev -E /run . / 2>/dev/null | ${pkgs.fzf}/bin/fzf --prompt='Files> ' --preview='if [ -d {} ]; then ls -la {} 2>/dev/null; else ${pkgs.bat}/bin/bat --style=numbers --color=always {} 2>/dev/null || cat {}; fi' --preview-window=right:60%)
      if [[ -n "$selection" ]]; then
        printf '%s' "$selection" | ${pkgs.xclip}/bin/xclip -selection clipboard
        echo "Copied: $selection"
      fi
    '')
  ];

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

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
      c     = "clear -x";
      cat   = "bat";                       # Use bat instead of cat
      b     = "bat";                       # Shorthand for bat
      l     = "ls -lh --color=auto";       # Long listing with human-readable sizes
      la    = "ls -lha --color=auto";      # Long listing including hidden files
      ".."  = "cd ..";
      "..." = "cd ../..";
      f     = "fzf";                 # Fzf fuzzy finder
      mem   = "free -h";                   # Memory usage
      disk  = "df -h";                     # Disk usage
      top   = "btop";                      # System monitor
      m     = "mpv";                       # Media player
      p     = "python";
      dn    = "sudo nix-collect-garbage --delete-older-than 30d";

      nn    = "~/Apps/ollama-notes/target/release/genote";
      tgw   = "steam-run ~/Apps/tgw/tgwsproxy";
      pp    = "cd ~/Apps/proxy-scraper-checker && ./target/release/proxy-scraper-checker";
      v     = "vim";
      yn = "yazi ~/Documents/xmb03";
      z  = "zellij";
      h  = "histy";                      # histy — TUI shell history browser
    };
  };
}
