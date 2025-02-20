-- stylua: ignore

---@enum CAnim
local Anim = {
  ACT_FILE          = "Act/Vehicles.act",
  LAND              = "/Global/Vehicles/Bikes/BMXTricks/BackManualLand",
  BARSPIN           = "/Global/Vehicles/Bikes/BMXTricks/Barspin",
  BARSPIN_CYCLE     = "/Global/Vehicles/Bikes/BMXTricks/BarspinCycle",
  WHIPLASH          = "/Global/Vehicles/Bikes/BMXTricks/Whiplash",
  FRONTNUDGE        = "/Global/Vehicles/Bikes/BMXTricks/FrontNudge",
  FRONTNUDGE_BRAKE  = "/Global/Vehicles/Bikes/BMXTricks/FrontNudgeBrake",
  STOPPIE           = "/Global/Vehicles/Bikes/Ground/Manual/IntoFrontManual/DoFrontManual",
  INTO_WHEELIE      = "/Global/Vehicles/Bikes/BMXTricks/IntoWheelie",
  START_WHEELIE     = "/Global/Vehicles/Bikes/BMXTricks/IntoWheelie/StartWheelie",
  WHEELIE           = "/Global/Vehicles/Bikes/BMXTricks/IntoWheelie/StartWheelie/Peddle",
}

--[[
Don't know why registering a custom `.act` file that contains these animations
via DSL does not work properly. Adding an act file inside Act.img is also
does not work.

Only works by replacing the original file AND adding more "Bank" (can be called
folder) to separate the original "Bank" and "Node" and the modified one.
]]
-- If not Bully AE (if it is Bully SE), then use the custom act file
--[[ if not (type(_G.PlayerGetUsingTouchScreen) == "function") then
  Anim = {
    ACT_FILE = "BMXTricks.act",
    LAND = "/Global/BMXTricks/BackManualLand",
    BARSPIN = "/Global/BMXTricks/Barspin",
    BARSPIN_CYCLE = "/Global/BMXTricks/BarspinCycle",
    WHIPLASH = "/Global/BMXTricks/Whiplash",
    FRONTNUDGE = "/Global/BMXTricks/FrontNudge",
    FRONTNUDGE_BRAKE = "/Global/BMXTricks/FrontNudgeBrake",
    STOPPIE = "/Global/BMXTricks/Manual/IntoFrontManual/DoFrontManual",
    INTO_WHEELIE = "/Global/BMXTricks/IntoWheelie",
    START_WHEELIE = "/Global/BMXTricks/IntoWheelie/StartWheelie",
    WHEELIE = "/Global/BMXTricks/IntoWheelie/StartWheelie/Peddle",
  }
end ]]

-- -------------------------------------------------------------------------- --
-- Save to Global Variable                                                    --
-- -------------------------------------------------------------------------- --

BMX_TRICKS.Constant.Anim = Anim
