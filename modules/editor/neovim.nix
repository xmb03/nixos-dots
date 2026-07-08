{ config, pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = false;
    viAlias = false;
    vimAlias = false;
    withNodeJs = false;
    withPython3 = true;

    plugins = with pkgs.vimPlugins; [
      telescope-nvim
      telescope-fzf-native-nvim
      nvim-cmp
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      luasnip
      nvim-treesitter
      nvim-treesitter-textobjects
      nvim-lspconfig
      comment-nvim
      toggleterm-nvim
      mini-align
    ];

    initLua = builtins.readFile ./neovim/init.lua;
  };

  home.packages = with pkgs; [
    pyright
    nil
    lua-language-server
    typescript-language-server
    marksman
    ripgrep
    fd
  ];
}
