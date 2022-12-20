local warExtendedTerminal = warExtendedTerminal

function warExtendedTerminal.DebugLogOnInitialize()
	warExtendedTerminal:RegisterToolbarItem(L"Debug Log", L"A concise error reporting tool.", "TerminalDebugLog", 04673, {
	 rowToEntryMap = {},
  numTotalRows = 0,
  lastPressedButtonId = 0,
 currentOptions = 0,
  data = {},
  lastParentWindow = nil,
  listBoxData = {}
	})
  warExtendedTerminal:WindowRegisterTextLogEvent("TerminalDebugLog", "UiLog", "warExtendedTerminal.DebugLogOnUiLogUpdate")
  warExtendedTerminal.DebugLogOnInitializeWindow()
end

function warExtendedTerminal.DebugLogPrepareData()
  local settings = warExtended.GetToolbarButtonSettings("TerminalDebugLog")
  
  	-- reset tables and counters that are going to be used later on
  	settings.orderTable = {}
  	settings.ListBoxData = {}
  	settings.numTotalRows = 1 -- more of an index than row counter
  	settings.rowToEntryMap = {}
  
  	if not warExtendedSettings.data then
  		return -- quit if we have no data to work on.
  	end
  
  	table.sort(warExtendedSettings.data, DataUtils.AlphabetizeByNames)
  
  	local function AddEntryAsRow(entryIndex, entryData, depth)
  		local entryTable = { name = entryData.name, depth = depth }
  		table.insert(warExtendedSettings.ListBoxData, warExtendedSettings.numTotalRows, entryTable)
  		table.insert(warExtendedSettings.orderTable, warExtendedSettings.numTotalRows)
  		table.insert(warExtendedSettings.rowToEntryMap, warExtendedSettings.numTotalRows, entryData)
  
  		warExtendedSettings.numTotalRows = warExtendedSettings.numTotalRows + 1
  
  		if entryData.expanded then
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


