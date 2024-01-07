local TerminalToolbar  = TerminalToolbar
local WINDOW_NAME      = "TerminalAreaViewer"
local TOOL_NAME        = L"Area Viewer"
local TOOL_DESCRIPTION = L"Displays complete information about the current zone - area IDs, names, influence IDs, objectives & control data."
local TOOL_ICON        = 08038

TerminalAreaViewer     = TerminalToolbar:RegisterTool(TOOL_NAME, TOOL_DESCRIPTION, WINDOW_NAME, TOOL_ICON, { objectivesData = {}, areaData = {} }, { isRegistered = false; })

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

