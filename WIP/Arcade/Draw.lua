local Invaders = warExtendedSpaceInvaders
local GAME_WINDOW = "warExtendedSpaceInvaders"

local RIGHT_OFFSET_LIMIT =  425
local LEFT_OFFSET_LIMIT = 12




function Invaders.SpawnEntity(entity, x, y)
  CreateWindow(entity.name, true)
  WindowSetParent(entity.name, GAME_WINDOW)
  entity:setPos(x,y)
end