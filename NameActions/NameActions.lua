warExtendedNameActions = warExtended.Register("warExtended NameActions")
local NameActions = warExtendedNameActions
local pairs=pairs
local towstring=towstring
---TODO: Implement smart channel in warExtended base so I can use it here

NameActions.SavedMessages = {
  Tell = {
    [1] = {
      Text = L"Invite please."
    },
    [2] = {
      Text = L"Test message."
    },
  },
  Chat = {
    [1] = {
      Text = L"LFM BB/BE",
      Channel = L"/s"
    },
    [2] = {
      Text = L"Warband LF more.",
      Channel = L"/shout"
    }
  }
}

local function getQuickMessage(specifiedMessageType, specifiedSlot)
  local quickMessage = towstring(NameActions.SavedMessages[specifiedMessageType][specifiedSlot].Text)
  local quickChannel = towstring(NameActions.SavedMessages[specifiedMessageType][specifiedSlot].Channel)
  return quickMessage, quickChannel
end

local function searchSocialForPlayer(playerName)
  SendPlayerSearchRequest(L""..playerName, L"", L"", { -1 }, 0, 40, false)
end


local function clearPlayerNameFromTag(playerName)
  playerName = wstring.gsub( playerName, L"PLAYER:", L"" )
  return playerName
end


local flagActions = {

  PlayerlinkLButtonUp = {

    isShiftPressed = function (playerName)
      NameActions:Send(playerName)
      searchSocialForPlayer(playerName)
    end,

    isCtrlPressed = function (playerName)
      NameActions:Send(L"/invite "..playerName)
    end,

    isAltPressed = function (playerName)
      NameActions:Send(L"/friend "..playerName)
    end
  },

  PlayerlinkRButtonUp = {

    isShiftPressed = function (playerName)
      NameActions:Send(playerName..L" "..getQuickMessage("Tell", 1))
    end,

    isCtrlPressed = function (playerName)
      NameActions:Send(L"/join "..playerName)
    end,

    isAltPressed = function (playerName)
      NameActions:Send(playerName..L" "..getQuickMessage("Tell", 2))
    end
  },

  ChatWindowLButtonUp = {

    isCtrlShiftPressed = function ()
      NameActions:Send(getQuickMessage("Chat", 1))
    end,

    isCtrlAltPressed = function ()
      NameActions:Send(getQuickMessage("Chat", 2))
    end,
  }
}

local flagNumberToFlagText = {
  [4] = "isShiftPressed",
  [8] = "isCtrlPressed",
  [12] = "isCtrlShiftPressed",
  [32] = "isAltPressed",
  [36] = "isAltShiftPressed",
  [40] = "isCtrlAltPressed",
  [44] = "isCtrlAltShiftPressed"
}


local function getFunctionFromFlag(playerName, flags, functionType)
  local flagText = flagNumberToFlagText[flags]
  local isFlagMatching = flagActions[functionType][flagText]

  if isFlagMatching then

    if playerName then
      playerName = clearPlayerNameFromTag(playerName)
    end

    isFlagMatching(playerName)
    return isFlagMatching
  end

  return isFlagMatching
end


function NameActions.newEA_ChatWindowOnPlayerLinkLButtonUp(playerName, flags, x, y )

  if getFunctionFromFlag(playerName, flags, "PlayerlinkLButtonUp") then
    return
  end

  originalEA_ChatWindowOnHyperLinkLButtonUp(playerName, flags, x, y )
end



function NameActions.newEA_ChatWindowOnPlayerLinkRButtonUp(playerName, flags, x, y, wndGroupId)

  if getFunctionFromFlag(playerName, flags, "PlayerlinkRButtonUp") then
    return
  end

  originalEA_ChatWindowOnPlayerLinkRButtonUp(playerName, flags, x, y, wndGroupId)
end



function NameActions.newEA_ChatWindowOnRButtonDown(flags)

  if getFunctionFromFlag(nil, flags, "ChatWindowLButtonUp") then
    return
  end

  originalEA_ChatWindowOnRButtonDown(flags)
end


local function getCurrentSavedMessages(specifiedMessageType)

  if specifiedMessageType then
    for messageNumber=1,#NameActions.SavedMessages[specifiedMessageType] do
      local messageText = tostring(NameActions.SavedMessages[specifiedMessageType][messageNumber].Text)
      NameActions:Print("Quick-"..specifiedMessageType.." message ["..messageNumber.."] is: "..messageText)
    end
    return
  end

  for messageTypes, _ in pairs(NameActions.SavedMessages) do
    for messageNum=1,#NameActions.SavedMessages[messageTypes] do
      local messageText = tostring(NameActions.SavedMessages[messageTypes][messageNum].Text)
      NameActions:Print("Quick-"..messageTypes.." message ["..messageNum.."] is: "..messageText)
    end
  end
end



local function saveMessage(newText, messageNumber, newChannel, messageType)
NameActions.SavedMessages[messageType][messageNumber].Text = newText

if newChannel then
  newChannel = string.format("/%s", newChannel:gsub("/",""))
  NameActions.SavedMessages[messageType][messageNumber].Channel = newChannel
  NameActions:Print("Quick-"..messageType.." message ["..messageNumber.."] set to:"
            ..newText.."\nChannel: "..newChannel)
  return
end

NameActions:Print("Quick-"..messageType.." message ["..messageNumber.."] set to:"..newText)
end



local function setQuickMessage(newText, messageNumber, newChannel, messageType)
  messageNumber = tonumber(messageNumber) or 1
  local isMessageNumberValid = NameActions.SavedMessages[messageType][messageNumber]

  if not isMessageNumberValid then
    NameActions:Warn("Invalid message number.")
    return
  elseif newText == "" then
    getCurrentSavedMessages(messageType)
    return
  end

  saveMessage(newText, messageNumber, newChannel, messageType)
end



local slashCommands = {
  qmsg = {
    func = function ()
      getCurrentSavedMessages()
    end,
    desc = "Prints currently set Quick-Messages."
  },
  qtell = {
    func = function (text, messageNumber)
      setQuickMessage(text, messageNumber,nil, "Tell")
    end,
    desc = "Set your quick-tell message: /qtell text#slotNumber"
  },
  qchat = {
    func =  function (text, messageNumber, channel)
      setQuickMessage(text, messageNumber,channel, "Chat")
    end,
    desc = "Set your quick-chat message: /qchat text#slotNumber#channel"
  }
}


function NameActions.OnInitialize()
  originalEA_ChatWindowOnHyperLinkLButtonUp = EA_ChatWindow.OnHyperLinkLButtonUp
  EA_ChatWindow.OnHyperLinkLButtonUp = NameActions.newEA_ChatWindowOnPlayerLinkLButtonUp

  originalEA_ChatWindowOnPlayerLinkRButtonUp = EA_ChatWindow.OnHyperLinkRButtonUp
  EA_ChatWindow.OnPlayerLinkRButtonUp = NameActions.newEA_ChatWindowOnPlayerLinkRButtonUp

  originalEA_ChatWindowOnRButtonDown = EA_ChatWindow.OnRButtonDown
  EA_ChatWindow.OnRButtonDown = NameActions.newEA_ChatWindowOnRButtonDown

  NameActions:RegisterSlash(slashCommands, "warext")
end
