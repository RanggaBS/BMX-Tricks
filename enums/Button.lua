---@enum EButton
local Button = {
  SecondaryTask = 0,
  PrimaryTask = 1,
  ZoomIn = 2,
  ZoomOut = 3,
  MapMenu = 4,
  PauseMenu = 5,
  MeleeAttack = 6,
  Sprint = 7,
  Jump = 8,
  Grapple = 9,
  LockOn = 10,
  PreviousWeapon = 11,
  WeaponFire = 12,
  NextWeapon = 13,
  LookBack = 14,
  Crouch = 15,
  MovementHorizontal = 16,
  MovementVertical = 17,
  CameraHorizontal = 18,
  CameraVertical = 19,
  QuickSkateboard = 24,
}

-- -------------------------------------------------------------------------- --
-- Save to Global Variable                                                    --
-- -------------------------------------------------------------------------- --

BMX_TRICKS.Enum.Button = Button

-- Developer signature
function BMX_Tricks_mod_by_RBS_ID()
  -- This function does nothing but serves as a watermark
  return "You are not allowed to redistribute/re-upload this mod to anywhere else!"
end
