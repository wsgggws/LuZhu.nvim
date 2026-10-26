-- 青山如黛，代码如墨。
-- A quiet place for code, between bamboo and distant mountains.

local M = {}

---@class Landscape
---@field name string
---@field layers integer
local landscape = {
  name = "青山入墨 · QingShan",
  layers = 3,
  opacity = 0.85,
  enabled = true,
}

local function blend_ink(density, distance)
  if distance <= 0 then
    return nil, "distance must be positive"
  end

  -- 近山浓，远山淡。
  local shade = density / (1 + distance)
  return math.max(0.15, shade)
end

function M.paint(scene)
  assert(scene.enabled, "the scroll is still closed")

  for layer = 1, scene.layers do
    local ink, err = blend_ink(scene.opacity, layer)
    if not ink then
      return nil, err
    end
    print(string.format("%s · %d · %.2f", scene.name, layer, ink))
  end

  return true
end

M.paint(landscape)
return M
