-- Most of original code from EA WAR Help Window modified for warExt Options
local OPTIONS_WINDOW                    = "warExtendedSettings"
local warExtended                       = warExtended

warExtendedSettings                     = {}

warExtendedSettings.rowToEntryMap       = {}
warExtendedSettings.numTotalRows        = 0
warExtendedSettings.lastPressedButtonId = 0
warExtendedSettings.currentOptions      = 0
warExtendedSettings.data                = {};
warExtendedSettings.lastParentWindow    = nil;

warExtendedSettings.ListBoxData         = {
}

function warExtendedSettings.OnLButtonUpRow()
  local row = WindowGetId(SystemData.ActiveWindow.name)
  warExtendedSettings.DisplayRow(row)
end

-- displays the entry information for a certain row
function warExtendedSettings.DisplayRow(rowIndex)
  local dataIndex    = ListBoxGetDataIndex(OPTIONS_WINDOW .. "List", rowIndex)
  local entryData    = warExtendedSettings.rowToEntryMap[dataIndex]   -- get the index in ManualWindow.data from the row
  entryData.expanded = not entryData.expanded
  
  warExtendedSettings.ResetPressedButton()
  warExtendedSettings.lastPressedButtonId = entryData.id
  ButtonSetPressedFlag(OPTIONS_WINDOW .. "ListRow" .. rowIndex .. "Name", true) -- set newly selected entry as pressed
  warExtendedSettings.DisplayManualEntry(entryData) -- display text for the just selected entry
  
  warExtendedSettings.PrepareData()
end

function warExtendedSettings.ResetPressedButton()
  warExtendedSettings.SetEntrySelectedById(warExtendedSettings.lastPressedButtonId, false)
end

local function getDepthText(entryId)
  local depthText = {}
  
  local function delve(entryId)
	for _, v in pairs(warExtendedSettings.rowToEntryMap) do
	  if v.id == entryId then
		table.insert(depthText, tostring(v.name))
		if v.parentEntryId ~= 0 then
		  delve(v.parentEntryId)
		end
	  end
	end
  end
  
  delve(entryId)
  table.sort(depthText, function(a, b) return a < b end)
  local headerText = towstring(table.concat(depthText, "/"))
  return headerText
end

local function getHeaderText(entryData)
  if entryData.parentEntryId ~= 0 then
	local headerText = getDepthText(entryData.id)
	return headerText
  end
  
  return entryData.name
end

function warExtendedSettings.DisplayManualEntry(entryData)
  local headerText = getHeaderText(entryData)
  LabelSetText(OPTIONS_WINDOW .. "HeaderText", headerText)
  
  if warExtendedSettings.lastParentWindow ~= nil then
	WindowSetShowing(warExtendedSettings.lastParentWindow, false)
  end
  
  warExtendedSettings.DisplayEntryWindow(entryData)
  warExtendedSettings.lastParentWindow = entryData.parentWindow
  
  ScrollWindowSetOffset(OPTIONS_WINDOW .. "Main", 0)        -- reset the scroll bar.
  ScrollWindowUpdateScrollRect(OPTIONS_WINDOW .. "Main")      -- reset the scroll bar.

end

function warExtendedSettings.SetEntrySelectedById(id, selected)
  for row = 1, warExtendedSettingsList.numVisibleRows do
	local index = ListBoxGetDataIndex(OPTIONS_WINDOW .. "List", row)
	local data  = warExtendedSettings.rowToEntryMap[index]
	if (data and data.id == warExtendedSettings.lastPressedButtonId) then
	  ButtonSetPressedFlag(OPTIONS_WINDOW .. "ListRow" .. row .. "Name", selected) -- set newly selected entry as pressed
	end
  end
end

function warExtendedSettings.SetListRowTints()
  for row = 1, warExtendedSettingsList.numVisibleRows do
	local row_mod         = math.mod(row, 2)
	color                 = DataUtils.GetAlternatingRowColor(row_mod)
	
	local targetRowWindow = OPTIONS_WINDOW .. "ListRow" .. row
	WindowSetTintColor(targetRowWindow .. "RowBackground", color.r, color.g, color.b)
	WindowSetAlpha(targetRowWindow .. "RowBackground", color.a)
  end
end

function warExtendedSettings.UpdateOptionsWindowRow()
  for row = 1, warExtendedSettingsList.numVisibleRows do
	local rowWindow = OPTIONS_WINDOW .. "ListRow" .. row
	local index     = ListBoxGetDataIndex(OPTIONS_WINDOW .. "List", row)
	local data      = warExtendedSettings.rowToEntryMap[index]
	
	if (data ~= nil)
	then
	  if (warExtendedSettings.lastPressedButtonId == data.id)
	  then
		ButtonSetPressedFlag(rowWindow .. "Name", true) -- set newly selected entry as pressed
	  else
		ButtonSetPressedFlag(rowWindow .. "Name", false)
	  end
	  
	  local hasChildEntries = #data.childEntries > 0
	  WindowSetShowing(rowWindow .. "PlusButton", hasChildEntries and not data.expanded)
	  WindowSetShowing(rowWindow .. "MinusButton", hasChildEntries and data.expanded)
	  
	  local depth = warExtendedSettings.ListBoxData[index].depth
	  WindowClearAnchors(rowWindow .. "Name")
	  WindowAddAnchor(rowWindow .. "Name", "left", rowWindow, "left", 30 + (15 * depth), 6)
	end
  end
end

function warExtendedSettings.PrepareData()
  -- reset tables and counters that are going to be used later on
  warExtendedSettings.orderTable    = {}
  warExtendedSettings.ListBoxData   = {}
  warExtendedSettings.numTotalRows  = 1                -- more of an index than row counter
  warExtendedSettings.rowToEntryMap = {}
  
  if (not warExtendedSettings.data) then
	return -- quit if we have no data to work on.
  end
  
  table.sort(warExtendedSettings.data, DataUtils.AlphabetizeByNames)
  
  local function AddEntryAsRow(entryIndex, entryData, depth)
	local entryTable = { name = entryData.name, depth = depth }
	table.insert(warExtendedSettings.ListBoxData, warExtendedSettings.numTotalRows, entryTable)
	table.insert(warExtendedSettings.orderTable, warExtendedSettings.numTotalRows)
	table.insert(warExtendedSettings.rowToEntryMap, warExtendedSettings.numTotalRows, entryData)
	
	warExtendedSettings.numTotalRows = warExtendedSettings.numTotalRows + 1
	
	if entryData.expanded
	then
	  -- entry is expanded so add children as rows, recursively
	  for childEntryIndex, childEntryData in ipairs(entryData.childEntries) do
		AddEntryAsRow(childEntryIndex, childEntryData, depth + 1)
	  end
	end
  end
  
  for entryIndex, entryData in ipairs(warExtendedSettings.data) do
	AddEntryAsRow(entryIndex, entryData, 0)
  end
  
  ListBoxSetDisplayOrder(OPTIONS_WINDOW .. "List", warExtendedSettings.orderTable)
  warExtendedSettings.SetListRowTints()
end

function warExtendedSettings.GetOptionsOrder()
  return warExtendedSettings.orderTable
end