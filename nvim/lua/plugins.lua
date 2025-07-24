-- 自动安装 lazy.nvim（第一次会自动 clone）
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- 插件列表
require("lazy").setup({
    -- 文件树
    { "nvim-tree/nvim-tree.lua", dependencies = { "nvim-tree/nvim-web-devicons" }, config = true },

    -- 状态栏
    { "nvim-lualine/lualine.nvim", dependencies = { "nvim-tree/nvim-web-devicons" }, config = true },

    -- 注释快捷键
    { "numToStr/Comment.nvim", config = true },

    -- 自动括号补全
    { "windwp/nvim-autopairs", config = true },

    -- 缩进线
    { "lukas-reineke/indent-blankline.nvim", main = "ibl", opts = {} },

    -- 启动界面
    {
      "goolord/alpha-nvim",
      config = function()
        require'alpha'.setup(require'alpha.themes.startify'.config)
      end,
    },
    {
        'akinsho/toggleterm.nvim', 
        version = "*", 
        opts = {
          open_mapping = [[<c-\>]], -- or { [[<c-\>]], [[<c-¥>]] } if you also use a Japanese keyboard.
          direction = 'float',
        },
    },
    -- tokyonight color scheme
    {
      "folke/tokyonight.nvim",
      lazy = false,
      priority = 1000,
      opts = {},
    },
    -- show tab buffer
    {'akinsho/bufferline.nvim', version = "*", dependencies = 'nvim-tree/nvim-web-devicons'}
})

