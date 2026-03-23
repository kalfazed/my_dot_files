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
