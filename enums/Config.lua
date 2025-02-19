---@enum (key) EConfig
local Config = {
  -- ------------------------------------------------------------------------ --
  -- Input                                                                    --
  -- ------------------------------------------------------------------------ --

  -- Keyboard

  KEY_COMBINATION_BARSPIN = "KEY_COMBINATION_BARSPIN",
  KEY_BARSPIN = "KEY_BARSPIN",

  KEY_COMBINATION_WHIPLASH = "KEY_COMBINATION_WHIPLASH",
  KEY_WHIPLASH = "KEY_WHIPLASH",

  KEY_COMBINATION_FRONTNUDGE = "KEY_COMBINATION_FRONTNUDGE",
  KEY_FRONTNUDGE = "KEY_FRONTNUDGE",

  KEY_COMBINATION_STOPPIE = "KEY_COMBINATION_STOPPIE",
  KEY_STOPPIE = "KEY_STOPPIE",

  KEY_COMBINATION_WHEELIE = "KEY_COMBINATION_WHEELIE",
  KEY_WHEELIE = "KEY_WHEELIE",

  -- Controller

  CONTROLLER_MIN_STICK = "CONTROLLER_MIN_STICK",
  CONTROLLER_DOUBLETAP_TRESHOLD = "CONTROLLER_DOUBLETAP_TRESHOLD",
  CONTROLLER_BARSPIN_INPUTSEQUENCE = "CONTROLLER_BARSPIN_INPUTSEQUENCE",
  CONTROLLER_WHIPLASH_INPUTSEQUENCE = "CONTROLLER_WHIPLASH_INPUTSEQUENCE",

  CONTROLLER_INPUTSEQUENCE_UPUP = "UpUp",
  CONTROLLER_INPUTSEQUENCE_UPDOWNDOWN = "UpDownDown",
  CONTROLLER_INPUTSEQUENCE_DOWNUPUP = "DownUpUp",
  CONTROLLER_INPUTSEQUENCE_DOWNDOWN = "DownDown",

  -- ------------------------------------------------------------------------ --
  -- Animation Gameplay                                                       --
  -- ------------------------------------------------------------------------ --

  ALLOW_MID_AIR = "ALLOW_MID_AIR",
  FRONTNUDGE_BRAKE = "FRONTNUDGE_BRAKE",
  BARSPIN_MIN_SPEED = "BARSPIN_MIN_SPEED",
  WHIPLASH_MIN_SPEED = "WHIPLASH_MIN_SPEED",
  FRONTNUDGE_MIN_SPEED = "FRONTNUDGE_MIN_SPEED",
  STOPPIE_MIN_SPEED = "STOPPIE_MIN_SPEED",
  WHEELIE_MIN_SPEED = "WHEELIE_MIN_SPEED",

  -- ------------------------------------------------------------------------ --
  -- Additional Anim                                                          --
  -- ------------------------------------------------------------------------ --

  PRE_BARSPIN_ANIM = "PRE_BARSPIN_ANIM",
  POST_BARSPIN_ANIM = "POST_BARSPIN_ANIM",
  PRE_WHIPLASH_ANIM = "PRE_WHIPLASH_ANIM",
  POST_WHIPLASH_ANIM = "POST_WHIPLASH_ANIM",
  POST_FRONTNUDGE_ANIM = "POST_FRONTNUDGE_ANIM",
  POST_STOPPIE_ANIM = "POST_STOPPIE_ANIM",
  PRE_WHEELIE_ANIM = "PRE_WHEELIE_ANIM",
  POST_WHEELIE_ANIM = "POST_WHEELIE_ANIM",

  -- ------------------------------------------------------------------------ --
  -- Activation Requirement                                                   --
  -- ------------------------------------------------------------------------ --

  BMX_ONLY = "BMX_ONLY",
}

-- -------------------------------------------------------------------------- --
-- Alias                                                                      --
-- -------------------------------------------------------------------------- --

-- TODO: Match with the above keys

---@alias AConfig
---| "KEY_COMBINATION_BARSPIN"
---| "KEY_BARSPIN"
---| "KEY_COMBINATION_WHIPLASH"
---| "KEY_WHIPLASH"
---| "KEY_COMBINATION_FRONTNUDGE"
---| "KEY_FRONTNUDGE"
---| "KEY_COMBINATION_STOPPIE"
---| "KEY_STOPPIE"
---| "KEY_COMBINATION_WHEELIE"
---| "KEY_WHEELIE"
---| "PRE_BARSPIN_ANIM"
---| "POST_BARSPIN_ANIM"
---| "PRE_WHIPLASH_ANIM"
---| "POST_STOPPIE_ANIM"
---| "PRE_WHEELIE_ANIM"
---| "POST_WHEELIE_ANIM"
---| "BMX_ONLY"

-- -------------------------------------------------------------------------- --
-- Save to Global Variable                                                    --
-- -------------------------------------------------------------------------- --

BMX_TRICKS.Enum.Config = Config

-- Developer signature
function BMX_Tricks_mod_by_RBS_ID()
  -- This function does nothing but serves as a watermark
  return "You are not allowed to redistribute/re-upload this mod to anywhere else!"
end
