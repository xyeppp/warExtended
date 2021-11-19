warExtendedSieger = warExtended.Register("warExtended Sieger")
local Sieger = warExtendedSieger

local function setSiegeChatLogDisplayFilters()
  local siegeWindowLog = "SiegeWeaponGeneralFireWindowChatLogDisplay"

  for _, channelInfo in pairs( ChatSettings.Channels )
  do
	LogDisplaySetFilterState( siegeWindowLog, channelInfo.logName, channelInfo.id, channelInfo.isOn )
  end

end

function Sieger.OnInitialize()
  setSiegeChatLogDisplayFilters()
end


