local warExtended   = warExtended
local WStringSplit  = WStringSplit
local CreateHyperLink = CreateHyperLink
local wstrmatch     = wstring.match
local LINK_TEMPLATE = L"^([%a%d]+%p)(.*)"
local DELIMETER     = L"[%a%d](%p)"

local hyperlinks    = {}

local function prepareLinkData(linkData)
  local delimeter = wstrmatch(linkData, DELIMETER)
  
  if delimeter then
	linkData = WStringSplit(linkData, delimeter)
  end
  
  return linkData
end

local function onHyperlinkHook(buttonType, linkData, flags, x, y)
  local linkName, linkData = wstrmatch(linkData, LINK_TEMPLATE)
  local hyperlink          = warExtended:GetHyperlink(linkName, buttonType)
  
  if hyperlink then
	p(hyperlink)
	hyperlink.data(prepareLinkData(linkData), flags, x, y)
	return true
  end
  
  return false
end

local function setHyperlinkHooks()
  local originalEA_ChatWindow_OnHyperLinkRButtonUp               = EA_ChatWindow.OnHyperLinkRButtonUp
  local originalEA_ChatWindow_OnHyperLinkLButtonUp               = EA_ChatWindow.OnHyperLinkLButtonUp
  local originalEA_ChatWindow_OnHyperLinkRButtonUpChatWindowOnly = EA_ChatWindow.OnHyperLinkRButtonUpChatWindowOnly
  
  EA_ChatWindow.OnHyperLinkLButtonUp                             = function(...)
	if onHyperlinkHook("OnLButtonUp", ...) then
	  return
	end
	
	originalEA_ChatWindow_OnHyperLinkLButtonUp(...)
  end
  
  EA_ChatWindow.OnHyperLinkRButtonUp                             = function(...)
	if onHyperlinkHook("OnRButtonUp", ...) then
	  return
	end
	
	originalEA_ChatWindow_OnHyperLinkRButtonUp(...)
  end
  
  EA_ChatWindow.OnHyperLinkRButtonUpChatWindowOnly               = function(...)
	if onHyperlinkHook("OnRButtonUp", ...) then
	  return
	end
	
	originalEA_ChatWindow_OnHyperLinkRButtonUpChatWindowOnly(...)
  end
  
  warExtended:AddHyperlink("OnLButtonUp", "WAREXT", p)
  warExtended:AddHyperlink("OnLButtonUp", "WAREXT:", p("das"))
end

function warExtended:GetHyperlink(key, name)
  key = warExtended:toStringOrEmpty(key)
  local links = hyperlinks[name]
  if (links == nil) then return end
  local hyperlink = links:Get(key)
  return hyperlink
end

function warExtended:RemoveHyperlink (key, name)
  local links = hyperlinks[name]
  if (links == nil) then return end
  links:Remove(key)
end

function warExtended:AddHyperlink(onButtonType, hyperlinkText, hyperlinkCallback)
  local links = hyperlinks[onButtonType]
  
  if (links == nil)
  then
	links               = warExtendedLinkedList.New ()
	hyperlinks[onButtonType] = links
  end
  
  if warExtended:GetHyperlink(hyperlinkText, onButtonType) then
	d("Hyperlink already registered.")
	return
  end
  
  links:Add(hyperlinkText, hyperlinkCallback)
end

function warExtended:CreateHyperlink(hyperlinkData, hyperlinkText, hyperlinkColor)
 	 if type (hyperlinkColor) == "string" then
		hyperlinkColor = DefaultColor[warExtended:toStringUpper(hyperlinkColor)]
 	 end
  
 	 local moduleHyperlink = CreateHyperLink( warExtended:toWStringOrEmpty(hyperlinkData), warExtended:toWString("["..hyperlinkText.."] "),
			{warExtended:UnpackRGB(hyperlinkColor)}, {} )
  p(moduleHyperlink)
	return moduleHyperlink
  end

warExtended:AddEventHandler("SetHyperlinkHooks", "CoreInitialized", setHyperlinkHooks)
