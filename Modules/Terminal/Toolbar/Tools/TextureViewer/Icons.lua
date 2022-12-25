local TerminalTextureViewer = TerminalTextureViewer
local GetIconData           = GetIconData
local MAX_ICON_ID           = 100000
local INVALID_ENTRY         = "icon-00001"
local INVALID_ENTRY2        = "icon-00002"
local INVALID_ENTRY3        = "icon000000"

local icons = {}

function TerminalTextureViewer.GetIconsList()
  icons = {}
  
  for iconId = 0, MAX_ICON_ID do
	local iconData, _, _ = GetIconData(iconId)
	if iconData ~= INVALID_ENTRY and iconData ~= INVALID_ENTRY2 and iconData ~= INVALID_ENTRY3 then
	  icons[#icons + 1] =  iconData
	end
  end
  
  return icons
end







