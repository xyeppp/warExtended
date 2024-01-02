SimpleCheckButton = DynamicImage:Subclass()

function SimpleCheckButton:Create (windowName, labelText, tooltipText, callbackObject, callbackFunction)
  local button = self:CreateFrameForExistingWindow(windowName)
  
  if (button)
  then
	button.m_CheckedImage = DynamicImage:CreateFrameForExistingWindow(windowName .. "Check")
	button.m_Label        = Label:CreateFrameForExistingWindow(windowName .. "Label")
	button.m_Tooltip	= tooltipText
	button.m_Label:SetText(labelText)
	
	if (callbackObject and callbackFunction)
	then
	  button.m_CallbackObject   = callbackObject
	  button.m_CallbackFunction = callbackFunction
	end
  end
  
  return button
end

function SimpleCheckButton:SetChecked (checkedFlag)
  self.m_IsChecked = checkedFlag
  
  if (self.m_CheckedImage)
  then
	self.m_CheckedImage:Show(checkedFlag)
  end
  
  if (self.m_CallbackObject and self.m_CallbackFunction)
  then
	local obj  = self.m_CallbackObject
	local func = self.m_CallbackFunction
	func(obj, self, self:GetChecked())
  end
end

function SimpleCheckButton:GetChecked ()
  return self.m_IsChecked or false
end

function SimpleCheckButton:OnLButtonUp (flags, x, y)
  self:SetChecked(not self:GetChecked())
end

function SimpleCheckButton:OnMouseOver (flags, x, y)
  if self.m_Tooltip then
	Tooltips.CreateTextOnlyTooltip (self:GetName (), self.m_Tooltip)
	Tooltips.Finalize ()
	Tooltips.AnchorTooltip (Tooltips.ANCHOR_WINDOW_VARIABLE)
  end
end

