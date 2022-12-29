local ComboBox = ComboBox

function ComboBox:AddMenuItem(itemName)
  ComboBoxAddMenuItem (self:GetName(), itemName)
end

function ComboBox:ClearMenuItems()
  ComboBoxClearMenuItems(self:GetName())
end

function ComboBox:GetSelectedMenuItem()
  return ComboBoxGetSelectedMenuItem(self:GetName())
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