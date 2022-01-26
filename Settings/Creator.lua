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

function Enemy.CreateConfigurationWindow (wn, root, properties, onChange)
  
  CreateWindowFromTemplate (wn, "EA_Window_Default", root)
  
  local onchange_handlers = {}
  g.onChangeHandlers[wn] = onchange_handlers
  
  local pp = {}
  g.properties[wn] = pp
  
  local window_width = 0
  local window_height = 0
  local prev_wnp = nil
  
  local sorted_properties = {}
  for _, p in pairs (properties)
  do
	tinsert (sorted_properties, p)
  end
  
  table.sort (sorted_properties, function (a, b)
	return a.order < b.order
  end)
  
  local tab_order = 1
  
  for _, p in ipairs (sorted_properties)
  do
	local wnp = wn.."___"..p.key.."___"
	
	if (p.onCreate)
	then
	  p.onCreate (wnp, p)
	else
	  if (p.type == "int" or p.type == "float")
	  then
		CreateWindowFromTemplate (wnp, p.template or "EnemyConfigurationWindow_PropertyNumberTemplate", wn)
		LabelSetText (wnp.."Label", p.name)
		
		WindowSetTabOrder (wnp.."Value", tab_order)
		tab_order = tab_order + 1
	  
	  elseif (p.type == "int[]")
	  then
		CreateWindowFromTemplate (wnp, p.template or "EnemyConfigurationWindow_PropertyNumberArray"..p.size.."Template", wn)
		LabelSetText (wnp.."Label", p.name)
		
		for k = 1, p.size
		do
		  WindowSetTabOrder (wnp.."Value"..k, tab_order)
		  tab_order = tab_order + 1
		end
	  
	  elseif (p.type == "color")
	  then
		CreateWindowFromTemplate (wnp, p.template or "EnemyConfigurationWindow_PropertyColorTemplate", wn)
		LabelSetText (wnp.."Label", p.name)
		
		for k = 1, 3
		do
		  WindowSetTabOrder (wnp.."Value"..k, tab_order)
		  tab_order = tab_order + 1
		end
	  
	  elseif (p.type == "select")
	  then
		CreateWindowFromTemplate (wnp, p.template or "EnemyConfigurationWindow_PropertySelectTemplate", wn)
		
		local select_values = p.values
		if (type (select_values) == "function")
		then
		  select_values = select_values ()
		end
		
		for _, v in ipairs (select_values)
		do
		  ComboBoxAddMenuItem (wnp.."Value", Enemy.toWStringOrEmpty (v.text))
		end
		
		LabelSetText (wnp.."Label", p.name)
		
		WindowSetTabOrder (wnp.."Value", tab_order)
		tab_order = tab_order + 1
	  
	  elseif (p.type == "bool")
	  then
		CreateWindowFromTemplate (wnp, p.template or "EnemyConfigurationWindow_PropertyBoolTemplate", wn)
		ButtonSetStayDownFlag (wnp.."Value", true)
		LabelSetText (wnp.."Label", p.name)
		
		WindowSetTabOrder (wnp.."Value", tab_order)
		tab_order = tab_order + 1
	  
	  elseif (p.type == "title")
	  then
		CreateWindowFromTemplate (wnp, p.template or "EnemyConfigurationWindow_TitleTemplate", wn)
		LabelSetText (wnp.."Label", p.name)
	  
	  elseif (p.type == "button")
	  then
		CreateWindowFromTemplate (wnp, p.template or "EnemyConfigurationWindow_ButtonTemplate", wn)
		ButtonSetText (wnp.."Value", p.name)
		
		WindowSetTabOrder (wnp.."Value", tab_order)
		tab_order = tab_order + 1
	  
	  elseif (p.type == "macro")
	  then
		CreateWindowFromTemplate (wnp, p.template or "EnemyConfigurationWindow_MacroTemplate", wn)
		LabelSetText (wnp.."Label", p.name)
	  
	  else
		CreateWindowFromTemplate (wnp, p.template or "EnemyConfigurationWindow_PropertyStringTemplate", wn)
		LabelSetText (wnp.."Label", p.name)
		
		WindowSetTabOrder (wnp.."Value", tab_order)
		tab_order = tab_order + 1
	  end
	end
	
	local width, height = WindowGetDimensions (wnp)
	
	if (p.windowWidth ~= nil)
	then
	  width = p.windowWidth
	  WindowSetDimensions (wnp, width, height)
	end
	
	if (p.windowHeight ~= nil)
	then
	  height = p.windowHeight
	  WindowSetDimensions (wnp, width, height)
	end
	
	window_width = math.max (window_width, width)
	
	if (prev_wnp)
	then
	  WindowAddAnchor (wnp, "bottomleft", prev_wnp, "topleft", p.paddingLeft or 0, p.paddingTop or 10)
	  window_height = window_height + height + (p.paddingTop or 10)
	else
	  WindowAddAnchor (wnp, "topleft", wn, "topleft", p.paddingLeft or 0, p.paddingTop or 0)
	  window_height = window_height + height + (p.paddingTop or 0)
	end
	
	prev_wnp = wnp
	
	onchange_handlers[p.key] = p.onChange or onChange
	pp[p.key] = p
  end
  
  window_height = window_height + 30
  WindowSetDimensions (wn, window_width, window_height)
  return window_width, window_height
end

warExtended:AddEventHandler("CreateEntry", "CreateSettingsEntry", warExtendedSettings.AddOptionEntry)

