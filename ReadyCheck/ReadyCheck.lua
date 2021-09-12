warExtendedReadyCheck = warExtended.Register("warExtended Ready Check")
local ReadyCheck = warExtendedReadyCheck
local DialogManager = DialogManager
local DefaultColor = DefaultColor


local linkTypes = {
  check = {
    data = "READYCHECK:IsReady?",
    text = "Ready Check?",
    color = DefaultColor.GREEN
  },
  ready = {
    data = "READYCHECKREADY:Ready.",
    text = "Ready.",
    color = DefaultColor.GREEN
  },
  notready = {
    data = "READYCHECKNOTREADY:Not ready.",
    text = "Not Ready.",
    color = DefaultColor.RED
  }
}


local function getReadyLink(linkType)
  local color = linkTypes[linkType].color
  local data = linkTypes[linkType].data
  local text = linkTypes[linkType].text
  local readyLink = CreateHyperLink( towstring(data), towstring(text), {color.r, color.g, color.b}, {} )
  return readyLink
end


local function isPlayerLeader()
  local isPlayerLeader = GameData.Player.isGroupLeader
  return isPlayerLeader
end




local function sendReadyCheck(groupType)
  --GetGroupType uses "BATTLEGROUP" and "GROUP" which correspond to chat filter names
  local chatChannel = ReadyCheck:GetChannelFromFilterName(groupType)
  local readyLink = getReadyLink("check")

  ReadyCheck:Send(readyLink, chatChannel)
end


local function readyCheck()
  local groupType = ReadyCheck:GetGroupType()


  if not groupType then
    ReadyCheck:Warn("Must be in group to issue a ready check.")
    return
  end

  if not isPlayerLeader() then
    ReadyCheck:Warn("Must be a group leader to issue a ready check.")
    return
  end

  sendReadyCheck(groupType)
end


local function readyButtonCallback(buttonText, channel)
  local readyLink = getReadyLink(buttonText)
  ReadyCheck:Send(readyLink, channel)
end


local function initializeReadyCheckDialog(senderName)
  local leaderName = towstring(senderName)
  local dialogText = leaderName..L"\n"..L"Ready Check?"
  local button1Text = L"Ready."
  local button2Text = L"Not ready."

  local chatType = tostring(GameData.ChatData.type)
  local channel = ReadyCheck:GetChannelFromChatType(chatType)

  DialogManager.MakeTwoButtonDialog( dialogText,
          button1Text, function () readyButtonCallback("ready", channel) end,
          button2Text, function () readyButtonCallback("notready", channel) end,
          30, 2)
end



local function addSenderToGroupWindow(senderName, readyType)


end


local function processReadyCheck(readyType, senderName)

  ReadyCheck:Print(senderName.." is "..readyType)
end


local function isTextMatchReadyCheck(chatText)
  local isReadyCheck = chatText:match("READYCHECK:(%w+)")
  local isPlayerReady = chatText:match("READYCHECKREADY:(%w+)")
  local isPlayerNotReady = chatText:match("READYCHECKNOTREADY:(%w+%s+%w+)")
  local readyType = isPlayerReady or isPlayerNotReady
  return isReadyCheck, readyType
end


function warExtendedReadyCheck.OnChatText()

  if ReadyCheck:IsCorrectChannel("BATTLEGROUP") or ReadyCheck:IsCorrectChannel("GROUP") or ReadyCheck:IsCorrectChannel("SAY") then
    local chatText = tostring(GameData.ChatData.text)
    local senderName = tostring(GameData.ChatData.name)
    local isReadyCheck,readyType = isTextMatchReadyCheck(chatText)

    if isReadyCheck and not isPlayerLeader() then
      initializeReadyCheckDialog(senderName)
    elseif readyType then
      processReadyCheck(readyType, senderName)
    end
  end

end


local slashCommands = {

  rcheck = {
    func = readyCheck,
    desc = "Ready check."
  }

}

function warExtendedReadyCheck.OnInitialize()
  ReadyCheck:RegisterSlash(slashCommands, "warext")
  ReadyCheck:RegisterChat("warExtendedReadyCheck.OnChatText")
end