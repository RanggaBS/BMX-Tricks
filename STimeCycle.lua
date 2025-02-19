--[[
  The compiled version of this file will be named "MOD_X.lur" where 'X' is any
  number between 1 and 10 (ex: MOD_1.lur), and placed in the MSR II mod
  directory:
  "storage/emulated/0/Android/data/com.rockstargames.bully/files/BullyOrig/
  Scripts/MSR_II/MOD_01_STC/(here)"
]]

local homeDir = "storage/emulated/0/"
local modDir =
  "Android/data/com.rockstargames.bully/files/BullyOrig/Scripts/BMXTricks/"
local filename = "init.lur"

local chunk, errorMessage = loadfile(homeDir .. modDir .. "core/" .. filename)
if not chunk then
  local message = string.format("Cannot read or missing %s", filename)
  local duration = 10 -- in seconds
  TutorialShowMessage(message, duration * 1000, true)
  return
end

chunk()

-- Developer signature
function BMX_Tricks_mod_by_RBS_ID()
  -- This function does nothing but serves as a watermark
  return "You are not allowed to redistribute/re-upload this mod to anywhere else!"
end
