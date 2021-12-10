warExtendedSpaceInvaders = warExtended.Register("warExtended Space Invaders")
local Invaders = warExtendedSpaceInvaders

local GameWindow_Width = 500
local GameWindow_Height= 700


local enemynumber = 0

local FlapTempX = GameWindow_Width/2
local FlapTempy = 550
local MAX_ENEMIES = 5
local ENEMY_VELOCITY = 2.5
local ENEMY_COUNT = 0

local function UpdatePosition(x,y)
  FlapTempX = x
  if y then
    FlapTempy = y
  end
end

local enemies = {}
local spawnTimer = 0


local bulletCount = 0

local bullets = {
}



local function updateBulletPosition()
    for k,v in pairs(bullets) do
        local bulleter = bullets[k]
    if bulleter then
      local bulletNumber = tostring(k)
      bulleter.y = bulleter.y - 5
      WindowSetOffsetFromParent("bullet"..bulletNumber,bulleter.x, bulleter.y )
    end
  end
end



local function checkBullets()
  for k,v in pairs(bullets) do
    local bulleter = bullets[k]
      if bulleter.y < 30 then
        local bulletNumber = tostring(k)
        DestroyWindow("bullet"..bulletNumber)
        bullets[k] = nil
      end
  end
end

local function checkEnemies()
  for k,v in pairs(enemies) do
    local enemy = enemies[k]
    if enemy.y > 580 then
      local enemynumber = tostring(k)
      DestroyWindow("enemy"..enemynumber)
      enemies[k] = nil
      ENEMY_COUNT = ENEMY_COUNT - 1
    end
  end
end

local function spawnEnemy()
  if ENEMY_COUNT < MAX_ENEMIES then
    local random = math.random(spawnTimer, spawnTimer+0.3)
    if spawnTimer < random then
      ENEMY_COUNT = ENEMY_COUNT + 1
      local  x = math.random(GameWindow_Width)
      local  y = 20
      local enemy = {
        x = x,
        y = y,
        ray = math.random(10,120)
      }
    
      enemynumber = enemynumber + 1
      enemies[enemynumber] = enemy
      CreateWindowFromTemplate("enemy"..enemynumber, "warExtendedSpaceInvadersEnemy", "warExtendedSpaceInvaders")
      WindowSetOffsetFromParent("enemy"..enemynumber,enemy.x, enemy.y)
      spawnTimer = 0
    end
    
    end
end

local function fireBullet()
  local bullet = {}
  bullet.x= FlapTempX + 25
  bullet.y= FlapTempy - 20
  bulletCount = bulletCount+1
  bullets[bulletCount] = bullet
  CreateWindowFromTemplate("bullet"..bulletCount, "warExtendedSpaceInvadersBullet", "warExtendedSpaceInvaders")
  WindowSetOffsetFromParent("bullet"..bulletCount, bullet.x, bullet.y)
end

local function moveEnemy()
  for k,v in pairs(enemies) do
    local enemy = enemies[k]
    if enemy then
      local enemynumber = tostring(k)
      enemy.y = enemy.y + ENEMY_VELOCITY
      WindowSetOffsetFromParent("enemy"..enemynumber,enemy.x, enemy.y )
    end
  end
  
end
local rightKeyIsPressed = false
local leftKeyIsPressed = false
local timer = 0


local enemyTimer = 0

local function checkBulletCollision()
  local i,j,b,a,del_asteroids,del_bullets
  del_enemies = {}
  del_bullets = {}
  
  for i,b in pairs(bullets) do
    for j,a in pairs(enemies) do
      local distance,dx,dy
      dx = a.x-b.x
      dy = a.y-b.y
      distance = math.sqrt((dx*dx)+(dy*dy))
      if distance < a.ray then
        del_enemies[j] = true
        del_bullets[i] = true
        break
      end
    end
  end
  
  for i,b in pairs(del_bullets) do
    local bulletNumber = tostring(i)
    DestroyWindow("bullet"..bulletNumber)
    bullets[i] = nil
  end
  
  for i,a in pairs(del_enemies) do
    local enemynumber = tostring(i)
    DestroyWindow("enemy"..enemynumber)
    ENEMY_COUNT = ENEMY_COUNT - 1
    enemies[i] = nil
  end
end



function Invaders.OnUpdate(elapsed)
  Invaders.CheckPlayerInput()
  
  if rightKeyIsPressed then
    if FlapTempX > 440 then
      return
    end
    p('moving right')
    WindowSetOffsetFromParent("warExtendedSpaceInvadersShip",(FlapTempX+10), FlapTempy)
    UpdatePosition(FlapTempX+10)
    elseif leftKeyIsPressed then
    if FlapTempX < 12 then
      return
    end
    p("moving left")
    WindowSetOffsetFromParent("warExtendedSpaceInvadersShip",(FlapTempX-10), FlapTempy)
    UpdatePosition(FlapTempX-10)
  end
  
  spawnTimer = spawnTimer + elapsed
  timer = timer + elapsed
  enemyTimer = enemyTimer + elapsed
  if timer > 0.05 then
    moveEnemy()
    updateBulletPosition()
    checkBulletCollision()
    checkBullets()
    checkEnemies()
    timer =0
  end
  
  if enemyTimer > 0.3 then
    spawnEnemy()
    enemyTimer=0
  end
  
end



function Invaders.OnInitialize()
  Invaders:RegisterUpdate("warExtendedSpaceInvaders.OnUpdate")
end


