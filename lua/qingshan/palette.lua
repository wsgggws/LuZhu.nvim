-- 青山入墨: mineral greens, warm paper, and restrained mineral pigments.
local M = {}

local colors = {
  bg = "#202F2B",
  bg_dark = "#1B2824",
  bg_float = "#263832",
  bg_highlight = "#2B3D35",
  bg_visual = "#3B5747",
  bg_search = "#52694A",
  fg = "#D9E2D1",
  fg_dim = "#A8B8AA",
  -- Warm stone separates prose from green syntax without sacrificing contrast.
  comment = "#ABA396",
  line_nr = "#667E6D",
  border = "#536B5A",
  keyword = "#8FB89A",
  bamboo = "#AAC39A",
  jade = "#A5C7B7",
  string = "#C3D6B1",
  gold = "#C5AD78",
  sand = "#CDBF9D",
  red = "#D29580",
  orange = "#C6A080",
  yellow = "#D1B77F",
  blue = "#9BBDB5",
  hint = "#9CB28E",
  diff_add = "#2C4031",
  diff_change = "#303E3B",
  diff_delete = "#432F2B",
  diff_text = "#40574C",
  diagnostic_error = "#382F2A",
  diagnostic_warn = "#38392C",
  diagnostic_info = "#293B36",
  diagnostic_hint = "#303C30",
  none = "NONE",
}

---Return an independent palette; customization never changes module defaults.
---@param overrides? table<string, string>
---@return table<string, string>
function M.get(overrides)
  local result = vim.deepcopy(colors)
  for name, value in pairs(overrides or {}) do
    if colors[name] == nil then
      error("qingshan: unknown palette color: " .. tostring(name))
    end
    if type(value) ~= "string" or not value:match("^#%x%x%x%x%x%x$") then
      error("qingshan: palette." .. name .. " must be a #RRGGBB color")
    end
    if name == "none" then
      error("qingshan: palette.none cannot be overridden")
    end
    result[name] = value
  end
  return result
end

---The shared ANSI order used by Neovim and exported terminal themes.
---@param p? table<string, string>
---@return string[]
function M.terminal(p)
  p = p or M.get()
  return {
    p.bg_dark,
    p.red,
    p.bamboo,
    p.gold,
    p.blue,
    p.sand,
    p.jade,
    p.fg_dim,
    p.line_nr,
    p.red,
    p.string,
    p.yellow,
    p.blue,
    p.sand,
    p.jade,
    p.fg,
  }
end

return M
