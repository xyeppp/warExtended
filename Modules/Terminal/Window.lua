local warExtendedTerminal = warExtendedTerminal
local Terminal = warExtendedTerminal
local TerminalWindow = "DebugWindow"
local copyWindow = "DevPadCopy"
local copyBar    = "CopyScrollBar"
local isDragged = false

--DebugWindow.spyfilter              = SystemData.Events
--RegisteredEvents = {}
--DebugWindow.RegisteredFunctionList = {}

function warExtendedTerminal.UpdateLoggingButton()
  
  if (warExtendedTerminal.Settings.logsOn == true) then
	ButtonSetText("DebugWindowToggleLogging", L"Logs (On)")
  else
	ButtonSetText("DebugWindowToggleLogging", L"Logs (Off)")
  end

end

function warExtendedTerminal.OnResizeBegin(minX, minY, endCallback)
  WindowUtils.BeginResize(TerminalWindow, "topleft", 300, 200, nil)
end

function warExtendedTerminal.OnShutdownWindow()

end

function warExtendedTerminal.OnUpdateWindow(timePassed)
  --[[if (warExtendedTerminal.lastMouseX ~= SystemData.MousePosition.x or warExtendedTerminal.lastMouseY ~= SystemData.MousePosition.x) then
	local mousePoint = L"" .. SystemData.MousePosition.x .. L", " .. SystemData.MousePosition.y;
	LabelSetText("DebugWindowMousePointText", mousePoint);
	
	warExtendedTerminal.lastMouseX = SystemData.MousePosition.x;
	warExtendedTerminal.lastMouseY = SystemData.MousePosition.y;
  end]]
  
  
  
  -- Update the MouseoverWindow
  if (warExtendedTerminal.lastMouseOverWindow ~= SystemData.MouseOverWindow.name) then
	LabelSetText("DebugWindowMouseOverText", StringToWString(SystemData.MouseOverWindow.name))
	
	warExtendedTerminal.lastMouseOverWindow = SystemData.MouseOverWindow.name
  end
end

function warExtendedTerminal.WindowOnLButtonDown ()
  isDragged = true
end

function warExtendedTerminal.WindowOnLButtonUp ()
  if isDragged then
	warExtendedTerminal.ReanchorOptions()
  end
  
  isDragged = false
end

DebugWindow = {}

