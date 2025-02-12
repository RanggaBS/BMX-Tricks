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

  -- local Util = BMX_TRICKS.Util
  -- local Enum = BMX_TRICKS.Enum
  -- local Const = BMX_TRICKS.Constant
  local bmxTrick = BMX_TRICKS.GetSingleton()
  -- local event = bmxTrick:GetEventManager()

  -- ------------------------------------------------------------------------ --
  -- DEBUG: Test Event                                                        --
  -- ------------------------------------------------------------------------ --

  --[[ event:AddListener(Enum.Event.OnWhiplashUpdate, function(data)
    -- DrawTextInline("LOREM IPSUM DOLOR SIT AMET", 0.01, 1)
    local elapsed = (GetTimer() - data.actualTrickStartTime) / 1000
    DrawTextInline(string.format("%.2f", elapsed), 0, 1)
  end) ]]

  -- ------------------------------------------------------------------------ --
  -- DEBUG: Node Time                                                         --
  -- ------------------------------------------------------------------------ --

  --[[ CreateThread(function()
    local maxNodeTime = 0

    while true do
      Wait(0)

      if PedMePlaying(0, "Barspin") and maxNodeTime < Util.GetNodeTime() then
        maxNodeTime = Util.GetNodeTime()
      end
      DrawTextInline("Max node time: " .. tostring(maxNodeTime), 0, 2)
    end
  end) ]]

  -- ------------------------------------------------------------------------ --
  -- DEBUG: Speed                                                             --
  -- ------------------------------------------------------------------------ --

  --[[ CreateThread(function()
    local speed, speedKm
    while true do
      Wait(0)
      speed = Util.GetVehicleSpeed(VehicleFromDriver(gPlayer))
      speedKm = speed * 3.6
      DrawTextInline(
        string.format("%.0f", speed)
          .. " m/s\n"
          .. string.format("%.0f", speedKm)
          .. " km/h",
        0,
        2
      )
    end
  end) ]]

  -- ------------------------------------------------------------------------ --
  -- DEBUG: Test action node                                                  --
  -- ------------------------------------------------------------------------ --

  --[[ CreateThread(function()
    local a = Const.Anim.INTO_WHEELIE
    local b = Const.Anim.WHEELIE
    local c, d = false, false
    while true do
      Wait(0)

      c = Util.IsPlaying(a)
      d = Util.IsPlaying(b)
      DrawTextInline(tostring((c and d) and c == d), 0, 1)
    end
  end) ]]

  -- ------------------------------------------------------------------------ --
  -- DEBUG: Stick Value                                                       --
  -- ------------------------------------------------------------------------ --

  --[[ CreateThread(function()
    local h, v = 0, 0
    while true do
      Wait(0)
      h, v = GetStickValue(16, 0), GetStickValue(17, 0)
      DrawTextInline(string.format("H: %.2f\nV: %.2f", h, v), 0, 2)
    end
  end) ]]

  -- ------------------------------------------------------------------------ --
  -- DEBUG: In air / flying                                                   --
  -- ------------------------------------------------------------------------ --

  --[[ CreateThread(function()
    local v
    while 1 do
      Wait(0)

      v = PedMePlaying(0, "HOP")
      DrawTextInline(tostring(v), 0, 1)
    end
  end) ]]

  -- ------------------------------------------------------------------------ --
  -- DEBUG: Stick id as argument on Button function                           --
  -- ------------------------------------------------------------------------ --

  --[[ CreateThread(function()
    local v
    while 1 do
      Wait(0)

      v = IsButtonPressed(17, 0)
      DrawTextInline(tostring(v), 0, 1)
    end
  end) ]]

  -- ------------------------------------------------------------------------ --
  -- DEBUG: Right analog stick press                                          --
  -- ------------------------------------------------------------------------ --

  --[[ CreateThread(function()
    local v
    local buttons = {
      0,
      1,
      2,
      3,
      4,
      5,
      6,
      7,
      8,
      9,
      10,
      11,
      12,
      13,
      14,
      15,
      16,
      17,
      18,
      19,
      24,
    }
    while 1 do
      Wait(0)
      for _, btn in ipairs(buttons) do
        v = IsButtonPressed(btn, 0)
        if v then
          DrawTextInline(tostring(btn), 0, 1) -- Button id: 15, it is crouch
        end
      end
    end
  end) ]]

  -- ------------------------------------------------------------------------ --
  -- DEBUG: Test register DSL custom act file                                 --
  -- ------------------------------------------------------------------------ --

  --[[ CreateThread(function()
    while 1 do
      Wait(0)
      if IsKeyBeingPressed("J") then
        PedSetActionNode(gPlayer, "/Global/BMXTricks/Trip", "BMXTricks.act")
        DrawTextInline("AASD", 0.3, 1)
        -- ForceActionNode(
        --   gPlayer,
        --   "/Global/Ambient/HarassMoves/HarassShort/Trip",
        --   "Act/Anim/Ambient.act"
        -- )
      end
    end
  end) ]]

  while true do
    Wait(0)
    bmxTrick:MainLogic()
  end
end
