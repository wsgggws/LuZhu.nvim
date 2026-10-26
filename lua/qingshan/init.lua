local M = {}

local defaults = {
  transparent = false,
  dim_inactive = false,
  terminal_colors = true,
  styles = {
    comments = { italic = true },
    keywords = { bold = true },
    functions = {},
    variables = {},
  },
  palette = {},
  highlights = {},
}

local options = vim.deepcopy(defaults)

local function validate(opts)
  for name in pairs(opts) do
    if defaults[name] == nil then
      error("qingshan: unknown option: " .. tostring(name))
    end
  end
  for _, name in ipairs({ "transparent", "dim_inactive", "terminal_colors" }) do
    if opts[name] ~= nil and type(opts[name]) ~= "boolean" then
      error("qingshan: " .. name .. " must be a boolean")
    end
  end
  for _, name in ipairs({ "styles", "palette" }) do
    if opts[name] ~= nil and type(opts[name]) ~= "table" then
      error("qingshan: " .. name .. " must be a table")
    end
  end
  if opts.highlights ~= nil and type(opts.highlights) ~= "table" and type(opts.highlights) ~= "function" then
    error("qingshan: highlights must be a table or function")
  end
  for name, style in pairs(opts.styles or {}) do
    if defaults.styles[name] == nil or type(style) ~= "table" then
      error("qingshan: styles must contain comments/keywords/functions/variables tables")
    end
    for attr, value in pairs(style) do
      if not vim.tbl_contains({ "bold", "italic", "underline", "undercurl", "strikethrough" }, attr) then
        error("qingshan: unsupported style: " .. tostring(attr))
      end
      if type(value) ~= "boolean" then
        error("qingshan: style attributes must be booleans")
      end
    end
  end
  require("qingshan.palette").get(opts.palette)
end

---Configure the next colorscheme load. Each call starts from the defaults.
---@param opts? table
function M.setup(opts)
  if opts == nil then
    opts = {}
  end
  if type(opts) ~= "table" then
    error("qingshan: setup expects a table")
  end
  validate(opts)
  local next_options = vim.tbl_deep_extend("force", vim.deepcopy(defaults), opts)
  -- Replace whole groups, including links, rather than merging highlight keys.
  next_options.highlights = opts.highlights or {}
  options = vim.deepcopy(next_options)
end

function M.load()
  local opts = vim.deepcopy(options)
  local palette = require("qingshan.palette").get(opts.palette)
  local groups = require("qingshan.theme").get(palette, opts)

  -- Build overrides before clearing the current theme, so callback errors are safe.
  local overrides = opts.highlights
  if type(overrides) == "function" then
    overrides = overrides(vim.deepcopy(palette), vim.deepcopy(opts))
  end
  if type(overrides) ~= "table" then
    error("qingshan: highlights callback must return a table")
  end
  for name, definition in pairs(overrides) do
    if type(name) ~= "string" or type(definition) ~= "table" then
      error("qingshan: highlights must map group names to tables")
    end
    groups[name] = vim.deepcopy(definition)
  end

  vim.o.termguicolors = true
  if vim.o.background ~= "dark" then
    vim.o.background = "dark"
  end
  vim.cmd("highlight clear")
  if vim.fn.exists("syntax_on") == 1 then
    vim.cmd("syntax reset")
  end
  vim.g.colors_name = "qingshan"

  -- Normal groups first: `default` links can then resolve against their targets.
  for name, definition in pairs(groups) do
    if not definition.link then
      vim.api.nvim_set_hl(0, name, definition)
    end
  end
  for name, definition in pairs(groups) do
    if definition.link then
      vim.api.nvim_set_hl(0, name, definition)
    end
  end

  if opts.terminal_colors then
    local terminal = require("qingshan.palette").terminal(palette)
    for index, color in ipairs(terminal) do
      vim.g["terminal_color_" .. (index - 1)] = color
    end
  end
end

return M
