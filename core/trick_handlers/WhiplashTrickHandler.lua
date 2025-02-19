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

local whiplashTrickHandler = TrickHandler.new(Enum.TrickName.Whiplash)

-- -------------------------------------------------------------------------- --
-- Enum                                                                       --
-- -------------------------------------------------------------------------- --

whiplashTrickHandler:SetEnumEvents({
  init = Enum.Event.OnWhiplashStart,
  playingStart = Enum.Event.OnWhiplashUpdateStart,
  playing = Enum.Event.OnWhiplashUpdate,
  playingEnd = Enum.Event.OnWhiplashUpdateEnd,
  freezeStart = Enum.Event.OnWhiplashFreezeStart,
  freeze = Enum.Event.OnWhiplashFreeze,
  freezeEnd = Enum.Event.OnWhiplashFreezeEnd,
  ending = Enum.Event.OnWhiplashEnd,
})

-- -------------------------------------------------------------------------- --
-- Additional Animation Handler                                               --
-- -------------------------------------------------------------------------- --

-- Initial/pre-trick

local endoConfKey, endo = Enum.Config.PRE_WHIPLASH_ANIM, true
local nt = 0

whiplashTrickHandler:SetInitialTrickHandler(function(config)
  endo = config:GetSettingValue(endoConfKey) --[[@as boolean]]
  if endo then
    Util.PlayAnimIfNotPlaying(Const.Anim.STOPPIE, Const.Anim.ACT_FILE)
    nt = Const.Nodetime.STOPPIE_LIFT_NODETIME
    while Util.IsPlaying(Const.Anim.STOPPIE) and Util.GetNodeTime() < nt do
      Wait(0)
    end
  end

  Util.PlayAnimIfNotPlaying(Const.Anim.WHIPLASH, Const.Anim.ACT_FILE)
end)

-- Ending/post-trick

local landConfKey, land = Enum.Config.POST_WHIPLASH_ANIM, false

