-- 判断文件所属的"项目根目录"，用作 nvim-tree 的根
--   1. 在 nvim 启动目录内      -> 启动目录（保持原样）
--   2. site-packages 里的库     -> site-packages/<包名>（显示整个库）
--   3. 其他                     -> 向上找 .git / pyproject.toml / package.xml 等
--   4. 都找不到                 -> 文件所在目录
local function project_root(path)
  local cwd = vim.fn.getcwd()
  if vim.startswith(path, cwd .. "/") then
    return cwd
  end

  local pkgs, pkg = path:match("^(.*/[%w%-]+%-packages)/([^/]+)/")
  if pkgs then
    return pkgs .. "/" .. pkg
  end

  return vim.fs.root(path, { ".git" })
    or vim.fs.root(path, { "pyproject.toml", "setup.py", "setup.cfg", "package.xml", "compile_commands.json" })
    or vim.fs.dirname(path)
end

local function follow_current_file(buf)
  local api = require("nvim-tree.api")
  if not api.tree.is_visible() then
    return
  end
  if not vim.api.nvim_buf_is_valid(buf) or vim.bo[buf].buftype ~= "" then
    return
  end
  local path = vim.api.nvim_buf_get_name(buf)
  if path == "" or not vim.uv.fs_stat(path) then
    return
  end
  path = vim.fs.normalize(vim.fn.fnamemodify(path, ":p"))

  local root = project_root(path)
  local tree_root = require("nvim-tree.core").get_cwd()
  if root and root ~= tree_root then
    api.tree.change_root(root)
  end
  api.tree.find_file({ buf = buf })
end

return {
  "nvim-tree/nvim-tree.lua",
  version = "*",
  lazy = false,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    require("nvim-tree").setup({
      -- 跟随当前文件的逻辑由下面的自定义 autocmd 处理（会切到"项目根"而不是文件所在目录）
      update_focused_file = { enable = false },
      -- 树的根目录变化时，不要跟着 :cd 改 nvim 的工作目录（否则 Telescope 搜索范围也会变）
      actions = {
        change_dir = { enable = false },
      },
      renderer = {
        -- 树顶部显示根目录路径（相对 ~）
        root_folder_label = ":~:s?$?/..?",
        highlight_opened_files = "name",
      },
    })

    -- 打开树时，定位到当前文件
    local api = require("nvim-tree.api")
    api.events.subscribe(api.events.Event.TreeOpen, function()
      vim.schedule(function()
        local win = vim.fn.win_getid(vim.fn.winnr("#"))
        follow_current_file(vim.api.nvim_win_get_buf(win))
      end)
    end)

    -- 切换 buffer（包括 gd 跳转、<C-o> 跳回）时，自动切换树的根并定位当前文件
    vim.api.nvim_create_autocmd("BufEnter", {
      group = vim.api.nvim_create_augroup("UserNvimTreeFollow", { clear = true }),
      callback = function(ev)
        vim.schedule(function()
          follow_current_file(ev.buf)
        end)
      end,
    })
  end,
}
