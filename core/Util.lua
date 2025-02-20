---@class Util
local Util = {}

-- -------------------------------------------------------------------------- --
-- Game Platform                                                              --
-- -------------------------------------------------------------------------- --

---@return boolean
function Util.IsBullyAE()
  return type(_G.PlayerGetUsingTouchScreen) == "function"
end

-- -------------------------------------------------------------------------- --
-- Script Loading                                                             --
-- -------------------------------------------------------------------------- --

---@param dir string
---@param filename string
function Util.AELoadScript(dir, filename)
  local chunk, errorMessage = loadfile(dir .. filename)
  if not chunk then
    local message = "Cannot read or missing " .. filename
    local durationInSecond = 10
    TutorialShowMessage(message, durationInSecond * 1000, true)
    while true do
      Wait(0)
    end
    return
  end
  chunk()
end

---@param ... string
function Util.AELoadScripts(...)
  for _, filename in ipairs(arg) do
    Util.AELoadScript("", filename)
  end
end

---@param ... string
function Util.LoadScripts(...)
  for _, filename in ipairs(arg) do
    LoadScript(filename)
  end
end

-- -------------------------------------------------------------------------- --
-- Configuration                                                              --
-- -------------------------------------------------------------------------- --

---@param config userdata
---@param key string
---@param defaultValue any
function Util.GetRealConfigValue(config, key, defaultValue)
  local func = ({
    ["boolean"] = GetConfigBoolean,
    ["number"] = GetConfigNumber,
    ["string"] = GetConfigString,
  })[type(defaultValue)] or GetConfigValue
  return func(config, key, defaultValue)
end

-- -------------------------------------------------------------------------- --
-- Vehicle                                                                    --
-- -------------------------------------------------------------------------- --

local bikes = {
  [272] = true, -- Green BMX
  [273] = true, -- Brown BMX
  [274] = true, -- Crap BMX
  [277] = true, -- Blue BMX
  [278] = true, -- Red BMX
  [279] = true, -- Bicycle
  [280] = true, -- Mountain bike
  [281] = true, -- Lady bike
  [282] = true, -- Racer bike
  [283] = true, -- Aquaberry bike
}

---@param vehicle integer
---@return boolean
function Util.IsBike(vehicle)
  return bikes[VehicleGetModelId(vehicle)] or false
end

local bmxs = {
  [272] = true, -- Green BMX
  [273] = true, -- Brown BMX
  [274] = true, -- Crap BMX
  [277] = true, -- Blue BMX
  [278] = true, -- Red BMX
}

---@param vehicle integer
---@return boolean
function Util.IsBMX(vehicle)
  return bmxs[VehicleGetModelId(vehicle)] or false
end

-- -------------------------------------------------------------------------- --
-- Animation                                                                  --
-- -------------------------------------------------------------------------- --

---@return boolean
function Util.IsDoingTricks()
  return PedMePlaying(gPlayer, "Tricks")
    or PedMePlaying(gPlayer, "DoFrontManual")
end

---@param bankNode string
---@return boolean
function Util.MePlaying(bankNode)
  return PedMePlaying(gPlayer, bankNode)
end

---@param actionNode string
---@return boolean
function Util.IsPlaying(actionNode)
  return PedIsPlaying(gPlayer, actionNode, true)
end

---@param actionNode string
function Util.WaitForAnim(actionNode)
  while PedIsPlaying(gPlayer, actionNode, true) do
    Wait(0)
  end
end

---@param actionNode string
---@param actFile string
function Util.PlayAnim(actionNode, actFile)
  PedSetActionNode(gPlayer, actionNode, actFile)
end

---@param actionNode string
---@param actFile string
function Util.PlayAnimIfNotPlaying(actionNode, actFile)
  if not PedIsPlaying(gPlayer, actionNode, true) then
    PedSetActionNode(gPlayer, actionNode, actFile)
  end
end

---@return number
function Util.GetNodeTime()
  return PedGetNodeTime(gPlayer)
end

---@param ped integer
---@param actionNode string
---@param actFile string
---@return boolean playing, integer attempt
function Util.ForcePlayActionNode(ped, actionNode, actFile)
  local maxAttempt = 10
  for attempt = 1, maxAttempt do
    PedSetActionNode(ped, actionNode, actFile)
    if PedIsPlaying(ped, actionNode, true) then return true, attempt end
  end
  return PedIsPlaying(ped, actionNode, true), maxAttempt
end

-- -------------------------------------------------------------------------- --
-- Pedestrian                                                                 --
-- -------------------------------------------------------------------------- --

---@param vehicle integer
---@return integer? ped
function Util.GetDriverFromVehicle(vehicle)
  for _, ped in { PedFindInAreaXYZ(0, 0, 0, 99999) } do
    if PedIsValid(ped) and VehicleFromDriver(ped) == vehicle then return ped end
  end
  return nil
