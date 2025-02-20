---@enum CNodetime
local Nodetime = {
  BARSPIN_MAX_NODETIME = 0.64,

  WHIPLASH_START_NODETIME = 0.2, -- The max node time that the bike frame not much rotated around
  WHIPLASH_LOOP_NODETIME = 1.1,
  WHIPLASH_FREEZE_NODETIME = 1.075, -- A little bit early than loop node time to achieve no 1 frame delay

  FRONTNUDGE_LOOP_NODETIME = 0.98,
  FRONTNUDGE_FREEZE_NODETIME = 0.9, -- A little bit early than loop node time to achieve no 1 frame delay

  STOPPIE_LIFT_NODETIME = 0.55,

  WHEELIE_END_NODETIME = 0.98,
}

-- -------------------------------------------------------------------------- --
-- Save to Global Variable                                                    --
-- -------------------------------------------------------------------------- --

BMX_TRICKS.Constant.Nodetime = Nodetime
