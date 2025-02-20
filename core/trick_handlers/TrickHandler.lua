-- -------------------------------------------------------------------------- --
-- Class                                                                      --
-- -------------------------------------------------------------------------- --

---@class TrickHandler
---@field trickName string
---@field enumEvents TrickHandler_EnumEvents
---@field initialTrickHandler TrickHandler_InitialHandler
---@field endingTrickHandler TrickHandler_EndingHandler
---@field keyboardInputCondition TrickHandler_InputCondition
---@field keyboardPlayingHandler TrickHandler_PlayingHandler
---@field keyboardFreezeHandler TrickHandler_FreezeHandler
---@field controllerInputCondition TrickHandler_InputCondition
---@field controllerPlayingHandler TrickHandler_PlayingHandler
---@field controllerFreezeHandler TrickHandler_FreezeHandler
---@field mobileInputCondition TrickHandler_InputCondition
---@field mobilePlayingHandler TrickHandler_PlayingHandler
---@field mobileFreezeHandler TrickHandler_FreezeHandler
local TrickHandler = {}
TrickHandler.__index = TrickHandler

-- -------------------------------------------------------------------------- --
-- Constructor                                                                --
-- -------------------------------------------------------------------------- --

---@param name string
---@return TrickHandler
function TrickHandler.new(name)
  local obj = setmetatable({}, TrickHandler)
  obj.trickName = name
  return obj
end

-- -------------------------------------------------------------------------- --
-- Enum                                                                       --
-- -------------------------------------------------------------------------- --

---@return TrickHandler_EnumEvents
function TrickHandler:GetEnumEvents()
  return self.enumEvents
end

---@param enumEvents TrickHandler_EnumEvents
function TrickHandler:SetEnumEvents(enumEvents)
  self.enumEvents = enumEvents
end

-- -------------------------------------------------------------------------- --
-- Additional Animation Handler                                               --
-- -------------------------------------------------------------------------- --

---@return TrickHandler_InitialHandler
function TrickHandler:GetInitialTrickHandler()
  return self.initialTrickHandler
end

---@param handler TrickHandler_InitialHandler
function TrickHandler:SetInitialTrickHandler(handler)
  self.initialTrickHandler = handler
end

---@return TrickHandler_EndingHandler
function TrickHandler:GetEndingTrickHandler()
  return self.endingTrickHandler
end

---@param handler TrickHandler_EndingHandler
function TrickHandler:SetEndingTrickHandler(handler)
  self.endingTrickHandler = handler
end

-- -------------------------------------------------------------------------- --
-- Keyboard                                                                   --
-- -------------------------------------------------------------------------- --

-- Input condition

---@return TrickHandler_InputCondition
function TrickHandler:GetKeyboardInputCondition()
  return self.keyboardInputCondition
end

---@param condition TrickHandler_InputCondition
function TrickHandler:SetKeyboardInputCondition(condition)
  self.keyboardInputCondition = condition
end

-- Playing Handler

---@return TrickHandler_PlayingHandler
function TrickHandler:GetKeyboardPlayingHandler()
  return self.keyboardPlayingHandler
end

---@param handler TrickHandler_PlayingHandler
function TrickHandler:SetKeyboardPlayingHandler(handler)
  self.keyboardPlayingHandler = handler
end

-- Freeze Handler

---@return TrickHandler_FreezeHandler
function TrickHandler:GetKeyboardFreezeHandler()
  return self.keyboardFreezeHandler
end

---@param handler TrickHandler_FreezeHandler
function TrickHandler:SetKeyboardFreezeHandler(handler)
  self.keyboardFreezeHandler = handler
end

-- -------------------------------------------------------------------------- --
-- Controller                                                                 --
-- -------------------------------------------------------------------------- --

-- Input condition

---@return TrickHandler_InputCondition
function TrickHandler:GetControllerInputCondition()
  return self.controllerInputCondition
end

---@param condition TrickHandler_InputCondition
function TrickHandler:SetControllerInputCondition(condition)
  self.controllerInputCondition = condition
end

-- While playing

---@return TrickHandler_PlayingHandler
function TrickHandler:GetControllerPlayingHandler()
  return self.controllerPlayingHandler
