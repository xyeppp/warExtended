local warExtended      = warExtended
local WINDOW_NAME      = "TerminalAreaViewer"
local TOOL_NAME        = L"Area Viewer"
local TOOL_DESCRIPTION = L"Displays complete information about the current zone - area IDs, names, influence IDs, objectives & control data."
local TOOL_ICON        = 08038

TerminalAreaViewer     = TerminalToolbar:RegisterTool(TOOL_NAME, TOOL_DESCRIPTION, WINDOW_NAME, TOOL_ICON, { objectivesData = {}, areaData = {} }, { isRegistered = false; })

function TerminalAreaViewer.OnShown()
  local settings = TerminalAreaViewer:GetSavedSettings()
  
  if settings.isRegistered then
	TerminalAreaViewer.UpdateDisplay()
	return
  end
  
  warExtended:RegisterGameEvent({ "player area name changed" }, "TerminalAreaViewer.OnAreaChange")
  warExtended:RegisterGameEvent({ "player area changed", "player zone changed" }, "TerminalAreaViewer.OnAreaChange")
  warExtended:RegisterGameEvent({ "public quest added" }, "TerminalAreaViewer.OnPQAdded")
  warExtended:RegisterGameEvent({
	"player area changed",
	"player zone changed",
	"public quest added",
	"public quest updated",
	"public quest condition updated",
	"public quest completed",
	"public quest failed",
	"public quest resetting",
	"public quest info updated",
	"public quest list updated",
	"public quest removed"
  }, "TerminalAreaViewer.RefreshObjectivesData")
  
  settings.isRegistered = true
  
  TerminalAreaViewer.UpdateDisplay()
end

function TerminalAreaViewer.OnHidden()
  local settings      = TerminalAreaViewer:GetSettings()
  local savedSettings = TerminalAreaViewer:GetSavedSettings()
  
  if not savedSettings.isRegistered then
	return
  end
  
  warExtended:UnregisterGameEvent({ "player area name changed" }, "TerminalAreaViewer.OnAreaChange")
  warExtended:UnregisterGameEvent({ "player area changed", "player zone changed" }, "TerminalAreaViewer.OnAreaChange")
  warExtended:UnregisterGameEvent({ "public quest added" }, "TerminalAreaViewer.OnPQAdded")
  warExtended:UnregisterGameEvent({
	"player area changed",
	"player zone changed",
	"public quest added",
	"public quest updated",
	"public quest condition updated",
	"public quest completed",
	"public quest failed",
	"public quest resetting",
	"public quest info updated",
	"public quest list updated",
	"public quest removed"
  }, "TerminalAreaViewer.RefreshObjectivesData")
  
  savedSettings.isRegistered = false;
  settings.areaData          = {}
  settings.objectivesData    = {}
end

function TerminalAreaViewer.IsInPQ()
  return TerminalAreaViewer:GetSettings().isInPQ
end

function TerminalAreaViewer.OnPQAdded()
  TerminalAreaViewer:GetSettings().isInPQ = true
  
  TerminalAreaViewer.UpdateDisplay()
end

function TerminalAreaViewer.OnPQRemoved()
  TerminalAreaViewer:GetSettings().isInPQ = false
  
  TerminalAreaViewer.UpdateDisplay()
end

