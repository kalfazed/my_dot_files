-- keymappings [view all the defaults by pressing <leader>Lk]
lvim.leader = "space"
-- add your own keymapping
lvim.keys.insert_mode["jj"]    = "<Esc>"
lvim.keys.normal_mode["<C-s>"] = ":w<cr>"
lvim.keys.normal_mode["<C-b>"] = ":DapToggleBreakpoint<CR>"
lvim.keys.normal_mode["<C-c>"] = ":DapContinue<CR>"
lvim.keys.normal_mode["<C-p>"] = ":SymbolsOutline<CR>"
lvim.keys.normal_mode["<C-i>"] = ":DapStepInto<CR>"
lvim.keys.normal_mode["<C-n>"] = ":DapStepOver<CR>"
lvim.keys.normal_mode["<S-l>"] = ":BufferLineCycleNext<CR>"
lvim.keys.normal_mode["<S-h>"] = ":BufferLineCyclePrev<CR>"
-- unmap a default keymapping
-- vim.keymap.del("n", "<C-Y>")

-- Use which-key to add extra bindings with the leader-key prefix
lvim.builtin.which_key.mappings["c"] = { ":qa<CR>", "Quit all" }
lvim.builtin.which_key.mappings["P"] = { "<cmd>Telescope projects<CR>", "Projects" }
lvim.builtin.which_key.mappings["t"] = {
  name = "+Trouble",
  r = { "<cmd>Trouble lsp_references<cr>", "References" },
  f = { "<cmd>Trouble lsp_definitions<cr>", "Definitions" },
  d = { "<cmd>Trouble document_diagnostics<cr>", "Diagnostics" },
  q = { "<cmd>Trouble quickfix<cr>", "QuickFix" },
  l = { "<cmd>Trouble loclist<cr>", "LocationList" },
  w = { "<cmd>Trouble workspace_diagnostics<cr>", "Workspace Diagnostics" },
}
