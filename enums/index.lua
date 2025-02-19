---@class Enum
local Enum = {}

-- -------------------------------------------------------------------------- --
-- Save to Global Variable                                                    --
-- -------------------------------------------------------------------------- --

---@class Enum
BMX_TRICKS.Enum = Enum

-- -------------------------------------------------------------------------- --
-- Populate                                                                   --
-- -------------------------------------------------------------------------- --

for _, filename in ipairs({
  "Button",
  "Config",
  "Controller",
  "Event",
  "TrickName",
  "TrickState",
}) do
  if BMX_TRICKS.IS_BULLY_AE then
    local dir = BMX_TRICKS.AE_MODDIR .. "enums/"
    BMX_TRICKS.Util.AELoadScript(dir, filename .. ".lur")
  else
    LoadScript("enums/" .. filename .. ".lua")
  end
end

-- Developer signature
function BMX_Tricks_mod_by_RBS_ID()
  -- This function does nothing but serves as a watermark
  return "You are not allowed to redistribute/re-upload this mod to anywhere else!"
end
