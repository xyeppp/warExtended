local BagBonus = warExtendedBagBonus

local BAG_BONUS_WINDOW = "BagBonusWindow"
local BAG_BONUS_TEMPLATE = "BagBonusTemplate"
local PROGRESS_BAR_LABEL = "ProgressBar"
local ICON_LABEL = "Icon"
local BONUS_TEXT_LABEL = "Bonus"

local STATUS_BAR_BACKGROUND_COLOR = {161, 44, 44}
local STATUS_BAR_FOREGROUND_COLOR = {25, 146, 41}

local bagData = {
  Gold = {
    maxBonusPoints = 1000,
    icon = 552,
  },
  Purple = {
    maxBonusPoints = 900,
    icon = 554,
  },
  Blue = {
    maxBonusPoints = 800,
    icon = 551,
  },
  Green = {
    maxBonusPoints = 700,
    icon = 553,
  },
  White = {
    maxBonusPoints = 600,
    icon = 555,
  }
}

local bagBonus = {

  getWindowName = function (self)
    local windowName = BAG_BONUS_TEMPLATE..self.id
    return windowName
  end,

  getStatusBarName = function (self)
    local statusBar = self:getWindowName()..PROGRESS_BAR_LABEL
    return statusBar
  end,

  getCurrentBonusPoints = function (self)
    local currentBonus = BagBonus.Settings.CurrentBonus[self.name]
    return currentBonus
  end,

  setCurrentBonusPoints = function (self, bonusPoints)
    BagBonus.Settings.CurrentBonus[self.name] = bonusPoints
  end,

  getMaxBonusPoints = function (self)
    local maxBonus = self.maxBonusPoints
    return maxBonus
  end,

  isBonusUpdated = function(self, bonusPoints)
    local isUpdated = bonusPoints ~= self:getCurrentBonusPoints()
    return isUpdated
  end,

  setMaxStatusBarValue = function (self)
    local statusBar = self:getStatusBarName()
    local maxBonus = self:getMaxBonusPoints()
    StatusBarSetMaximumValue(statusBar, maxBonus)
  end,

  setCurrentStatusBarValue = function (self)
    local statusBar = self:getStatusBarName()
    local currentBonus = self:getCurrentBonusPoints()
    StatusBarSetCurrentValue(statusBar, currentBonus)
  end,

  setCurrentTextValue = function(self)
    local windowName = self:getWindowName()..BONUS_TEXT_LABEL
    local textValue = towstring(self:getCurrentBonusPoints())
    LabelSetText(windowName, textValue)
  end,

  updateCurrentBonus = function(self, currentBonus)
    self:setCurrentBonusPoints(currentBonus)
    self:setCurrentStatusBarValue()
    self:setCurrentTextValue()
  end,

  setForegroundColor = function(self)
    local statusBarName = self:getStatusBarName()
    StatusBarSetForegroundTint(statusBarName, unpack(STATUS_BAR_FOREGROUND_COLOR))
  end,

  setBackgroundColor = function(self)
    local statusBarName = self:getStatusBarName()
    StatusBarSetBackgroundTint(statusBarName, unpack(STATUS_BAR_BACKGROUND_COLOR))
  end,

  setIcon = function(self)
    local texture, x,y = GetIconData(self.icon)
    DynamicImageSetTexture(self:getWindowName()..ICON_LABEL, texture, x,y)
    DynamicImageSetTextureScale(self:getWindowName()..ICON_LABEL,0.5)
  end,

  addAnchor = function(self)
    if self.id == 1 then
      WindowAddAnchor( self:getWindowName(), "topleft", BAG_BONUS_WINDOW, "center", 20, 35 )
    else
      WindowAddAnchor( self:getWindowName(), "topleft", BAG_BONUS_TEMPLATE..(self.id-1), "center", 0, 54 )
    end
  end,

  createSelfTemplate = function (self)
    CreateWindowFromTemplate(self:getWindowName(), BAG_BONUS_TEMPLATE, BAG_BONUS_WINDOW )


    self:setIcon()
    self:setMaxStatusBarValue()
    self:setCurrentStatusBarValue()
    self:setCurrentTextValue()
    self:setForegroundColor()
    self:setBackgroundColor()
    self:addAnchor()

  end
}

bagBonus.__index = bagBonus

function BagBonus.RegisterBagTable(bagTable, bagName, bagId)
  bagTable = setmetatable(bagTable, bagBonus)
  bagTable.name = bagName
  bagTable.id = bagId
  return bagTable
end

function BagBonus.GetBagTable(bagName)
  local asd = warExtended:toString(bagName)
  p(asd)
  local bagName = warExtended:Capitalize(warExtended:toString(bagName))
  p(bagName)
  local bagTable = bagData[bagName]
  return bagTable
end

function BagBonus.GetInitialBagBonus()
  local isFirstInitialize = not BagBonus.Settings.IsBonusCached

  if isFirstInitialize then
   -- BagBonus:Send(".bag")
    BagBonus.Settings.IsBonusCached = true;
  end

end
