local Invaders = warExtendedSpaceInvaders

local bullet = {
  x = nil,
  y = nil,
  
  setPos = function(self, x, y)
    self.x = x
    self.y = y
  end,
  
  getPos = function(self)
    return self.x, self.y
  end,
  
  destroySelf = function(self)
    Invaders:DestroyWindow(self.id)
  end
}


local bullets = {
  activeBullets = {
  },
  
  bulletsFired = 0,
  bulletsMissed = 0,
  bulletCount = 999999999999,
  
  addActiveBullet = function(self, bulletId, newBullet)
    newBullet.id = bulletId
    self.activeBullets[bulletId] = newBullet
  end,
  
  getNewBulletId = function(self)
    self.bulletsFired = self.bulletsFired + 1
    return self.bulletsFired
  end,
  
  getBulletsFired = function(self)
    return self.bulletsFired
  end,
  
  getBulletsMissed = function(self)
    return self.getBulletsMissed
  end,
  
  getBulletCount = function(self)
    return self.bulletCount
  end,
  
  setBulletCount = function(self, count)
    self.bulletCount = self.bulletCount + count
  end,
  
  fire = function(self)
    local newBullet = setmetatable({}, { __index = bullet })
    self:addActiveBullet(self:getNewBulletId(), newBullet)
  end,
  
  removeActiveBullet = function(self, bulletId)
    self.activeBullets[bulletId] = nil
  end,
  
  
register = function(self, bulletVelocity, entityTable)
  local bullets = setmetatable (self, {__index = entityTable})
  bullets.velocity = bulletVelocity
  return bullets
end

}


function Invaders.RegisterBullets(bulletVelocity, entityTable)
  local bulletTable = bullets:register(bulletVelocity, entityTable)
  return bulletTable
end