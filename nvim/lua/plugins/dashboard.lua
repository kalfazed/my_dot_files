-- Dashboard: KALVIM  (KALfazed + nVIM)
-- ANSI Shadow font, 6 rows per letter
local letters = {
  K = { "██╗  ██╗", "██║ ██╔╝", "█████╔╝ ", "██╔═██╗ ", "██║  ██╗", "╚═╝  ╚═╝" },
  A = { " █████╗ ", "██╔══██╗", "███████║", "██╔══██║", "██║  ██║", "╚═╝  ╚═╝" },
  L = { "██╗     ", "██║     ", "██║     ", "██║     ", "███████╗", "╚══════╝" },
  V = { "██╗   ██╗", "██║   ██║", "██║   ██║", "╚██╗ ██╔╝", " ╚████╔╝ ", "  ╚═══╝  " },
  I = { "██╗", "██║", "██║", "██║", "██║", "╚═╝" },
  M = { "███╗   ███╗", "████╗ ████║", "██╔████╔██║", "██║╚██╔╝██║", "██║ ╚═╝ ██║", "╚═╝     ╚═╝" },
}
local word = { "K", "A", "L", "V", "I", "M" }

-- one color per letter: blue -> cyan -> purple -> pink -> red (tokyonight palette)
local gradient = { "#7aa2f7", "#7dcfff", "#9d7cd8", "#bb9af7", "#ff007c", "#f7768e" }

local function set_highlights()
  for i, color in ipairs(gradient) do
    vim.api.nvim_set_hl(0, "DashLogo" .. i, { fg = color, bold = true })
  end
  vim.api.nvim_set_hl(0, "DashTitle", { fg = "#e0af68", bold = true })
  vim.api.nvim_set_hl(0, "DashSubtitle", { fg = "#565f89", italic = true })
  vim.api.nvim_set_hl(0, "DashButton", { fg = "#c0caf5" })
  vim.api.nvim_set_hl(0, "DashShortcut", { fg = "#ff9e64", bold = true })
  vim.api.nvim_set_hl(0, "DashFooter", { fg = "#9ece6a", italic = true })
end

-- build logo lines and per-letter byte ranges for the gradient
local function build_logo()
  local lines, hls = {}, {}
  for row = 1, 6 do
    local line, line_hl = "", {}
    for idx, ch in ipairs(word) do
      local piece = letters[ch][row]
      local start = #line
      line = line .. piece
      table.insert(line_hl, { "DashLogo" .. idx, start, #line })
    end
    lines[row] = line
    hls[row] = line_hl
  end
  return lines, hls
end

return {
  "goolord/alpha-nvim",
  event = "VimEnter",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local alpha = require("alpha")
    local dashboard = require("alpha.themes.dashboard")

    set_highlights()
    vim.api.nvim_create_autocmd("ColorScheme", { callback = set_highlights })

    local logo_lines, logo_hls = build_logo()
    local logo = {
      type = "text",
      val = logo_lines,
      opts = { position = "center", hl = logo_hls },
    }

    local title = {
      type = "text",
      val = "⚡  T H E   U L T I M A T E   E D I T O R  ⚡",
      opts = { position = "center", hl = "DashTitle" },
    }
    local subtitle = {
      type = "text",
      val = "— code at the speed of thought —",
      opts = { position = "center", hl = "DashSubtitle" },
    }

    local function button(key, icon, desc, cmd)
      local b = dashboard.button(key, icon .. "  " .. desc, cmd)
      b.opts.hl = "DashButton"
      b.opts.hl_shortcut = "DashShortcut"
      b.opts.width = 44
      return b
    end

    local buttons = {
      type = "group",
      val = {
        button("f", "󰈞", "Find file", "<cmd>Telescope find_files<CR>"),
        button("r", "󰄉", "Recent files", "<cmd>Telescope oldfiles<CR>"),
        button("g", "󰊄", "Live grep", "<cmd>Telescope live_grep<CR>"),
        button("e", "󰙅", "File tree", "<cmd>NvimTreeOpen<CR>"),
        button("n", "󰝒", "New file", "<cmd>ene <BAR> startinsert<CR>"),
        button("c", "󰒓", "Config", "<cmd>cd ~/.config/nvim <BAR> Telescope find_files<CR>"),
        button("l", "󰒲", "Plugins", "<cmd>Lazy<CR>"),
        button("q", "󰗼", "Quit", "<cmd>qa<CR>"),
      },
      opts = { spacing = 1 },
    }

    local footer = {
      type = "text",
      val = "",
      opts = { position = "center", hl = "DashFooter" },
    }

    -- top padding so the content is vertically centered (~30 lines of content)
    local top_pad = {
      type = "padding",
      val = function()
        return math.max(1, math.floor((vim.fn.winheight(0) - 30) / 2))
      end,
    }

    alpha.setup({
      layout = {
        top_pad,
        logo,
        { type = "padding", val = 1 },
        title,
        subtitle,
        { type = "padding", val = 2 },
        buttons,
        { type = "padding", val = 1 },
        footer,
      },
      opts = { margin = 5 },
    })

    -- footer: plugin count and startup time
    vim.api.nvim_create_autocmd("User", {
      pattern = "LazyVimStarted",
      once = true,
      callback = function()
        local stats = require("lazy").stats()
        local ms = math.floor(stats.startuptime * 100 + 0.5) / 100
        footer.val = string.format(
          "󱐋 %d/%d plugins loaded in %.2f ms  ·  %s",
          stats.loaded,
          stats.count,
          ms,
          os.date("%Y-%m-%d %H:%M")
        )
        pcall(vim.cmd.AlphaRedraw)
      end,
    })

    -- hide statusline / ruler / eob "~" on the dashboard, restore on leave
    vim.api.nvim_create_autocmd("User", {
      pattern = "AlphaReady",
      callback = function()
        local saved = { laststatus = vim.o.laststatus, ruler = vim.o.ruler }
        vim.o.laststatus = 0
        vim.o.ruler = false
        vim.opt_local.fillchars = { eob = " " }
        vim.api.nvim_create_autocmd("BufUnload", {
          buffer = 0,
          once = true,
          callback = function()
            vim.o.laststatus = saved.laststatus
            vim.o.ruler = saved.ruler
          end,
        })
      end,
    })
  end,
}
