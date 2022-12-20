local warExtendedTerminal = warExtendedTerminal
local GetIconData = GetIconData
local MAX_ICON_ID = 600000
local INVALID_ENTRY = "icon-00001"
local INVALID_ENTRY2 = "icon-00002"
local INVALID_ENTRY3 = "icon000000"
local iconList = {}

function warExtendedTerminal.TextureViewerGetIconList()
  for iconId=0,MAX_ICON_ID do
	local iconData, x,y = GetIconData(iconId)
	if iconData ~= INVALID_ENTRY and iconData ~= INVALID_ENTRY2 and iconData ~= INVALID_ENTRY3 then
	  iconList[#iconList+1] = { iconData, x, y }
	end
  end
end



function warExtendedTerminal.TextureViewerClearIconList()
  iconList = {}
end

function warExtendedTerminal.TextureViewerGetIconList2()
  return iconList
end


