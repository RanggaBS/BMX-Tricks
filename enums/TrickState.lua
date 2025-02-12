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
