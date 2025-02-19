---@class Enum
local Enum = BMX_TRICKS.Enum
---@class Constant
local Const = BMX_TRICKS.Constant
---@class Util
local Util = BMX_TRICKS.Util
---@class TrickHandler
local TrickHandler = BMXTRICKS_TrickHandler

-- -------------------------------------------------------------------------- --
-- Object Declaration                                                         --
-- -------------------------------------------------------------------------- --

local barspinTrickHandler = TrickHandler.new(Enum.TrickName.Barspin)

-- -------------------------------------------------------------------------- --
-- Enum                                                                       --
-- -------------------------------------------------------------------------- --

barspinTrickHandler:SetEnumEvents({
  init = Enum.Event.OnBarspinStart,
  playingStart = Enum.Event.OnBarspinUpdateStart,
  playing = Enum.Event.OnBarspinUpdate,
  playingEnd = Enum.Event.OnBarspinUpdateEnd,
  freezeStart = Enum.Event.OnBarspinFreezeStart,
  freeze = Enum.Event.OnBarspinFreeze,
  freezeEnd = Enum.Event.OnBarspinFreezeEnd,
  ending = Enum.Event.OnBarspinEnd,
})

-- -------------------------------------------------------------------------- --
-- Additional Animation Handler                                               --
-- -------------------------------------------------------------------------- --

-- Initial/pre-trick

local liftConfKey, lift = Enum.Config.PRE_BARSPIN_ANIM, true

barspinTrickHandler:SetInitialTrickHandler(function(config)
  lift = config:GetSettingValue(liftConfKey) --[[@as boolean]]
  if lift then
    -- Play the front wheel lift animation
    Util.PlayAnimIfNotPlaying(Const.Anim.INTO_WHEELIE, Const.Anim.ACT_FILE)

    local intoWheelie = Const.Anim.INTO_WHEELIE
    local startWheelie = Const.Anim.START_WHEELIE

    -- Wait while lifting the front wheel
    while Util.IsPlaying(intoWheelie) and not Util.IsPlaying(startWheelie) do
      Wait(0)
    end
  end
end)

-- Ending/post-trick

local landConfKey, land = Enum.Config.POST_BARSPIN_ANIM, true

