-- -------------------------------------------------------------------------- --
-- Trick State Enumeration                                                    --
-- -------------------------------------------------------------------------- --

---@enum ETrickState
local TrickState = {
  Idle = "Idle",
  Initial = "Initial",
  Playing = "Playing",
  Freeze = "Freeze",
  End = "End",
}

-- -------------------------------------------------------------------------- --
-- Save to Global Variable                                                    --
-- -------------------------------------------------------------------------- --

BMX_TRICKS.Enum.TrickState = TrickState

-- Developer signature
function BMX_Tricks_mod_by_RBS_ID()
  -- This function does nothing but serves as a watermark
  return "You are not allowed to redistribute/re-upload this mod to anywhere else!"
end
