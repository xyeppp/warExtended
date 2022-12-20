local warExtendedTerminal = warExtendedTerminal

function warExtendedTerminal.DebugLogOnInitializeWindow()
  ButtonSetText("TerminalDebugLogSortButton1", L"Last Error")
  ButtonSetText("TerminalDebugLogSortButton2", L"Addon Name")
  ButtonSetText("TerminalDebugLogSortButton3", L"Error Count")
end

function warExtendedTerminal.DebugLogPopulateErrorList()
  local settings = warExtended.GetToolbarButtonSettings("TerminalDebugLog")
  
  for row = 1, TerminalDebugLogErrorList.numVisibleRows do
    local rowWindow = TerminalDebugLogError .. "ListRow" .. row
    local index = ListBoxGetDataIndex(TerminalDebugLogError .. "List", row)
    local data = settings.rowToEntryMap[index]
    
    if data ~= nil then
      if settings.lastPressedButtonId == data.id then
        ButtonSetPressedFlag(rowWindow .. "Name", true) -- set newly selected entry as pressed
      else
        ButtonSetPressedFlag(rowWindow .. "Name", false)
      end
      
      local hasChildEntries = #data.childEntries > 0
      WindowSetShowing(rowWindow .. "PlusButton", hasChildEntries and not data.expanded)
      WindowSetShowing(rowWindow .. "MinusButton", hasChildEntries and data.expanded)
      
      local depth = settings.ListBoxData[index].depth
      WindowClearAnchors(rowWindow .. "Name")
      WindowAddAnchor(rowWindow .. "Name", "left", rowWindow, "left", 30 + (15 * depth), 6)
    end
  end
end

function warExtendedTerminal.DebugLogSetEntrySelectedById(id, selected)
  local settings = warExtended.GetToolbarButtonSettings("TerminalDebugLog")
  
  for row = 1, TerminalDebugLogErrorList.numVisibleRows do
    local index = ListBoxGetDataIndex("TerminalDebugLogError" .. "List", row)
    local data = settings.rowToEntryMap[index]
    if data and data.id == settings.lastPressedButtonId then
      ButtonSetPressedFlag("TerminalDebugLogError" .. "ListRow" .. row .. "Name", selected) -- set newly selected entry as pressed
    end
  end
  
end

function warExtendedTerminal.DebugLogSetListRowTints()
  for row = 1, TerminalDebugLogErrorList.numVisibleRows do
    local row_mod = math.mod(row, 2)
    color = DataUtils.GetAlternatingRowColor(row_mod)
    
    local targetRowWindow = "TerminalDebugLogError" .. "ListRow" .. row
    WindowSetTintColor(targetRowWindow .. "RowBackground", color.r, color.g, color.b)
    WindowSetAlpha(targetRowWindow .. "RowBackground", color.a)
  end
end

function warExtendedTerminal.DebugLogOnLButtonUpRow()
  local row = WindowGetId(SystemData.ActiveWindow.name)
  warExtendedTerminal.DebugLogDisplayRow(row)
end


-- displays the entry information for a certain row
function warExtendedTerminal.DebugLogDisplayRow(rowIndex)
  local settings = warExtended.GetToolbarButtonSettings("TerminalDebugLog")
  
  local dataIndex = ListBoxGetDataIndex("TerminalDebugLogError" .. "List", rowIndex)
  local entryData = settings.rowToEntryMap[dataIndex] -- get the index in ManualWindow.data from the row
  entryData.expanded = not entryData.expanded
  
  warExtendedTerminal.DebugLogResetPressedButton()
  settings.lastPressedButtonId = entryData.id
  ButtonSetPressedFlag("TerminalDebugLogError" .. "ListRow" .. rowIndex .. "Name", true) -- set newly selected entry as pressed
  
  warExtendedTerminal.DebugLogDisplayManualEntry(entryData) -- display text for the just selected entry
  
  warExtendedTerminal.DebugLogPrepareData()
end

function warExtendedTerminal.DebugLogResetPressedButton()
  local settings = warExtended.GetToolbarButtonSettings("TerminalDebugLog")
  
  warExtendedTerminal.DebugLogSetEntrySelectedById(settings.lastPressedButtonId, false)
end

function warExtendedTerminal.DebugLogDisplayManualEntry(entryData)
  TextEditBoxSetText("TerminalDebugLogText", entryData.errorText)
end



