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
      })
      vim.cmd([[colorscheme tokyonight-night]])
    end,
  },
}
