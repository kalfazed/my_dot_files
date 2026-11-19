local parsers = {
  "python",
  "cpp",
  "c",
  "cuda",
  "cmake",
  "lua",
  "vim",
  "vimdoc",
  "query",
  "markdown",
  "markdown_inline",
  "fish",
  "bash",
  "json",
  "yaml",
  "xml",
}

local setup = function()
  local ts = require("nvim-treesitter")
  ts.setup({
    -- Directory to install parsers and queries to (prepended to `runtimepath` to have priority)
    install_dir = vim.fn.stdpath("data") .. "/site",
  })

  -- only install what is missing (avoids spawning install jobs on every startup)
  local installed = ts.get_installed()
  local missing = vim.tbl_filter(function(p)
    return not vim.list_contains(installed, p)
  end, parsers)
  if #missing > 0 then
    ts.install(missing)
  end

  vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("UserTreesitter", { clear = true }),
    callback = function(ev)
      if vim.bo[ev.buf].filetype == "bigfile" then
        return
      end
      -- start highlighting only if a parser exists for this filetype
      pcall(vim.treesitter.start, ev.buf)
    end,
  })
end

return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,
  build = ":TSUpdate",
  config = setup,
}
