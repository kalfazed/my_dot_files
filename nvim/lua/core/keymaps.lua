vim.g.mapleader = " "

local keymap = vim.keymap

-- ------------------ insert mode -------------- --
keymap.set("i", "jj", "<ESC>")

-- ------------------ normal mode -------------- --
keymap.set("n", "<leader>sv", "<C-w>v") -- Split window vertical
keymap.set("n", "<leader>sh", "<C-w>s") -- Split window horizontal
keymap.set("n", "<leader>q", ":q<CR>")  -- quit window
keymap.set("n", "<leader>w", ":w<CR>")  -- save
keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>") -- Toggle nvim-tree
keymap.set("n", "<leader>E", ":NvimTreeFindFile<CR>", { desc = "Reveal current file in nvim-tree" })
keymap.set("n", "<leader>fp", function()
  vim.fn.setreg("+", vim.fn.expand("%:p"))
  vim.notify("Copied: " .. vim.fn.expand("%:p"))
end, { desc = "Copy current file's absolute path" })

-- Comment.lua --
keymap.set('n', '<leader>/', 
  function()
    require('Comment.api').toggle.linewise.current()
  end, 
  { desc = 'Comment toggle current line' }
)

keymap.set('v', '<leader>/', 
  '<ESC><cmd>lua require("Comment.api").toggle.linewise(vim.fn.visualmode())<CR>', 
  { desc = 'Comment toggle selection' }
)

-- ------------------ bufferline (switch buffer) -------------- --
keymap.set("n", "L", ":BufferLineCycleNext<CR>", { desc = "Next buffer" })
keymap.set("n", "H", ":BufferLineCyclePrev<CR>", { desc = "Prev buffer" })

-- ------------------ Telescope (abstract search) ------------------ --

-- ------------------ Keymap List ------------------ --
keymap.set('n', '<leader>?', ':map<CR>', { desc = 'Show mapped keys' })
keymap.set('n', '<leader>sf', function() require('telescope.builtin').find_files() end, { desc = 'Telescope find files' })
keymap.set('n', '<leader>st', function() require('telescope.builtin').live_grep()  end, { desc = 'Telescope live grep' })
keymap.set('n', '<leader>sr', function() require('telescope.builtin').oldfiles()   end, { desc = 'Telescope recent files' })
keymap.set('n', '<leader>sb', function() require('telescope.builtin').buffers()    end, { desc = 'Telescope buffers' })
keymap.set('n', '<leader>sh', function() require('telescope.builtin').help_tags()  end, { desc = 'Telescope help tags' })

-- lsp
-- 有多个结果时弹出 telescope 选择，只有一个结果时直接跳转；用 <C-o> 跳回
vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'LSP keybindings',
  callback = function(event)
    local function map(lhs, rhs, desc)
      vim.keymap.set('n', lhs, rhs, { buffer = event.buf, desc = desc })
    end
    local tb = function(name)
      return function() require('telescope.builtin')[name]({ reuse_win = true }) end
    end

    map('gd', tb('lsp_definitions'), 'Goto definition')
    map('gD', vim.lsp.buf.declaration, 'Goto declaration')
    map('gr', tb('lsp_references'), 'Goto references')
    map('gi', tb('lsp_implementations'), 'Goto implementation')
    map('gy', tb('lsp_type_definitions'), 'Goto type definition')
    map('K', function() vim.lsp.buf.hover({ border = 'rounded' }) end, 'Hover')
    map('<leader>rn', vim.lsp.buf.rename, 'Rename symbol')
    map('<leader>ca', vim.lsp.buf.code_action, 'Code action')
    map('<leader>ds', tb('lsp_document_symbols'), 'Document symbols')
    map('<leader>ws', tb('lsp_dynamic_workspace_symbols'), 'Workspace symbols')
    map('<leader>d', vim.diagnostic.open_float, 'Line diagnostics')
    map('[d', function() vim.diagnostic.jump({ count = -1, float = true }) end, 'Prev diagnostic')
    map(']d', function() vim.diagnostic.jump({ count = 1, float = true }) end, 'Next diagnostic')

    -- C/C++: 头文件 / 源文件切换
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client and client.name == 'clangd' then
      map('gs', '<cmd>LspClangdSwitchSourceHeader<CR>', 'Switch source/header')
    end
  end,
})
