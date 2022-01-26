local warExtendedSettings = warExtendedSettings
local OPTIONS_WINDOW = "warExtendedSettings"

local childEntry = {
  createNew = function(self, name, parentWindow, id)
	local newChildEntry = setmetatable({}, {__index = self})
	newChildEntry.childEntries = {}
	newChildEntry.id = id+100
	newChildEntry.expanded = false
	newChildEntry.name = towstring(name)
	newChildEntry.parentWindow = parentWindow
	newChildEntry.parentEntryId = id
	return newChildEntry
  end,
  
  createNewChild = function(self, name, parentWindow)
	self.childEntries[#self.childEntries+1] = self:createNew(name, parentWindow, self.id)
  end,
}

local optionEntry = {
  createNew = function(self, name, parentWindow, id)
	local newEntry = setmetatable({}, {__index = self})
	newEntry.name = towstring(name:gsub("warExtended ", ""))
	newEntry.addonName = name
	newEntry.expanded = false;
	newEntry.parentEntryId = 0;
	newEntry.parentWindow = parentWindow
	newEntry.childEntries = {
	}
	newEntry.id = id
	return newEntry
  end,
  
  createNewChild = function(self, name, entryWindow)
	self.childEntries[#self.childEntries+1] = childEntry:createNew(name, entryWindow, self.id)
  end
}

local optionManager = {
  registeredOptions = 0,
  nameToId = {},
  
  registerNewOption = function(self, parentName)
	self.registeredOptions = self.registeredOptions + 1
	self.nameToId[parentName] = self.registeredOptions
	local newOptionEntry = optionEntry:createNew(parentName, OPTIONS_WINDOW.."Main",self.registeredOptions)
	warExtendedSettings.data[self.registeredOptions] = newOptionEntry
	return newOptionEntry
  end,
  
  registerOptionChildEntry = function(self, parentName, entryName, entryWindow)
	local optionEntry = warExtendedSettings.data[self.nameToId[parentName]]
		optionEntry:createNewChild(entryName, entryWindow)
  end
}

function warExtendedSettings.AddOptionEntry(name)
  p(name)
  optionManager:registerNewOption(name)
end

function warExtendedSettings.AddOptionChildEntry(parentName, entryName, entryWindow)
  optionManager:registerOptionChildEntry(parentName, entryName, entryWindow)
end

function warExtendedSettings.GetOptionParent(parentId)
  for i=1,#warExtendedSettings.rowToEntryMap do
	local optionEntry = warExtendedSettings.rowToEntryMap[i]
	if optionEntry.id == parentId then
	  return optionEntry
	end
  end
end

warExtended:AddEventHandler("CreateEntry", "CreateSettingsEntry", warExtendedSettings.AddOptionEntry)

