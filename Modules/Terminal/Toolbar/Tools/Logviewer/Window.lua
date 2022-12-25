local warExtended         = warExtended
local WINDOW_NAME         = "TerminalLogViewer"
local SEARCH_LABEL        = 1
local LOG_LIST            = 2
local LOG_OUTPUT          = 3
local SEARCH_BOX          = 4
local ADD_BUTTON          = 5
local REMOVE_BUTTON       = 6
local TITLEBAR            = 10
local SORT_BUTTON_1       = 11
local SORT_BUTTON_2       = 12
--TODO: change savedVar pos from terminal to toolbar?

local TerminalLogViewer   = TerminalLogViewer
local WINDOW              = Frame:Subclass(WINDOW_NAME)
local LOAD_LOG			  = TextLog:Subclass("LogViewerLog")
local LOGS_FRAME          = ListBox:CreateFrameForExistingWindow(WINDOW_NAME .. "LogList")
local SEARCH_FRAME        = SearchEditBox:Create(WINDOW_NAME .. "Search", TerminalLogViewer:GetSavedSettings().savedLogs)
local OUTPUT_FRAME        = TextEditBox:CreateFrameForExistingWindow(WINDOW_NAME .. "Text")
local ADD_BUTTON_FRAME    = ButtonFrame:CreateFrameForExistingWindow(WINDOW_NAME .. "Add")
local REMOVE_BUTTON_FRAME = ButtonFrame:CreateFrameForExistingWindow(WINDOW_NAME .. "Remove")
local SORT_BTN_1          = ButtonFrame:CreateFrameForExistingWindow(WINDOW_NAME .. "LogSortButton1")
local SORT_BTN_2          = ButtonFrame:CreateFrameForExistingWindow(WINDOW_NAME .. "LogSortButton2")

function WINDOW:Create()
  self:CreateFromTemplate(WINDOW_NAME)
  LOGS_FRAME:SetSelfTable(TerminalLogViewerLogList)
  LOAD_LOG:Create(9999999999)
  
  self.m_Windows = {
	[TITLEBAR] = Label:CreateFrameForExistingWindow(WINDOW_NAME .. "TitleBarLabel"),
	[LOG_LIST] = LOGS_FRAME,
	[LOG_OUTPUT] = OUTPUT_FRAME,
	[SEARCH_BOX] = SEARCH_FRAME,
	[ADD_BUTTON] = ADD_BUTTON_FRAME,
	[REMOVE_BUTTON] = REMOVE_BUTTON_FRAME,
	[SEARCH_BOX] = SEARCH_FRAME,
	[SORT_BUTTON_1] = SORT_BTN_1,
	[SORT_BUTTON_2] = SORT_BTN_2,
  }
  
  local win      = self.m_Windows
  
  win[TITLEBAR]:SetText(L"Log Viewer")
  
  win[LOG_LIST]:SetRowDefintion()
  win[LOG_LIST]:SetDisplayOrder(TerminalLogViewer:GetSavedSettings().savedLogs)
  win[LOG_LIST]:SetRowTints()
  
  if win[LOG_OUTPUT]:TextAsWideString() == L"" then
	win[LOG_OUTPUT]:SetTextCache("Hover over an entry to see more information.")
  end
  
  win[ADD_BUTTON]:SetText(L"Add Log")
  win[REMOVE_BUTTON]:SetText(L"Remove Log")
  
  win[SORT_BUTTON_1]:SetText(L"Date")
  win[SORT_BUTTON_2]:SetText(L"Name")
  
  win[SEARCH_BOX].m_Windows[SEARCH_LABEL]:SetText(L"Search:")
  win[SEARCH_BOX]:AddCallback(LOGS_FRAME.OnTextChangedSearch)
  --  win[SEARCH_BOX]:AddFilters(searchFilters)

end

function TerminalLogViewer.GetLog(logName)
  for log=1,#TerminalLogViewer:GetSavedSettings().savedLogs do
	if TerminalLogViewer:GetSavedSettings().savedLogs[log].name == logName then
	  return true
	end
  end
end

