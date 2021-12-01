warExtendedScreenFlash = warExtended.Register("warExtended Screen Flash")
local ScreenFlash = warExtendedScreenFlash

local threshold = {
  setNextThresholdHp = function (self, nextThreshold)
	if nextThreshold == nil then
	  self.nextThresholdHp = 0
	  return
	end

	self.nextThresholdHp = nextThreshold.hp
  end,

  getActiveThreshold = function (self, currentHP)
	if currentHP <= self.hp and currentHP > self.nextThresholdHp then
	  return self
	end
  end,

  flash = function (self)
	if( ScreenFlashWindow.curFlashTimer > 0 ) then
	  return
	end

	WindowSetShowing( "ScreenFlashWindow", true )
	WindowStartAlphaAnimation(  "ScreenFlashWindow",
			Window.AnimationType.POP_AND_EASE,
			ScreenFlashWindow.ANIMATION_DATA.startAlpha,
			self.alpha,
			ScreenFlashWindow.ANIMATION_DATA.duration,
			true, 0, 0 )

	ScreenFlashWindow.curFlashTimer = ScreenFlashWindow.ANIMATION_DATA.duration
  end,

  create = function (self, hpPercentage, alphaLevel)
	local newThreshold = setmetatable ({ }, {__index = self})
	newThreshold.hp = hpPercentage * ScreenFlash:GetPlayerHPMax() / 100
	newThreshold.alpha = alphaLevel
	return newThreshold
  end,

}

function ScreenFlash.RegisterThreshold(hpPercentage, alphaLevel)
  local newThreshold = threshold:create(hpPercentage, alphaLevel)
  return newThreshold
end

