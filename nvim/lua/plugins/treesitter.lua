local setup = function()
    require'nvim-treesitter'.setup {
      -- Directory to install parsers and queries to (prepended to `runtimepath` to have priority)
      install_dir = vim.fn.stdpath('data') .. '/site'
    }
    require('nvim-treesitter').install({
      "python", 
      "cpp", 
      "c", 
      "lua", 
      "vim", 
      "vimdoc", 
      "query", 
      "markdown", 
      "markdown_inline",
      "fish",
      "bash",
    })
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "lua", "python", "bash", "fish" , "cpp", "markdown" },
      callback = function()
        vim.treesitter.start()
      end,
    })
end

return {
    "nvim-treesitter/nvim-treesitter",
    branch = 'main',
    lazy = false,
    build = ":TSUpdate",
    config = setup
}
