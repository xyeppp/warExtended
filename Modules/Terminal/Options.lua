local warExtendedTerminal = warExtendedTerminal
local Terminal = warExtendedTerminal

--- Options Window

function Terminal.ToggleOptions()
  local showing = WindowGetShowing("DebugWindowOptions")
  Terminal:WindowSetRelativeAnchor("DebugWindowOptions", "DebugWindow")
  WindowSetShowing("DebugWindowOptions", showing == false)
end

function Terminal.ReanchorOptions()
  Terminal:WindowSetRelativeAnchor("DebugWindowOptions", "DebugWindow")
end

function Terminal.HideOptions()
  WindowSetShowing("DebugWindowOptions", false)
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
  ButtonSetPressedFlag("DebugWindowOptionsLuaDebugLibraryButton", GetLoadLuaDebugLibrary())

end

function Terminal.UpdateDisplayFilter()
  
  local filterId                                    = WindowGetId(SystemData.ActiveWindow.name)
  
  local enabled                                     = not Terminal.Settings.LogFilters[filterId].enabled
  Terminal.Settings.LogFilters[filterId].enabled = enabled
  
  ButtonSetPressedFlag("DebugWindowOptionsFilterType" .. filterId .. "Button", enabled)
  LogDisplaySetFilterState("DebugWindowText", "UiLog", filterId, enabled)
  
  -- When UI Log filters are off, disable logging of that filter type entirely.
  TextLogSetFilterEnabled("UiLog", filterId, enabled)

end

function Terminal.UpdateLuaErrorHandling()
  
  Terminal.Settings.useDevErrorHandling = not Terminal.Settings.useDevErrorHandling;
  ButtonSetPressedFlag("DebugWindowOptionsErrorOption1Button", Terminal.Settings.useDevErrorHandling)
end

function Terminal.UpdateCodeErrorHandling()
  local enabled = GetUseLuaErrorHandling()
  enabled       = not enabled
  
  SetUseLuaErrorHandling(enabled)
  ButtonSetPressedFlag("DebugWindowOptionsErrorOption2Button", enabled)
end

function Terminal.UpdateLoadLuaDebugLibrary()
  local enabled = GetLoadLuaDebugLibrary()
  enabled       = false
  
  SetLoadLuaDebugLibrary(enabled)
  ButtonSetPressedFlag("DebugWindowOptionsLuaDebugLibraryButton", enabled)
end
