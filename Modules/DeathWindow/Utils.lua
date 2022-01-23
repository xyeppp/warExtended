local DeathRecap = warExtendedDeathWindow
local RECAP_WINDOW = "warExtendedDeathRecap"
local RECAP_TEMPLATE = "warExtendedDeathRecapAbilityEntry"
local ICON_LABEL = "Icon"
local TEXT_LABEL = "Name"
local TIME_LABEL = "Time"
local HIT_LABEL = "HitValue"

local MAX_RECAP_ENTRIES = 5
local recapEntry= 0

local function getRecapEntryId()
  if recapEntry < MAX_RECAP_ENTRIES then
	recapEntry = recapEntry + 1
	return recapEntry
  end

  return recapEntry
end

local recapEntry = {
  getWindowName = function (self)
	local windowName = RECAP_TEMPLATE..self.id
	return windowName
  end,

  destroySelf = function(self)
	DestroyWindow(self:getWindowName())
  end,

  setIcon = function(self)
	local texture, x,y = DeathRecap:GetIconData(self.abilityInfo.iconNum)
	DynamicImageSetTexture(self:getWindowName()..ICON_LABEL, texture, x,y)
	DynamicImageSetTextureScale(self:getWindowName()..ICON_LABEL, 1)
  end,

	getAbilityName = function (self)
	  return self.abilityInfo.name
	end,

  getAbilityData = function(self)
	return self.abilityInfo
  end,

	getAbilityHitValue = function (self)
	  return self.hitValue
	end,

	getAbilityHitTimeBeforeDeath = function (self)
	  local hitTimeBeforeDeath = DeathRecap.Settings.timeOfDeath - self.hitTime.."s"
	  return hitTimeBeforeDeath
	end,

  addAnchor = function(self)
	if self.id == 1 then
	  WindowAddAnchor( self:getWindowName(), "top", RECAP_WINDOW, "top", 0, 56)
	else
	  WindowAddAnchor( self:getWindowName(), "center", RECAP_TEMPLATE..(self.id-1), "center", 0, 82 )
	end
  end,

  setWindowId = function(self)
	WindowSetId(self:getWindowName(), self.id)
  end,

  setCurrentText = function (self)
	LabelSetText(self:getWindowName()..TIME_LABEL, towstring(self:getAbilityHitTimeBeforeDeath()))
	LabelSetText(self:getWindowName()..TEXT_LABEL, towstring(self:getAbilityName()))
	LabelSetText(self:getWindowName()..HIT_LABEL, towstring("-"..self:getAbilityHitValue()))
  end,

	createSelfTemplate = function(self)
		CreateWindowFromTemplate(self:getWindowName(), RECAP_TEMPLATE, RECAP_WINDOW )

		self:setIcon()
		self:setCurrentText()
		self:addAnchor()
	  	self:setWindowId()

	  if self.id == 5 then
		WindowSetShowing(RECAP_TEMPLATE.."5MiddleDivider", false)
	  end

	end,

	registerEntry = function(self, abilityDamage, abilityId, hitTime)
	  local newEntry = setmetatable({ }, { __index = self })

	  newEntry.id = getRecapEntryId()
	  newEntry.hitValue = abilityDamage
	  newEntry.abilityInfo = DeathRecap:GetAbilityData(abilityId)
	  newEntry.hitTime = hitTime

	  return newEntry
	end
}

function DeathRecap.RegisterRecapEntry(abilityDamage, abilityData, hitTime)
  local newEntry = recapEntry:registerEntry(abilityDamage, abilityData, hitTime)
  return newEntry
end