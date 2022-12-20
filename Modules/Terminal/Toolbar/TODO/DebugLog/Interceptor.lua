local warExtendedTerminal = warExtendedTerminal

local expandableChildEntry = {
  createNew = function(self, name, parentWindow, id)
    local newChildEntry = setmetatable({}, { __index = self })
    newChildEntry.childEntries = {}
    newChildEntry.id = id + 100
    newChildEntry.expanded = false
    newChildEntry.name = towstring(name)
    newChildEntry.parentWindow = parentWindow
    newChildEntry.parentEntryId = id
    return newChildEntry
  end,
  
  createNewChild = function(self, name, parentWindow)
    self.childEntries[#self.childEntries + 1] = self:createNew(name, parentWindow, self.id)
  end,
}

local expandableOptionEntry = {
  createNew = function(self, name, parentWindow, id)
    local newEntry = setmetatable({}, { __index = self })
    newEntry.name = towstring(name:gsub("warExtended ", ""))
    newEntry.addonName = name
    newEntry.expanded = false
    newEntry.parentEntryId = 0
    newEntry.parentWindow = parentWindow
    newEntry.childEntries = {}
    newEntry.id = id
    return newEntry
  end,
  
  createNewChild = function(self, name, entryWindow)
    self.childEntries[#self.childEntries + 1] = childEntry:createNew(name, entryWindow, self.id)
  end,
}

local expandableListBoxManager = {
  totalEntries = 0,
  entryNameToId = {},
  dataTable = nil,
  
  registerNewEntry = function(self, entryTable, dataTable)
    local settings = warExtended.GetToolbarButtonSettings("TerminalDebugLog")
    self.totalEntries = self.totalEntries + 1
    self.entryNameToId[entryTable.entryName] = self.totalEntries
    settings.data[self.registeredOptions] = optionEntry:createNew(entryTable, self.registeredOptions)
  end,
  
  registerNewChildEntry = function(self, parentEntry, entryTable)
    local settings = warExtended.GetToolbarButtonSettings("TerminalDebugLog")
    local optionEntry = settings.data[self.entryNameToId[parentEntry.entryName]]
    optionEntry:createNewChild(entryTable)
  end,
}

function warExtendedTerminal.DebugLogAddSettingsEntry(entryTable)
  expandableListBoxManager:registerNewEntry(entryTable)
end

function warExtendedTerminal.DebugLogAddOptionChildEntry(parentEntry, entryTable)
  expandableListBoxManager:registerNewChildEntry(parentEntry, entryTable)
end













local tremove = table.remove
local pcall = pcall
local towstring = towstring
local TextLogGetEntry = TextLogGetEntry
local TextLogGetNumEntries = TextLogGetNumEntries
local ButtonSetDisabledFlag = ButtonSetDisabledFlag
local DoesWindowExist = DoesWindowExist
local uiLog = "UiLog"

-- 1 is SYSTEM
-- 2 is WARNING
-- 3 is ERROR
-- 4 is DEBUG
-- 5 is FUNCTION
-- 6 is LOADING

local uiLogInterceptor = {
  errorList = {[L"<Non-addon specific>"] = {} },
  errorCount = 0
}

errors = {
}

function testFunction321()
  p(errors)
end

function warExtendedTerminal.DebugLogOnShown()
  p("here")
end

function refreshTest()
  lastEntryNum = TextLogGetNumEntries(uiLog) - 1
  p(lastEntryNum)
  
  for i=0, lastEntryNum do
	local entryTime, entryFilter, entryText = TextLogGetEntry("UiLog", i)
	if entryFilter == 3 then
	  local addonName, errorMessage = entryText:match(L"^%(([^)]+)%): (.*)")
	  
	  if not addonName then
		addonName, errorMessage = L"<Non-addon specific>", entryText
	  end
	  
	  p(addonName, errorMessage)
	  
	  if not errors[addonName] then
		errors[addonName] = {}
	  end
	  
	  local addonErrorList = errors[addonName]
	  local numPastErrors = #addonErrorList
	  
	  if numPastErrors > 0 then
		local previousError = addonErrorList[numPastErrors]
		if 	errorMessage == previousError.errorText then
		  -- If it is, then just up the repeat count and we're done handling this message.
		  previousError.repeatCount = previousError.repeatCount + 1
		  continue
		end
	  end
	  
	  
	  -- If we've already seen 100 errors for this addon, stop recording
	  -- (since this only tracks errors since the last UI load, if there are 100+
	  -- errors for an addon we probably want to see the initial causes).
	  if numPastErrors >= 100 then return end
	  
	  -- If it's not a repeat, and we've seen fewer than 100 errors already
	  -- for this addon, add it to the list.
	  addonErrorList[numPastErrors+1] =
	  {
		timeStamp   = entryTime,
		errorText   = errorMessage,
		repeatCount = 1,
	  }
	
	end
	
  end
  
end


function warExtendedTerminal.DebugLogOnUiLogUpdate(updateType, filterType)
  -- For now, all we care about is new messages
  if updateType ~= 0 then return end
  
  -- For now, all we care about are error messages
  if filterType ~= 3 then return end
  
  lastEntryNum = TextLogGetNumEntries(uiLog) - 1
  local entryTime, entryFilter, entryText = TextLogGetEntry("UiLog", lastEntryNum)
  local addonName, errorMessage = entryText:match(L"^%(([^)]+)%):  (.*)")
  
  if not addonName then
	addonName, errorMessage = L"<Non-addon specific>", entryText
  end
  
  if not errors[addonName] then
	errors[addonName] = {}
  end
  
  local addonErrorList = errors[addonName]
  local numPastErrors = #addonErrorList
  
  if numPastErrors > 0 then
	local previousError = addonErrorList[numPastErrors]
	if 	errorMessage == previousError.errorText then
	  -- If it is, then just up the repeat count and we're done handling this message.
	  previousError.repeatCount = previousError.repeatCount + 1
	  return
	end
  end
  
  
  -- If we've already seen 100 errors for this addon, stop recording
  -- (since this only tracks errors since the last UI load, if there are 100+
  -- errors for an addon we probably want to see the initial causes).
  if numPastErrors >= 100 then return end
  
  -- If it's not a repeat, and we've seen fewer than 100 errors already
  -- for this addon, add it to the list.
  addonErrorList[numPastErrors+1] =
  {
	timeStamp   = entryTime,
	errorText   = errorMessage,
	repeatCount = 1,
  }
end

function warExtendedTerminal.DebugLogProcessUiLogUpdateProxy(...)
  
  -- This is a proxy to invoke ProcessUiLogUpdate using pcall.
  -- We really don't want to be generating ui log messages from within an event handler
  -- that was triggered by a generated ui log message (infinite recursion is bad).
  --if not warExtendedTerminal or not warExtendedTerminal.DebugLogOnUiLogUpdate then return end
  pcall(warExtendedTerminal.DebugLogOnUiLogUpdate, ...)
 
end

