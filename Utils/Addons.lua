local warExtended    = warExtended
local ModulesGetData = ModulesGetData

local function getAddonData(addonName, addonData)
  local addonsData = ModulesGetData()
  for Addons = 1, #addonsData do
	local addon = addonsData[Addons]
	if addon.name == addonName then
	  if addonData == "desc" then
		local data = addon.description.text
		return data
	  elseif addonData == "enabled" then
		local data = addon.isEnabled
		return data
	  elseif addonData == "version" then
		local data = addon.version
		return data
	  end
	end
  end
end

function warExtended.IsAddonEnabled(addonName)
  local isEnabled = getAddonData(addonName, "enabled")
  return isEnabled
end

function warExtended.GetAddonDescription(addonName)
  local addonDescription  =  getAddonData(addonName, "desc") or L"No Addon Description."
  return addonDescription
end

function warExtended.GetAddonVersion(addonName)
  local addonVersion =  "v."..getAddonData(addonName, "version")
  return addonVersion
end