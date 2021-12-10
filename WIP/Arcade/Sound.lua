local Invaders = warExtendedSpaceInvaders
local Sound = Sound

local gameSounds = {
  FIRE = 7,
  HIT = 6,

  GAMEOVER = 32,
  GAMESTART = 31,
  POWERUP = 9,
}


function Invaders.PlaySound(soundType)
  Sound.Play(gameSounds[soundType])
end