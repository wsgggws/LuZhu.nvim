-- 绿意凝珠，温润如玉。
-- Quiet code, like a pearl resting in jade.

local M = {}

---@class Pearl
---@field name string
---@field layers integer
local pearl = {
  name = "绿珠 · LuZhu",
  layers = 3,
  lustre = 0.85,
  enabled = true,
}

local function pearl_glow(lustre, layer)
  if layer <= 0 then
    return nil, "layer must be positive"
  end

  -- 珠光渐敛，玉色自温。
  local glow = lustre / (1 + layer)
  return math.max(0.15, glow)
end

function M.polish(gem)
  assert(gem.enabled, "the jewel box is closed")

  for layer = 1, gem.layers do
    local glow, err = pearl_glow(gem.lustre, layer)
    if not glow then
      return nil, err
    end
    print(string.format("%s · %d · %.2f", gem.name, layer, glow))
  end

  return true
end

M.polish(pearl)
return M
