DebugWindow = {}

--TODO: Create context menu instead of logs(on), options, reloadui

local warExtendedTerminal = warExtendedTerminal
local Terminal = warExtendedTerminal
local TERMINAL_WINDOW = "DebugWindow"
local isDragged = false

if( IsInternalBuild() and (InterfaceCore.inGame == false) and TextLogGetEnabled( "UiLog" ) )
then
    warExtendedTerminal.Settings.logsOn = true
    warExtendedTerminal.Settings.useDevErrorHandling = GetUseLuaErrorHandling()
    warExtendedTerminal.Settings.loadLuaDebugLibrary = GetLoadLuaDebugLibrary()

    -- Filters
    for filterType, filterData in pairs( DebugWindow.Settings.LogFilters )
    do
        filterData.enabled = TextLogGetFilterEnabled( "UiLog", filterType)
    end

end

local function HandlePregameInit()

    if( IsInternalBuild() and (InterfaceCore.inGame == false) )
    then

        -- If the Logs are enabled in the pregame, show the window
        if( warExtendedTerminal.Settings.logsOn )
        then
            WindowSetShowing( "DebugWindow", true )
        end
    end
end

function DebugWindow.WindowOnInitialize()
    SetLoadLuaDebugLibrary(false)

    CreateWindow("DebugWindowOptions", false)

    CreateWindowFromTemplate("DebugWindowOptionsLogsOn", "warExtendedTerminalLogsOptionContextMenu", "Root")
    CreateWindowFromTemplate("DebugWindowOptionsLogsOff", "warExtendedTerminalLogsOptionContextMenu", "Root")

  -- Setup the Log
 warExtendedTerminal.UpdateLog()

  if warExtendedTerminal.Settings.showTimestamp then
	LogDisplaySetShowTimestamp("DebugWindowText", true)
  else
	LogDisplaySetShowTimestamp("DebugWindowText", false)
  end

  LogDisplaySetShowLogName("DebugWindowText", false)
  LogDisplaySetShowFilterName("DebugWindowText", true)

  -- Add the Lua Log
  warExtendedTerminal.AddUiLog()

  LabelSetText("DebugWindowTitleBarLabel", L"Terminal")

  ButtonSetText("DebugWindowTitleBarToggleSettings", L">>")

  LabelSetText("DebugWindowOptionsLogsOffLabel", L"Off")
  LabelSetText("DebugWindowOptionsLogsOnLabel", L"On")

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
  LabelSetText("DebugWindowOptionsLuaDebugLibraryLabel", L"Load Lua Debug Library")
  LabelSetText("DebugWindowOptionsOtherTitle", L"Other:")
  LabelSetText("DebugWindowOptionsShowTimestampsLabel", L"Show Timestamps")

  for index = 1, 2
  do
	ButtonSetStayDownFlag("DebugWindowOptionsErrorOption" .. index .. "Button", true)
  end

  ButtonSetPressedFlag("DebugWindowOptionsErrorOption1Button", Terminal.Settings.useDevErrorHandling)
  ButtonSetPressedFlag("DebugWindowOptionsErrorOption2Button", GetUseLuaErrorHandling())
  ButtonSetDisabledFlag("DebugWindowOptionsLuaDebugLibraryButton", GetLoadLuaDebugLibrary())
  ButtonSetDisabledFlag("DebugWindowOptionsLuaDebugLibraryButton", true)
  ButtonSetPressedFlag("DebugWindowOptionsShowTimestampsButton", Terminal.Settings.showTimestamp)


  ButtonSetText("DebugWindowOptionsClearLogText", L"Clear Log")

  WindowSetShowing("DebugWindowOptions", false)

  TextEditBoxSetHistory("DebugWindowTextBox", Terminal.Settings.history)

  HandlePregameInit()
end

function warExtendedTerminal.UpdateLoggingButton()
    local isLogging = warExtendedTerminal.Settings.logsOn == true

    if isLogging then
        WindowSetShowing("DebugWindowOptionsLogsOnCheck", true)
        WindowSetShowing("DebugWindowOptionsLogsOffCheck", false)
    else
        WindowSetShowing("DebugWindowOptionsLogsOnCheck", false)
        WindowSetShowing("DebugWindowOptionsLogsOffCheck", true)
    end
end

function warExtendedTerminal.WindowOnResizeBegin(minX, minY, endCallback)
    local toolbarFrame = GetFrame("DebugWindowToolbar")

    if toolbarFrame then
        local x,y = toolbarFrame:GetDimensions()
        WindowUtils.BeginResize(TERMINAL_WINDOW, "topleft", x+4, 200, nil)
        else
        WindowUtils.BeginResize(TERMINAL_WINDOW, "topleft", 300, 200, nil)
    end
end

function warExtendedTerminal.WindowOnShutdown()
    Terminal.Settings.history = TextEditBoxGetHistory("DebugWindowTextBox")
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

function warExtendedTerminal.WindowOnRButtonUp()
    EA_Window_ContextMenu.CreateDefaultContextMenu(TERMINAL_WINDOW)
end

function warExtendedTerminal.WindowOnShown()
    -- toolbar hook
end

function Terminal.WindowOnHidden()
    -- toolbar hook
end


function Terminal.WindowOnCloseButton()
  WindowSetShowing("DebugWindow", false)
  WindowSetShowing("DebugWindowOptions", false)
end


function Terminal.LogDisplayScrollToBottom ()
  LogDisplayScrollToBottom("DebugWindowText")
  WindowAssignFocus("DebugWindowTextBox", true)
end

function Terminal.TextBoxOnShown()
    local visible = WindowGetShowing("DebugWindow") == true
    if visible then
	    WindowAssignFocus("DebugWindowTextBox", true)
    end
end

function Terminal.TextBoxOnKeyEscape()
    local isScrolled = LogDisplayIsScrolledToBottom("DebugWindowText") == true
    local empty            = TextEditBoxGetText("DebugWindowTextBox") == L""

    if not isScrolled then
        Terminal.LogDisplayScrollToBottom()
    elseif not empty and isScrolled then
        TextEditBoxSetText(SystemData.ActiveWindow.name, L"")
    elseif isScrolled and empty then
        Terminal.WindowOnCloseButton()
    end
end

function Terminal.WindowOnKeyEscape()
    if WindowGetShowing("DebugWindow") then
	    WindowAssignFocus("DebugWindowTextBox", true)
    	Terminal.LogDisplayScrollToBottom()
    end
end


