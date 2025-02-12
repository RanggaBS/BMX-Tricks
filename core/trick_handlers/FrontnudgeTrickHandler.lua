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

local frontnudgeTrickHandler = TrickHandler.new(Enum.TrickName.Frontnudge)

-- -------------------------------------------------------------------------- --
-- Enum                                                                       --
-- -------------------------------------------------------------------------- --

frontnudgeTrickHandler:SetEnumEvents({
  init = Enum.Event.OnFrontnudgeStart,
  playingStart = Enum.Event.OnFrontnudgeUpdateStart,
  playing = Enum.Event.OnFrontnudgeUpdate,
  playingEnd = Enum.Event.OnFrontnudgeUpdateEnd,
  freezeStart = Enum.Event.OnFrontnudgeFreezeStart,
  freeze = Enum.Event.OnFrontnudgeFreeze,
  freezeEnd = Enum.Event.OnFrontnudgeFreezeEnd,
  ending = Enum.Event.OnFrontnudgeEnd,
})

-- -------------------------------------------------------------------------- --
-- Additional Animation Handler                                               --
-- -------------------------------------------------------------------------- --

-- Initial/pre-trick

local minSpeedConfKey, minSpeed = Enum.Config.FRONTNUDGE_MIN_SPEED, 0
local frontnudgeAnim = Const.Anim.FRONTNUDGE_BRAKE
local brakeConfKey, brake = Enum.Config.FRONTNUDGE_BRAKE, true
local trackFreezeNodetime = 0

---@param config? Config
---@return boolean
local function IsEnoughSpeed(config)
  if config then
    minSpeed = config:GetSettingValue(minSpeedConfKey) --[[@as number]]
  end
  return Util.ToKmPerHour(Util.GetBikeSpeed()) >= minSpeed
end

frontnudgeTrickHandler:SetInitialTrickHandler(function(config)
  if not VehicleFromDriver(gPlayer) or not IsEnoughSpeed(config) then
    return
  end

  frontnudgeAnim = Const.Anim.FRONTNUDGE_BRAKE

  brake = config:GetSettingValue(brakeConfKey) --[[@as boolean]]
  if not brake then
    frontnudgeAnim = Const.Anim.FRONTNUDGE
  end

  Util.PlayAnimIfNotPlaying(frontnudgeAnim, Const.Anim.ACT_FILE)
  trackFreezeNodetime = Util.GetNodeTime()
end)

-- Ending/post-trick

local landConfKey, land = Enum.Config.POST_FRONTNUDGE_ANIM, false

