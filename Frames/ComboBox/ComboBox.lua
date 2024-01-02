local warExtended = warExtended
local ComboBox    = ComboBox
local ComboBoxAddMenuItem = ComboBoxAddMenuItem
local ComboBoxClearMenuItems = ComboBoxClearMenuItems
local ComboBoxGetSelectedMenuItem = ComboBoxGetSelectedMenuItem
local ComboBoxSetSelectedMenuItem = ComboBoxSetSelectedMenuItem
local ComboBoxSetDisabledFlag = ComboBoxSetDisabledFlag
local ComboBoxGetDisabledFlag = ComboBoxGetDisabledFlag
local ComboBoxIsMenuOpen = ComboBoxIsMenuOpen
local ComboBoxExternalOpenMenu = ComboBoxExternalOpenMenu


function ComboBox:AddMenuItem(itemName)
  ComboBoxAddMenuItem(self:GetName(), itemName)
  self[#self+1] = itemName
end

function ComboBox:ClearMenuItems()
  ComboBoxClearMenuItems(self:GetName())
    for idx, _ in ipairs(self) do
        self[idx] = nil
    end
end

function ComboBox:GetMenuItems()
    return #self
end

function ComboBox:SetSelectedMenuItem (itemIndex)
    ComboBoxSetSelectedMenuItem (self:GetName (), itemIndex)
end

function ComboBox:GetSelectedMenuItem()
  return ComboBoxGetSelectedMenuItem(self:GetName()), self[ComboBoxGetSelectedMenuItem(self:GetName())]
end

function ComboBox:SetDisabledFlag(isDisabled)
  ComboBoxSetDisabledFlag(self:GetName(), isDisabled)
end

function ComboBox:GetDisabledFlag()
  return ComboBoxGetDisabledFlag(self:GetName())
end

function ComboBox:IsMenuOpen()
  return ComboBoxIsMenuOpen(self:GetName())
end

function ComboBox:ExternalMenuOpen()
  return ComboBoxExternalOpenMenu(self:GetName())
end

function ComboBox:AddTable (wideStringItemTable)
  local comboName = self:GetName()
  
  for _, v in ipairs(wideStringItemTable)
  do
	if not warExtended:IsType(v, "wstring") then
	  v = warExtended:toWString(v)
	end
	
	self:AddMenuItem(v)
  end
  
  -- select the first item as a convenience...
  self:SetSelectedMenuItem(1)
end

function ComboBox:SetSelectedFromName(name)
  name = warExtended:toWString(name)

  for idx, v in ipairs(self) do
	if name == v then
	  self:SetSelectedMenuItem(idx)
	  return
	end
  end
  
  self:SetSelectedMenuItem(1)
end

