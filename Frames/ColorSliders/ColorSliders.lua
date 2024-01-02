local warExtended = warExtended
local colorTypes = {
  ["R"] = L"Red",
  ["G"] = L"Green",
  ["B"] = L"Blue"
}

local SLIDER = 1
local TEXT = 2
local COLOR_VALUE = 3

local Slider = SliderBar:Subclass()

function Slider:Create(windowName, colorType, maxValue)
  local frame = self:CreateFrameForExistingWindow(windowName)
  frame.maxValue = maxValue
  frame.colorType = colorType:lower()
  
  return frame
end

function Slider:OnSlide(curPos)
  local sliders = self:GetParent():GetParent()
  curPos = curPos*self.maxValue
  self:GetParent().m_Windows[COLOR_VALUE]:SetText(warExtended:Round(curPos))
  
  sliders[self.colorType] = curPos
  sliders.m_Windows[4]:SetTintColor(sliders.r, sliders.g, sliders.b)
  
  if (sliders.m_CallbackObject and sliders.m_CallbackFunction)
  then
	local obj  = sliders.m_CallbackObject
	local func = sliders.m_CallbackFunction
	
	func(sliders.r, sliders.g, sliders.b)
  end
end

ColorSlider = Frame:Subclass()
local ColorSlider = ColorSlider

function ColorSlider:Create(parentName, colorType, callbackObject, callbackFunction)
  local colorSlider = self:CreateFrameForExistingWindow(parentName..colorType)

  if (colorSlider)
  then
	colorSlider.m_Windows = {
	[SLIDER] = Slider:Create(colorSlider:GetName().."Slider", colorType, 255),
	[TEXT] = Label:CreateFrameForExistingWindow(colorSlider:GetName().."Text"),
	[COLOR_VALUE] = Label:CreateFrameForExistingWindow(colorSlider:GetName().."Value")
	}
  end
  
  local win = colorSlider.m_Windows
  
  win[TEXT]:SetText(colorTypes[colorType])
  win[COLOR_VALUE]:SetText(warExtended:Round(win[SLIDER]:GetCurrentPosition()))
  
  return colorSlider
end

function ColorSlider:SetPosition(pos)
  local slider = self.m_Windows[SLIDER]
  slider:SetCurrentPosition(pos/slider.maxValue)
  self.m_Windows[COLOR_VALUE]:SetText(warExtended:Round(pos))
  --REDUCE TO OnSlide by dividing axvalue
end

ColorSliders = Frame:Subclass()

local SLIDER_R = 1
local SLIDER_G = 2
local SLIDER_B = 3
local COLOR_SWATCH = 4

function ColorSliders:Create(windowName, isVertical, callbackObject, callbackFunction)
  local colorSliders = self:CreateFrameForExistingWindow(windowName)

  if (colorSliders)
  then
	colorSliders.m_Windows = {
	[SLIDER_R] = ColorSlider:Create(windowName, "R"),
	[SLIDER_G] = ColorSlider:Create(windowName,"G"),
	[SLIDER_B] = ColorSlider:Create(windowName, "B"),
	[COLOR_SWATCH] = FullResizeImage:CreateFrameForExistingWindow(windowName.."ColorSwatch")
	}
	
	
	colorSliders.r = 0
	colorSliders.g = 0
	colorSliders.b = 0
	
	if (callbackObject and callbackFunction)
	then
	  colorSliders.m_CallbackObject   = callbackObject
	  colorSliders.m_CallbackFunction = callbackFunction
	end
  end
  
  return colorSliders
end

function ColorSliders:UpdateSliders(r,g,b)
  self.m_Windows[SLIDER_R]:SetPosition(r)
  self.m_Windows[SLIDER_G]:SetPosition(g)
  self.m_Windows[SLIDER_B]:SetPosition(b)
  self.m_Windows[COLOR_SWATCH]:SetTintColor(r,g,b)
end

function ColorSliders:SetChecked (checkedFlag)
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

function ColorSliders:GetChecked ()
  return self.m_IsChecked or false
end

function ColorSliders:OnLButtonUp (flags, x, y)
  self:SetChecked(not self:GetChecked())
end

function ColorSliders:OnMouseOver (flags, x, y)
  if self.m_Tooltip then
	Tooltips.CreateTextOnlyTooltip (self:GetName (), self.m_Tooltip)
	Tooltips.Finalize ()
	Tooltips.AnchorTooltip (Tooltips.ANCHOR_WINDOW_VARIABLE)
  end
end


