local warExtended = warExtended

TabGroup          = Frame:Subclass()
local TabButton    = ButtonFrame:Subclass("warExtendedTopTab")

function TabButton:ShowTab(flag)
  WindowSetShowing(self.m_windowName, flag)
end

function TabButton:IsShowing()
  local isShowing = WindowGetShowing(self.m_WindowName)
  return isShowing
end

function TabButton:GetTabGroup()
  return self.m_tabGroup
end

function TabButton:Flash()
  if not self:IsShowing() then
	self:StartAlphaAnimation(Window.AnimationType.LOOP, 1, 0.5, 0.5, 0, 1)
  end
end

function TabButton:OnLButtonUp(flags, x, y)
  local tabIndex = self:GetId()
  
  if self:IsDisabled() then
	return
  end
  
  TabGroup:SwitchTabs(tabIndex)
end

function TabButton:OnMouseOver()
  local anchor = { Point = "bottom", RelativeTo = self:GetName(), RelativePoint = "top", XOffset = 0, YOffset = -32 }
  
  if self:GetName():match("BottomTab") then
	anchor = { Point = "top", RelativeTo = self:GetName(), RelativePoint = "bottom", XOffset = 0, YOffset = 74 }
  end
  
  warExtended:CreateTextTooltip(self:GetName(), {
	[1]={{text =self.m_tooltip, color=Tooltips.COLOR_HEADING}},
  }, nil, anchor, 1)
end





function TabGroup:SetSelected(tabIndex)
  local callbackObject, _    = self:GetCallbacks(self:GetTabGroupButton(tabIndex):GetTabGroup())
  callbackObject.selectedTab = tabIndex
end

function TabGroup:Create (windowName, callbackObject, callbackFunction)
  local tabGroup = self:CreateFrameForExistingWindow(windowName)
  
  if (self.m_Windows == nil)
  then
	self.m_Windows = {}
  end
  
  if callbackObject ~= nil then
	if self.m_Callbacks == nil then
	  self.m_Callbacks = {}
	end
	
	self.m_Callbacks[windowName] = { callbackObject, callbackFunction }
  end
  
  return tabGroup
end

function TabGroup:GetCallbacks(tabGroup)
  if not self.m_Callbacks then
	return
  end
  
  local callbackTable = self.m_Callbacks[tabGroup]
  
  if not callbackTable then
	return
  end
  
  local callbackObject, callbackFunction = unpack(callbackTable)
  return callbackObject, callbackFunction
end

function TabGroup:GetTabGroupButton(tabIndex)
  return self.m_Windows[tabIndex]
end

function TabGroup:AddExistingTab (tabName, windowName, labelText, tooltip)
  local tabGroup = self:GetName()
  local tab      = TabButton:CreateFrameForExistingWindow(tabName)
  tab.m_Id       = #self.m_Windows + 1
  
  if (tab)
  then
	tab:SetStayDownFlag(false)
	tab:SetPressedFlag(false)
	tab.m_windowName = windowName
	tab.m_tooltip    = warExtended:toWString(tooltip)
	tab.m_tabGroup   = tabGroup
	
	if (labelText)
	then
	  tab:SetText(labelText)
	end
  end
  
  self.m_Windows[tab:GetId()] = tab
  
  tab:ShowTab(false)
  
  local callbackObject, _ = self:GetCallbacks(tab.m_tabGroup)
  if callbackObject then
	if callbackObject.selectedTab == tabId then
	  self:SwitchTabs(tab:GetId())
	end
  end
  
  return tab
end

function TabGroup:SwitchTabs(tabIndex)
  local callbackObject, callbackFunction = self:GetCallbacks(self:GetTabGroupButton(tabIndex):GetTabGroup())
  
  for tabId, _ in pairs(self.m_Windows)
  do
	local activeTab = (tabId == tabIndex)
	local tab       = self.m_Windows[tabId]
	
	tab:ShowTab(activeTab)
	tab:SetStayDownFlag(activeTab)
	tab:SetPressedFlag(activeTab)
  end
  
  if callbackObject ~= nil then
	if callbackFunction then
	  callbackFunction(tabIndex)
	else
	  self:SetSelected(tabIndex)
	end
  end
end

function TabGroup:FlashTab(tabId)
  if self.m_selectedTab == tabId then
	return
  end
  
  local tab = self.m_Windows[tabId]
  tab:Flash()
end


