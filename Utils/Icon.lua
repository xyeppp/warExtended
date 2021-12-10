local warExtended = warExtended
local GetIconData = GetIconData
local LMB_ICON = "00092"
local RMB_ICON = "00093"

function warExtended:GetIconString(iconId)
  local iconString = "<icon"..iconId..">"
  return iconString
end

function warExtended:GetIconData(iconId)
  local texture, x, y = GetIconData(iconId)
  return texture, x, y
end

