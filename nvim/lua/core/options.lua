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
-- 1) 在 tmux 里：把内容交给 tmux（load-buffer -w），tmux 再通过 OSC 52 转发给
--    当前连接的终端（比如 ssh 过来的 MacBook）。需要 tmux 里 `set -s set-clipboard on`。
--    如果是在台式机本地的图形界面里（DISPLAY=:N），同时写入本机的 X 剪贴板。
-- 2) 不在 tmux、但在 SSH 里：直接用 OSC 52。
--    （X11 转发的 xsel/xclip 每次约 0.5s，转发断开时还会卡死 nvim，所以不用）
-- 粘贴：从 tmux buffer / nvim 寄存器取；外部复制的内容请用终端的粘贴键（Cmd+V）。
if vim.env.TMUX and vim.env.TMUX ~= "" then
  local last = { text = nil, regtype = "v" }
  local function copy(lines, regtype)
    local text = table.concat(lines, "\n")
    if regtype == "V" then
      text = text .. "\n"
    end
    last.text, last.regtype = text, regtype
    vim.system({ "tmux", "load-buffer", "-w", "-" }, { stdin = text })
    local display = vim.env.DISPLAY
    if display and display:match("^:") and vim.fn.executable("xsel") == 1 then
      vim.system({ "xsel", "-ib" }, { stdin = text })
    end
  end
  local function paste()
    local res = vim.system({ "tmux", "save-buffer", "-" }, { text = true }):wait(1000)
    local text = (res and res.code == 0) and res.stdout or ""
    local regtype = (text == last.text) and last.regtype or "v"
    if regtype == "V" then
      text = text:gsub("\n$", "")
    end
    return { vim.split(text, "\n", { plain = true }), regtype }
  end
  vim.g.clipboard = {
    name = "tmux (OSC 52)",
    copy = { ["+"] = copy, ["*"] = copy },
    paste = { ["+"] = paste, ["*"] = paste },
    cache_enabled = false,
  }
elseif vim.env.SSH_TTY or vim.env.SSH_CONNECTION then
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
