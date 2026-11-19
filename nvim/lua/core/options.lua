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
-- Over SSH, the X11-forwarded clipboard (xsel/xclip) is slow (~0.5s per call)
-- and can hang nvim completely when the forwarding is broken. Use OSC 52
-- instead: copy goes to the local terminal's clipboard; paste uses nvim's own
-- registers (use your terminal's paste, e.g. Ctrl+Shift+V, for outside text).
if vim.env.SSH_TTY or vim.env.SSH_CONNECTION then
  local function paste()
    return { vim.fn.split(vim.fn.getreg(""), "\n"), vim.fn.getregtype("") }
  end
  vim.g.clipboard = {
    name = "OSC 52",
    copy = {
      ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
      ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
    },
    paste = { ["+"] = paste, ["*"] = paste },
  }
end
-- set clipboard after startup so a slow provider never blocks startup
vim.schedule(function()
  vim.opt.clipboard:append("unnamedplus")
end)

-- faster CursorHold / swap write
opt.updatetime = 250

-- search
opt.ignorecase = true
opt.smartcase = true

-- appearance
opt.termguicolors = true
opt.signcolumn = "yes"
-- 隐藏文件末尾的 ~，并使用粗分割线（透明背景下更清晰）
opt.fillchars = {
  eob = " ",
  vert = "┃",
  horiz = "━",
  horizup = "┻",
  horizdown = "┳",
  vertleft = "┫",
  vertright = "┣",
  verthoriz = "╋",
}

-- undo persistent
opt.undofile = true
