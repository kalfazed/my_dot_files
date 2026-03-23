return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "hrsh7th/cmp-nvim-lsp", -- 你的补全插件依赖
  },
  config = function()
    -- 1. 依然使用 Mason 下载和管理二进制文件
    require("mason").setup()
    
    -- 2. 依然用 mason-lspconfig 确保 clangd 被下载，
    -- 【关键点】：千万不要在这里写 `handlers = { ... }`，否则会触发老 API 导致报错！
    require("mason-lspconfig").setup({
      ensure_installed = { "clangd" },
    })

    -- 3. (可选) 全局配置：为所有原生 LSP 注入 nvim-cmp 的补全能力
    local capabilities = require("cmp_nvim_lsp").default_capabilities()
    -- 在 0.11 中，用 '*' 代表为所有 LSP 注入通用配置
    vim.lsp.config('*', {
      capabilities = capabilities,
    })

    -- 4. 专门配置 clangd (使用 0.11 的新 API：vim.lsp.config)
    vim.lsp.config("clangd", {
      cmd = {
        "clangd",
        "--background-index",
        "--clang-tidy",
        "--header-insertion=iwyu",
        "--completion-style=detailed",
      },
      -- 如果你需要针对 C++ 做其他特殊设置，都加在这个 table 里
    })

    -- 5. 启用 clangd (使用 0.11 的新 API：vim.lsp.enable)
    vim.lsp.enable("clangd")
  end,
}
