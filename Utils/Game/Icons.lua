local warExtended = warExtended

local MAX_ICON_ID = 100000
local INVALID_ENTRY = "icon-00001"
local INVALID_ENTRY2 = "icon-00002"
local INVALID_ENTRY3 = "icon000000"

local LMB_ICON = L"0092"
local RMB_ICON = L"0093"
local MMB_ICON = L"0094"

function warExtended:GetIconList()
  local iconList = {}

  for iconId = 0, MAX_ICON_ID do
    local iconData, _, _ = GetIconData(iconId)

    if iconData ~= INVALID_ENTRY and iconData ~= INVALID_ENTRY2 and iconData ~= INVALID_ENTRY3 then
      iconList[#iconList+1] =  {
        m_Id = iconId,
        m_texture = iconData
      }
    end
  end

  return iconList
end

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
