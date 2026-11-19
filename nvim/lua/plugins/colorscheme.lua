return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("tokyonight").setup({
        style = "night",
        -- 不设置背景色，直接使用终端的背景（透明 / 终端配色）
        transparent = true,
        styles = {
          sidebars = "transparent", -- nvim-tree、help 等侧边栏也透明
          floats = "transparent", -- 浮动窗口（hover、telescope 等）也透明
        },
        -- 透明模式下 tokyonight 的分割线颜色接近原背景色，在终端背景上几乎看不见，这里调亮
        on_highlights = function(hl, c)
          local sep = c.blue0 -- #3d59a1，明显但不刺眼
          hl.WinSeparator = { fg = sep, bold = true }
          hl.NvimTreeWinSeparator = { fg = sep, bold = true }
          -- 文件树：根目录、缩进线、当前行更醒目
          hl.NvimTreeRootFolder = { fg = c.orange, bold = true }
          hl.NvimTreeIndentMarker = { fg = c.dark3 }
          hl.NvimTreeCursorLine = { bg = c.bg_highlight }
          hl.NvimTreeOpenedFile = { fg = c.green, bold = true }
          -- 当前窗口行号高亮，方便看出焦点在哪个窗口
          hl.CursorLineNr = { fg = c.orange, bold = true }
        end,
      })
      vim.cmd([[colorscheme tokyonight-night]])
    end,
  },
}
