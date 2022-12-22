LogDisplay = Frame:Subclass()

function LogDisplay:AddLog(logName, addEntries)
  LogDisplayAddLog(self:GetName(), logName, addEntries)
end

function LogDisplay:RemoveLog(logName)
  LogDisplayRemoveLog(self:GetName(), logName)
end

function LogDisplay:SetShowTimestamp(bool)
  LogDisplaySetShowTimestamp(self:GetName(), bool)
end

function LogDisplay:GetShowTimestamp()
  return LogDisplayGetShowTimestamp(self:GetName())
end

function LogDisplay:SetShowLogName(bool)
  LogDisplaySetShowLogName(self:GetName(), bool)
end

function LogDisplay:GetShowLogName()
  return LogDisplayGetShowLogName(self:GetName())
end

function LogDisplay:SetShowFilterName(bool)
  LogDisplaySetShowFilterName(self:GetName(), bool)
end

function LogDisplay:GetShowFilterName()
  return LogDisplayGetShowFilterName(self:GetName())
end

function LogDisplay:SetFilterColor(logName, filterId, color)
  LogDisplaySetFilterColor(self:GetName(), logName, filterId, unpack(color))
end

function LogDisplay:GetFilterColor(logName, filterId)
  return LogDisplayGetFilterColor(self:GetName(), logName, filterId)
end

function LogDisplay:SetFilterState(logName, filterId, bool)
  LogDisplaySetFilterState(self:GetName(), logName, filterId, bool)
end

function LogDisplay:GetFilterState(logName, filterId)
  return LogDisplayGetFilterState(self:GetName(), logName, filterId)
end

function LogDisplay:HideFilterSubType(logName, filterId, subTypeName, bool)
  LogDisplayHideFilterSubType(self:GetName(), logName, filterId, subTypeName, bool)
end

function LogDisplay:SetTextFadeTime(visibleTime)
  LogDisplaySetTextFadeTime(self:GetName(), visibleTime)
end

function LogDisplay:GetTextFadeTime()
  return LogDisplayGetTextFadeTime(self:GetName())
end

function LogDisplay:IsScrollbarActive()
  return LogDisplayIsScrollbarActive(self:GetName())
end

function LogDisplay:SetFont(fontName)
  LogDisplaySetFont(self:GetName(), fontName)
end

function LogDisplay:GetFont()
  return LogDisplayGetFont(self:GetName())
end

function LogDisplay:ScrollToBottom()
  LogDisplayScrollToBottom(self:GetName())
end

function LogDisplay:IsScrolledToBottom()
  return LogDisplayIsScrolledToBottom(self:GetName())
end

function LogDisplay:ResetLineFadeTime()
  LogDisplayResetLineFadeTime(self:GetName())
end

function LogDisplay:ShowScrollbar(showScrollbar)
  LogDisplayShowScrollbar(self:GetName(), showScrollbar)
end

function LogDisplay:ScrollToTop()
  LogDisplayScrollToTop(self:GetName())
end

function LogDisplay:IsScrolledToTop()
  return LogDisplayIsScrolledToTop(self:GetName())
end