-- -------------------------------------------------------------------------- --
-- Type Definitions                                                           --
-- -------------------------------------------------------------------------- --

---@alias EventName string
---@alias EventCallback function
---@alias EventListeners table<EventName, EventCallback[]>
---@alias EventEmitter fun(eventName: EventName, ...: any)

-- -------------------------------------------------------------------------- --
-- Class                                                                      --
-- -------------------------------------------------------------------------- --

---@class EventManager
---@field listeners EventListeners
local EventManager = {}
EventManager.__index = EventManager

-- -------------------------------------------------------------------------- --
-- Constructor                                                                --
-- -------------------------------------------------------------------------- --

---@return EventManager
function EventManager.new()
  local obj = setmetatable({}, EventManager)
  obj.listeners = {}
  return obj
end

-- -------------------------------------------------------------------------- --
-- Methods                                                                    --
-- -------------------------------------------------------------------------- --

---@param eventName EventName
---@param callback EventCallback
function EventManager:AddListener(eventName, callback)
  if not self.listeners[eventName] then
    self.listeners[eventName] = {}
  end
  table.insert(self.listeners[eventName], callback)
end

---@param eventName EventName
---@param ... any
function EventManager:Emit(eventName, ...)
  if self.listeners[eventName] then
    for _, callback in ipairs(self.listeners[eventName]) do
      callback(unpack(arg))
    end
  end
end

---@param eventName EventName
---@param callback EventCallback
function EventManager:RemoveListener(eventName, callback)
  if self.listeners[eventName] then
    for index, registeredCallback in ipairs(self.listeners[eventName]) do
      if registeredCallback == callback then
        table.remove(self.listeners[eventName], index)
        break
      end
    end
  end
end

-- -------------------------------------------------------------------------- --
-- Save to Global Variable                                                    --
-- -------------------------------------------------------------------------- --

BMXTRICKS_EventManager = EventManager

-- Developer signature
function BMX_Tricks_mod_by_RBS_ID()
  -- This function does nothing but serves as a watermark
  return "You are not allowed to redistribute/re-upload this mod to anywhere else!"
end