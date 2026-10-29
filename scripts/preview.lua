-- Standalone, plugin-free preview: nvim -u scripts/preview.lua
local root = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":p:h:h")
vim.opt.runtimepath:prepend(root)
vim.opt.loadplugins = false
vim.opt.shadafile = "NONE"
vim.opt.swapfile = false
vim.opt.undofile = false
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.number = true
vim.opt.signcolumn = "yes:1"
vim.opt.cursorline = true
vim.opt.laststatus = 3
vim.opt.showmode = false
vim.opt.showcmd = false
vim.opt.ruler = false
vim.opt.wrap = false
vim.opt.splitright = true
vim.opt.scrolloff = 3
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.fillchars = { eob = " ", vert = "│" }
vim.opt.shortmess:append("I")
vim.opt.statusline = "  %t %m%r %= LuZhu   %{&filetype}   %l:%c  "
-- Keep the preview independent of ftplugins that may auto-start a parser.
vim.cmd("filetype plugin off")
vim.cmd("filetype indent on")
vim.cmd("syntax on")
vim.cmd.colorscheme("luzhu")

vim.api.nvim_create_autocmd("VimEnter", {
  once = true,
  nested = true, -- Allow BufRead/FileType/Syntax when the preview opens its file.
  callback = function()
    if vim.fn.argc() == 0 then
      vim.cmd.edit(vim.fn.fnameescape(root .. "/examples/showcase.lua"))
    end
    -- The bundled Lua parser is optional; Vim syntax remains a complete fallback.
    if not pcall(vim.treesitter.start, 0, "lua") then
      vim.bo.syntax = "lua"
    end
    local source = vim.api.nvim_get_current_buf()
    local ns = vim.api.nvim_create_namespace("luzhu-preview")
    vim.diagnostic.config({
      virtual_text = { prefix = "●", spacing = 3 },
      underline = true,
      signs = { text = { [1] = "E", [2] = "W", [3] = "I", [4] = "H" } },
      update_in_insert = false,
    })
    -- These diagnostics are explicit fixtures, not results from a language server.
    vim.diagnostic.set(ns, source, {
      { lnum = 11, col = 2, end_col = 8, severity = 2, message = "demo: pearl lustre", source = "preview" },
      { lnum = 17, col = 16, end_col = 41, severity = 1, message = "demo: error text", source = "preview" },
      { lnum = 26, col = 2, end_col = 8, severity = 3, message = "demo: contract", source = "preview" },
    })
    vim.fn.sign_define("LuZhuPreviewAdd", { text = "+", texthl = "GitSignsAdd" })
    vim.fn.sign_define("LuZhuPreviewChange", { text = "~", texthl = "GitSignsChange" })
    vim.fn.sign_place(0, "luzhu-preview", "LuZhuPreviewAdd", source, { lnum = 22 })
    vim.fn.sign_place(0, "luzhu-preview", "LuZhuPreviewChange", source, { lnum = 30 })
    vim.api.nvim_win_set_cursor(0, { 16, 15 })

    local p = require("luzhu.palette").get()
    local lines = {
      "",
      "  绿珠",
      "  LuZhu",
      "",
      "  绿意凝珠，温润如玉。",
      "",
      "  PALETTE",
      "",
      "  潭绿   " .. p.bg,
      "  碧玉   " .. p.keyword,
      "  玉青   " .. p.jade,
      "  珠白   " .. p.fg,
      "  钗金   " .. p.gold,
      "  绢灰   " .. p.comment,
      "",
      "  EDITOR",
      "",
      "  keyword   local / return",
      "  function  pearl_glow()",
      "  string    green pearl",
      "  number    0.85 / 3",
      "  comment   quiet notes",
      "",
      "  DIAGNOSTICS",
      "",
      "  E  error:   红粉",
      "  W  warning: 金缕",
      "  I  info:    水碧",
      "  H  hint:    青佩",
      "",
      "  SURFACES",
      "",
      "  selected text",
      "  search match",
      "  current match",
      "",
      "  variable   pearl",
      "  parameter  lustre",
      "  No plugins required.",
    }
    vim.cmd("botright 36vnew")
    local panel = vim.api.nvim_get_current_buf()
    vim.bo[panel].buftype = "nofile"
    vim.bo[panel].bufhidden = "wipe"
    vim.bo[panel].swapfile = false
    vim.api.nvim_buf_set_name(panel, "LuZhu / palette")
    vim.api.nvim_buf_set_lines(panel, 0, -1, false, lines)
    vim.bo[panel].modifiable = false
    vim.wo.number = false
    vim.wo.signcolumn = "no"
    vim.wo.cursorline = false
    vim.wo.winfixwidth = true
    local labels = {
      [1] = "Title",
      [2] = "Comment",
      [4] = "Comment",
      [6] = "Title",
      [8] = "Comment",
      [9] = "Keyword",
      [10] = "Function",
      [11] = "Normal",
      [12] = "Number",
      [13] = "Comment",
      [15] = "Title",
      [17] = "Keyword",
      [18] = "Function",
      [19] = "String",
      [20] = "Number",
      [21] = "Comment",
      [23] = "Title",
      [25] = "DiagnosticError",
      [26] = "DiagnosticWarn",
      [27] = "DiagnosticInfo",
      [28] = "DiagnosticHint",
      [30] = "Title",
      [32] = "Visual",
      [33] = "Search",
      [34] = "CurSearch",
      [36] = "Identifier",
      [37] = "LuZhuParameter",
      [38] = "Comment",
    }
    for line, group in pairs(labels) do
      vim.api.nvim_buf_set_extmark(panel, ns, line, 2, { end_col = #lines[line + 1], hl_group = group })
    end
    vim.cmd("wincmd p")
  end,
})
