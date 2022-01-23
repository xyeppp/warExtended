local warExtended = warExtended
local ModulesGetData = ModulesGetData

local function getAddonData(addonName, addonData)
  local addonsData = ModulesGetData()
  
  for Addons=1,#addonsData do
	local addon = addonsData[Addons]
	
	if addon.name == addonName then
	  if addonData == "desc" then
		local addonDescription = towstring(addon.description.text)
		return addonDescription
	  elseif addonData == "enabled" then
		local isEnabled = addon.isEnabled
		return isEnabled
	  elseif addonData == "version" then
		local addonVersion = "v."..addon.version
		return addonVersion
	  end
	end
	
  end
end


function warExtended.IsAddonEnabled(addonName)
 local isEnabled = getAddonData(addonName, "enabled")
  return isEnabled
end

function warExtended.GetAddonDescription(addonName)
  local noDescriptionText = L"No Addon Description."
  local addonDescription = getAddonData(addonName, "desc")
  return addonDescription or noDescriptionText
end

function warExtended.GetAddonVersion(addonName)
  local addonVersion = getAddonData(addonName, "version")
  return addonVersion
end

function warExtended.RegisterAddonHyperlink(addonName, hyperlinkText, hyperlinkColor)
  hyperlinkText = hyperlinkText or "warExt"
  hyperlinkColor = hyperlinkColor or "GREEN"
  local version = warExtended.GetAddonVersion(addonName)
  local HyperlinkData = "WAREXT:"  ..  addonName .." ".. version
  local HyperlinkText = "["..hyperlinkText.."] "
  local HyperlinkColor = DefaultColor[string.upper(hyperlinkColor)]
  local moduleHyperlink = CreateHyperLink( towstring(HyperlinkData), towstring(HyperlinkText),
		  {HyperlinkColor.r, HyperlinkColor.g, HyperlinkColor.b}, {} )
  return moduleHyperlink
end