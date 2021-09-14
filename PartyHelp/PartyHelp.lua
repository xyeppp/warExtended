warExtendedPartyHelper = warExtended.Register("warExtended Party Helper")
local PartyHelp = warExtendedPartyHelper
local DialogManager = DialogManager
local DefaultColor = DefaultColor
local PARTY_HELP_WINDOW = "PartyHelpWindow"

local linkTypes = {
  check = {
    data = "READYCHECK:check",
    text = "Ready Check?",
    color = DefaultColor.GREEN
  },
  ready = {
    data = "READYCHECKREADY:ready",
    text = "Ready.",
    color = DefaultColor.GREEN
  },
  notready = {
    data = "READYCHECKNOTREADY:notready.",
    text = "Not Ready.",
    color = DefaultColor.RED
  },
  announce = {
    data = "ANNOUNCE:",
    color = DefaultColor.ORANGE
  }
}

local function getChatChannelFromGroupType()
  local groupType = PartyHelp:GetGroupType()
  local chatChannel = PartyHelp:GetChannelFromFilterName(groupType)
  return chatChannel
end

local function isPlayerLeader()
  local isLeader = GameData.Player.isGroupLeader
  return isLeader
end

local function isPlayerSender(senderName)
  local playerName = GameData.Player.name
  local isSender = WStringsCompareIgnoreGrammer(playerName, towstring(senderName)) ~= 1
  return isSender
end


local function getReadyLink(linkType)
  local color = linkTypes[linkType].color
  local data = linkTypes[linkType].data
  local text = linkTypes[linkType].text
  local readyLink = CreateHyperLink( towstring(data), towstring(text), {color.r, color.g, color.b}, {} )
  return readyLink
end

local function sendReadyCheck()
  local chatChannel = getChatChannelFromGroupType()
  local readyLink = getReadyLink("check")

  PartyHelp:Send(readyLink, chatChannel)
end


local function readyCheck()

  if not isPlayerLeader() then
    PartyHelp:Warn("Must be a group leader to issue a ready check.")
    return
  end

  sendReadyCheck()
end


local function readyDialogButtonCallback(buttonText, channel)
  local readyLink = getReadyLink(buttonText)
  PartyHelp:Send(readyLink, channel)
end


local function initializeReadyCheckDialog(senderName)
  local leaderName = towstring(senderName)
  local dialogText = leaderName..L"\n"..L"Ready Check?"
  local button1Text = L"Ready."
  local button2Text = L"Not ready."

  local chatType = tostring(GameData.ChatData.type)
  local channelToSend = PartyHelp:GetChannelFromChatType(chatType)

  DialogManager.MakeTwoButtonDialog( dialogText,
          button1Text, function () readyDialogButtonCallback("ready", channelToSend) end,
          button2Text, function () readyDialogButtonCallback("notready", channelToSend) end,
          30, 2)
end


local function clearGroupWindow()
  for groupNumber=1,4 do
    for memberNumber = 1,6 do
      local window = PARTY_HELP_WINDOW .. "Warband".."Group" .. groupNumber .. memberNumber
      LabelSetText(window, L"")
    end
  end
end


local function populateGroupWindow()
  clearGroupWindow()
  local groupNames = PartyHelp:GetGroupNames()

  for groupNumber = 1,#groupNames do
    local groupName = groupNames[groupNumber]
    for memberNumber = 1,#groupName do
      local memberName = groupName[memberNumber]
      local window = PARTY_HELP_WINDOW .. "Warband".."Group" .. groupNumber .. memberNumber
      LabelSetText(window, memberName)
    end
  end
end


local function processReadyCheck(readyType, senderName)
  local memberNumber = warExtended:GetPlayerMemberNumber(senderName)
  local groupNumber = warExtended:GetPlayerGroupNumber(senderName)
  local readyText = linkTypes[readyType].text
  local readyColor = linkTypes[readyType].color
  local windowName = PARTY_HELP_WINDOW .. "Warband".."Group" .. groupNumber .. memberNumber
  local currentText = LabelGetText(windowName)

  LabelSetText(windowName, currentText..L" - "..towstring(readyText))
  LabelSetTextColor(windowName, readyColor.r, readyColor.g, readyColor.b)
end


local function isTextMatchReadyCheck(chatText)
  local isReadyCheck = chatText:match("READYCHECK:(%w+)")
  local isPlayerReady = chatText:match("READYCHECKREADY:(%w+)")
  local isPlayerNotReady = chatText:match("READYCHECKNOTREADY:(%w+)")
  local readyType = isPlayerReady or isPlayerNotReady
  return isReadyCheck, readyType
end





