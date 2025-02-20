---@class Enum
local Enum = BMX_TRICKS.Enum
---@class Constant
local Const = BMX_TRICKS.Constant
---@class Util
local Util = BMX_TRICKS.Util

-- -------------------------------------------------------------------------- --
-- Object Definition                                                          --
-- -------------------------------------------------------------------------- --

local wheelieTrickHandler = BMXTRICKS_TrickHandler.new(Enum.TrickName.Wheelie)

-- -------------------------------------------------------------------------- --
-- Enum                                                                       --
-- -------------------------------------------------------------------------- --

wheelieTrickHandler:SetEnumEvents({
  init = Enum.Event.OnWheelieStart,
  playingStart = Enum.Event.OnWheelieUpdateStart,
  playing = Enum.Event.OnWheelieUpdate,
  playingEnd = Enum.Event.OnWheelieUpdateEnd,
  freezeStart = Enum.Event.OnWheelieFreezeStart,
  freeze = Enum.Event.OnWheelieFreeze,
  freezeEnd = Enum.Event.OnWheelieFreezeEnd,
  ending = Enum.Event.OnWheelieEnd,
})

-- -------------------------------------------------------------------------- --
-- Additional Animation Handler                                               --
-- -------------------------------------------------------------------------- --

-- Initial/pre-trick

local liftConfKey, lift = Enum.Config.PRE_WHEELIE_ANIM, true

wheelieTrickHandler:SetInitialTrickHandler(function(config)
  lift = config:GetSettingValue(liftConfKey) --[[@as boolean]]
  if lift then
    Util.PlayAnimIfNotPlaying(Const.Anim.INTO_WHEELIE, Const.Anim.ACT_FILE)

    local intoWheelie = Const.Anim.INTO_WHEELIE
    local startWheelie = Const.Anim.START_WHEELIE

    -- While lifting the front wheel
    while Util.IsPlaying(intoWheelie) and not Util.IsPlaying(startWheelie) do
      Wait(0)
    end

    Util.PlayAnim(Const.Anim.WHEELIE, Const.Anim.ACT_FILE)
  end

  Util.PlayAnimIfNotPlaying(Const.Anim.WHEELIE, Const.Anim.ACT_FILE)
end)

-- Ending/post-trick

local landConfKey, land = Enum.Config.POST_WHEELIE_ANIM, true

wheelieTrickHandler:SetEndingTrickHandler(function(config)
  -- If crashing
  if not VehicleFromDriver(gPlayer) then return end

  PlayerStopAllActionControllers()

  land = config:GetSettingValue(landConfKey) --[[@as boolean]]
  if land then
    Util.PlayAnimIfNotPlaying(Const.Anim.LAND, Const.Anim.ACT_FILE)
    Util.WaitForAnim(Const.Anim.LAND)
  end
end)

-- -------------------------------------------------------------------------- --
-- Keyboard Input Handler                                                     --
-- -------------------------------------------------------------------------- --

-- Input condition

local keyConfKey = Enum.Config.KEY_WHEELIE
local keyCombinationConfKey = Enum.Config.KEY_COMBINATION_WHEELIE
local key, keyCombination = "", ""

local condition

wheelieTrickHandler:SetKeyboardInputCondition(function(config)
  key = config:GetSettingValue(keyConfKey) --[[@as string]]
  keyCombination = config:GetSettingValue(keyCombinationConfKey) --[[@as string]]

  condition = IsKeyBeingPressed(key) or IsKeyPressed(key)

  if keyCombination ~= "" then
    return IsKeyPressed(keyCombination) and condition
  end

  return condition
end)

-- While playing

local WHEELIE_END_NODETIME = Const.Nodetime.WHEELIE_END_NODETIME
local minSpeedConfKey, minSpeed = Enum.Config.WHEELIE_MIN_SPEED, 0

---@param config Config
---@return boolean
local function IsEnoughSpeed(config)
  minSpeed = config:GetSettingValue(minSpeedConfKey) --[[@as number]]
  return Util.ToKmPerHour(Util.GetBikeSpeed()) >= minSpeed
end

wheelieTrickHandler:SetKeyboardPlayingHandler(function(config)
  if not IsEnoughSpeed(config) then return false end

  key = config:GetSettingValue(keyConfKey) --[[@as string]]
  keyCombination = config:GetSettingValue(keyCombinationConfKey) --[[@as string]]

  if keyCombination ~= "" then
    if IsKeyPressed(keyCombination) then
      if IsKeyPressed(key) then
        -- Smooth animation
        if Util.GetNodeTime() >= WHEELIE_END_NODETIME then
          Util.PlayAnim(Const.Anim.WHEELIE, Const.Anim.ACT_FILE)
        end

        return true
      end

      return nil
    end

    return false
  end

  -- Smooth animation
  if IsKeyPressed(key) and Util.GetNodeTime() >= WHEELIE_END_NODETIME then
    Util.PlayAnim(Const.Anim.WHEELIE, Const.Anim.ACT_FILE)
    return true
  end

  return false
end)

-- While frozen

wheelieTrickHandler:SetKeyboardFreezeHandler(function(config)
  if not IsEnoughSpeed(config) then return false end

  key = config:GetSettingValue(keyConfKey) --[[@as string]]
  keyCombination = config:GetSettingValue(keyCombinationConfKey) --[[@as string]]

  if IsKeyBeingPressed(key) or IsKeyPressed(key) then
    return true
  elseif keyCombination ~= "" and IsKeyPressed(keyCombination) then
    Util.PlayAnim(Const.Anim.WHEELIE, Const.Anim.ACT_FILE)
    return nil
  end
  return false
end)

-- -------------------------------------------------------------------------- --
-- Controller Input Handler                                                   --
-- -------------------------------------------------------------------------- --

-- No need to.
-- Use the game default mechanic, that is analog stick down + repeatedly press
-- accelerate button

-- -------------------------------------------------------------------------- --
-- Save to Global Variable                                                    --
-- -------------------------------------------------------------------------- --

BMXTRICKS_WheelieTrickHandler = wheelieTrickHandler
