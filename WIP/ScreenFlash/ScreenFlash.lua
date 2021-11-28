warExtendedScreenFlash = warExtended.Register("warExtended Screen Flash")
local ScreenFlashWindow = ScreenFlashWindow
local ScreenFlash = warExtendedScreenFlash

ScreenFlash.Settings = {
  IsEnabled = false;
  IsRegistered = false;
  CurrentThreshold = 0
}

local function setActiveThreshold(thresholdIndex)
  ScreenFlash.Settings.CurrentThreshold = thresholdIndex
end

local function setActive(self, isActive, thresholdIndex)
  self.isActive = isActive

  if isActive then
    setActiveThreshold(thresholdIndex)
  else
    setActiveThreshold(thresholdIndex-1)
  end

end

local function getAlpha(self)
  return self.alpha
end

local function getActive(self)
  return self.isActive
end

local function registerThreshold(hp, alpha)
  local self = {}
  self.hp = hp
  self.alpha = alpha
  self.isActive = false;
  self.getAlpha = getAlpha
  self.setActive = setActive
  self.getActive = getActive
  return self
end

local hpThresholds = {
  [1] = registerThreshold(90, 0.15),
  [2] = registerThreshold(80, 0.25),
  [3] = registerThreshold(70, 0.35),
  [4] = registerThreshold(50, 0.45),
  [5] = registerThreshold(30,0.55),
  [6] = registerThreshold(15,0.7)
}


local function isUnderThreshold(currentHP, threshold)
  local maximumHP = GameData.Player.hitPoints.maximum
  local isUnderThreshold = 100 * (currentHP / maximumHP ) <= threshold
  return isUnderThreshold
end

local function setCurrentThreshold(currentHP)
  for thresholdIndex=1,#hpThresholds do
    local threshold = hpThresholds[thresholdIndex]
    local treshholdHP = threshold.hp

    if not threshold:getActive() and isUnderThreshold(currentHP, treshholdHP) then
      threshold:setActive(true, thresholdIndex)
     elseif threshold:getActive() and not isUnderThreshold(currentHP, treshholdHP) then
      threshold:setActive(false, thresholdIndex)
      end
    end
end


local function startScreenFlashThresholdFlash(thresholdFlashEndAlpha)
  if( ScreenFlashWindow.curFlashTimer > 0 ) then
    return
  end

  WindowSetShowing( "ScreenFlashWindow", true )
  WindowStartAlphaAnimation(  "ScreenFlashWindow",
          Window.AnimationType.POP_AND_EASE,
          ScreenFlashWindow.ANIMATION_DATA.startAlpha,
          thresholdFlashEndAlpha,
          ScreenFlashWindow.ANIMATION_DATA.duration,
          true, 0, 0 )

  ScreenFlashWindow.curFlashTimer = ScreenFlashWindow.ANIMATION_DATA.duration
end


local function getActiveThreshold()
  local currentThreshold = ScreenFlash.Settings.CurrentThreshold

  if currentThreshold == 0 then
    return
  end

  return hpThresholds[currentThreshold]
end


local function startThresholdFlash(currentHP)
  local threshold = getActiveThreshold(currentHP)

  if threshold then
    local thresholdAlpha = threshold:getAlpha()

    if thresholdAlpha then
      startScreenFlashThresholdFlash(thresholdAlpha)
    end
  end

end


local function startGenericFlash(currentHP)
  local lastHitPoints = ScreenFlashWindow.lastPlayerHitPoints

  if( currentHP < lastHitPoints ) then
    ScreenFlashWindow.StartFlash()
  end

  ScreenFlashWindow.lastPlayerHitPoints = currentHP
end


function ScreenFlash.OnPlayerHitPointsUpdated(currentHP)
  local isFlashEnabled = ScreenFlashWindow.IsEnabled()

  if isFlashEnabled then
    startGenericFlash(currentHP)
    return
  end

  setCurrentThreshold(currentHP)
  startThresholdFlash(currentHP)
end
