-- -------------------------------------------------------------------------- --
-- Load Scripts                                                               --
-- -------------------------------------------------------------------------- --

local files = {
  { dir = "enums/", name = "index" },
  { dir = "constants/", name = "index" },
  { dir = "core/", name = "EventManager" },
  { dir = "core/trick_handlers/", name = "TrickHandler" },
}
for _, file in ipairs(files) do
  if BMX_TRICKS.IS_BULLY_AE then
    local dir = BMX_TRICKS.AE_MODDIR .. file.dir
    local filename = file.name .. ".lur"
    BMX_TRICKS.Util.AELoadScript(dir, filename)
  else
    LoadScript(file.dir .. file.name .. ".lua")
  end
end

-- -------------------------------------------------------------------------- --
-- Localize                                                                   --
-- -------------------------------------------------------------------------- --

-- Enable keyword coloring by adding `---@class <name>` above the variable
-- declaration. Using `---@type <type>` will not work.
-- Extension name: "Lua", by sumneko

---@class Enum
local Enum = BMX_TRICKS.Enum
---@class Constant
local Const = BMX_TRICKS.Constant
---@class Util
local Util = BMX_TRICKS.Util
---@class EventManager
local EventManager = BMXTRICKS_EventManager

-- -------------------------------------------------------------------------- --
-- Class                                                                      --
-- -------------------------------------------------------------------------- --

---@class BMXTrick
---@field isEnabled boolean
---@field config Config
---@field eventManager EventManager
---@field lastTrick ETrickName? The name of last played trick
---@field currentTrick ETrickName? The name of currently played trick
---@field trickState ETrickState The state of the current trick
---@field lastTrickState ETrickState The last state of the current trick
---@field lastTrickPlayed number The last time trick was played
---@field trickStartTime number The time of additional trick animation starts
---@field actualTrickStartTime number The time of the actual trick animation starts
---@field trickDatas table<ETrickName, { key: string, keyCombination: string, handler: TrickHandler }>
---@field trickEventData BMXTrick_TrickEventData
local BMXTrick = {}
BMXTrick.__index = BMXTrick

-- -------------------------------------------------------------------------- --
-- Constructor                                                                --
-- -------------------------------------------------------------------------- --

---@param config Config
---@return BMXTrick
function BMXTrick.new(config)
  local obj = setmetatable({}, BMXTrick)

  obj.isEnabled = true
  obj.config = config
  obj.eventManager = EventManager.new()

  obj.currentTrick = nil
  obj.lastTrickState = Enum.TrickState.Idle
  obj.trickState = Enum.TrickState.Idle

  obj.trickDatas = {}

  obj.trickEventData = {
    trickName = nil,
    trickState = Enum.TrickState.Idle,
    trickStartTime = 0,
    actualTrickStartTime = 0,
    lastTrickPlayed = 0,
    startPosition = { 0, 0, 0 },
    actualStartPosition = { 0, 0, 0 },
    endTrickPosition = { 0, 0, 0 },
    startHeading = 0,
    actualStartHeading = 0,
    endHeading = 0,
  }

  obj:Init()

  return obj
end

-- -------------------------------------------------------------------------- --
-- Core Methods                                                               --
-- -------------------------------------------------------------------------- --

