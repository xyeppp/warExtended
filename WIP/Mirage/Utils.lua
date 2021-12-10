local warExtendedMirage = warExtendedMirage
local Mirage = warExtendedMirage
local WINDOW_NAME = "warExtendedMirage"
local COMBO_BOX = WINDOW_NAME.."SetComboBox"

local set = {
  addSet = function(self)
	local setId = warExtendedMirage[#Sets+1]
	warExtendedMirage.Sets[setId] = self
	self:updateComboBox()
  end,
  
  removeSet = function(self, setId)
	warExtendedMirage.Sets[setId] = nil
	self:updateComboBox()
  end,
  
  getLastAddedSet = function()
	return Mirage.Sets[#Mirage.Sets]
  end
}

function Mirage.RegisterSet()
	set:addSet()
  	ComboBoxSetSelectedMenuItem(COMBO_BOX, set:getLastAddedSet() )
end

function Mirage.RemoveSet()

end
