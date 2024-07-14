-- Additional Plugins
lvim.plugins = {
  -- lsp related
  "ray-x/lsp_signature.nvim",

  -- DAP related
  "rcarriga/nvim-dap-ui",
  "mfussenegger/nvim-dap",
  "ldelossa/nvim-dap-projects",
  {
    "folke/trouble.nvim",
    cmd = "TroubleToggle",
  },

  -- markdown related
  {
    "iamcco/markdown-preview.nvim",
    build = "cd app && npm install",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = "markdown",
    init = function()
        vim.g.mkdp_filetypes = { "markdown" }
        local g = vim.g
        g.mkdp_auto_start = 0
        g.mkdp_auto_close = 0
        g.mkdp_refresh_slow = 0
        g.mkdp_command_for_global = 0
        g.mkdp_open_to_the_world = 1
        g.mkdp_open_ip = ''
        g.mkdp_browser = 'firefox'
        g.mkdp_echo_preview_url = 0
        g.mkdp_browserfunc = ''
        g.mkdp_theme = 'dark'
        g.mkdp_filetypes = { "markdown" }
        g.mkdp_page_title = "${name}.md"
        g.mkdp_preview_options = {
            disable_sync_scroll = 0,
            disable_filename = 1
        }
        g.mkdp_comvine_preview = 1
    end,
  },


  -- outline related
  {
    "simrat39/symbols-outline.nvim",
    config = function()
      require('symbols-outline').setup()
    end
  },

  -- bracey: live html, css, and javascript editing in vim
  {
    "turbio/bracey.vim",
    cmd = {"Bracey", "BracyStop", "BraceyReload", "BraceyEval"},
    build = "cd app && npm install --prefix server",
    init = function()
        local g = vim.g
        g.bracey_auto_start_browser = 1
        g.bracey_browser_command = 'firefox'
        g.bracey_server_port = 9090
    end,
    -- config = function()
    --   vim.g.bracey_server_port = 9090
    --   vim.cmd [[
    --     let g:bracey_server_port=9090
    --   ]]
    -- end,
  },

  -- show colors ion nvim
  {
    "norcalli/nvim-colorizer.lua",
      config = function()
        require("colorizer").setup({ "css", "scss", "html", "javascript"}, {
            RGB = true, -- #RGB hex codes
            RRGGBB = true, -- #RRGGBB hex codes
            RRGGBBAA = true, -- #RRGGBBAA hex codes
            rgb_fn = true, -- CSS rgb() and rgba() functions
            hsl_fn = true, -- CSS hsl() and hsla() functions
            css = true, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
            css_fn = true, -- Enable all CSS *functions*: rgb_fn, hsl_fn
            })
    end,
  },
  {"mfussenegger/nvim-dap-python"},
  {
    'nvim-telescope/telescope-media-files.nvim',
    config = function()
      require('telescope').load_extension('media_files')
      require('telescope').setup({
        extension = {
          media_files = {
            filetypes = {"png", "webp", "jpg", "jpeg"},
            find_cmd = "rg"
          }
        }
      })
    end
  },
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
  },
  {
    "zbirenbaum/copilot-cmp",
    after = { "copilot.lua" },
    config = function()
      require("copilot_cmp").setup()
    end,
  },
}
