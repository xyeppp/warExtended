local Invaders = warExtendedSpaceInvaders

local keyboardController = {
  inputKeys = {
	[32] = { -- d key
	  isPressed     = false;
	  inputFunction = Invaders.PlayerMoveRight,
	},
	[30] = { -- a key
	  isPressed     = false;
	  inputFunction = Invaders.PlayerMoveLeft,
	},
	[57] = { -- space key
	  isPressed     = false;
	  inputFunction = Invaders.PlayerFireBullet,
	}
  },

  setKeyPressed = function (self, buttonId, isKeyPressed)
    self.inputKeys[buttonId].isPressed = isKeyPressed
  end,
 }


function Invaders.OnRawDeviceInputKeyboardController(deviceId, buttonId, pressedState)
  if not keyboardController.inputKeys[buttonId] then
	  return
  end

  local isKeyPressed = pressedState == 1
  keyboardController:setKeyPressed(buttonId, isKeyPressed)
end


function Invaders.CheckPlayerInput()
  for _, keyData in pairs(keyboardController.inputKeys) do

  	if keyData.isPressed then
	  keyData.inputFunction()
  	end

  end
end



