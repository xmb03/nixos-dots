{ config, pkgs, lib, ... }:

{
  programs.bash = {
    enable = true;

    bashrcExtra = ''
      export PATH="$HOME/.local/bin:$PATH"

      alias ls='ls --color=auto'
      alias grep='grep --color=auto'
      PS1='[\u@\h \W]\$ '

      alias up='sudo nixos-rebuild switch'
      alias c='clear'
      alias l='ls -lh --color=auto'
      alias la='ls -lha --color=auto'
      alias cat='bat'
      alias n='nvim'
      alias f='fastfetch'
      alias top='btop'
    '';
  };
}
