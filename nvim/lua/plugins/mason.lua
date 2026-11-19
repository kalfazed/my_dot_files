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

    -- pyright 是 Node.js 程序（Mason 安装它也需要 npm）。没有 node 时跳过它，
    -- 避免反复出现 "pyright quit with exit code 127" 之类的报错；clangd 不依赖 node。
    local has_node = vim.fn.executable("node") == 1
    local servers = { "clangd" }
    if has_node then
      table.insert(servers, "pyright")
    else
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "python",
        once = true,
        callback = function()
          vim.notify("Node.js not found: pyright (Python LSP) is disabled", vim.log.levels.WARN)
        end,
      })
    end

    -- 2. mason-lspconfig: 确保需要的 server 已安装
    --    automatic_enable 关掉，由下面的 vim.lsp.enable(servers) 统一控制启用哪些
    require("mason-lspconfig").setup({
      ensure_installed = servers,
      automatic_enable = false,
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
            -- 默认 standard 模式对研究/数据处理代码太严格，满屏红色 E
            -- basic: 只保留比较有价值的检查
            typeCheckingMode = "basic",
            -- 类型相关的问题降为警告（黄色 W），真正的错误（语法错误、未定义变量等）仍是红色 E
            diagnosticSeverityOverrides = {
              reportMissingImports = "warning", -- 当前 python 环境里没装这个库
              reportMissingModuleSource = "none", -- 有类型存根但没装源码，不影响使用
              reportOptionalSubscript = "warning",
              reportOptionalMemberAccess = "warning",
              reportOptionalIterable = "warning",
              reportOptionalCall = "warning",
              reportOptionalOperand = "warning",
              reportArgumentType = "warning",
              reportAttributeAccessIssue = "warning",
              reportCallIssue = "warning",
              reportIndexIssue = "warning",
              reportPossiblyUnbound = "warning",
              reportAssignmentType = "warning",
              reportReturnType = "warning",
            },
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

    vim.lsp.enable(servers)

    -- 6. 诊断显示
    vim.diagnostic.config({
      severity_sort = true,
      float = { border = "rounded", source = true },
      -- 只在光标所在行显示错误信息，其余行只显示左侧图标
      virtual_text = { current_line = true, spacing = 2, prefix = "●" },
      underline = true,
      signs = {
        -- hint（如未使用的变量）不在左侧显示图标，只做灰色淡化
        severity = { min = vim.diagnostic.severity.INFO },
        text = {
          [vim.diagnostic.severity.ERROR] = "󰅙",
          [vim.diagnostic.severity.WARN] = "󰀦",
          [vim.diagnostic.severity.INFO] = "󰋼",
          [vim.diagnostic.severity.HINT] = "󰌵",
        },
      },
    })
  end,
}