function BMXTrick:Init()
  local confKeyBarspin = Enum.Config.KEY_BARSPIN
  local confKeyWhiplash = Enum.Config.KEY_WHIPLASH
  local confKeyFrontnudge = Enum.Config.KEY_FRONTNUDGE
  local confKeyStoppie = Enum.Config.KEY_STOPPIE
  local confKeyWheelie = Enum.Config.KEY_WHEELIE

  local confKeyCombBarspin = Enum.Config.KEY_COMBINATION_BARSPIN
  local confKeyCombWhiplash = Enum.Config.KEY_COMBINATION_WHIPLASH
  local confKeyCombFrontnudge = Enum.Config.KEY_COMBINATION_FRONTNUDGE
  local confKeyCombStoppie = Enum.Config.KEY_COMBINATION_STOPPIE
  local confKeyCombWheelie = Enum.Config.KEY_COMBINATION_WHEELIE

  local keyBarspin = self.config:GetSettingValue(confKeyBarspin) --[[@as string]]
  local keyWhiplash = self.config:GetSettingValue(confKeyWhiplash) --[[@as string]]
  local keyFrontnudge = self.config:GetSettingValue(confKeyFrontnudge) --[[@as string]]
  local keyStoppie = self.config:GetSettingValue(confKeyStoppie) --[[@as string]]
  local keyWheelie = self.config:GetSettingValue(confKeyWheelie) --[[@as string]]

  local keyCombBarspin = self.config:GetSettingValue(confKeyCombBarspin) --[[@as string]]
  local keyCombWhiplash = self.config:GetSettingValue(confKeyCombWhiplash) --[[@as string]]
  local keyCombFrontnudge = self.config:GetSettingValue(confKeyCombFrontnudge) --[[@as string]]
  local keyCombStoppie = self.config:GetSettingValue(confKeyCombStoppie) --[[@as string]]
  local keyCombWheelie = self.config:GetSettingValue(confKeyCombWheelie) --[[@as string]]

  local barspinTrickHandler = BMXTRICKS_BarspinTrickHandler
  local whiplashTrickHandler = BMXTRICKS_WhiplashTrickHandler
  local frontnudgeTrickHandler = BMXTRICKS_FrontnudgeTrickHandler
  local stoppieTrickHandler = BMXTRICKS_StoppieTrickHandler
  local wheelieTrickHandler = BMXTRICKS_WheelieTrickHandler

  ---@type { [string]: { keyCombination: string, name: ETrickName, handler: TrickHandler } }
  local trickDatas = {
    [keyBarspin] = {
      keyCombination = keyCombBarspin,
      name = barspinTrickHandler:GetTrickName(),
      handler = barspinTrickHandler,
    },
    [keyWhiplash] = {
      keyCombination = keyCombWhiplash,
      name = whiplashTrickHandler:GetTrickName(),
      handler = whiplashTrickHandler,
    },
    [keyFrontnudge] = {
      keyCombination = keyCombFrontnudge,
      name = frontnudgeTrickHandler:GetTrickName(),
      handler = frontnudgeTrickHandler,
    },
    [keyStoppie] = {
      keyCombination = keyCombStoppie,
      name = stoppieTrickHandler:GetTrickName(),
      handler = stoppieTrickHandler,
    },
    [keyWheelie] = {
      keyCombination = keyCombWheelie,
      name = wheelieTrickHandler:GetTrickName(),
      handler = wheelieTrickHandler,
    },
  }
  for key, trickData in pairs(trickDatas) do
    local keyData = { key = key, keyCombination = trickData.keyCombination }
    self:RegisterTrick(trickData.name, keyData, trickData.handler)
  end
end

local allowMidAir
---@return boolean
function BMXTrick:CanPerformInMidAir()
  allowMidAir = self.config:GetSettingValue(Enum.Config.ALLOW_MID_AIR) --[[@as boolean]]
  return allowMidAir or not Util.MePlaying("HOP")
end

---@return boolean
function BMXTrick:CanDoTricks()
  return (not BMX_TRICKS.IS_BULLY_AE and not IsConsoleActive() or true)
    and PlayerIsInAnyVehicle()
    and self:CanPerformInMidAir()
    and self:CanDoTricksOnBike(VehicleFromDriver(gPlayer))
    and not self:IsDoingTricks()
    and self.trickState == Enum.TrickState.Idle
end

