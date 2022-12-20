local pairs = pairs
local warExtended = warExtended

local set = {
  setName = function(self, name)
	self.name = name
  end,
  
  getName = function(self)
	return self.name
  end,
  
  addToList = function(self, list, item)
	self[list][#self[list]+1] = item
  end,

doCallback = function(self, list, callback)
  for i=1,#self[list] do
	callback(self[list][i])
	if type(self[list][i]) == "table" then
	  self.doCallback(self, self[list][i], callback)
	end
  end
end,

removeFromList = function(self, list, item)
for i=1,#self[list] do
local obj = self[list][i]
if obj == item then
self[list][i] = nil
end
end
end,

clearList = function(self, list)
for obj=1,#self[list] do
self[list][obj] = nil
end
end,

clearSet = function(self)
for obj=1,#self.whitelist do
self.whitelist[obj] = nil
end

for obj=1,#self.blacklist do
self.blacklist[obj] = nil
end
end,

destroySet = function(self)
self = nil
end,

isInList = function(self, list, item)
for obj=1,#self[list] do
if self[list][item] then
return self[list][item], list
end
end
end,

registerSet = function(self, name)
  local obj = {
  name = name;
  whitelist = {},
  blacklist = {},
  }
  setmetatable(obj, self)
  return obj
  end
  }
  
  warExtendedSet = {}
  warExtendedSet.__index = warExtendedLinkedList
  
  function warExtendedSet.RegisterNewSet(comboBoxName)
  local newSet = {
  comboBoxName = comboBoxName,
  selectedSet = nil;
  savedSets = {
  },
  }
  setmetatable (newSet, warExtendedLinkedList)
  return newSet
  end
  
  function warExtendedSet:AddSet(setName)
  self.savedSets[#self.savedSets+1] = set:registerSet(setName)
end

function warExtendedSet:LoadSet(set)
self.selectedSet = set
ComboBoxSetSelectedMenuItem(self.comboBoxName, set)
end

function warExtendedSet:GetSelectedSet()
return self.savedSets[self.selectedSet]
end


function warExtendedSet:RemoveSet(set)
self.savedSets[set]:destroySet()
if self.selectedSet == set then
warExtendedSet:LoadSet(1)
end
end

function warExtendedSet:ClearSet(set)
self.savedSets[set]:clearSet()
  end
  