function DebugWindow.OnInitializeWindow()
  CHAT_DEBUG(L"DASnt")
  
  -- Setup the Log
 warExtendedTerminal.UpdateLog()
  
  
  CHAT_DEBUG(L"PAST")
  --local version = warExtended:toWString(warExtended.GetAddonVersion("warExtended Terminal"))
 -- LabelSetText("DebugWindowMouseOverLabel", L"Terminal "..version)
  
  
  if warExtendedTerminal.Settings.showTimestamp then
	LogDisplaySetShowTimestamp("DebugWindowText", true)
  else
	LogDisplaySetShowTimestamp("DebugWindowText", false)
  end
  LogDisplaySetShowLogName("DebugWindowText", false)
  LogDisplaySetShowFilterName("DebugWindowText", true)
  
  -- Add the Lua Log
  warExtendedTerminal.AddUiLog()
  ButtonSetText("DebugWindowReloadUi", L"Reload UI")
  ButtonSetText("DebugWindowClose", L"X")
  
  
  
  
  -- Options
  ButtonSetText("DebugWindowToggleOptions", L"Options")
  
  --DevPad
  ButtonSetText("DebugWindowToggleDevPad", L"DevPad")
  
  --Copy
  ButtonSetText("DebugWindowToggleCopy", L"Copy")
  
  --Object
  ButtonSetText("DebugWindowToggleObject", L"Inspect")
  
  CreateWindow("DebugWindowOptions", false)
  CreateWindow("DevPadWindow", false)
  
  LabelSetText("DebugWindowOptionsFiltersTitle", L"Logging Filters:")
  LabelSetText("DebugWindowOptionsFilterType1Label", L"Ui System Messages")
  LabelSetText("DebugWindowOptionsFilterType2Label", L"Warning Messages")
  LabelSetText("DebugWindowOptionsFilterType3Label", L"Error Messages")
  LabelSetText("DebugWindowOptionsFilterType4Label", L"Debug Messages")
  LabelSetText("DebugWindowOptionsFilterType5Label", L"Function Calls Messages")
  LabelSetText("DebugWindowOptionsFilterType6Label", L"File Loading Messages")
  LabelSetText("DebugWindowOptionsFilterType9Label", L"Input Messages")
  LabelSetText("DebugWindowOptionsFilterType10Label", L"Output Messages")
  LabelSetText("DebugWindowOptionsFilterType11Label", L"Event Messages")
  ButtonSetText("DebugWindowOptionsClose", L"Close")
  
  -- Options
  for filterType, filterData in pairs(Terminal.Settings.LogFilters)
  do
	local buttonName = "DebugWindowOptionsFilterType" .. filterType .. "Button"
	ButtonSetStayDownFlag(buttonName, true)
	
	LogDisplaySetFilterState("DebugWindowText", "UiLog", filterType, filterData.enabled)
	ButtonSetPressedFlag(buttonName, filterData.enabled)
	WindowSetId(buttonName, filterType)
	
	
	-- When UI Log filters are off, disable logging of that filter type entirely.
	TextLogSetFilterEnabled("UiLog", filterType, filterData.enabled)
  end
  
  LabelSetText("DebugWindowOptionsErrorHandlingTitle", L"Generate lua-errors from:")
  LabelSetText("DebugWindowOptionsErrorOption1Label", L"Lua calls to ERROR()")
  LabelSetText("DebugWindowOptionsErrorOption2Label", L"Errors in lua calls to C")
  
  for index = 1, 2
  do
	ButtonSetStayDownFlag("DebugWindowOptionsErrorOption" .. index .. "Button", true)
  end
  ButtonSetPressedFlag("DebugWindowOptionsErrorOption1Button", Terminal.Settings.useDevErrorHandling)
  ButtonSetPressedFlag("DebugWindowOptionsErrorOption2Button", GetUseLuaErrorHandling())
  
  LabelSetText("DebugWindowOptionsLuaDebugLibraryLabel", L"Show Timestamps")
  ButtonSetPressedFlag("DebugWindowOptionsLuaDebugLibraryButton", LogDisplayGetShowTimestamp("DebugWindowText"))
  
  ButtonSetText("DebugWindowOptionsClearLogText", L"Clear Log")
  WindowSetShowing("DebugWindowOptionsFilterType10", false)
  WindowSetShowing("EA_LabelCheckButtonSmallCopy", false)
  
  WindowSetShowing("DebugWindowOptions", false)
  WindowSetShowing(copyBar, false)
  WindowSetShowing(copyWindow, false)
  
  --HandlePregameInit()
  
  --history
  TextEditBoxSetHistory("DebugWindowTextBox", Terminal.Settings.history)
  if (Terminal.Settings.history) then
	TextEditBoxSetHistory("DebugWindowTextBox", Terminal.Settings.history)
  end
  --defs
 -- abfind     = DebugWindow.AbilityFind
  desc       = "desc"
 -- mesh       = Mesh.Toggle
  changefont = SetNamesAndTitlesFont
 -- RegisterEventHandler(327698, "DebugWindow.InitAddons")
end

--[[function Terminal.InitAddons()
  DevPad.Initialize()
  ObjectInspector.WindowInit()
  CaptainHook.Initialise()
end]]

function warExtendedTerminal.OnShown()
--  TerminalToolbar:Toggle()
 -- warExtendedTerminal.ShowToolbar ()
 -- if not bustedloaded then return else
	--if Busted.Show then
	--  WindowSetShowing("BustedGUI", true)
	--end
  --end
end

function Terminal.OnHidden()
 -- TerminalToolbar:Toggle()
  --warExtendedTerminal.HideToolbar()
 -- WindowSetShowing("BustedGUI", false)
end

-- OnShutdown Handler
function Terminal.Shutdown()
  --warExtended:FixSettings (warExtendedTerminal.Settings)
  Terminal.Settings.history = TextEditBoxGetHistory("DebugWindowTextBox")
end

function Terminal.Hide()
  WindowSetShowing("DebugWindow", false)
  WindowSetShowing("DebugWindowOptions", false)
  --if WindowGetShowing("BustedGUI") then
	--WindowSetShowing("BustedGUI", false)
  --end