end

---@param meterPerSecond number
function Util.ToKmPerHour(meterPerSecond)
  return meterPerSecond * 3.6
end

-- -------------------------------------------------------------------------- --
-- Input                                                                      --
-- -------------------------------------------------------------------------- --

---@return number
function Util.GetHorizontalStickValue()
  return -GetStickValue(16, 0)
end

---@return number
function Util.GetVerticalStickValue()
  return GetStickValue(17, 0)
end

function Util.GetStickMagnitude()
  return math.sqrt(GetStickValue(16, 0) ^ 2 + GetStickValue(17, 0) ^ 2)
end

---@type table<string, boolean>
local prevStateMap = {}
local isConditionMet = false
---@param uniqueKey string
---@param stickId integer
---@param condition fun(stickValue: number): boolean
---@return boolean
function Util.IsStickConditionJustMet(uniqueKey, stickId, condition)
  isConditionMet = condition(GetStickValue(stickId, 0)) -- 0 is player1 controller

  if isConditionMet and not prevStateMap[uniqueKey] then
    prevStateMap[uniqueKey] = true
    return true
  end

  if not isConditionMet then prevStateMap[uniqueKey] = false end

  return false
end

---@return boolean
function Util.IsBikeLeftOrRightPunchPressed()
  return GetStickValue(10, 0) > 0 or GetStickValue(12, 0) > 0
end

-- -------------------------------------------------------------------------- --
-- Vehicle Speed stuff                                                        --
-- -------------------------------------------------------------------------- --

---@param vehicle integer
---@return number speed
function Util.GetVehicleSpeed(vehicle)
  if BMX_TRICKS.vehSpeeds.map[vehicle] then
    return BMX_TRICKS.vehSpeeds.map[vehicle].speed
  end
  return 0
end

---@return number speed
function Util.GetBikeSpeed()
  return Util.GetVehicleSpeed(VehicleFromDriver(gPlayer))
end

-- -------------------------------------------------------------------------- --
-- Vehicle Speed Thread                                                       --
-- -------------------------------------------------------------------------- --

function _G.TF_VehicleSpeed()
  BMX_TRICKS.vehSpeeds = {
    ---@type table<integer, { lastPos: ArrayOfNumbers3D, lastTime: number, speed: number }>
    map = {},
    currentTime = 0,
    lastTime = 0,
  }
  local t = BMX_TRICKS.vehSpeeds

  ---@param vehicle integer
  local function RegisterVehicle(vehicle)
    t.map[vehicle] = {
      lastPos = { VehicleGetPosXYZ(vehicle) },
      lastTime = 0,
      speed = 0,
    }
  end

  ---@param vehicle integer
  local function UnregisterVehicle(vehicle)
    t.map[vehicle] = nil
  end

  ---@param vehicle integer
  local function UpdateSpeed(vehicle)
    local vehData = t.map[vehicle]
    local currentTime = GetTimer()
    local currentPos = { VehicleGetPosXYZ(vehicle) }

    local deltaX = currentPos[1] - vehData.lastPos[1]
    local deltaY = currentPos[2] - vehData.lastPos[2]
    local deltaZ = currentPos[3] - vehData.lastPos[3]
    local deltaDistance = math.sqrt(deltaX ^ 2 + deltaY ^ 2 + deltaZ ^ 2)

    local speed = 0

    local deltaTime = (currentTime - vehData.lastTime) / 1000
    if deltaTime == 0 or deltaDistance == 0 then
      vehData.speed = speed
      return
    end

    speed = deltaDistance / deltaTime

    vehData.speed = speed
    vehData.lastPos = currentPos
    vehData.lastTime = currentTime
  end

  local driver, allVehicles

  while true do
    Wait(0)

    allVehicles = VehicleFindInAreaXYZ(0, 0, 0, 99999)
    if allVehicles then
      for _, vehicle in ipairs(allVehicles) do
        driver = Util.GetDriverFromVehicle(vehicle)
        if not t.map[vehicle] and PedIsValid(driver) then
          RegisterVehicle(vehicle)
        end
      end
    end

    for vehicle, _ in pairs(t.map) do
      driver = Util.GetDriverFromVehicle(vehicle)
      if
        VehicleIsValid(vehicle)
        and driver
        and PedIsValid(driver)
        and PedIsInVehicle(driver, vehicle)
      then
        UpdateSpeed(vehicle)
      else
        UnregisterVehicle(vehicle)
      end
    end
  end
end
local argument = BMX_TRICKS.IS_BULLY_AE and "TF_VehicleSpeed" or TF_VehicleSpeed
BMX_TRICKS.T_VehicleSpeed = CreateThread(argument)

-- -------------------------------------------------------------------------- --
-- Save to Global Variable                                                    --
-- -------------------------------------------------------------------------- --

BMX_TRICKS.Util = Util
