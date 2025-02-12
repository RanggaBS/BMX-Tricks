--[[
  Bully AE user mod configuration file

	To apply your desired configuration, you need to compile this Lua file using
	luac.exe and replace the bmx_config.lur file with the new compiled one.

	Bully SE/PC user can ignore this, the configuration is in the
  `config/bmx_tricks.ini` file.
]]

BMX_TRICKS.USER_CONFIG = {
  -- ------------------------------------------------------------------------ --
  -- Input Controls                                                           --
  -- ------------------------------------------------------------------------ --

  -- https://www.maketecheasier.com/assets/uploads/2020/08/Deadzone-Sticks.gif
  --
  -- How far the small circle dot in the center of the analog needs to be moved.
  -- [x,y] => [0,0]: center, [0,1]: top center
  -- Value: 0-1
  CONTROLLER_MIN_STICK = 0.9,

  -- The maximum delay between each tap, in miliseconds
  CONTROLLER_DOUBLETAP_TRESHOLD = 300,

  -- Value: "UpDownDown" or "DownDown"
  CONTROLLER_BARSPIN_INPUTSEQUENCE = "UpDownDown",

  -- Value: "DownUpUp" or "UpUp"
  CONTROLLER_WHIPLASH_INPUTSEQUENCE = "DownUpUp",

  -- ------------------------------------------------------------------------ --
  -- Choose/set different behavior of the animations.                         --
  -- ------------------------------------------------------------------------ --

  -- Allow tricks to be performed in mid-air
  ALLOW_MID_AIR = true,

  -- Slow down the bike speed while performing front manual nudge
  FRONTNUDGE_BRAKE = false,

  -- The minimum speed to be able to perform barspin (in km/h)
  BARSPIN_MIN_SPEED = 10,

  -- The minimum speed to be able to perform whiplash (in km/h)
  WHIPLASH_MIN_SPEED = 10,

  -- The minimum speed to be able to perform front manual nudge (in km/h)
  FRONTNUDGE_MIN_SPEED = 15,

  -- The minimum speed to be able to perform endo/stoppie (in km/h)
  STOPPIE_MIN_SPEED = 15,

  -- The minimum speed to be able to perform pedalling wheelie (in km/h)
  WHEELIE_MIN_SPEED = 10,

  -- ------------------------------------------------------------------------ --
  -- Play additional animation before/after performing the trick.             --
  -- ------------------------------------------------------------------------ --

  -- Play the front wheel lift animation
  PRE_BARSPIN_ANIM = true,
  -- Play the front wheel land animation
  POST_BARSPIN_ANIM = true,

  -- Play the rear wheel lift animation
  PRE_WHIPLASH_ANIM = false,
  -- Play the front wheel land animation
  POST_WHIPLASH_ANIM = false,

  -- Play the front wheel lift animation
  POST_FRONTNUDGE_ANIM = false,

  -- Play the front wheel land animation
  POST_STOPPIE_ANIM = true,

  -- Play the front wheel lift animation
  PRE_WHEELIE_ANIM = true,
  -- Play the front wheel land animation
  POST_WHEELIE_ANIM = true,

  -- ------------------------------------------------------------------------ --
  -- Hacks                                                                    --
  -- ------------------------------------------------------------------------ --

  -- Set whether tricks can only be played on BMX bikes or not.
  BMX_ONLY = true,

  -- ------------------------------------------------------------------------ --
  -- Ignore and do not delete or comment the code                             --
  -- ------------------------------------------------------------------------ --

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
}
