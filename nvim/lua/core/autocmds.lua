local augroup = vim.api.nvim_create_augroup("UserAutocmds", { clear = true })

-- ------------------ Big file protection -------------- --
-- Files larger than this (or with very long lines, e.g. minified JSON) get the
-- "bigfile" filetype: no syntax, no treesitter, no LSP / Copilot.
local BIGFILE_SIZE = 1.5 * 1024 * 1024 -- 1.5 MB
local BIGFILE_LINE_LEN = 1000 -- average chars per line

vim.filetype.add({
  pattern = {
    [".*"] = {
      function(path, buf)
        if not path or not buf or vim.bo[buf].filetype == "bigfile" then
          return
        end
        if path ~= vim.fs.normalize(vim.api.nvim_buf_get_name(buf)) then
          return
        end
        local size = vim.fn.getfsize(path)
        if size <= 0 then
          return
        end
        if size > BIGFILE_SIZE then
          return "bigfile"
        end
        local lines = vim.api.nvim_buf_line_count(buf)
        if (size - lines) / lines > BIGFILE_LINE_LEN then
          return "bigfile"
        end
      end,
      { priority = math.huge },
    },
  },
})

vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  pattern = "bigfile",
  callback = function(ev)
    vim.b[ev.buf].copilot_enabled = false
    vim.opt_local.foldmethod = "manual"
    vim.opt_local.spell = false
    vim.opt_local.undofile = false
    vim.opt_local.swapfile = false
    vim.opt_local.cursorline = false
    vim.opt_local.list = false
    vim.notify("Big file detected: syntax / treesitter / LSP disabled", vim.log.levels.WARN)
  end,
})

-- Never let any LSP (including Copilot) attach to a big file.
vim.api.nvim_create_autocmd("LspAttach", {
  group = augroup,
  callback = function(ev)
    if vim.bo[ev.buf].filetype == "bigfile" then
      vim.schedule(function()
        pcall(vim.lsp.buf_detach_client, ev.buf, ev.data.client_id)
      end)
    end
  end,
})

-- ------------------ Restore last cursor position -------------- --
vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup,
  callback = function(ev)
    local ft = vim.bo[ev.buf].filetype
    if ft == "gitcommit" or ft == "gitrebase" or vim.b[ev.buf].last_loc_done then
      return
    end
    vim.b[ev.buf].last_loc_done = true
    local mark = vim.api.nvim_buf_get_mark(ev.buf, '"')
    local lcount = vim.api.nvim_buf_line_count(ev.buf)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
      vim.cmd("normal! zz")
    end
  end,
})

-- ------------------ Highlight on yank -------------- --
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup,
  callback = function()
    vim.hl.on_yank({ timeout = 150 })
  end,
})

-- Reload file if it was changed outside of nvim
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = augroup,
  callback = function()
    if vim.o.buftype ~= "nofile" then
      vim.cmd("checktime")
    end
  end,
})
