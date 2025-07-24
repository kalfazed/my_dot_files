require("basic")
require("plugins")

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*",
  callback = function()
    vim.opt_local.wrap = false
  end,
})


-- To use bufferline
vim.opt.termguicolors = true
require("bufferline").setup{}

-- Be able to use clipboard
vim.opt.clipboard = "unnamedplus"

-- Color scheme
vim.cmd[[colorscheme tokyonight-night]]

-- """SESSION: Shortcut key"""
-- Set <Space> as leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.keymap.set("n", "<S-l>", "<cmd>BufferLineCycleNext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<S-h>", "<cmd>BufferLineCyclePrev<CR>", { desc = "Previous buffer" })

-- Map <leader>q to close current window
vim.keymap.set("n", "<leader>q", "<cmd>:q<CR>", { desc = "Close current window" })
