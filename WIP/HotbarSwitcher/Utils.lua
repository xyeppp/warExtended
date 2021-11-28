local Switcher = warExtendedHotbarSwitcher

local HOTBAR_SWITCH_COMMAND = "HotbarSwitch"
local HOTBAR_SWITCHER = HOTBAR_SWITCH_COMMAND.."%((%d+),(%d+)%)"

local switcher = {
  getName = function (self)
	local switcherName = self.name
	return switcherName
  end,

  setName = function (self)
	local actionBarData, actionSlot = ActionBars:BarAndButtonIdFromSlot(slot)
	local macroButton = actionBarData.m_Buttons[actionSlot]
	local name = macroButton.m_Name.."Action"
	self.name = name
  end,

  setActionSlot = function (self, id)
	self.actionSlot = id
  end,

  getChildHotbar = function (self)
	local switcherId = self.childHotbar
	return switcherId
  end,

  setChildHotbar = function(self, childHotbarId)
	self.childHotbar = childHotbarId
  end,

  setParentHotbar = function (self, parentHotbarId)
	self.parentHotbarId = parentHotbarId
  end,

  removeSelf = function(self)
	self.Switchers[self.actionSlot] = nil
  end
}

local function isSwitcherMacro(actionId, actionType)

end

function Switcher:CreateSwitch()
  local newSwitcher = setmetatable(newSwitcher, switcher)
  newSwitcher.__index = switcher
  return newSwitcher
end

function Switcher:DoesSwitchExist(actionSlot)
  local doesSwitchExist = self.Switchers[actionSlot]
  return doesSwitchExist
end

function Switcher:GetSwitch()

end