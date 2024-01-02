local StatusBar = StatusBar

function StatusBar:SetCurrentValue(value)
  value               = value or 0
  
  self.m_currentValue = value
  StatusBarSetCurrentValue(self:GetName(), value)
end

function StatusBar:GetCurrentValue()
  return self.m_currentValue
end

function StatusBar:SetMaximumValue(value)
  value           = value or 0
  
  self.m_maxValue = value
  StatusBarSetMaximumValue(self:GetName(), value)
end

function StatusBar:GetMaximumValue(value)
  self.m_maxValue = value
end

function StatusBar:StopInterpolating()
  StatusBarStopInterpolating(self:GetName())
end

function StatusBar:SetForegroundTint(color)
  StatusBarSetForegroundTint(self:GetName(), color.r, color.g, color.b)
end

function StatusBar:SetBackgroundTint(color)
  StatusBarSetBackgroundTint(self:GetName(), color.r, color.g, color.b)
end


warExtendedDefaultStatusBar = Frame:Subclass("EA_Window_DefaultFrameStatusBar_Interpolate")
local STATUS_BAR = warExtendedDefaultStatusBar

local BAR = 1
local BAR_TEXT = 2

function STATUS_BAR:Create(windowName)
  local frame = GetFrame(windowName) or self:CreateFrameForExistingWindow(windowName)

  if frame then
    frame.m_Windows = {
      [BAR] = StatusBar:CreateFrameForExistingWindow(frame:GetName().."Bar"),
      [BAR_TEXT] = Label:CreateFrameForExistingWindow(frame:GetName().."BarText")
    }

    local win = frame.m_Windows

    win[BAR]:SetForegroundTint(DefaultColor.GREEN)
    win[BAR]:SetBackgroundTint(DefaultColor.BLACK)

    return frame
  end
end

function STATUS_BAR:SetCurrentValue(value)
  local win = self.m_Windows
  win[BAR]:SetCurrentValue(value)
end

function STATUS_BAR:GetCurrentValue()
  local win = self.m_Windows
  win[BAR]:GetCurrentValue()
end

function STATUS_BAR:SetMaximumValue(value)
  local win = self.m_Windows
  win[BAR]:SetMaximumValue(value)
end

function STATUS_BAR:GetMaximumValue(value)
  local win = self.m_Windows
  win[BAR]:GetMaximumValue(value)
end

function STATUS_BAR:StopInterpolating()
  local win = self.m_Windows
  win[BAR]:StopInterpolating()
end

function STATUS_BAR:SetForegroundTint(color)
  local win = self.m_Windows
  win[BAR]:SetForegroundTint(color)
end

function STATUS_BAR:SetBackgroundTint(color)
  local win = self.m_Windows
  win[BAR]:SetBackgroundTint(color)
end

function STATUS_BAR:SetText(text)
  local win = self.m_Windows
  win[BAR_TEXT]:SetText(text)
end

