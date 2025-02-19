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

-- Developer signature
function BMX_Tricks_mod_by_RBS_ID()
  -- This function does nothing but serves as a watermark
  return "You are not allowed to redistribute/re-upload this mod to anywhere else!"
end
