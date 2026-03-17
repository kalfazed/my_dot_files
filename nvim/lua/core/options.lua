local opt = vim.opt

opt.number = true

-- intend
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.autoindent = true

-- avoid wrap
opt.wrap = false

-- cursor highlight
opt.cursorline = true

-- activate cursor
opt.mouse:append("a")

-- system clipboard
opt.clipboard:append("unnamedplus")

-- search
opt.ignorecase = true
opt.smartcase = true

-- appearance
opt.termguicolors = true
opt.signcolumn = "yes"

-- undo persistent
opt.undofile = true
