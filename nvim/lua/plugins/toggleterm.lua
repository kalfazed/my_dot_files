return {
  {
    'akinsho/toggleterm.nvim', 
    version = "*", 
    opts = {
      --[[ things you want to change go here]]
      size = 20,
      open_mapping = [[<c-\>]],
      shade_terminals = true,
      direction = 'float'
    },
    config = function(_, opts)
      require("toggleterm").setup (opts)
    end,
  }
}
