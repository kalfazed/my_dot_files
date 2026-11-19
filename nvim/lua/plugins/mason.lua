return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "hrsh7th/cmp-nvim-lsp", -- 你的补全插件依赖
  },
  config = function()
    -- 1. Mason 下载和管理 LSP 二进制
    require("mason").setup()

    -- 2. mason-lspconfig: 确保 clangd / pyright 已安装，并自动 vim.lsp.enable 已安装的 server
    require("mason-lspconfig").setup({
      ensure_installed = { "clangd", "pyright" },
    })

    -- 3. 为所有 LSP 注入 nvim-cmp 的补全能力
    vim.lsp.config("*", {
      capabilities = require("cmp_nvim_lsp").default_capabilities(),
    })

    -- 4. C / C++
    -- 跨文件跳转需要 compile_commands.json：
    --   cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=ON ...   (放在项目根或 build/ 下，clangd 会自动找)
    --   colcon build --cmake-args -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
    --     然后把 build/<pkg>/compile_commands.json 软链/合并到工作区根目录
    vim.lsp.config("clangd", {
      cmd = {
        "clangd",
        "--background-index",
        "--clang-tidy",
        "--header-insertion=iwyu",
        "--completion-style=detailed",
        "--function-arg-placeholders=false",
        "--pch-storage=memory",
        "-j=4",
        -- mason 的 clangd 需要向系统编译器询问 include 路径，否则找不到 <vector> 等标准头文件
        "--query-driver=/usr/bin/*g++*,/usr/bin/*gcc*,/usr/bin/c++,/usr/bin/cc,/usr/bin/clang*,/usr/local/cuda*/bin/nvcc",
      },
      root_markers = {
        "compile_commands.json",
        "compile_flags.txt",
        ".clangd",
        ".clang-tidy",
        ".clang-format",
        "CMakeLists.txt",
        ".git",
      },
      init_options = {
        -- 没有 compile_commands.json 时的默认编译参数
        fallbackFlags = { "-std=c++17" },
      },
    })

    -- 5. Python
    vim.lsp.config("pyright", {
      root_markers = {
        "pyrightconfig.json",
        "pyproject.toml",
        "setup.py",
        "setup.cfg",
        "requirements.txt",
        "Pipfile",
        ".git",
      },
      settings = {
        python = {
          analysis = {
            autoSearchPaths = true,
            useLibraryCodeForTypes = true, -- 没有类型存根的库也能跳到源码
            diagnosticMode = "openFilesOnly", -- 大项目里只分析打开的文件，更快
          },
        },
      },
      -- 使用当前激活的 conda / venv 里的 python，这样第三方库能被解析和跳转
      before_init = function(_, config)
        local venv = vim.env.VIRTUAL_ENV or vim.env.CONDA_PREFIX
        local python = venv and (venv .. "/bin/python") or vim.fn.exepath("python3")
        if python ~= "" and vim.uv.fs_stat(python) then
          config.settings.python.pythonPath = python
        end
      end,
    })

    -- mason-lspconfig 已经会自动 enable，这里显式写一下更直观（重复 enable 无副作用）
    vim.lsp.enable({ "clangd", "pyright" })

    -- 6. 诊断显示
    vim.diagnostic.config({
      severity_sort = true,
      float = { border = "rounded", source = true },
    })
  end,
}
