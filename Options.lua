local warExtended = warExtended

warExtended.data = nil           -- data we receive from C
ManualWindow.OptionsListBoxDataOrder = {}
ManualWindow.listBoxData = {}     -- same data, but organized in such a way that ListBox can display it.
ManualWindow.rowToEntryMap = {}   -- map used to go from the # of the row to the entry in ManualWindow.data
ManualWindow.numTotalRows = 0                -- this value is used to count how many rows are currently visible in the listbox
ManualWindow.lastPressedButtonId = 0


warExtended.OptionsListBoxData = {
  }

local configurationWindow = {
}

function warExtended.InitializeOptions()
  p("initializing opt")
end

function warExtended.OptionsOnInitialize()
  p('window shown')
end

function warExtended.OptionsOnShutdown()
  p("window disabled")
end