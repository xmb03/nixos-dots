local modes = { "n", "i", "v", "x" }
local arrows = { "<Up>", "<Down>", "<Left>", "<Right>" }

for _, mode in ipairs(modes) do
  for _, arrow in ipairs(arrows) do
    vim.keymap.set(mode, arrow, "<Nop>", { noremap = true, silent = true })
  end
end