function BMXTrick:MainLogic()
  if self.isEnabled then
    if self:CanDoTricks() then self:CheckInitialTrickInput() end

    if self.trickState == Enum.TrickState.Playing then
      self:HandlePlayingState()
    elseif self.trickState == Enum.TrickState.Freeze then
      self:HandleFreezeState()
    elseif self.trickState == Enum.TrickState.End then
      self:HandleEndingTrick()
    end
  end
end

-- -------------------------------------------------------------------------- --

---@param trickName ETrickName
---@param keyData { key: string, keyCombination: string }
---@param handler TrickHandler
function BMXTrick:RegisterTrick(trickName, keyData, handler)
  self.trickDatas[trickName] = {}
  self.trickDatas[trickName].key = keyData.key
  self.trickDatas[trickName].keyCombination = keyData.keyCombination
  self.trickDatas[trickName].handler = handler
end

-- -------------------------------------------------------------------------- --
-- Trick State Handlers                                                       --
-- -------------------------------------------------------------------------- --

local condition

function BMXTrick:CheckInitialTrickInput()
  for trickName, trickData in pairs(self.trickDatas) do
    condition = self:GetAppropriateTrickInputCondition(trickData.handler)
    if condition and condition(self.config) then
      self:SetCurrentTrickName(trickName)
      self:SetTrickState(Enum.TrickState.Initial)
      self.trickStartTime = GetTimer()

      self:UpdateAllTrickEventData()

      local eventEnum = trickData.handler:GetEnumEvents()
      self:EmitTrickEvent(
        Enum.Event.OnTrickStart,
        eventEnum.init,
        self.trickEventData
      )

      local handler = trickData.handler:GetInitialTrickHandler()
      handler(self.config)

      -- Fix Bully AE touchscreen cannot do stoppie
      -- if not self:GetAppropriateTrickPlayingHandler(trickData.handler) then
      --   return
      -- end

      self:SetTrickState(Enum.TrickState.Playing)
      break
    end
  end
end

function BMXTrick:HandlePlayingState()
  self.actualTrickStartTime = GetTimer()

  local trickName = self.currentTrick --[[@as ETrickName]]
  local trickData = self.trickDatas[trickName]
  local eventEnum = trickData.handler:GetEnumEvents()

  local handler = self:GetAppropriateTrickPlayingHandler(trickData.handler)
  if not handler then
    -- self:SetTrickState(Enum.TrickState.Idle)
    return
  end

  self:UpdateAllTrickEventData()
  self:EmitTrickEvent(
    Enum.Event.OnTrickUpdate,
    eventEnum.playingStart,
    self.trickEventData
  )

  ---@type boolean?
  local continue
  repeat
    Wait(0)
    continue = handler(self.config)
    if continue ~= true then break end -- Don't trigger event when returns false|nil
    self:EmitTrickEvent(
      Enum.Event.OnTrickUpdate,
      eventEnum.playing,
      self.trickEventData
    )
  until continue ~= true

  self:EmitTrickEvent(
    Enum.Event.OnTrickUpdate,
    eventEnum.playingEnd,
    self.trickEventData
  )

  self:SetTrickState(Enum.TrickState.End)
  if continue == nil then self:SetTrickState(Enum.TrickState.Freeze) end
end

function BMXTrick:HandleFreezeState()
  local trick = self.currentTrick --[[@as ETrickName]]
  local trickData = self.trickDatas[trick]
  local eventEnum = trickData.handler:GetEnumEvents()

  local handler = self:GetAppropriateTrickFreezeHandler(trickData.handler)
  if not handler then return end

  self:EmitTrickEvent(
    Enum.Event.OnTrickFreezeStart,
    eventEnum.freezeStart,
    self.trickEventData
  )

  ---@type TrickHandler_FreezeHandlerReturnValue
  local goback
  repeat
    goback = handler(self.config)
    if goback ~= nil then break end
    self:EmitTrickEvent(
      Enum.Event.OnTrickFreeze,
      eventEnum.freeze,
      self.trickEventData
    )
    Wait(0)
  until goback ~= nil

  self:EmitTrickEvent(
    Enum.Event.OnTrickFreezeEnd,
    eventEnum.freezeEnd,
    self.trickEventData
  )

  self:SetTrickState(Enum.TrickState.End)
  if goback then self:SetTrickState(Enum.TrickState.Playing) end
