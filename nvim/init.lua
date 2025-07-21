require("basic")
require("plugins")

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*",
  callback = function()
    vim.opt_local.wrap = false
  end,
})

vim.opt.clipboard = "unnamedplus"