end


function Terminal.ClearTextLog()
  --DEBUG(L"Entered Clear text Log")
  
  -- Clear the UI log
  TextLogClear("UiLog")
  
  -- Options
  for filterType, filterData in pairs(Terminal.Settings.LogFilters)
  do
	LogDisplaySetFilterState("DebugWindowText", "UiLog", filterType, filterData.enabled)
	
	-- When UI Log filters are off, disable logging of that filter type entirely.
	TextLogSetFilterEnabled("UiLog", filterType, filterData.enabled)
  end
  
  for index = 1, 2
  do
	ButtonSetStayDownFlag("DebugWindowOptionsErrorOption" .. index .. "Button", true)
  end
  
  ButtonSetPressedFlag("DebugWindowOptionsErrorOption1Button", Terminal.Settings.useDevErrorHandling)
  ButtonSetPressedFlag("DebugWindowOptionsErrorOption2Button", GetUseLuaErrorHandling())
  ButtonSetPressedFlag("DebugWindowOptionsLuaDebugLibraryButton", LogDisplayGetShowTimestamp("DebugWindowText"))

end


--modified LoadLuaDebugLibrary into timeStamp since we don't have an internal client and never will
function Terminal.UpdateLoadLuaDebugLibrary()
  local enabled = LogDisplayGetShowTimestamp("DebugWindowText")
  enabled       = not enabled
  
  LogDisplaySetShowTimestamp("DebugWindowText", enabled)
  if enabled then
	Terminal.Settings.showTimestamp = true
  else
	Terminal.Settings.showTimestamp = false
  end
  ButtonSetPressedFlag("DebugWindowOptionsLuaDebugLibraryButton", enabled)
end

-----------------CHAT HISTORY-----------------
function Terminal.AddInputHistory()
  table.insert(Terminal.Settings.history, text)
end

------------SCROLL TO BOTTOM----------------------
function Terminal.ScrollToBottom ()
  LogDisplayScrollToBottom("DebugWindowText")
  WindowAssignFocus("DebugWindowTextBox", true)
end

function Terminal.ScJoin()
  pp("Attempting to join a scenario.")
  BroadcastEvent(SystemData.Events.SCENARIO_INSTANCE_JOIN_NOW)
end

function Terminal.ScGroup()
  if not WindowGetShowing("ScenarioGroupWindow") then
	pp("Displaying Scenario Groups Window.")
	WindowSetShowing("ScenarioGroupWindow", true)
  else
	pp("Hiding Scenario Groups Window.")
	WindowSetShowing("ScenarioGroupWindow", false)
  end
end

function Terminal.GuildID()
  pp("Your Guild ID is: " .. tostring(GameData.Guild.m_GuildID))
end

function Terminal.CombatLog()
  local logOn = TextLogGetEnabled("Combat")
  if logOn then
	pp("Disabling Combat log.")
	TextLogSetEnabled("Combat", false)
  else
	pp("Enabling Combat log.")
	TextLogSetEnabled("Combat", true)
  end
end

---------------------MAIN CHAT SEND-----------------
function Terminal.TextSend()
  text = towstring(TextEditBoxGetText(SystemData.ActiveWindow.name))
  if text == L"" then
	Terminal.TextSender()
  elseif text == L"h" then
	Terminal.TextSender()
	Terminal.help()
  elseif text == L"r" then
	InterfaceCore.ReloadUI()
  elseif text == L"f" then
	Terminal.TextSender()
	functionlist()
  elseif text == L"e" then
	Terminal.TextSender()
	Terminal.EventList()
  elseif text == L"s" then
	Terminal.TextSender()
	Terminal.Spy()
  elseif text == L"areainfo" then
	Terminal.TextSender()
	Terminal.GetAreaInfo()
  elseif text == L"abfind" then
	Terminal.TextSender()
	Terminal.AbilityFind()
  elseif text == L"mesh" then
	Terminal.TextSender()
	Mesh.Toggle()
  elseif text == L"scjoin" then
	Terminal.TextSender()
	Terminal.ScJoin()
  elseif text == L"scgroup" then
	Terminal.TextSender()
	Terminal.ScGroup()
  elseif text == L"guildid" then
	Terminal.TextSender()
	Terminal.GuildID()
  elseif text == L"keepid" then
	Terminal.TextSender()
	Terminal.KeepList()
  elseif text == L"fontlist" then
	Terminal.TextSender()
	Terminal.FontList()
  elseif text == L"changefont" then
	Terminal.TextSender()
	pp("Usage: changefont(\"font1\", \"font2\")\nChanges the name & title font respectively. (fontlist to print available fonts)")
  elseif text == L"clog" then
	Terminal.TextSender()
	Terminal.CombatLog()
  elseif text ~= nil then
	Terminal.TextSender()
	Terminal.ScriptSender()
  end