local function getAnnouncementLink(linkText, announceGroups)
  local color = linkTypes.announce.color
  local data = linkTypes.announce.data .. linkText .. "#GROUPS##"
  local text = "Announce: "..linkText

  if announceGroups then
     data = linkTypes.announce.data .. linkText .. "#GROUPS#" .. announceGroups .. "#"
     text = "Group "..announceGroups..": "..linkText
  end

  local announceLink = CreateHyperLink( towstring(data), towstring(text), {color.r, color.g, color.b}, {} )
  return announceLink
end



local function groupAnnounce(text, announceGroups)
  local chatChannel = getChatChannelFromGroupType()

  if not isPlayerLeader() then
    PartyHelp:Warn("Must be a group leader to issue an announcement.")
    return
  end

  if text == "" then
    PartyHelp:Warn("Must specify an announcement text.")
    return
  end

  if groupType == "GROUP" and announceGroups then
    announceGroups = nil
  end

  local announcementLink = getAnnouncementLink(text, announceGroups)
  PartyHelp:Send(announcementLink, chatChannel)

end

local function getGuildMemberPermissionStatus(playerName)
  local guildMemberList = GuildWindowTabRoster.memberListData
  for guildMember = 1,#guildMemberList do
    local isPlayer = playerName:match(tostring(guildMemberList[guildMember].name))

    if isPlayer then
      local memberStatus = guildMemberList[guildMember].statusNumber
      return memberStatus
    end

  end
end


local function guildAnnounce(text)
  local playerName = tostring(GameData.Player.name)
  local playerPermissionStatus = getGuildMemberPermissionStatus(playerName)
  local guildChatChannel = PartyHelp:GetChannelFromFilterName("GUILD")
  local isPlayerPermittedToPromote = GuildWindowTabAdmin.GetGuildCommandPermission(3, playerPermissionStatus)

  if not isPlayerPermittedToPromote then
    PartyHelp:Warn("Insufficient guild permissions to make an announcement.")
    return
  end

  if text == "" then
    PartyHelp:Warn("Must specify an announcement text.")
    return
  end

  local announcementLink = getAnnouncementLink(text, nil)
  PartyHelp:Send(announcementLink, guildChatChannel)
end




local function isPlayerInAnnounceGroup(announceGroups)
  local playerName = tostring(GameData.Player.name)
  local playerGroupNumber = PartyHelp:GetPlayerGroupNumber(playerName)
  local groupsToAnnounce = StringSplit(announceGroups, ",")

  for announceGroup=1,#groupsToAnnounce do
    local isCorrectGroup = playerGroupNumber == tonumber(groupsToAnnounce[announceGroup])
    return isCorrectGroup
  end

end



local function processAnnouncement(announcementText, senderName, announceGroups)
  if not isPlayerSender(senderName) then

    if announceGroups then
      local isCorrectGroup = isPlayerInAnnounceGroup(announceGroups)

      if isCorrectGroup then
        PartyHelp:Alert(senderName..": "..announcementText, 32)
      end

      return
    end

    PartyHelp:Alert(senderName..": "..announcementText, 32)
  end
end


local function isTextMatchAnnounce(chatText)
  local annText = chatText:match("ANNOUNCE:(.*)#GROUPS")
  local annGroups = chatText:match("#([1-4%p]+)#")
  return annText, annGroups
end


function warExtendedPartyHelper.OnChatText()

  if PartyHelp:IsCorrectChannel("BATTLEGROUP") or PartyHelp:IsCorrectChannel("GROUP") or PartyHelp:IsCorrectChannel("GUILD") then
    local chatText = tostring(GameData.ChatData.text)
    local senderName = tostring(GameData.ChatData.name)
    local isReadyCheck,readyType = isTextMatchReadyCheck(chatText)
    local announceText, announceGroups = isTextMatchAnnounce(chatText)

    if isReadyCheck then
        populateGroupWindow()
        processReadyCheck("ready", senderName)
      if not isPlayerLeader() then
        initializeReadyCheckDialog(senderName)
      end
    elseif readyType then
      processReadyCheck(readyType, senderName)
    elseif announceText then
      processAnnouncement(announceText, senderName, announceGroups)
    end
  end

end



local slashCommands = {

  rcheck = {
    func = readyCheck,
    desc = "Ready check."
  },

  ann = {
    func = groupAnnounce,
    desc = "Announce a message to the specified group or WB. text#3,2"
  },

  guildann = {
    func = guildAnnounce,
    desc = "Announce a message to your guild."
  }

}



local function registerLayoutWindow()
  LayoutEditor.RegisterWindow( PARTY_HELP_WINDOW,
          L"Party Helper Window",
          L"Party Helper Window",
          false, false )
end


function warExtendedPartyHelper.OnInitialize()
  registerLayoutWindow()
  PartyHelp:RegisterSlash(slashCommands, "warext")
  PartyHelp:RegisterChat("warExtendedPartyHelper.OnChatText")
end