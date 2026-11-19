return {
  "github/copilot.vim",
  -- Copilot 的语言服务器是 Node.js 程序；没有 node 时不加载，避免启动报错
  cond = function()
    return vim.fn.executable("node") == 1
  end,
}