whiplashTrickHandler:SetEndingTrickHandler(function(config)
  -- If crashing
  if not VehicleFromDriver(gPlayer) then return end

  -- PlayerStopAllActionControllers() -- bug
  Util.PlayAnim("/Global", "Act/Globals.act")

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

local keyConfKey = Enum.Config.KEY_WHIPLASH
local keyCombinationConfKey = Enum.Config.KEY_COMBINATION_WHIPLASH
local key, keyCombination = "", ""
local minSpeedConfKey, minSpeed = Enum.Config.WHIPLASH_MIN_SPEED, 0
local condition

---@param config? Config
---@return boolean
local function IsEnoughSpeed(config)
  if config then
    minSpeed = config:GetSettingValue(minSpeedConfKey) --[[@as number]]
  end
  return Util.ToKmPerHour(Util.GetBikeSpeed()) >= minSpeed
end

whiplashTrickHandler:SetKeyboardInputCondition(function(config)
  key = config:GetSettingValue(keyConfKey) --[[@as string]]
  keyCombination = config:GetSettingValue(keyCombinationConfKey) --[[@as string]]

  condition = IsKeyBeingPressed(key) or IsKeyPressed(key)

  if keyCombination ~= "" then
    return IsEnoughSpeed(config) and IsKeyPressed(keyCombination) and condition
  end

  return IsEnoughSpeed(config) and condition
end)

-- While playing

whiplashTrickHandler:SetKeyboardPlayingHandler(function(config)
  -- If crashing
  if not VehicleFromDriver(gPlayer) then return false end

  -- If not enough speed and still doing the trick
  nt = Util.GetNodeTime()
  if not IsEnoughSpeed(config) and Util.IsPlaying(Const.Anim.WHIPLASH) then
    -- If the bike frame has been kicked and not much rotated around
    if nt < Const.Nodetime.WHIPLASH_START_NODETIME then
      return false
    -- If frozen
    elseif nt >= Const.Nodetime.WHIPLASH_FREEZE_NODETIME then
      return false
    end
  end

  key = config:GetSettingValue(keyConfKey) --[[@as string]]
  keyCombination = config:GetSettingValue(keyCombinationConfKey) --[[@as string]]

  if keyCombination ~= "" then
    -- Continue doing whiplash while key is held down
    if IsKeyPressed(keyCombination) then
      if IsKeyBeingPressed(key) or IsKeyPressed(key) then
        -- Smooth whiplash animation:
        nt = Const.Nodetime.WHIPLASH_LOOP_NODETIME
        if Util.IsPlaying(Const.Anim.WHIPLASH) and Util.GetNodeTime() >= nt then
          Util.PlayAnim(Const.Anim.WHIPLASH, Const.Anim.ACT_FILE)
        end

        Util.PlayAnimIfNotPlaying(Const.Anim.WHIPLASH, Const.Anim.ACT_FILE)

        return true
      end

      -- While still performing the trick
      if Util.IsPlaying(Const.Anim.WHIPLASH) then
        if Util.GetNodeTime() >= Const.Nodetime.WHIPLASH_FREEZE_NODETIME then
          -- Go to freeze state
          return nil
        end

        return true
      end
    end

    -- While still performing the trick
    if Util.IsPlaying(Const.Anim.WHIPLASH) then return true end

    return false
  end

  return false
end)

-- While frozen

whiplashTrickHandler:SetKeyboardFreezeHandler(function(config)
  if Util.ToKmPerHour(Util.GetBikeSpeed()) < minSpeed then return false end

  key = config:GetSettingValue(keyConfKey) --[[@as string]]
  keyCombination = config:GetSettingValue(keyCombinationConfKey) --[[@as string]]

  if IsKeyBeingPressed(key) or IsKeyPressed(key) then
    return true
  elseif keyCombination ~= "" and IsKeyPressed(keyCombination) then
    Util.PlayAnim(Const.Anim.WHIPLASH, Const.Anim.ACT_FILE)
    return nil
  end
  return false
end)

-- -------------------------------------------------------------------------- --
-- Controller Input Handler                                                   --
-- -------------------------------------------------------------------------- --

-- Input condition

local minStickValueConfKey = Enum.Config.CONTROLLER_MIN_STICK
local doubleTapTresholdConfKey = Enum.Config.CONTROLLER_DOUBLETAP_TRESHOLD
local inputSeqConfKey = Enum.Config.CONTROLLER_WHIPLASH_INPUTSEQUENCE
local inputSeq, minStickValue, doubleTapTreshold, lastTap = "", 0, 0, 0
local stckKey = "whiplash"

---@param stickValue number
---@return boolean
local function Option2StickCondition(stickValue)
  return stickValue >= minStickValue
end

---@return boolean
local function DoubleTapTrickActivationHandler()
  -- second tap, while analog stick down
  while Util.GetVerticalStickValue() >= minStickValue do
    Wait(0)

    if GetTimer() >= lastTap + doubleTapTreshold then return false end

    -- move your analog stick up a bit
    while Util.GetVerticalStickValue() < minStickValue do
      Wait(0)
      if GetTimer() >= lastTap + doubleTapTreshold then return false end

      -- Third tap
      if Util.GetVerticalStickValue() >= minStickValue then return true end
    end
  end

  return false
end

-- Separate the first tap input logic to avoid whiplash trick sometime won't
-- work because the execution flow moved to barspin's logic, and because
-- barspin got called first. TLDR: while loop
function _G.TF_BMXTRICKS_WHIPLASHCTRLINPUT()
  while true do
    Wait(0)
    if BMX_TRICKS.GetSingleton():CanDoTricks() then
      -- First tap, update last tap value
      if inputSeq == Enum.Config.CONTROLLER_INPUTSEQUENCE_DOWNUPUP then
        while Util.GetVerticalStickValue() <= -minStickValue do
          Wait(0)
          lastTap = GetTimer()
        end
      elseif inputSeq == Enum.Config.CONTROLLER_INPUTSEQUENCE_UPUP then
        if Util.IsStickConditionJustMet(stckKey, 17, Option2StickCondition) then
          lastTap = GetTimer()
        end
      end
    end
  end
end
local func = Util.IsBullyAE() and "TF_BMXTRICKS_WHIPLASHCTRLINPUT"
  or TF_BMXTRICKS_WHIPLASHCTRLINPUT
BMX_TRICKS.T_WHIPLASH = CreateThread(func)

whiplashTrickHandler:SetControllerInputCondition(function(config)
  inputSeq = config:GetSettingValue(inputSeqConfKey) --[[@as string]]
  minStickValue = config:GetSettingValue(minStickValueConfKey) --[[@as number]]
  doubleTapTreshold = config:GetSettingValue(doubleTapTresholdConfKey) --[[@as number]]

  -- First tap input logic here on the thread..

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

whiplashTrickHandler:SetControllerPlayingHandler(function(config)
  -- If crashing
  if not VehicleFromDriver(gPlayer) then return false end

  minStickValue = config:GetSettingValue(minStickValueConfKey) --[[@as number]]
  doubleTapTreshold = config:GetSettingValue(doubleTapTresholdConfKey) --[[@as number]]

  if not Cancel() then
    -- If the stick is pointed very upwards
    -- if Util.GetVerticalStickValue() >= minStickValue then -- OLD
    if Util.IsBikeLeftOrRightPunchPressed() then -- NEW
      -- Smooth loop animation
      nt = Const.Nodetime.WHIPLASH_LOOP_NODETIME
      if Util.IsPlaying(Const.Anim.WHIPLASH) and Util.GetNodeTime() >= nt then
        Util.PlayAnim(Const.Anim.WHIPLASH, Const.Anim.ACT_FILE)
      end

      Util.PlayAnimIfNotPlaying(Const.Anim.WHIPLASH, Const.Anim.ACT_FILE)
      return true
    end

    nt = Const.Nodetime.WHIPLASH_FREEZE_NODETIME
    if Util.IsPlaying(Const.Anim.WHIPLASH) and Util.GetNodeTime() >= nt then
      return nil
    end

    Util.PlayAnimIfNotPlaying(Const.Anim.WHIPLASH, Const.Anim.ACT_FILE)

    return Util.IsPlaying(Const.Anim.WHIPLASH)
  end

  return false
end)

-- While frozen

whiplashTrickHandler:SetControllerFreezeHandler(function(config)
  if not VehicleFromDriver(gPlayer) or not IsEnoughSpeed(config) then
    return false
  end

  minStickValue = config:GetSettingValue(minStickValueConfKey) --[[@as number]]
  doubleTapTreshold = config:GetSettingValue(doubleTapTresholdConfKey) --[[@as number]]

  -- If the stick is pointed upwards
  -- if Util.GetVerticalStickValue() >= minStickValue then -- OLD
  if Util.IsBikeLeftOrRightPunchPressed() then -- NEW
    return true

  -- While the cancel button is not pressed
  elseif not Cancel() then
    Util.PlayAnim(Const.Anim.WHIPLASH, Const.Anim.ACT_FILE)
    return nil
  end

  return false
end)

-- -------------------------------------------------------------------------- --
-- Save to Global Variable                                                    --
-- -------------------------------------------------------------------------- --

BMXTRICKS_WhiplashTrickHandler = whiplashTrickHandler

-- Developer signature
function BMX_Tricks_mod_by_RBS_ID()
  -- This function does nothing but serves as a watermark
  return "You are not allowed to redistribute/re-upload this mod to anywhere else!"
end