frontnudgeTrickHandler:SetEndingTrickHandler(function(config)
  -- If crashing
  if not VehicleFromDriver(gPlayer) then
    return
  end

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

local keyConfKey = Enum.Config.KEY_FRONTNUDGE
local keyCombinationConfKey = Enum.Config.KEY_COMBINATION_FRONTNUDGE
local key, keyCombination = "", ""

local condition

frontnudgeTrickHandler:SetKeyboardInputCondition(function(config)
  key = config:GetSettingValue(keyConfKey) --[[@as string]]
  keyCombination = config:GetSettingValue(keyCombinationConfKey) --[[@as string]]

  condition = IsKeyBeingPressed(key) or IsKeyPressed(key)

  if keyCombination ~= "" then
    return IsEnoughSpeed(config) and IsKeyPressed(keyCombination) and condition
  end

  return IsEnoughSpeed(config) and condition
end)

-- While playing

local LOOP_NODETIME = Const.Nodetime.FRONTNUDGE_LOOP_NODETIME
local FREEZE_NODETIME = Const.Nodetime.FRONTNUDGE_FREEZE_NODETIME

frontnudgeTrickHandler:SetKeyboardPlayingHandler(function(config)
  -- If the bike speed is too slow and still performing the trick
  if
    Util.IsPlaying(frontnudgeAnim)
    and Util.GetNodeTime() >= FREEZE_NODETIME
    and not IsEnoughSpeed(config)
  then
    return false
  end

  if keyCombination ~= "" then
    if Util.IsPlaying(frontnudgeAnim) then
      if IsKeyPressed(key) and Util.GetNodeTime() >= LOOP_NODETIME then
        Util.PlayAnim(frontnudgeAnim, Const.Anim.ACT_FILE)
        trackFreezeNodetime = Util.GetNodeTime()
        return true
      --
      elseif IsKeyBeingPressed(key) then
        Util.PlayAnim(frontnudgeAnim, Const.Anim.ACT_FILE)
        trackFreezeNodetime = Util.GetNodeTime()
        return true
      --
      elseif IsKeyPressed(keyCombination) then
        -- Only update freeze node time while it is less than the target node time
        if trackFreezeNodetime < LOOP_NODETIME then
          trackFreezeNodetime = Util.GetNodeTime()
        else
          return nil
        end

        return Util.GetNodeTime() < FREEZE_NODETIME or nil
      end

      return Util.GetNodeTime() < LOOP_NODETIME
    end

    return false
  end

  if Util.IsPlaying(frontnudgeAnim) then
    if IsKeyPressed(key) then
      if trackFreezeNodetime < LOOP_NODETIME then
        trackFreezeNodetime = Util.GetNodeTime()
      end

      -- Freeze the actor
      if trackFreezeNodetime >= LOOP_NODETIME then
        Util.PlayAnim(frontnudgeAnim, Const.Anim.ACT_FILE)
      end

      return true
    end

    -- The key is now released

    -- true: Wait for actor to finish performing the trick
    -- false: Ends the trick
    return Util.GetNodeTime() < LOOP_NODETIME
    -- and trackFreezeNodetime < FREEZE_NODETIME
  end

  return false
end)

-- While frozen

frontnudgeTrickHandler:SetKeyboardFreezeHandler(function(config)
  if not IsEnoughSpeed(config) then
    return false
  end

  key = config:GetSettingValue(keyConfKey) --[[@as string]]
  keyCombination = config:GetSettingValue(keyCombinationConfKey) --[[@as string]]

  if keyCombination ~= "" then
    if IsKeyBeingPressed(key) or IsKeyPressed(key) then
      Util.PlayAnim(frontnudgeAnim, Const.Anim.ACT_FILE)
      trackFreezeNodetime = Util.GetNodeTime()
      return true

    -- Freeze
    elseif IsKeyPressed(keyCombination) then
      Util.PlayAnim(frontnudgeAnim, Const.Anim.ACT_FILE)
      return nil
    end

    return false
  end

  return false
end)

-- -------------------------------------------------------------------------- --
-- Controller Input Handler                                                   --
-- -------------------------------------------------------------------------- --

-- Input condition

local minStickValueConfKey = Enum.Config.CONTROLLER_MIN_STICK
local doubleTapTresholdConfKey = Enum.Config.CONTROLLER_DOUBLETAP_TRESHOLD
local minStickValue, doubleTapTreshold, lastTap = 0, 0, 0

frontnudgeTrickHandler:SetControllerInputCondition(function(config)
  if not IsEnoughSpeed(config) then
    return false
  end

  minStickValue = config:GetSettingValue(minStickValueConfKey) --[[@as number]]
  doubleTapTreshold = config:GetSettingValue(doubleTapTresholdConfKey) --[[@as number]]

  -- If the stick is pointed upwards and the brake button is being pressed
  if
    Util.GetVerticalStickValue() >= minStickValue
    and IsButtonBeingPressed(Enum.Button.MeleeAttack, Enum.Controller.PLAYER1)
  then
    -- If the brake button is being pressed again under this treshold time
    if GetTimer() < lastTap + doubleTapTreshold then
      return true
    end

    lastTap = GetTimer()
  end

  return false
end)

local nt = 0

---@return boolean
local function Cancel()
  return IsButtonBeingPressed(Enum.Button.Jump, Enum.Controller.PLAYER1)
    or IsButtonBeingPressed(Enum.Button.Grapple, Enum.Controller.PLAYER1)
end

-- While playing

frontnudgeTrickHandler:SetControllerPlayingHandler(function(config)
  if not VehicleFromDriver(gPlayer) or not IsEnoughSpeed(config) then
    return false
  end

  minStickValue = config:GetSettingValue(minStickValueConfKey) --[[@as number]]
  doubleTapTreshold = config:GetSettingValue(doubleTapTresholdConfKey) --[[@as number]]

  if Util.IsPlaying(frontnudgeAnim) and not Cancel() then
    nt = Const.Nodetime.FRONTNUDGE_LOOP_NODETIME
    -- If the analog stick is pointed upwards and ...
    if Util.IsBikeLeftOrRightPunchPressed() and Util.GetNodeTime() >= nt then
      Util.PlayAnim(frontnudgeAnim, Const.Anim.ACT_FILE)
      return true
    end

    -- Wait while the node time is below the target freeze node time
    return Util.GetNodeTime() < Const.Nodetime.FRONTNUDGE_FREEZE_NODETIME or nil
  end

  return false
end)

-- While frozen

frontnudgeTrickHandler:SetControllerFreezeHandler(function(config)
  if not IsEnoughSpeed(config) then
    return false
  end

  minStickValue = config:GetSettingValue(minStickValueConfKey) --[[@as number]]
  doubleTapTreshold = config:GetSettingValue(doubleTapTresholdConfKey) --[[@as number]]

  -- If the analog stick is pointed upwards
  -- if Util.GetVerticalStickValue() >= minStickValue then -- OLD
  if Util.IsBikeLeftOrRightPunchPressed() then -- NEW
    return true

  -- While the cancel button is not being pressed
  elseif not Cancel() then
    Util.PlayAnim(frontnudgeAnim, Const.Anim.ACT_FILE)
    return nil
  end

  return false
end)

-- -------------------------------------------------------------------------- --
-- Save to Global Variable                                                    --
-- -------------------------------------------------------------------------- --

BMXTRICKS_FrontnudgeTrickHandler = frontnudgeTrickHandler
