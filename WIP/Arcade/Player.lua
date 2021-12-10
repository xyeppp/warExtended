local Invaders = warExtendedSpaceInvaders
local PLAYER_WINDOW_NAME = "warExtendedSpaceInvadersShip"

local player = Invaders.RegisterEntity({
    name = PLAYER_WINDOW_NAME,
    hp = 5,
    velocity = 3,
    bullets = Invaders.RegisterBullets(2, self)
})

function Invaders.PlayerMoveRight()
  player:move("right")
end

function Invaders.PlayerMoveLeft()
  player:move("left")
end

function Invaders.PlayerMoveUp()
  player:move("up")
end

function Invaders.PlayerMoveDown()
  player:move("down")
end

function Invaders.PlayerFireBullet()
  player.bullets:fire()
  Invaders.PlaySound("FIRE")
end

function Invaders.Tester()
  player:spawn(250, 550)
end


