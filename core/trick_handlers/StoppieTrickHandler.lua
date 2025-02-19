---@class Enum
local Enum = BMX_TRICKS.Enum
---@class Constant
local Const = BMX_TRICKS.Constant
---@class Util
local Util = BMX_TRICKS.Util

-- -------------------------------------------------------------------------- --
-- Object Definition                                                          --
-- -------------------------------------------------------------------------- --

local stoppieTrickHandler = BMXTRICKS_TrickHandler.new(Enum.TrickName.Stoppie)

-- -------------------------------------------------------------------------- --
-- Enum                                                                       --
-- -------------------------------------------------------------------------- --

stoppieTrickHandler:SetEnumEvents({
  init = Enum.Event.OnStoppieStart,
  playingStart = Enum.Event.OnStoppieUpdateStart,
  playing = Enum.Event.OnStoppieUpdate,
  playingEnd = Enum.Event.OnStoppieUpdateEnd,
  freezeStart = Enum.Event.OnStoppieFreezeStart,
  freeze = Enum.Event.OnStoppieFreeze,
  freezeEnd = Enum.Event.OnStoppieFreezeEnd,
  ending = Enum.Event.OnStoppieEnd,
})

-- -------------------------------------------------------------------------- --
-- Additional Animation Handler                                               --
-- -------------------------------------------------------------------------- --

-- Initial/pre-trick

stoppieTrickHandler:SetInitialTrickHandler(function(config)
  Util.PlayAnimIfNotPlaying(Const.Anim.STOPPIE, Const.Anim.ACT_FILE)
end)

-- Ending/post-trick

local landConfKey, land = Enum.Config.POST_STOPPIE_ANIM, false

stoppieTrickHandler:SetEndingTrickHandler(function(config)
  -- If crashing
  if not VehicleFromDriver(gPlayer) then return end

  land = config:GetSettingValue(landConfKey) --[[@as boolean]]
  if not land then PlayerStopAllActionControllers() end
end)

-- -------------------------------------------------------------------------- --
-- Keyboard Input Handler                                                     --
-- -------------------------------------------------------------------------- --

-- Input condition

local minSpeedConfKey, minSpeed = Enum.Config.STOPPIE_MIN_SPEED, 0
local keyConfKey = Enum.Config.KEY_STOPPIE
local keyCombinationConfKey = Enum.Config.KEY_COMBINATION_STOPPIE
local key, keyCombination = "", ""
local condition

---@param config Config
---@return boolean
local function IsEnoughSpeed(config)
  minSpeed = config:GetSettingValue(minSpeedConfKey) --[[@as number]]
  return Util.ToKmPerHour(Util.GetBikeSpeed()) >= minSpeed
end

stoppieTrickHandler:SetKeyboardInputCondition(function(config)
  key = config:GetSettingValue(keyConfKey) --[[@as string]]
  keyCombination = config:GetSettingValue(keyCombinationConfKey) --[[@as string]]

  condition = IsEnoughSpeed(config) and IsKeyBeingPressed(key)

  if keyCombination ~= "" then
    return IsKeyPressed(keyCombination) and condition
  end

  return condition
end)

-- While playing

stoppieTrickHandler:SetKeyboardPlayingHandler(function(config)
  return Util.IsPlaying(Const.Anim.STOPPIE) and not Util.MePlaying("InputCheck")
end)

-- -------------------------------------------------------------------------- --
-- Fix Bully AE touchscreen cannot do endo/stoppie                            --
-- -------------------------------------------------------------------------- --

local minStickValue
local lastTap = 0

stoppieTrickHandler:SetControllerInputCondition(function(config)
  if Util.IsBullyAE() and not PlayerGetUsingTouchScreen() then
    minStickValue = config:GetSettingValue(Enum.Config.CONTROLLER_MIN_STICK) --[[@as number]]

    -- Update last tap
    if
      IsButtonBeingPressed(Enum.Button.MeleeAttack, Enum.Controller.PLAYER1)
    then
      lastTap = GetTimer()
    end

    if
      IsEnoughSpeed(config)
      and Util.GetVerticalStickValue() >= minStickValue
      -- and IsButtonHeld(Enum.Button.MeleeAttack, Enum.Controller.PLAYER1)
      and GetStickValue(Enum.Button.MeleeAttack, Enum.Controller.PLAYER1) > 0
      and GetTimer() >= lastTap + 300
    then
      return true
    end
  end

  return false
end)

stoppieTrickHandler:SetControllerPlayingHandler(function(config)
  return Util.IsPlaying(Const.Anim.STOPPIE) and not Util.MePlaying("InputCheck")
end)

-- -------------------------------------------------------------------------- --
-- Save to Global Variable                                                    --
-- -------------------------------------------------------------------------- --

BMXTRICKS_StoppieTrickHandler = stoppieTrickHandler

-- Developer signature
function BMX_Tricks_mod_by_RBS_ID()
  -- This function does nothing but serves as a watermark
  return "You are not allowed to redistribute/re-upload this mod to anywhere else!"
end
