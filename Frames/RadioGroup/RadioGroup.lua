RadioGroup        = Frame:Subclass()

function RadioGroup:Create (windowName, callbackObject, callbackFunction)
  local group = self:CreateFrameForExistingWindow(windowName)
  
  if (callbackObject and callbackFunction)
  then
	group.m_CallbackObject   = callbackObject
	group.m_CallbackFunction = callbackFunction
  end
  
  return group
end

function RadioGroup:AddExistingButton (buttonName, pressedId, labelText)
  local button = ButtonFrame:CreateFrameForExistingWindow(buttonName)
  
  if (button)
  then
	button:SetCheckButtonFlag(true)
	button:SetPressedFlag(false)
	
	button.m_RadioGroup = self
	button.m_PressedId  = pressedId
	
	if (self.m_Buttons == nil)
	then
	  self.m_Buttons = {}
	  self.m_Labels  = {}
	end
	
	self.m_Buttons[buttonName] = button
	
	if (labelText and DoesWindowExist(buttonName .. "Label"))
	then
	  self.m_Labels[buttonName] = Label:CreateFrameForExistingWindow(buttonName .. "Label")
	  self.m_Labels[buttonName]:SetText(labelText)
	end
  end
  
  return button
end

function RadioGroup:UpdatePressedId (pressedButtonFrame)
  if (pressedButtonFrame ~= nil)
  then
	local pressedButtonName = pressedButtonFrame:GetName()
	
	for _, button in pairs(self.m_Buttons)
	do
	  local thisButtonIsPressed = (button:GetName() == pressedButtonName)
	  
	  button:SetPressedFlag(thisButtonIsPressed)
	  
	  if (thisButtonIsPressed)
	  then
		self.m_PressedId = button.m_PressedId
	  end
	end
	
	if (self.m_CallbackObject and self.m_CallbackFunction)
	then
	  local obj  = self.m_CallbackObject
	  local func = self.m_CallbackFunction
	  
	  func(obj, self.m_PressedId)
	end
  end
end

function RadioGroup:GetPressedId ()
  return m_PressedId or 0
end

