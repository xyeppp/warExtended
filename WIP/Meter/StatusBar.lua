local Meter = warExtendedMeter
local METER_TEMPLATE = "warExtendedMeterEntryTemplate"
local STATUS_BAR_LABEL = "StatusBar"
local ABILITY_NAME_LABEL = "Name"
local ICON_LABEL = "Icon"
local METER_WINDOW = "warExtendedMeter"

local MAX_METER_ENTRIES = 5
local createdTemplates = 0

local function getMeterId()
if createdTemplates < MAX_METER_ENTRIES then
  createdTemplates = createdTemplates + 1
end
return createdTemplates
end

local function getRandomMeterColor()
  local r = math.random(0,255)
  local g = math.random(0,255)
  local b = math.random(0,255)
  return r,g,b
end

local meterTemplateEntry = {
  
  getWindowName = function (self)
	local windowName = METER_TEMPLATE..self.id
	return windowName
  end,
  
  getStatusBarName = function (self)
	local statusBar = self:getWindowName()..STATUS_BAR_LABEL
	return statusBar
  end,

  getAbilityName = function (self)
	return self.name
  end,
  
  getCurrentDPS = function (self)
	return self.totalDamage
  end,
  
  getTotalDps = function (self)
	local maxBonus = self.totalDps
	return maxBonus
  end,
  
  setMaxStatusBarValue = function (self)
	local statusBar = self:getStatusBarName()
	local maxBonus = self:getTotalDps()+math.random(1,250)
	StatusBarSetMaximumValue(statusBar, maxBonus)
  end,
  
  setCurrentStatusBarValue = function (self)
	local statusBar = self:getStatusBarName()
	local currentBonus = self:getCurrentDPS()
	StatusBarSetCurrentValue(statusBar, currentBonus)
  end,
  
  setCurrentTextValue = function(self)
	local windowName = self:getWindowName()..ABILITY_NAME_LABEL
	local textValue = towstring(self:getAbilityName())
	LabelSetText(windowName, textValue)
  end,
  
  updateCurrentBonus = function(self)
	self:setMaxStatusBarValue()
	self:setCurrentStatusBarValue()
	self:setCurrentTextValue()
  end,
  
  setForegroundColor = function(self)
	local statusBarName = self:getStatusBarName()
	StatusBarSetForegroundTint(statusBarName, getRandomMeterColor())
  end,
  
  setBackgroundColor = function(self)
	local statusBarName = self:getStatusBarName()
	StatusBarSetBackgroundTint(statusBarName, 30,30,30)
  end,
  
  setIcon = function(self)
	local texture, x,y = GetIconData(self.iconNum)
	DynamicImageSetTexture(self:getWindowName()..ICON_LABEL, texture, x,y)
	DynamicImageSetTextureScale(self:getWindowName()..ICON_LABEL,0.5)
  end,
  
  addAnchor = function(self)
	if self.id == 1 then
	  WindowAddAnchor( self:getWindowName(), "top", METER_WINDOW, "center", 0, 35 )
	else
	  WindowAddAnchor( self:getWindowName(), "top", METER_TEMPLATE..(self.id-1), "center", 0, 35 )
	end
  end,
  
  createSelfTemplate = function (self)
	CreateWindowFromTemplate(self:getWindowName(), METER_TEMPLATE, METER_WINDOW )
	
	
	self:setIcon()
	self:setMaxStatusBarValue()
	self:setCurrentStatusBarValue()
	self:setCurrentTextValue()
	self:setForegroundColor()
	self:setBackgroundColor()
	self:addAnchor()
  
  end,
  
  registerTemplate = function (self, abilityData, dmg)
	local newEntry = setmetatable({ }, { __index = self })
	newEntry.id = getMeterId()
	newEntry.name = abilityData.name
	newEntry.iconNum = abilityData.iconNum
	newEntry.totalDamage = dmg
	newEntry.totalDps = dmg + 300
	newEntry:createSelfTemplate()
	return newEntry
  end
}

function Meter.CreateMeterEntry(abilityData, dmg)
  if createdTemplates == MAX_METER_ENTRIES then
	return
  end
  
  local meterEntry = meterTemplateEntry:registerTemplate(abilityData, dmg)
  return meterEntry
end