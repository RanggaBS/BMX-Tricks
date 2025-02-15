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