function TerminalLogViewer.AddLog(logName, logObjects)
  -- if not TerminalLogViewer.GetLog(logName) then
  --DialogManager.MakeOneButtonDialog(L"You should add at least one effect filter", L"Ok",
  -- DialogManager.MakeDoubleTextEntryDialog(L"Add Log", L"Log name:", logName, L"Log objects:\n(Separate objects by ,)", logObjects, TerminalLogViewer.AddLog, nil, nil, nil, nil, 1)
  
  --local dlgIndex = DialogManager.FindAvailableDialog(DialogManager.oneButtonDlgs, DialogManager.NUM_ONE_BUTTON_DLGS)
  
  --if dlgIndex then
  --dlgIndex = dlgIndex - 1
  --end
  
  --WindowClearAnchors("OneButtonDlg" .. dlgIndex)
  --WindowAddAnchor("OneButtonDlg" .. dlgIndex, "Center", "Root", "Center", 0, 0)
  --  end
  
  --StringUtils.FormatDateString(month, day, year)
  --p(Enemy.GetTimeFromSeconds(GetComputerTime ()))
  --p(StringUtils.FormatTimeString(19, 30))
  
  if TerminalLogViewer.GetLog(logName) then
	DialogManager.MakeOneButtonDialog(L"A log with this name already exists.", L"Ok",
			DialogManager.MakeDoubleTextEntryDialog(L"Add Log", L"Log name:", logName, L"Log objects:\n(Separate objects by ;)", logObjects, TerminalLogViewer.AddLog, nil, nil, nil))
	return
	elseif logObjects == L"" then
	DialogManager.MakeOneButtonDialog(L"Log objects cannot be empty.", L"Ok",
	DialogManager.MakeDoubleTextEntryDialog(L"Add Log", L"Log name:", logName, L"Log objects:\n(Separate objects by ;)", logObjects, TerminalLogViewer.AddLog, nil, nil, nil))
	return
  end
  
  local dt   = warExtended:GetCurrentDateTime()
  local date = StringUtils.FormatDateString(dt.month, dt.day, dt.year)
  local time = StringUtils.FormatTimeString(dt.hours, dt.minutes)
  p(date, time)
  
  local logs      = TerminalLogViewer:GetSavedSettings().savedLogs
  
  logs[#logs + 1] = {
	name = logName,
	date = date,
	time = time,
	objects = objects,
	totalSeconds = dt.totalSeconds,
	contents = StringSplit(warExtended:toString(logObjects), ",")
  }
  
  p(logs)
  p(logName, logObjects)
  return warExtended:Script(L"TerminalLogViewer.DumpLog(\"" .. (logName) .. L"\"," .. logObjects .. L")")
end

function TerminalLogViewer.RemoveLog()

end

function TerminalLogViewer.LoadLog(logName)
  LOAD_LOG:LoadFromFile(logName)
  
end

function TerminalLogViewer.DumpLog(name, ...)
  local log = TextLog:Subclass(name)
  local logName = warExtended:toWString(log:GetName())
  log:Create(9999999999)
  log:SetIncrementalSaving(true, logName)
  log:AddEntry(0, warExtended:toWString(objToString(...)))
  log:SetIncrementalSaving(false, logName)
  log:Destroy()
end

function ADD_BUTTON_FRAME:OnLButtonUp(...)
  DialogManager.MakeDoubleTextEntryDialog(L"Add Log", L"Log name:", L"", L"Log objects:\n(Separate objects by ;)", L"", TerminalLogViewer.AddLog, nil, nil, nil)
end

function REMOVE_BUTTON_FRAME:OnLButtonUp(...)
  p(...)
end

function LOGS_FRAME.OnTextChangedSearch(searchResults)
  LOGS_FRAME:SetDisplayOrder(searchResults, function(a, b) return a < b end)
end

function LOGS_FRAME.OnLButtonUpLog(idx, _, ...)
  local log = TerminalLogViewer:GetSavedSettings().savedLogs[idx]
  LOAD_LOG:LoadFromFile(log.name)
  OUTPUT_FRAME:SetOutputText(LOAD_LOG:GetEntriesAsString())
end

function LOGS_FRAME.OnMouseOverLog(idx, _, ...)
  local log = TerminalLogViewer:GetSavedSettings().savedLogs[idx]
  
  p(log)
end

function LOGS_FRAME:SetRowDefintion()
  local rowCallbacks = {
	["OnMouseOver"] = LOGS_FRAME.OnMouseOverLog,
	["OnLButtonUp"] = LOGS_FRAME.OnLButtonUpLog
  }
  
  local labelData    = {
	["Date"] = { subclass = Label, callback = function(self, index)
	  local log  = TerminalLogViewer:GetSavedSettings().savedLogs[index]
	  local date = log.date .. L"\n" .. log.time
	  self:SetText(date)
	end },
	["Contents"] = { subclass = Label, callback = function(self, index)
	  local log      = TerminalLogViewer:GetSavedSettings().savedLogs[index].contents
	  local contents = table.concat(log, ", ")
	  self:SetText(warExtended:toWString(contents))
	end },
  }
  
  self:SetRowCallbacks(rowCallbacks)
  self:SetRowPopulation(labelData)
end

function OUTPUT_FRAME:SetOutputText(data)
  local str = objToString(data)
  self:SetTextCache(str)
end

function TerminalLogViewer.UpdateDisplay()
  local logs = TerminalLogViewer:GetSavedSettings().savedLogs
  
  LOGS_FRAME:SetDisplayOrder(logs)
end

function TerminalLogViewer.OnPopulateLogs()
  LOGS_FRAME:SetRowData()
  LOGS_FRAME:SetRowTints()
end

WINDOW:Create()