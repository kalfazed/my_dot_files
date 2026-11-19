return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  opts = {
    options = {
      theme = "ayu_dark"
    },
    sections = {
      -- path = 1: 显示相对当前目录的路径；文件在当前目录之外时显示 ~/... 绝对路径
      lualine_c = { { 'filename', path = 1 } },
    },
  },
}