end

function BMXTrick:HandleEndingTrick()
  self.lastTrickPlayed = GetTimer()

  local trickName = self.currentTrick --[[@as ETrickName]]
  local trickData = self.trickDatas[trickName]
  local eventEnum = trickData.handler:GetEnumEvents()

  self:UpdateAllTrickEventData()

  self:EmitTrickEvent(
    Enum.Event.OnTrickEnd,
    eventEnum.ending,
    self.trickEventData
  )

  local handler = trickData.handler:GetEndingTrickHandler()
  handler(self.config)

  self:SetTrickState(Enum.TrickState.Idle)
  self:SetCurrentTrickName(nil)
end

--

---@param trickHandler TrickHandler
---@return TrickHandler_InputCondition? condition
function BMXTrick:GetAppropriateTrickInputCondition(trickHandler)
  if Util.IsBullyAE() or IsUsingJoystick(Enum.Controller.PLAYER1) then
    return trickHandler:GetControllerInputCondition()
  end
  return trickHandler:GetKeyboardInputCondition()
end

---@param trickHandler TrickHandler
---@return TrickHandler_PlayingHandler? handler
function BMXTrick:GetAppropriateTrickPlayingHandler(trickHandler)
  if Util.IsBullyAE() or IsUsingJoystick(Enum.Controller.PLAYER1) then
    return trickHandler:GetControllerPlayingHandler()
  end
  return trickHandler:GetKeyboardPlayingHandler()
end

---@param trickHandler TrickHandler
---@return TrickHandler_FreezeHandler? handler
function BMXTrick:GetAppropriateTrickFreezeHandler(trickHandler)
  if Util.IsBullyAE() or IsUsingJoystick(Enum.Controller.PLAYER1) then
    return trickHandler:GetControllerFreezeHandler()
  end
  return trickHandler:GetKeyboardFreezeHandler()
end

--

---@param trickEvent EEvent
---@param currentTrickEvent EEvent
---@param ... any
function BMXTrick:EmitTrickEvent(trickEvent, currentTrickEvent, ...)
  self.eventManager:Emit(trickEvent, unpack(arg))
  self.eventManager:Emit(currentTrickEvent, unpack(arg))

  if not Util.IsBullyAE() then
    local prefix = "BMXTricks:"
    RunLocalEvent(prefix .. trickEvent, unpack(arg))
    RunLocalEvent(prefix .. currentTrickEvent, unpack(arg))
  end
end

-- -------------------------------------------------------------------------- --
-- Utilities                                                                  --
-- -------------------------------------------------------------------------- --

---@param name ETrickName?
function BMXTrick:SetCurrentTrickName(name)
  self.lastTrick = self.currentTrick
  self.currentTrick = name
end

---@param state ETrickState
function BMXTrick:SetTrickState(state)
  self.lastTrickState = self.trickState
  self.trickState = state
end

---@param key BMXTrick_TrickKeyEventData
---@param value BMXTrick_TrickValueEventData
function BMXTrick:UpdateTrickEventData(key, value)
  if type(value) == "table" then
    -- Don't replace the table
    for vKey, vValue in pairs(value) do
      self.trickEventData[vKey] = vValue
    end
  else
    self.trickEventData[key] = value
  end
end

