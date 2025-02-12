---@diagnostic disable: assign-type-mismatch, lowercase-global
-- -------------------------------------------------------------------------- --
-- Steps                                                                      --
-- -------------------------------------------------------------------------- --

local isBullyAE = type(_G.PlayerGetUsingTouchScreen) == "function"

local function CreateModRootGlobalVariable()
  _G.BMX_TRICKS = {
    IS_BULLY_AE = isBullyAE,
    AE_MODDIR = "storage/emulated/0/"
      .. "Android/data/com.rockstargames.bully/"
      .. "files/BullyOrig/Scripts/BMXTricks/",

    ---@type Enum
    Enum = nil,

    ---@type Constant
    Constant = nil,

    CONFIG_FILEPATH = "config/bmx_tricks.ini",

    ---@type table<EConfig, boolean|number|string>
    DEFAULT_CONFIG = {
      KEY_COMBINATION_BARSPIN = "LSHIFT",
      KEY_BARSPIN = "1",
      KEY_COMBINATION_WHIPLASH = "LSHIFT",
      KEY_WHIPLASH = "2",
      KEY_COMBINATION_FRONTNUDGE = "LSHIFT",
      KEY_FRONTNUDGE = "3",
      KEY_COMBINATION_STOPPIE = "LSHIFT",
      KEY_STOPPIE = "4",
      KEY_COMBINATION_WHEELIE = "LSHIFT",
      KEY_WHEELIE = "5",

      CONTROLLER_MIN_STICK = 0.9,
      CONTROLLER_DOUBLETAP_TRESHOLD = 300,
      CONTROLLER_BARSPIN_INPUTSEQUENCE = "UpDownDown",
      CONTROLLER_WHIPLASH_INPUTSEQUENCE = "DownUpUp",

      ALLOW_MID_AIR = true,
      FRONTNUDGE_BRAKE = false,
      BARSPIN_MIN_SPEED = 10,
      WHIPLASH_MIN_SPEED = 10,
      FRONTNUDGE_MIN_SPEED = 15,
      STOPPIE_MIN_SPEED = 15,
      WHEELIE_MIN_SPEED = 10,

      PRE_BARSPIN_ANIM = true,
      POST_BARSPIN_ANIM = true,
      PRE_WHIPLASH_ANIM = false,
      POST_WHIPLASH_ANIM = false,
      POST_FRONTNUDGE_ANIM = false,
      POST_STOPPIE_ANIM = true,
      PRE_WHEELIE_ANIM = true,
      POST_WHEELIE_ANIM = true,

      BMX_ONLY = true,
    },

    ---@type BMXTrick
    bmxTrick = nil,
  }
end

local function LoadNecessaryScripts()
  local files = {
    { dir = "core/", name = "Util" },
    { dir = "config/", name = "bmx_tricks" },
    { dir = "core/", name = "Config" },
    { dir = "core/", name = "BMXTrick" },
  }
  for _, file in ipairs(files) do
    if isBullyAE then
      local filename = file.name .. ".lur"
      local chunk, _ = loadfile(BMX_TRICKS.AE_MODDIR .. file.dir .. filename)
      if not chunk then
        local message = string.format("Cannot read or missing %s", filename)
        local duration = 10
        TutorialShowMessage(message, duration * 1000, true)
        while true do
          Wait(0)
        end
        return
      end
      chunk()
    else
      LoadScript(file.dir .. file.name .. ".lua")
    end
  end
end

---@return Config
local function CreateConfigObj()
  local filepath = BMX_TRICKS.CONFIG_FILEPATH
  local defaultConfig = BMX_TRICKS.DEFAULT_CONFIG
  local userConfig = BMX_TRICKS.USER_CONFIG

  local Config = BMXTRICKS_Config
  return Config.new(filepath, defaultConfig, userConfig)
end

local function DefineSingletonMethod()
  ---@return BMXTrick
  function BMX_TRICKS.GetSingleton()
    if not BMX_TRICKS.bmxTrick then
      local config = CreateConfigObj()
      local BMXTrick = BMXTRICKS_BMXTrick
      BMX_TRICKS.bmxTrick = BMXTrick.new(config)
    end

    return BMX_TRICKS.bmxTrick
  end

  BMX_TRICKS.bmxTrick = BMX_TRICKS.GetSingleton()
end

local function ClearNonNeededGlobalVariables()
  BMXTRICKS_Config = nil
  BMXTRICKS_EventManager = nil
  BMXTRICKS_BMXTrick = nil
  BMXTRICKS_TrickHandler = nil
  BMXTRICKS_BarspinTrickHandler = nil
  BMXTRICKS_WhiplashTrickHandler = nil
  BMXTRICKS_FrontnudgeTrickHandler = nil
  BMXTRICKS_StoppieTrickHandler = nil
  BMXTRICKS_WheelieTrickHandler = nil
end

-- -------------------------------------------------------------------------- --
-- Run                                                                        --
-- -------------------------------------------------------------------------- --

local function Init()
  CreateModRootGlobalVariable()
  LoadNecessaryScripts()
  DefineSingletonMethod()
  ClearNonNeededGlobalVariables()
  Init = nil --[[@diagnostic disable-line]]
end

if not isBullyAE then
  Init()
  return
end

-- -------------------------------------------------------------------------- --
-- Define Main Function for Bully AE                                          --
-- -------------------------------------------------------------------------- --

function main()
  while not SystemIsReady() do
    Wait(0)
  end

  Init()

  local bmxTrick = BMX_TRICKS.GetSingleton()

  while true do
    Wait(0)
    bmxTrick:MainLogic()
  end
end
