warExtendedSieger = warExtended.Register("warExtended Sieger")
local Sieger = warExtendedSieger
local SIEGE_LOG = "SiegeWeaponGeneralFireWindowChatLogDisplay"
local CHAT_LOG = "EA_ChatTab1TextLog"

local function setSiegeChatLogDisplayFilters()
  for filterId, msgTypeData in pairs( ChatSettings.Channels )
  do
    local color = ChatSettings.ChannelColors[filterId]


	LogDisplaySetFilterState( SIEGE_LOG, msgTypeData.logName, msgTypeData.id, LogDisplayGetFilterState(CHAT_LOG, "Chat", filterId))
    LogDisplaySetFilterColor( SIEGE_LOG, msgTypeData.logName, msgTypeData.id, color.r,color.g, color.b )
  end
end

local function setSiegeChatLogDisplay()
  LogDisplaySetFont(SIEGE_LOG, LogDisplayGetFont(CHAT_LOG))
  LogDisplaySetShowLogName(SIEGE_LOG, LogDisplayGetShowLogName(CHAT_LOG))
  LogDisplaySetShowFilterName(SIEGE_LOG, LogDisplayGetShowFilterName(CHAT_LOG))
  LogDisplaySetShowTimestamp(SIEGE_LOG, LogDisplayGetShowTimestamp(CHAT_LOG))
  LogDisplaySetTextFadeTime (SIEGE_LOG, LogDisplayGetTextFadeTime (CHAT_LOG))
end

function Sieger.OnInitialize()
 setSiegeChatLogDisplayFilters()
 setSiegeChatLogDisplay()
end


