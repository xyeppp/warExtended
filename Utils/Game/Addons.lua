local warExtended    = warExtended
local ModulesGetData = ModulesGetData
local addonsData     = nil

local function getAddonData(addonName, addonData)

  if addonsData == nil then
	addonsData = ModulesGetData()
  end

  for Addons = 1, #addonsData do
	local addon = addonsData[Addons]

	if addon.name == addonName then
	  if addonData == "desc" then
		return addon.description.text
	  elseif addonData == "enabled" then
		return addon.isEnabled
	  elseif addonData == "version" then
		return addon.version
	  elseif addonData == "table" then
		  return addon
	  end
	end
  end

end

function warExtended.IsAddonEnabled(addonName)
  local isAddonEnabled = getAddonData(addonName, "enabled")
  return isAddonEnabled
end

function warExtended.GetAddonTable(addonName)
	local addonTable = getAddonData(addonName, "table")
	return addonTable
end

function warExtended.GetAddonDescription(addonName)
  local addonDescription = getAddonData(addonName, "desc") or L "No Addon Description."
  return addonDescription
end

function warExtended.GetAddonVersion(addonName)
  local addonVersion = "v." .. getAddonData(addonName, "version")
  return addonVersion
end
