-- -------------------------------------------------------------------------- --
-- Utilities / Helper Functions                                               --
-- -------------------------------------------------------------------------- --

---Reference:
---[Code](https://help.interfaceware.com/v6/extract-a-filename-from-a-file-path),
---[Regex](https://onecompiler.com/lua/3zzskbj4q)
---@param path string
---@return string
local function GetFilenameWithExtensionFromPath(path)
  local startIndex, _ = string.find(path, "[^%\\/]-$")
  ---@diagnostic disable-next-line: param-type-mismatch
  return string.sub(path, startIndex, string.len(path))
end

---@param value any
---@return boolean
local function IsBoolean(value)
  return ({ ["true"] = true, ["false"] = true })[value] or false
end

---@param str string
---@param by string
---@return boolean
local function IsStringEnclosedBy(str, by)
  return string.sub(str, 1, 1) == by and string.sub(str, -1) == by
end

-- -------------------------------------------------------------------------- --
-- Types                                                                      --
-- -------------------------------------------------------------------------- --

---@alias ConfigKey string
---@alias ConfigValue boolean|number|string
---@alias ConfigSetting table<string, ConfigValue>

-- -------------------------------------------------------------------------- --

---@class Config
---@field private _filePath string
---@field private _filenameWithExtension string
---@field private _configUserdata userdata
---@field private _CompareSettingValuesAndApply fun(self: Config)
---@field private _LoadFile fun(self: Config)
---@field private _ReadSettings fun(self: Config)
---@field settings ConfigSetting
---@field aeUserSettings ConfigSetting
---@field keys ConfigKey[]
local Config = {}
Config.__index = Config

-- -------------------------------------------------------------------------- --
-- Constructor                                                                --
-- -------------------------------------------------------------------------- --

---@param filePath string
---@param defaultSetting ConfigSetting
---@param aeUserSetting ConfigSetting
---@return Config
function Config.new(filePath, defaultSetting, aeUserSetting)
  local obj = setmetatable({}, Config)

  obj._filePath = filePath
  obj._filenameWithExtension = not BMX_TRICKS.IS_BULLY_AE
      and GetFilenameWithExtensionFromPath(filePath)
    or ""
  obj._configUserdata = nil
  obj.settings = defaultSetting
  obj.aeUserSettings = aeUserSetting
  obj.keys = {}

  -- Insert keys
  for key, _ in pairs(defaultSetting) do
    table.insert(obj.keys, key)
  end

  -- Sort config keys in ascending
  table.sort(obj.keys, function(a, b)
    return a < b
  end)

  if BMX_TRICKS.IS_BULLY_AE then
    obj:_CompareSettingValuesAndApply()
  else
    obj:_LoadFile()
    obj:_ReadSettings()
  end

  return obj
end

-- -------------------------------------------------------------------------- --
-- Private Methods                                                            --
-- -------------------------------------------------------------------------- --

function Config:_CompareSettingValuesAndApply()
  local function ShowErrorAndInfLoop(message)
    MinigameSetAnnouncement(message, true)
    Wait(10000) -- 10 second
    MinigameReleaseCompletion()
    while true do
      Wait(0)
    end
  end

  for key, value in pairs(self.settings) do
    -- If key doesn't exist
    if self.aeUserSettings[key] == nil then
      ShowErrorAndInfLoop("Missing config key " .. key)
      return
    end

    -- If the user setting value type doesn't match with the default setting
    -- value type
    if type(self.aeUserSettings[key]) ~= type(value) then
      ShowErrorAndInfLoop("Incorrect setting value type on key " .. key)
      return
    end

    -- Apply user setting
    self:SetSettingValue(key, self.aeUserSettings[key])
  end
end

function Config:_LoadFile()
  self._configUserdata = LoadConfigFile(self._filePath)
  if IsConfigMissing(self._configUserdata) then
    error(string.format('Missing config file "%s".', self._filePath))
  end
end

function Config:_ReadSettings()
  local indent = "  "

  local errorMessage =
    string.format('Failed to read config file "%s".\n', self._filePath)

  for key, defaultSettingValue in pairs(self.settings) do
    -- local configFunc = GetConfigValueFunction(type(defaultSettingValue))
    -- local settingValue = configFunc(self._configUserdata, key) --[[@as string]]
    local settingValue = GetConfigValue(self._configUserdata, key) --[[@as string]]

    -- Validate setting values

    -- Boolean checks
    if
      type(defaultSettingValue) == "boolean"
      and not IsBoolean(settingValue)
    then
      local str1 = indent .. 'Invalid boolean value on key "%s".\n'
      local str2 = indent
        .. 'The value must be either "true" or "false" (without the "), got "%s" instead.'
      local str = errorMessage .. str1 .. str2
      error(string.format(str, key, tostring(settingValue)))

    -- Number checks
    elseif
      type(defaultSettingValue) == "number" and not tonumber(settingValue)
    then
      local str1 = 'Invalid number value "%s".'
      local str = errorMessage .. str1
      error(errorMessage .. string.format(str, tostring(settingValue)))

    -- String checks
    elseif type(defaultSettingValue) == "string" then
      -- Check if the value starts and ends with single/double quotes
      if
        IsStringEnclosedBy(settingValue, '"')
        or IsStringEnclosedBy(settingValue, "'")
      then
        -- Get the value without the quotes

        settingValue = string.sub(settingValue, 2, -2)
      else
        local str1 = indent
          .. 'Invalid string value in %s: "Missing or incorrect quotes'
        local str = errorMessage .. str1
        error(string.format(str, tostring(settingValue)))
      end
    end

    -- Convert & apply

    local convertedValue = ({
      ["boolean"] = settingValue == "true",
      ["number"] = tonumber(settingValue),
      ["string"] = settingValue,
    })[type(defaultSettingValue)]

    self.settings[key] = convertedValue
  end
end

-- -------------------------------------------------------------------------- --
-- Public Methods                                                             --
-- -------------------------------------------------------------------------- --

---@return string
function Config:GetFilePath()
  return self._filePath
end

---@return userdata
function Config:GetConfigUserdata()
  return self._configUserdata
end

---@return ConfigKey[]
function Config:GetKeys()
  return self.keys
end

---@param key ConfigKey
---@return ConfigValue
function Config:GetSettingValue(key)
  return self.settings[key]
end

---@param key ConfigKey
---@param value ConfigValue
function Config:SetSettingValue(key, value)
  self.settings[key] = value
end

-- -------------------------------------------------------------------------- --
-- Save to Global Variable                                                    --
-- -------------------------------------------------------------------------- --

BMXTRICKS_Config = Config

-- Developer signature
function BMX_Tricks_mod_by_RBS_ID()
  -- This function does nothing but serves as a watermark
  return "You are not allowed to redistribute/re-upload this mod to anywhere else!"
end
