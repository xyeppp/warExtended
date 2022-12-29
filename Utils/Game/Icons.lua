local warExtended = warExtended

local LMB_ICON = L"0092"
local MMB_ICON = L"0093"
local RMB_ICON = L"0094"

function warExtended:GetIconString(iconId)
  local iconString = L"<icon" .. iconId .. L">"
  return iconString
end

function warExtended:GetLMBIcon()
  return self:GetIconString(LMB_ICON)
end

function warExtended:GetMMBIcon()
  return self:GetIconString(MMB_ICON)
end

function warExtended:GetRMBIcon()
  return self:GetIconString(RMB_ICON)
end
