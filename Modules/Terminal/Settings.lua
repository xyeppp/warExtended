local Terminal = warExtendedTerminal

function Terminal.ToggleOptions()
  local showing = WindowGetShowing("DebugWindowOptions")
  WindowUtils.SetRelativeAnchors("DebugWindowOptions", "DebugWindow")
  WindowSetShowing("DebugWindowOptions", showing == false)
end

--TODO:move contextmenu to windowlua

local contextMenu = {
  {text = L"Options", callback = warExtendedTerminal.ToggleOptions, disabled=false},
  {text = L"Logs", type = "cascading", disabled = false,
   entryData = {
     {type="userDefined", windowName = "DebugWindowOptionsLogsOn"},
     {type="userDefined", windowName = "DebugWindowOptionsLogsOff"},
   },
  },
  {text = L"Reload UI", callback = InterfaceCore.ReloadUI, disabled=false},
}

local contextMenuAnchor =  {
  ["XOffset"] = -60,
  ["YOffset"] = 80,
  ["Point"] = "bottomright",
  ["RelativePoint"] = "bottomleft",
  ["RelativeTo"] = "DebugWindowTitleBarToggleSettings",
}

function warExtendedTerminal.SettingsOnLButtonUp()
  warExtended:CreateContextMenu(nil, contextMenu, nil, contextMenuAnchor)
  warExtendedTerminal.TextBoxOnShown()
end

function Terminal.ReanchorOptions()
  WindowUtils.SetRelativeAnchors("DebugWindowOptions", "DebugWindow")
end

function Terminal.HideOptions()
  WindowSetShowing("DebugWindowOptions", false)
end

function Terminal.ClearTextLog()
  TextLogClear("UiLog")
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
  Terminal.Settings.loadLuaDebugLibrary = not Terminal.Settings.loadLuaDebugLibrary
  local enabled = not GetLoadLuaDebugLibrary()

  SetLoadLuaDebugLibrary(enabled)
  ButtonSetPressedFlag("DebugWindowOptionsLuaDebugLibraryButton", enabled)
end

function Terminal.UpdateTimestamps()
  local enabled = not LogDisplayGetShowTimestamp("DebugWindowText")

  Terminal.Settings.showTimestamp = enabled
  LogDisplaySetShowTimestamp("DebugWindowText", enabled)
  ButtonSetPressedFlag("DebugWindowOptionsShowTimestampsButton", enabled)
end

