local opt = vim.opt

opt.number = true
opt.relativenumber = true
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.mouse = "a"
opt.hidden = true
opt.wildmenu = true
opt.nobackup = true
opt.nowritebackup = true
opt.noswapfile = true
opt.undofile = true
opt.termguicolors = true
opt.smartindent = true

local modes = { "n", "i", "v", "t" }
for _, mode in ipairs(modes) do
  for _, key in ipairs({ "<Up>", "<Down>", "<Left>", "<Right>" }) do
    vim.keymap.set(mode, key, "<Nop>")
  end
end

vim.keymap.set("n", "<C-/>", "<cmd>ToggleTerm<CR>")
vim.keymap.set("i", "<C-/>", "<Esc><cmd>ToggleTerm<CR>")
vim.keymap.set("v", "<C-/>", "<Esc><cmd>ToggleTerm<CR>")
vim.keymap.set("t", "<C-/>", "<cmd>ToggleTerm<CR>")

local builtin = require("telescope.builtin")
vim.keymap.set("n", "<C-p>", builtin.find_files)
vim.keymap.set("n", "<C-f>", builtin.live_grep)
vim.keymap.set("n", "gd", vim.lsp.buf.definition)
vim.keymap.set("n", "K", vim.lsp.buf.hover)
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename)

local cmp = require("cmp")
cmp.setup({
  mapping = cmp.mapping.preset.insert({
    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.abort(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
  }),
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "buffer" },
    { name = "path" },
  }),
  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end,
  },
})

local lspconfig = require("lspconfig")
lspconfig.pyright.setup({})
lspconfig.nil_ls.setup({})
lspconfig.lua_ls.setup({})
lspconfig.ts_ls.setup({})
lspconfig.marksman.setup({})

require("nvim-treesitter.configs").setup({
  ensure_installed = {
    "python", "nix", "lua", "vim", "vimdoc",
    "json", "yaml", "markdown", "markdown_inline", "bash",
  },
  auto_install = false,
  highlight = { enable = true },
})

require("toggleterm").setup({
  size = 20,
  open_mapping = [[<C-/>]],
  direction = "horizontal",
})

require("Comment").setup()

require("mini.align").setup()
