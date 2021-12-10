local Invaders = warExtendedSpaceInvaders
local GAME_WINDOW = "warExtendedArcadeGameWindow"

local entity = {
  name = nil,
  hp = nil,
  
  x = 0,
  y = 0,
  rotation = 0,
  
  velocity = nil,
  
  getPos = function (self)
	return self.x, self.y
  end,

  setPos = function(self, x, y)
	self.x = x;
	self.y = y;
	Invaders:SetWindowOffset(self.name, self.x, self.y)
  end,
  
  getHp = function(self)
	return self.hp
  end,
  
  setHp = function(self, hpChange)
	self.hp = self.hp + hpChange
  end,
  
  getName = function(self)
	return self.name
  end,
  
  setVelocity = function(self, newVelocity)
	self.velocity = newVelocity
  end,

  getVelocity = function(self)
	return self.velocity
  end,
  
  spawn = function(self, x, y)
	CreateWindow(self.name, true)
	WindowSetParent(self.name, GAME_WINDOW)
	self:setPos(x,y)
  end,
  
  move = function(self, direction)
	if direction == "up" then
	  self:setPos(self.x, self.y+self.velocity)
	elseif direction == "right" then
	  self:setPos(self.x+self.velocity, self.y)
	elseif direction =="down" then
	  self:setPos(self.x, self.y-self.velocity)
	elseif direction =="left" then
	  self:setPos(self.x-self.velocity, self.y)
	end
  end,
  
  register = function(self, newEntity)
	newEntity = setmetatable (newEntity, {__index = self})
	return newEntity
  end
}


function Invaders.RegisterEntity(newEntity)
  newEntity = entity:register(newEntity)
  return newEntity
end




