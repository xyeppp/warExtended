local warExtended = warExtended
local LINK_TEMPLATE = L"^([%a%d]+%p)(.*)"
local DELIMETER = L"[%a%d](%p)"

local function splitLink(wholeLink)
  local linkName, linkData = wstring.match(wholeLink,LINK_TEMPLATE)
  
  if linkData then
	local delimeter = wstring.match(linkData, DELIMETER)
	
	if delimeter then
	  linkData = WStringSplit(linkData, delimeter)
	end
  end
  
  return linkName, linkData
end

local hyperlinkManager = {
  addonLinks = {},
  OnLButtonUp = {
  },

  OnRButtonUp = {
  },
  
  addHyperlink = function (self, buttonType, hyperlinkText, hyperlinkFunction)
	hyperlinkText = towstring(hyperlinkText)
	
	if self[buttonType][hyperlinkText] then
	  d("Hyperlink already registered.")
	  return
	end
	
	self[buttonType][hyperlinkText] = hyperlinkFunction
  end,
  
  removeHyperlink = function(self, buttonType, hyperlinkText)
	hyperlinkText = towstring(hyperlinkText)
	
	if not self[buttonType][hyperlinkText] then
	  return
	end
 
	self[buttonType][hyperlinkText] = nil
  end,
  
  onHyperLink = function(self, buttonType, linkData, flags, x, y)
	local linkName, linkData = splitLink(linkData)
	local hyperlinkFunction = self[buttonType][linkName]
 
	if not hyperlinkFunction then
	  return hyperlinkFunction
	end
	
	hyperlinkFunction(linkData, flags, x, y)
  end
}

function warExtended:AddHyperlink(buttonType, hyperlinkText, hyperlinkFunction)
  hyperlinkManager:addHyperlink(buttonType, hyperlinkText, hyperlinkFunction)
end

function warExtended:RemoveHyperlink(buttonType, hyperlinkText)
  hyperlinkManager:removeHyperlink(buttonType, hyperlinkText)
end

function warExtended.SetHyperlinkHooks()
 local originalEA_ChatWindow_OnHyperLinkRButtonUp = EA_ChatWindow.OnHyperLinkRButtonUp
 local originalEA_ChatWindow_OnHyperLinkLButtonUp = EA_ChatWindow.OnHyperLinkLButtonUp
 local originalEA_ChatWindow_OnHyperLinkRButtonUpChatWindowOnly = EA_ChatWindow.OnHyperLinkRButtonUpChatWindowOnly
  
  EA_ChatWindow.OnHyperLinkLButtonUp = function(...)
	p(...)
	if not hyperlinkManager:onHyperLink("OnLButtonUp", ...) then
	  originalEA_ChatWindow_OnHyperLinkLButtonUp(...)
	end
  end
  
  EA_ChatWindow.OnHyperLinkRButtonUp = function (...)
	p(...)
	if not hyperlinkManager:onHyperLink("OnRButtonUp", ...) then
	  originalEA_ChatWindow_OnHyperLinkRButtonUp(...)
	end
  end
  
  EA_ChatWindow.OnHyperLinkRButtonUpChatWindowOnly = function(...)
	if not hyperlinkManager:onHyperLink("OnRButtonUp", ...) then
	  originalEA_ChatWindow_OnHyperLinkRButtonUpChatWindowOnly(...)
	end
  end
end

