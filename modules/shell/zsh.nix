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

      ZSH_HIGHLIGHT_STYLES[command]="fg=#b8bb26,bold"
      ZSH_HIGHLIGHT_STYLES[builtin]="fg=#83a598"
      ZSH_HIGHLIGHT_STYLES[alias]="fg=#fabd2f"
      ZSH_HIGHLIGHT_STYLES[path]="fg=#83a598"
      ZSH_HIGHLIGHT_STYLES[error]="fg=#fb4934"
      ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#504945"

      PROMPT="%F{#83a598}>%f "

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
