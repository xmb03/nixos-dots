{ config, pkgs, ... }:

{
  programs.vim = {
    enable = true;

    plugins = with pkgs.vimPlugins; [
      vim-commentary
      vim-floaterm
      fzf-vim
      rust-vim
      vim-lsp
    ];

    settings = {
      number = true;
      relativenumber = true;
      tabstop = 4;
      shiftwidth = 4;
      expandtab = true;
      mouse = "a";
      hidden = true;
    };

    extraConfig = ''
      syntax on
      set clipboard=unnamedplus wildmenu nobackup nowritebackup noswapfile undofile termguicolors smartindent

      " Tab → insert tab at line start, else LSP completion
      inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<C-x>\<C-o>"

      noremap <Up> <Nop>
      noremap <Down> <Nop>
      noremap <Left> <Nop>
      noremap <Right> <Nop>
      inoremap <Up> <Nop>
      inoremap <Down> <Nop>
      inoremap <Left> <Nop>
      inoremap <Right> <Nop>
      vnoremap <Up> <Nop>
      vnoremap <Down> <Nop>
      vnoremap <Left> <Nop>
      vnoremap <Right> <Nop>
      tnoremap <Up> <Nop>
      tnoremap <Down> <Nop>
      tnoremap <Left> <Nop>
      tnoremap <Right> <Nop>

      nnoremap <C-/> :FloatermToggle --cwd=<buffer><CR>
      inoremap <C-/> <Esc>:FloatermToggle --cwd=<buffer><CR>
      vnoremap <C-/> <Esc>:FloatermToggle --cwd=<buffer><CR>
      tnoremap <C-/> <C-\><C-n>:FloatermToggle<CR>

      " vim-lsp: rust-analyzer (standalone .rs files supported via RUST_SRC_PATH)
      au User lsp_setup call lsp#register_server({
          \ 'name': 'rust-analyzer',
          \ 'cmd': {server_info->['${pkgs.rust-analyzer}/bin/rust-analyzer']},
          \ 'allowlist': ['rust'],
          \ 'workspace_config': {
          \   'rust-analyzer': {
          \     'checkOnSave': v:false,
          \     'cargo': { 'loadOutDirsFromCheck': v:true },
          \   },
          \ },
          \ })
      au FileType rust setlocal omnifunc=lsp#complete
    '';
  };
}
