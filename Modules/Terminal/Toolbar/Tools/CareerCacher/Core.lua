local warExtended      = warExtended
local GetFrame = GetFrame
local TOOL_NAME        = L"Career Cacher"
local TOOL_DESCRIPTION = L"Displays your character's career advance packages and allows you to save them into a log file."
local TOOL_ICON        = 08003
local WINDOW_NAME      = "TerminalCareerCacher"

TerminalCareerCacher   = TerminalToolbar:RegisterTool(TOOL_NAME, TOOL_DESCRIPTION, WINDOW_NAME, TOOL_ICON, { advanceData = {} })

function TerminalCareerCacher.OnShown()
  local settings    = TerminalCareerCacher:GetSettings()
  local advanceData = warExtended:GetPlayerAdvanceData()
  
  settings          = warExtended:ExtendTable(settings.advanceData, advanceData)

  GetFrame(WINDOW_NAME.."OutputAdvancesSearch"):SetArticle(advanceData)
  TerminalCareerCacher.UpdateDisplay()
end

function TerminalCareerCacher.OnHidden()
  TerminalCareerCacher:GetSettings().advanceData = {}
end
