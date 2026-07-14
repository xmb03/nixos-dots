{ config, pkgs, inputs, lib, ... }:
with lib;

{
  # Включаем Chromium с расширениями
  programs.chromium = {
    enable = true;

    # Список расширений (их ID я нашел в прошлый раз)
    extensions = [
      "cjpalhdlnbpafiamejdnhcphjbkeiagm"  # uBlock Origin
      "mkejgcgkdlddbggjhhflekkondicpnop"  # Privacy Badger
      "clnalilglegcjmlgenoppklmfppddien"  # Vimium C
      "mpiodijhokgodhhofbcjdecpffjipkle"  # Single File
      "eimadpbcbfnmbkopoojfekhnkhdbieeh"  # Dark Reader
      "cnojnbdhbhnkbcieeekonklommdnndci"  # Search by Image
      "dgdfbndljpogobgjlligoffljmkiiafc"  # RuTracker
    ];
  };

  # Настройка шрифтов на уровне всей системы
  fonts.fontconfig.defaultFonts = {
    monospace = [ "JetBrainsMono Nerd Font" ];
    sansSerif = [ "JetBrainsMono Nerd Font" ];
    serif = [ "JetBrainsMono Nerd Font" ];
  };
}