end

---@param handler TrickHandler_PlayingHandler
function TrickHandler:SetControllerPlayingHandler(handler)
  self.controllerPlayingHandler = handler
end

-- Freeze handler

---@return TrickHandler_FreezeHandler
function TrickHandler:GetControllerFreezeHandler()
  return self.controllerFreezeHandler
end

---@param handler TrickHandler_FreezeHandler
function TrickHandler:SetControllerFreezeHandler(handler)
  self.controllerFreezeHandler = handler
end

-- -------------------------------------------------------------------------- --
-- Mobile, Bully AE                                                           --
-- -------------------------------------------------------------------------- --

-- Input condition

---@return TrickHandler_InputCondition
function TrickHandler:GetTouchscreenInputCondition()
  return self.touchscreenInputCondition
end

---@param condition TrickHandler_InputCondition
function TrickHandler:SetTouchscreenInputCondition(condition)
  self.touchscreenInputCondition = condition
end

-- While playing

---@return TrickHandler_PlayingHandler
function TrickHandler:GetTouchscreenPlayingHandler()
  return self.touchscreenPlayingHandler
end

---@param handler TrickHandler_PlayingHandler
function TrickHandler:SetTouchscreenPlayingHandler(handler)
  self.touchscreenPlayingHandler = handler
end

-- Freeze handler

---@return TrickHandler_FreezeHandler
function TrickHandler:GetTouchscreenFreezeHandler()
  return self.touchscreenFreezeHandler
end

---@param handler TrickHandler_FreezeHandler
function TrickHandler:SetTouchscreenFreezeHandler(handler)
  self.touchscreenFreezeHandler = handler
end

-- -------------------------------------------------------------------------- --
-- Miscellaneous                                                              --
-- -------------------------------------------------------------------------- --

---@return string
function TrickHandler:GetTrickName()
  return self.trickName
end

-- -------------------------------------------------------------------------- --
-- Save to Global Variable                                                    --
-- -------------------------------------------------------------------------- --

BMXTRICKS_TrickHandler = TrickHandler

-- -------------------------------------------------------------------------- --
-- Create Objects                                                             --
-- -------------------------------------------------------------------------- --

local filenames = {
  "BarspinTrickHandler",
  "WhiplashTrickHandler",
  "FrontnudgeTrickHandler",
  "StoppieTrickHandler",
  "WheelieTrickHandler",
}
for _, filename in ipairs(filenames) do
  if BMX_TRICKS.IS_BULLY_AE then
    local dir = BMX_TRICKS.AE_MODDIR .. "core/trick_handlers/"
    BMX_TRICKS.Util.AELoadScript(dir, filename .. ".lur")
  else
    LoadScript("core/trick_handlers/" .. filename .. ".lua")
  end
end

-- -------------------------------------------------------------------------- --
-- Type Definitions                                                           --
-- -------------------------------------------------------------------------- --

---@alias TrickHandler_PlayingHandlerReturnValue
---| true  # Continue doing the trick
---| false # Ends the trick - Go to end state
---| nil   # Froze the actor - Go to freeze state

---@alias TrickHandler_FreezeHandlerReturnValue
---| true  # Go back to perform the trick - Go to playing state
---| false # Ends the trick - Go to end state
---| nil   # Continue freezing

---@alias TrickHandler_EnumEventsKey "init"|"playingStart"|"playing"|"playingEnd"|"freezeStart"|"freeze"|"freezeEnd"|"ending"
---@alias TrickHandler_EnumEvents table<TrickHandler_EnumEventsKey, EEvent>

---@alias TrickHandler_InitialHandler fun(config: Config)
---@alias TrickHandler_EndingHandler fun(config: Config)

---Returns a boolean whether should start the trick
---@alias TrickHandler_InputCondition fun(config: Config): boolean
---Returns a boolean whether should continue doing tricks, or returns nil when the actor should freeze
---@alias TrickHandler_PlayingHandler fun(config: Config): TrickHandler_PlayingHandlerReturnValue
---Returns a boolean whether should back to perform the trick
---@alias TrickHandler_FreezeHandler fun(config: Config): TrickHandler_FreezeHandlerReturnValue
