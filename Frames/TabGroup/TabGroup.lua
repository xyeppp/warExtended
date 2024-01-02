local warExtended = warExtended

TabGroup          = Frame:Subclass()
local TabButton    = ButtonFrame:Subclass("warExtendedTopTab")

function TabButton:ShowTab(isShowing)
  local frame = GetFrame(self.m_windowName)
  frame:Show(isShowing)
end

function TabButton:IsShowing()
  local frame = GetFrame(self.m_windowName)
  return frame:IsShowing()
end

function TabButton:Flash()
  if not self:IsShowing() then
	self:StartAlphaAnimation(Window.AnimationType.LOOP, 1, 0.5, 0.5, 0, 1)
  end
end

function TabButton:OnLButtonUp(flags, x, y)
  if self:IsDisabled() then
	return
  end
  
  self:GetParent():SwitchTabs(self:GetId())
end

function TabButton:OnMouseOver()
    if self.m_tooltip then
        local anchor = { Point = "bottom", RelativeTo = self:GetName(), RelativePoint = "top", XOffset = 0, YOffset = -64 }

        if self:GetName():match("BottomTab") then
            anchor = { Point = "top", RelativeTo = self:GetName(), RelativePoint = "bottom", XOffset = 0, YOffset = 74 }
        end

        warExtended:CreateTextTooltip(self:GetName(), {
            [1]={{text =self.m_tooltip, color=Tooltips.COLOR_HEADING}},
        }, nil, anchor, 1)
    end
end




function TabGroup:GetSelectedTab()
  return self.m_selectedTab
end

function TabGroup:SetSelectedTab(tabIndex)
  self.m_selectedTab = tabIndex
end

function TabGroup:GetCallbacks()
  return self.m_Callbacks.obj, self.m_Callbacks.func
end

function TabGroup:DoCallback(tabIndex)
  local callbackObject, callbackFunction    = self:GetCallbacks()
  callbackObject.selectedTab = tabIndex
  
  if callbackFunction then
	callbackFunction(self:GetTabWindowFrame(tabIndex))
  end
end

function TabGroup:GetTabFrame(tabIdx)
  return self.m_Windows[tabIdx]
end

function TabGroup:GetTabWindowFrame(tabIdx)
  local tabWindowFrame = GetFrame(self.m_Windows[tabIdx].m_windowName)
  return tabWindowFrame
end

function TabGroup:GetCurrentTab()
  local currentTab = self:GetTabWindowFrame(self:GetSelectedTab())
  return currentTab
end

function TabGroup:Create (windowName, callbackObject, callbackFunction)
  local tabGroup = self:CreateFrameForExistingWindow(windowName)
  tabGroup.m_Windows = {}
	
	if callbackObject ~= nil then
	  tabGroup.m_Callbacks = {}
	  tabGroup.m_Callbacks = {
		obj=callbackObject,
		func=callbackFunction
	  }
	end
  
  return tabGroup
end

function TabGroup:AddExistingTab (tabName, windowName, labelText, tooltip)
  local tab      = TabButton:CreateFrameForExistingWindow(tabName)
  tab.m_Id       = #self.m_Windows + 1
  
  if (tab)
  then
	tab:SetStayDownFlag(false)
	tab:SetPressedFlag(false)
	tab.m_windowName = windowName
	tab.m_tooltip    = tooltip
	tab:SetText(labelText)
  end
  
  self.m_Windows[tab:GetId()] = tab
  tab:ShowTab(false)
  
  local callbackObject, _ = self:GetCallbacks()
  p(self:GetCallbacks().selectedTab)
  if callbackObject and callbackObject.selectedTab == tab:GetId() then
	self:SwitchTabs(tab:GetId())
  else
	self:SwitchTabs(1)
  end
  
  return tab
end

function TabGroup:SwitchTabs(tabId)
  for tabIdx=1,#self.m_Windows do
	local tab = self.m_Windows[tabIdx]
 
	tab:ShowTab(tabIdx == tabId)
	tab:SetStayDownFlag(tabIdx == tabId)
	tab:SetPressedFlag(tabIdx == tabId)
  end
  
  self:SetSelectedTab(tabId)
  
  if self:GetCallbacks() then
	self:DoCallback(tabId)
  end
end

function TabGroup:FlashTab(tabIdx)
  if self:GetSelectedTab() == tabIdx then
	return
  end
  
  self:GetTabFrame(tabIdx):Flash()
end