barspinTrickHandler:SetEndingTrickHandler(function(config)
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

local keyConfKey = Enum.Config.KEY_BARSPIN
local keyCombinationConfKey = Enum.Config.KEY_COMBINATION_BARSPIN
local key, keyCombination = "", ""
local condition

barspinTrickHandler:SetKeyboardInputCondition(function(config)
  key = config:GetSettingValue(keyConfKey) --[[@as string]]
  keyCombination = config:GetSettingValue(keyCombinationConfKey) --[[@as string]]

  condition = IsKeyBeingPressed(key) --or IsKeyPressed(key)

  if keyCombination ~= "" then
    return IsKeyPressed(keyCombination) and condition
  end

  return condition
end)

-- While playing

local minSpeedConfKey, minSpeed = Enum.Config.BARSPIN_MIN_SPEED, nil
local nt = Const.Nodetime.BARSPIN_MAX_NODETIME
local barspinNode = Const.Anim.BARSPIN
local barspinCycleNode = Const.Anim.BARSPIN_CYCLE

---@param config? Config
---@return boolean
local function IsEnoughSpeed(config)
  if config then
    minSpeed = config:GetSettingValue(minSpeedConfKey) --[[@as number]]
  end
  return Util.ToKmPerHour(Util.GetBikeSpeed()) >= minSpeed
end

barspinTrickHandler:SetKeyboardPlayingHandler(function(config)
  if not VehicleFromDriver(gPlayer) or not IsEnoughSpeed(config) then
    return false
  end

  key = config:GetSettingValue(keyConfKey) --[[@as string]]
  keyCombination = config:GetSettingValue(keyCombinationConfKey) --[[@as string]]

  if keyCombination ~= "" then
    nt = Const.Nodetime.BARSPIN_MAX_NODETIME

    if IsKeyPressed(keyCombination) then
      if IsKeyBeingPressed(key) or IsKeyPressed(key) then
        Util.PlayAnimIfNotPlaying(barspinCycleNode, Const.Anim.ACT_FILE)
        return true
      end

      if Util.IsPlaying(barspinNode) and Util.GetNodeTime() >= nt then
        return nil
      end

      Util.PlayAnimIfNotPlaying(barspinNode, Const.Anim.ACT_FILE)
      return true
    end

    return Util.IsPlaying(barspinNode) and Util.GetNodeTime() < nt
  end
end)

-- While frozen

barspinTrickHandler:SetKeyboardFreezeHandler(function(config)
  -- If crashing or not enough speed
  if not VehicleFromDriver(gPlayer) or not IsEnoughSpeed(config) then
    return false
  end

  key = config:GetSettingValue(keyConfKey) --[[@as string]]
  keyCombination = config:GetSettingValue(keyCombinationConfKey) --[[@as string]]

  if Util.IsPlaying(barspinNode) then
    if IsKeyBeingPressed(key) or IsKeyPressed(key) then
      return true
    elseif keyCombination ~= "" and IsKeyPressed(keyCombination) then
      Util.PlayAnim(barspinNode, Const.Anim.ACT_FILE)
      return nil
    end
  end

  return false
end)

-- -------------------------------------------------------------------------- --
-- Controller Input Handler                                                   --
-- -------------------------------------------------------------------------- --

local minStickValueConfKey = Enum.Config.CONTROLLER_MIN_STICK
local doubleTapTresholdConfKey = Enum.Config.CONTROLLER_DOUBLETAP_TRESHOLD
local inputSeqConfKey = Enum.Config.CONTROLLER_BARSPIN_INPUTSEQUENCE
local inputSeq, minStickValue, doubleTapTreshold, lastTap = "", 0, 0, 0
local stckKey = "barspin"

---Cache the function definition
---@param stickValue number
---@return boolean
local function Option2StickCondition(stickValue)
  return stickValue <= -minStickValue
end

---@return boolean
local function DoubleTapTrickActivationHandler()
  -- second tap, while analog stick down
  while Util.GetVerticalStickValue() <= -minStickValue do
    Wait(0)

    if GetTimer() >= lastTap + doubleTapTreshold then return false end

    -- move your analog stick up a bit
    while Util.GetVerticalStickValue() > -minStickValue do
      Wait(0)
      if GetTimer() >= lastTap + doubleTapTreshold then return false end

      -- Third tap
      if Util.GetVerticalStickValue() <= -minStickValue then return true end
    end
  end

  return false
end

function _G.TF_BMXTRICKS_BARSPINCTRLINPUT()
  while true do
    Wait(0)
    if BMX_TRICKS.GetSingleton():CanDoTricks() then
      -- First tap, update the last tap value
      if inputSeq == Enum.Config.CONTROLLER_INPUTSEQUENCE_UPDOWNDOWN then
        while Util.GetVerticalStickValue() >= minStickValue do
          Wait(0)
          lastTap = GetTimer()
        end
      elseif inputSeq == Enum.Config.CONTROLLER_INPUTSEQUENCE_DOWNDOWN then
        if Util.IsStickConditionJustMet(stckKey, 17, Option2StickCondition) then -- pass the function
          lastTap = GetTimer()
        end
      end
    end
  end
end
local func = Util.IsBullyAE() and "TF_BMXTRICKS_BARSPINCTRLINPUT"
  or TF_BMXTRICKS_BARSPINCTRLINPUT
BMX_TRICKS.T_BARSPIN_CTRLINPUT = CreateThread(func)

barspinTrickHandler:SetControllerInputCondition(function(config)
  inputSeq = config:GetSettingValue(inputSeqConfKey) --[[@as string]]
  minStickValue = config:GetSettingValue(minStickValueConfKey) --[[@as number]]
  doubleTapTreshold = config:GetSettingValue(doubleTapTresholdConfKey) --[[@as number]]

  -- First tap logic..

  -- Second tap
  if GetTimer() < lastTap + doubleTapTreshold then
    return DoubleTapTrickActivationHandler()
  end

  return false
end)

-- While playing

---@return boolean
local function Cancel()
  return IsButtonBeingPressed(Enum.Button.Grapple, Enum.Controller.PLAYER1)
    or IsButtonBeingPressed(Enum.Button.Jump, Enum.Controller.PLAYER1)
end

barspinTrickHandler:SetControllerPlayingHandler(function(config)
  if not VehicleFromDriver(gPlayer) or not IsEnoughSpeed(config) then
    return false
  end

  minStickValue = config:GetSettingValue(minStickValueConfKey) --[[@as number]]
  doubleTapTreshold = config:GetSettingValue(doubleTapTresholdConfKey) --[[@as number]]

  if not Cancel() then
    -- If the stick is pointed very downwards
    -- if Util.GetVerticalStickValue() <= -minStickValue then -- OLD
    if Util.IsBikeLeftOrRightPunchPressed() then -- NEW
      Util.PlayAnimIfNotPlaying(barspinCycleNode, Const.Anim.ACT_FILE)
      return true
    end

    nt = Const.Nodetime.BARSPIN_MAX_NODETIME
    if Util.IsPlaying(barspinNode) and Util.GetNodeTime() >= nt then
      return nil
    end

    Util.PlayAnimIfNotPlaying(barspinNode, Const.Anim.ACT_FILE)
    return true
  end

  return Util.IsPlaying(Const.Anim.BARSPIN) and Util.GetNodeTime() < nt
end)

-- While frozen

barspinTrickHandler:SetControllerFreezeHandler(function(config)
  if not VehicleFromDriver(gPlayer) or not IsEnoughSpeed(config) then
    return false
  end

  minStickValue = config:GetSettingValue(minStickValueConfKey) --[[@as number]]
  doubleTapTreshold = config:GetSettingValue(doubleTapTresholdConfKey) --[[@as number]]

  -- If the stick is pointed downwards
  -- if Util.GetVerticalStickValue() <= -minStickValue then -- OLD
  if Util.IsBikeLeftOrRightPunchPressed() then -- NEW
    return true

  -- While the cancel button is not pressed
  elseif not Cancel() then
    Util.PlayAnim(barspinNode, Const.Anim.ACT_FILE)
    return nil
  end

  return false
end)

-- -------------------------------------------------------------------------- --
-- Touchscreen Input Handler                                                  --
-- -------------------------------------------------------------------------- --

-- Exacly the same logic as above

-- barspinTrickHandler:SetTouchscreenInputCondition(controllerInputCondition)
-- barspinTrickHandler:SetTouchscreenPlayingHandler(controllerPlayingHandler)
-- barspinTrickHandler:SetTouchscreenFreezeHandler(controllerFreezeHandler)

-- -------------------------------------------------------------------------- --
-- Save to Global Variable                                                    --
-- -------------------------------------------------------------------------- --

BMXTRICKS_BarspinTrickHandler = barspinTrickHandler

-- Developer signature
function BMX_Tricks_mod_by_RBS_ID()
  -- This function does nothing but serves as a watermark
  return "You are not allowed to redistribute/re-upload this mod to anywhere else!"
end
