---@class Constant
local Constant = {}

-- -------------------------------------------------------------------------- --
-- Save to Global Variable                                                    --
-- -------------------------------------------------------------------------- --

---@class Constant
BMX_TRICKS.Constant = Constant

-- -------------------------------------------------------------------------- --
-- Populate                                                                   --
-- -------------------------------------------------------------------------- --

for _, filename in ipairs({ "anim", "nodetime" }) do
  if BMX_TRICKS.IS_BULLY_AE then
    local dir = BMX_TRICKS.AE_MODDIR .. "constants/"
    BMX_TRICKS.Util.AELoadScript(dir, filename .. ".lur")
  else
    LoadScript("constants/" .. filename .. ".lua")
  end
end
