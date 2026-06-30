{ config, pkgs, lib, ... }:

{
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      up = "sudo nixos-rebuild switch";
      n = "nvim";
      c = "clear";
      cat = "bat";
      b = "bat";
      l = "ls -lh --color=auto";
      la = "ls -lha --color=auto";
      ".." = "cd ..";
      "..." = "cd ../..";
      f = "fastfetch";
      mem = "free -h";
      disk = "df -h";
      top = "btop";
      m = "mpv";
    };

    envExtra = ''
      export PATH="$HOME/.npm-global/bin:$PATH"
      fpath+=(${pkgs.zsh-completions}/share/zsh-completions)
    '';

    initContent = lib.mkBefore ''
      HISTFILE=~/.zsh_history
      HISTSIZE=10000
      SAVEHIST=10000
      setopt appendhistory
      autoload -Uz compinit && compinit

      if [ -f "$HOME/.cache/wal/sequences" ]; then
        cat "$HOME/.cache/wal/sequences"
      fi

      if [ -f "$HOME/.cache/wal/colors.sh" ]; then
        source "$HOME/.cache/wal/colors.sh"
      fi

      ZSH_HIGHLIGHT_STYLES[command]="fg=$color2,bold"
      ZSH_HIGHLIGHT_STYLES[builtin]="fg=$color6"
      ZSH_HIGHLIGHT_STYLES[alias]="fg=$color3"
      ZSH_HIGHLIGHT_STYLES[path]="fg=$color4"
      ZSH_HIGHLIGHT_STYLES[error]="fg=$color1"
      ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=$color8"

      PROMPT="%F{$color4}>%f "

      y() {
        if [ -f "$1" ]; then
          cat "$1" | xclip -selection clipboard
          echo "Copied!"
        else
          echo "File not found."
        fi
      }
    '';
  };
}
