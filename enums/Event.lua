-- stylua: ignore
-- -------------------------------------------------------------------------- --
-- Event Enumeration                                                          --
-- -------------------------------------------------------------------------- --

---@enum EEvent
local Event = {
  -- ------------------------------------------------------------------------ --
  -- Mod Events                                                               --
  -- ------------------------------------------------------------------------ --

  OnModEnabled  = "OnModEnabled",
  OnModDisabled = "OnModDisabled",

  -- ------------------------------------------------------------------------ --
  -- Trick Events                                                             --
  -- ------------------------------------------------------------------------ --

  OnTrickStart       = "OnTrickStart",
  OnTrickUpdateStart = "OnTrickUpdateStart",
  OnTrickUpdate      = "OnTrickUpdate",
  OnTrickUpdateEnd   = "OnTrickUpdateEnd",
  OnTrickFreezeStart = "OnTrickFreezeStart",
  OnTrickFreeze      = "OnTrickFreeze",
  OnTrickFreezeEnd   = "OnTrickFreezeEnd",
  OnTrickEnd         = "OnTrickEnd",

  -- ------------------------------------------------------------------------ --
  -- Individual Trick Events                                                  --
  -- ------------------------------------------------------------------------ --

  OnBarspinStart       = "OnBarspinStart",
  OnBarspinUpdateStart = "OnBarspinUpdateStart",
  OnBarspinUpdate      = "OnBarspinUpdate",
  OnBarspinUpdateEnd   = "OnBarspinUpdateEnd",
  OnBarspinFreezeStart = "OnBarspinFreezeStart",
  OnBarspinFreeze      = "OnBarspinFreeze",
  OnBarspinFreezeEnd   = "OnBarspinFreezeEnd",
  OnBarspinEnd         = "OnBarspinEnd",

  OnWhiplashStart       = "OnWhiplashStart",
  OnWhiplashUpdateStart = "OnWhiplashUpdateStart",
  OnWhiplashUpdate      = "OnWhiplashUpdate",
  OnWhiplashUpdateEnd   = "OnWhiplashUpdateEnd",
  OnWhiplashFreezeStart = "OnWhiplashFreezeStart",
  OnWhiplashFreeze      = "OnWhiplashFreeze",
  OnWhiplashFreezeEnd   = "OnWhiplashFreezeEnd",
  OnWhiplashEnd         = "OnWhiplashEnd",

  OnFrontnudgeStart       = "OnFrontnudgeStart",
  OnFrontnudgeUpdateStart = "OnFrontnudgeUpdateStart",
  OnFrontnudgeUpdate      = "OnFrontnudgeUpdate",
  OnFrontnudgeUpdateEnd   = "OnFrontnudgeUpdateEnd",
  OnFrontnudgeFreezeStart = "OnFrontnudgeFreezeStart",
  OnFrontnudgeFreeze      = "OnFrontnudgeFreeze",
  OnFrontnudgeFreezeEnd   = "OnFrontnudgeFreezeEnd",
  OnFrontnudgeEnd         = "OnFrontnudgeEnd",

  OnStoppieStart       = "OnStoppieStart",
  OnStoppieUpdateStart = "OnStoppieUpdateStart",
  OnStoppieUpdate      = "OnStoppieUpdate",
  OnStoppieUpdateEnd   = "OnStoppieUpdateEnd",
  OnStoppieFreezeStart = "OnStoppieFreezeStart",
  OnStoppieFreeze      = "OnStoppieFreeze",
  OnStoppieFreezeEnd   = "OnStoppieFreezeEnd",
  OnStoppieEnd         = "OnStoppieEnd",

  OnWheelieStart       = "OnWheelieStart",
  OnWheelieUpdateStart = "OnWheelieUpdateStart",
  OnWheelieUpdate      = "OnWheelieUpdate",
  OnWheelieUpdateEnd   = "OnWheelieUpdateEnd",
  OnWheelieFreezeStart = "OnWheelieFreezeStart",
  OnWheelieFreeze      = "OnWheelieFreeze",
  OnWheelieFreezeEnd   = "OnWheelieFreezeEnd",
  OnWheelieEnd         = "OnWheelieEnd",
}

-- -------------------------------------------------------------------------- --
-- Save to Global Variable                                                    --
-- -------------------------------------------------------------------------- --

BMX_TRICKS.Enum.Event = Event

-- Developer signature
function BMX_Tricks_mod_by_RBS_ID()
  -- This function does nothing but serves as a watermark
  return "You are not allowed to redistribute/re-upload this mod to anywhere else!"
end