function BMXTrick:UpdateAllTrickEventData()
  self.trickEventData.trickName = self.currentTrick
  self.trickEventData.trickStartTime = self.trickStartTime
  self.trickEventData.actualTrickStartTime = self.actualTrickStartTime
  self.trickEventData.lastTrickPlayed = self.lastTrickPlayed

  if
    self.lastTrickState == Enum.TrickState.Idle
    and self.trickState == Enum.TrickState.Initial
  then
    self.trickEventData.startPosition = { PlayerGetPosXYZ() }
    self.trickEventData.startHeading = PedGetHeading(gPlayer) --[[@as number]]

    --
  elseif
    self.lastTrickState == Enum.TrickState.Initial
    and self.trickState == Enum.TrickState.Playing
  then
    self.trickEventData.actualStartPosition = { PlayerGetPosXYZ() }
    self.trickEventData.actualStartHeading = PedGetHeading(gPlayer) --[[@as number]]

    --
  elseif
    self.lastTrickState == Enum.TrickState.Playing
    and self.trickState == Enum.TrickState.Freeze
  then
    -- TODO: Track something, like position, etc..

    --
  elseif
    self.lastTrickState == Enum.TrickState.Freeze
    and self.trickState == Enum.TrickState.Playing
  then
    -- TODO: Track something, like position, etc..

    --
  elseif
    self.lastTrickState == Enum.TrickState.Playing
    and self.trickState == Enum.TrickState.End
  then
    self.trickEventData.endTrickPosition = { PlayerGetPosXYZ() }
    self.trickEventData.endHeading = PedGetHeading(gPlayer) --[[@as number]]
  end
end

-- -------------------------------------------------------------------------- --
-- API                                                                        --
-- -------------------------------------------------------------------------- --

---@param enable boolean
function BMXTrick:SetEnabled(enable)
  self.isEnabled = enable

  local eventName = enable and Enum.Event.OnModEnabled
    or Enum.Event.OnModDisabled

  self.eventManager:Emit(eventName)
end

---@return EventManager
function BMXTrick:GetEventManager()
  return self.eventManager
end

---@return Config
function BMXTrick:GetConfig()
  return self.config
end

local bmxOnly
---@param vehicle integer
---@return boolean
function BMXTrick:CanDoTricksOnBike(vehicle)
  bmxOnly = self.config:GetSettingValue(Enum.Config.BMX_ONLY)
  return (bmxOnly and Util.IsBMX(vehicle))
    or (not bmxOnly and Util.IsBike(vehicle))
end

function BMXTrick:IsDoingTricks()
  return Util.MePlaying("DoFrontManual") or Util.MePlaying("BMXTricks")
end

---@return ETrickName?
function BMXTrick:GetCurrentTrickName()
  return self.currentTrick
end

---@return ETrickName?
function BMXTrick:GetLastTrickName()
  return self.currentTrick
end

---@return ETrickState
function BMXTrick:GetLastTrickState()
  return self.lastTrickState
end

---@return ETrickState
function BMXTrick:GetTrickState()
  return self.trickState
end

-- -------------------------------------------------------------------------- --
-- Save to Global Variable                                                    --
-- -------------------------------------------------------------------------- --

BMXTRICKS_BMXTrick = BMXTrick

-- -------------------------------------------------------------------------- --
-- Type Definitions                                                           --
-- -------------------------------------------------------------------------- --

---@alias BMXTrick_TrickEventData { trickName: ETrickName?, trickStartTime: number, actualTrickStartTime: number, lastTrickPlayed: number, startPosition: ArrayOfNumbers3D, actualStartPosition: ArrayOfNumbers3D, endTrickPosition: ArrayOfNumbers3D, startHeading: number, actualStartHeading: number, endHeading: number }
---@alias BMXTrick_TrickKeyEventData
---| "trickName"
---| "trickStartTime"
---| "actualTrickStartTime"
---| "lastTrickPlayed"
---| "startPosition"
---| "actualStartPosition"
---| "endTrickPosition"
---| "startHeading"
---| "actualStartHeading"
---| "endHeading"
---@alias BMXTrick_TrickValueEventData
---| ArrayOfNumbers3D
---| ETrickName?
---| number
