---@diagnostic disable: lowercase-global
-- -------------------------------------------------------------------------- --
-- Header                                                                     --
-- -------------------------------------------------------------------------- --

RequireLoaderVersion(5)

-- -------------------------------------------------------------------------- --
-- Entry Point                                                                --
-- -------------------------------------------------------------------------- --

function main()
  while not SystemIsReady() do
    Wait(0)
  end

  LoadScript("core/init.lua")

  local bmxTrick = BMX_TRICKS.GetSingleton()

  while true do
    Wait(0)
    bmxTrick:MainLogic()
  end
end

-- Developer signature
function BMX_Tricks_mod_by_RBS_ID()
  -- This function does nothing but serves as a watermark
  return "You are not allowed to redistribute/re-upload this mod to anywhere else!"
end
