LogDisplay = Frame:Subclass()

function LogDisplay:AddLog(logName, addEntries)
  LogDisplayAddLog(self:GetName(), logName, addEntries)
end

function LogDisplay:RemoveLog(logName)
  LogDisplayRemoveLog(self:GetName(), logName )
end

function LogDisplay:SetShowTimestamp(bool)
  LogDisplaySetShowTimestamp(self:GetName(), bool)
end

function LogDisplay:GetShowTimestamp()
  return LogDisplayGetShowTimestamp(self:GetName())
end

function LogDisplay:SetShowLogName(bool)
  LogDisplaySetShowLogName(self:GetName(), bool )
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
return LogDisplayGetFilterState(self:GetName(), logName, filterId )
end

function LogDisplay:HideFilterSubType(logName, filterId, subTypeName, bool)
  LogDisplayHideFilterSubType(self:GetName(), logName, filterId, subTypeName, bool)
end

function LogDisplay:SetTextFadeTime()

end

function LogDisplay:GetTextFadeTime()

end

function LogDisplay:IsScrollbarActive()

end

function LogDisplay:SetFont()

end

function LogDisplay:GetFont()

end

function LogDisplay:ScrollToBottom()

end

function LogDisplay:IsScrolledToBottom()

end

function LogDisplay:ResetLineFadeTime()

end

function LogDisplay:ShowScrollbar()

end

function LogDisplay:ScrollToTop()

end

function LogDisplay:IsScrolledToTop()

end