end

-------------AUTOSEND----------------
function Terminal.AutoSender()
  local text = towstring(TextEditBoxGetText("DebugWindowTextBox"))
  if text == L"ff" then
	Terminal.TextSender()
	Terminal.RegisteredList()
  elseif text == L"ror" then
	Terminal.TextSender()
	Terminal.ror()
  elseif text == L"ss" then
	Terminal.TextSender()
	Terminal.SpyStop()
  elseif text == L"spylist" then
	Terminal.TextSender()
	Terminal.SpyList()
  elseif text == L"devpad" then
	Terminal.TextSender()
	Terminal.Toggle()
  end
end



---------------------------------------------------------------------
----------------EVENT SPY--------------------


function Terminal.OnShowFocus()
  local visible = WindowGetShowing("DebugWindow") == true
  local codevis = WindowGetShowing("DevPadWindowDevPadCode") == true
  if codevis == true and visible == false then
	WindowAssignFocus("DevPadWindowDevPadCode", true)
  elseif visible == true then
	WindowAssignFocus("DebugWindowTextBox", true) end
end

-----------------------
-------------REGISTER ALL FUNCTIONS------------
function Terminal.RegisterFunctions()
  for k in pairs(Terminal.RegisteredFunctionList) do
	Terminal.RegisteredFunctionList[k] = nil
  end
  for i, v in pairs(_G) do
	if type(v) == "function" then
	  Terminal.RegisteredFunctionList[i] = v
	end
  end
  table.sort(Terminal.RegisteredFunctionList)
end

---------------------------------------------------------------------
------------- PRINT ALL REGISTERED FUINCTIONS---------------------

function Terminal.RegisteredList()
  Terminal.RegisterFunctions()
  p(Terminal.RegisteredFunctionList)
end

------------------------------SEND FROM TERMINAL-------------

function Terminal.ScriptSender(...)
  local emptytext = false;
  local regex     = string.match(tostring(text), "\^\%s")
  if regex then
	emptytext = true;
  else
	emptytext = false;
  end
  if not emptytext then
	SendChatText(L"/script " .. towstring(text), L"")
  end
end

function Terminal.TextSender()
  local text = towstring(TextEditBoxGetText("DebugWindowTextBox"))
  inp(text)
  Terminal.AddInputHistory()
  Terminal.ScrollToBottom()
  TextEditBoxSetText(SystemData.ActiveWindow.name, L"")
end

-----------------------ON ESC BEHAVIOR TEXTBOX---------------------------------------
function Terminal.TextClear()
  local devpad          = WindowGetShowing("DevPadWindow") == true
  local scrollcondition = LogDisplayIsScrolledToBottom("DebugWindowText") == true
  local text            = TextEditBoxGetText("DebugWindowTextBox")
  local texting         = true;
  if (text == L"" and scrollcondition == true) then
	texting = false;
	if devpad == true then
	  WindowAssignFocus("DevPadWindowDevPadCode", true)
	else
	  Terminal.Hide()
	end
  end
  if texting then
	Terminal.ScrollToBottom()
	if scrollcondition == true then
	  TextEditBoxSetText(SystemData.ActiveWindow.name, L"")
	end
  end
end
---------------------------------------------------------------------
---------on esc window behavior------------------------------
function Terminal.OnKeyEscape()
  if WindowGetShowing("DebugWindow") then
	WindowAssignFocus("DebugWindowTextBox", true)
	Terminal.ScrollToBottom()
  end
end
------------------------

