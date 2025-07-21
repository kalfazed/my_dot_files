vim.g.mapleader = " "
vim.o.number = true
vim.o.relativenumber = false
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.o.termguicolors = true
vim.o.cursorline = true

-- 文件树快捷键
vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", { noremap = true, silent = true })

-- 在插入模式下，快速按 jj 等价于 Esc
vim.keymap.set("i", "jj", "<Esc>", { noremap = true, silent = true })
