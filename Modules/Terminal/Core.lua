warExtendedTerminal                                                       = { }

local INPUT                                                               = 9
local PRINT                                                               = 10
local EVENT                                                               = 11

if not warExtendedTerminal.Settings then
  warExtendedTerminal.Settings                                            = {
    logsOn = true,
    history = {},
    showTimestamp = true,
    useDevErrorHandling = false,
    autoCommands = false,
    registeredSpyEvents = {},
    loadLuaDebugLibrary = true,
    LogFilters = {
      [SystemData.UiLogFilters.SYSTEM]   = { enabled = true, color = DefaultColor.MAGENTA },
      [SystemData.UiLogFilters.WARNING]  = { enabled = true, color = DefaultColor.ORANGE },
      [SystemData.UiLogFilters.ERROR]    = { enabled = true, color = DefaultColor.RED },
      [SystemData.UiLogFilters.DEBUG]    = { enabled = true, color = DefaultColor.YELLOW },
      [SystemData.UiLogFilters.LOADING]  = { enabled = false, color = DefaultColor.LIGHT_GRAY},
      [SystemData.UiLogFilters.FUNCTION] = { enabled = false, color = DefaultColor.GREEN },
      [INPUT]                            = { enabled = true, color = DefaultColor.MAGENTA },
      [PRINT]                            = { enabled = true, color = DefaultColor.LIGHT_BLUE },
      [EVENT]                            = { enabled = true, color = DefaultColor.GOLD },
    },
  }
end

function warExtendedTerminal.OnInitialize()
  SetLoadLuaDebugLibrary(false)
  SetCheckForCircularDependencies(false)

  warExtendedTerminal.OnInitializeEventSpy()

  TextLogAddFilterType("UiLog", EVENT, L"[Event]:")
end

function warExtendedTerminal.AddUiLog()
  LogDisplayAddLog("DebugWindowText", "UiLog", true)

  for filterType, filterData in pairs(warExtendedTerminal.Settings.LogFilters)
  do
    CHAT_DEBUG(towstring(filterData.color.r))
    LogDisplaySetFilterColor("DebugWindowText", "UiLog", filterType, filterData.color.r, filterData.color.g, filterData.color.b)
  end

  warExtendedTerminal.UpdateLoggingButton()
end

function warExtendedTerminal.ToggleLogging()
  warExtendedTerminal.Settings.logsOn = not warExtendedTerminal.Settings.logsOn

  warExtendedTerminal.UpdateLog()

end

function warExtendedTerminal.UpdateLog()
  TextLogSetIncrementalSaving("UiLog", warExtendedTerminal.Settings.logsOn, L"logs/uilog.log");
  TextLogSetEnabled("UiLog", warExtendedTerminal.Settings.logsOn)

  warExtendedTerminal.UpdateLoggingButton()
end



