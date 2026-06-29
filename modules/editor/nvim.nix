{ config, pkgs, lib, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    withPython3 = true;

    extraPackages = with pkgs; [
      lua-language-server
      stylua
      typescript-language-server
    ];

    extraLuaConfig = ''
      -- bootstrap lazy.nvim, LazyVim and your plugins
      require("config.lazy")
    '';
  };

  xdg.configFile = {
    "nvim/lua/config/lazy.lua".text = ''
      local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
      if not (vim.uv or vim.loop).fs_stat(lazypath) then
        local lazyrepo = "https://github.com/folke/lazy.nvim.git"
        local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
        if vim.v.shell_error ~= 0 then
          vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out,                            "WarningMsg" },
            { "\nPress any key to exit..." },
          }, true, {})
          vim.fn.getchar()
          os.exit(1)
        end
      end
      vim.opt.rtp:prepend(lazypath)

      require("lazy").setup({
        spec = {
          { "LazyVim/LazyVim", import = "lazyvim.plugins" },
          { import = "plugins" },
        },
        defaults = {
          lazy = false,
          version = false,
        },
        install = { colorscheme = { "catppuccin" } },
        checker = {
          enabled = true,
          notify = false,
        },
        performance = {
          rtp = {
            disabled_plugins = {
              "gzip",
              "tarPlugin",
              "tohtml",
              "tutor",
              "zipPlugin",
            },
          },
        },
      })
    '';

    "nvim/lua/config/options.lua".text = ''
      -- Options are automatically loaded before lazy.nvim startup
      -- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
      -- Add any additional options here
    '';

    "nvim/lua/config/keymaps.lua".text = ''
      -- Keymaps are automatically loaded on the VeryLazy event
      -- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
      -- Add any additional keymaps here
      local modes = { "n", "i", "v", "x" }
      local arrows = { "<Up>", "<Down>", "<Left>", "<Right>" }

      for _, mode in ipairs(modes) do
        for _, arrow in ipairs(arrows) do
          vim.keymap.set(mode, arrow, "<Nop>", { noremap = true, silent = true })
        end
      end
    '';

    "nvim/lua/config/autocmds.lua".text = ''
      -- Autocmds are automatically loaded on the VeryLazy event
      -- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
      --
      -- Add any additional autocmds here
      -- with `vim.api.nvim_create_autocmd`
      --
      -- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
      -- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")
    '';

    "nvim/lua/plugins/colorscheme.lua".text = ''
      return {
        { "catppuccin", lazy = false, priority = 1000 },

        {
          "LazyVim/LazyVim",
          opts = {
            colorscheme = "catppuccin",
          },
        },
      }
    '';
  };
}
