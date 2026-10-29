-- 绿珠：潭水为底，珠玉为光，罗绢与钗饰点染其间。
local M = {}

local colors = {
  bg = "#1D3229", -- 潭绿
  bg_dark = "#182A22", -- 深潭
  bg_float = "#243B2E", -- 碧潭
  bg_highlight = "#293F30", -- 翠影
  bg_visual = "#41634A", -- 翠帷
  bg_search = "#536C43", -- 苔锦
  fg = "#DCE8D5", -- 珠白
  fg_dim = "#AEC0AB", -- 薄绢
  comment = "#A6A5A2", -- 绢灰：近中性的浅灰，微暖以区别青绿语法。
  line_nr = "#6C866E", -- 帘影
  border = "#56785D", -- 玉阶
  keyword = "#89C79B", -- 碧玉
  bamboo = "#A8C38B", -- 柳芽
  jade = "#99CEBE", -- 玉青
  string = "#C6D8A3", -- 碧绫
  gold = "#C5AD78", -- 钗金
  sand = "#D7C5A0", -- 绢黄
  red = "#D29580", -- 红粉
  orange = "#C6A080", -- 琥珀
  yellow = "#D1B77F", -- 金缕
  blue = "#9BBDB5", -- 水碧
  hint = "#A2BC8E", -- 青佩
  diff_add = "#294630", -- 柳影
  diff_change = "#2C423B", -- 潭影
  diff_delete = "#432F2B", -- 胭脂
  diff_text = "#3A5B46", -- 翠纹
  diagnostic_error = "#382F2A", -- 红粉底
  diagnostic_warn = "#38392C", -- 金缕底
  diagnostic_info = "#253D32", -- 水碧底
  diagnostic_hint = "#2C402D", -- 青佩底
  none = "NONE", -- 透明
}

---Return an independent palette; customization never changes module defaults.
---@param overrides? table<string, string>
---@return table<string, string>
function M.get(overrides)
  local result = vim.deepcopy(colors)
  for name, value in pairs(overrides or {}) do
    if colors[name] == nil then
      error("luzhu: unknown palette color: " .. tostring(name))
    end
    if type(value) ~= "string" or not value:match("^#%x%x%x%x%x%x$") then
      error("luzhu: palette." .. name .. " must be a #RRGGBB color")
    end
    if name == "none" then
      error("luzhu: palette.none cannot be overridden")
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
