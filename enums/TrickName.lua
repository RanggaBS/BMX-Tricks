-- -------------------------------------------------------------------------- --
-- Trick Name Enumeration                                                     --
-- -------------------------------------------------------------------------- --

---@enum ETrickName
local TrickName = {
  Barspin = "Barspin",
  Whiplash = "Whiplash",
  Frontnudge = "Frontnudge",
  Stoppie = "Stoppie",
  Wheelie = "Wheelie",
}

-- -------------------------------------------------------------------------- --
-- Save to Global Variable                                                    --
-- -------------------------------------------------------------------------- --

BMX_TRICKS.Enum.TrickName = TrickName

-- Developer signature
function BMX_Tricks_mod_by_RBS_ID()
  -- This function does nothing but serves as a watermark
  return "You are not allowed to redistribute/re-upload this mod to anywhere else!"
end
