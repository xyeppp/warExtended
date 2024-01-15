warExtendedSiegeWeaponWindow = warExtended.Register("warExtended Siege Weapon Window")

warExtendedSiegeWeaponWindow:Hook(SiegeWeaponGeneralFireWindow.Initialize, function()
    local SIEGE_LOG = LogDisplay:CreateFrameForExistingWindow("SiegeWeaponGeneralFireWindowChatLogDisplay")
    local CHAT_LOG = GetFrame("EA_ChatTab1TextLog") or LogDisplay:CreateFrameForExistingWindow("EA_ChatTab1TextLog")

    for filterId, msgTypeData in pairs( ChatSettings.Channels )
    do
        local color = ChatSettings.ChannelColors[filterId]
        SIEGE_LOG:SetFilterState(msgTypeData.logName, msgTypeData.id, CHAT_LOG:GetFilterState("Chat", filterId))
        SIEGE_LOG:SetFilterColor(msgTypeData.logName, msgTypeData.id, color)
    end

    SIEGE_LOG:SetFont(CHAT_LOG:GetFont())
    SIEGE_LOG:SetShowLogName(CHAT_LOG:GetShowLogName())
    SIEGE_LOG:SetShowFilterName(CHAT_LOG:GetShowFilterName())
    SIEGE_LOG:SetShowTimestamp(CHAT_LOG:GetShowTimestamp())
    SIEGE_LOG:SetTextFadeTime(CHAT_LOG:GetTextFadeTime())
end,true)
