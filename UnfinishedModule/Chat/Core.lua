warExtendedChat = warExtended.Register("warExtended Chat", "Chat")
local Chat = warExtendedChat

function QuickNameActionsRessurected.OnShownText()
  tester={8, 4, 14,0,EA_ChatWindow.savedChannel}
end

function QuickNameActionsRessurected.newEA_ChatWindowOnKeyTab()
  oldEA_ChatWindowOnKeyTab()
  if (EA_ChatWindow.curChannel ~= SystemData.ChatLogFilters.TELL_SEND)
  then
    counter=counter+1
    EA_ChatWindow.curChannel=tester[counter]
    EA_ChatWindow.SwitchToChatChannel(tester[counter], ChatSettings.Channels[EA_ChatWindow.curChannel].labelText, EA_TextEntryGroupEntryBoxTextInput.Text)
    if (counter >= 5) then
      counter=0
    end
  end
end

function QuickNameActionsRessurected.newEA_ChatWindowInsertItemLink( itemData )
  local ITEM_TAG=L"ITEM:"
  if( itemData == nil )
  then
    return
  end

  local data  = ITEM_TAG..itemData.uniqueID
  local icon = "<icon"..itemData.iconNum..">"
  local text  = L"["..itemData.name..L"]"
  local color = DataUtils.GetItemRarityColor(itemData)

  local link  = CreateHyperLink( data, text, {color.r,color.g,color.b}, {} )
  if QuickNameActionsRessurected.Settings.ItemIcons then
    EA_ChatWindow.InsertText(towstring(QuickNameActionsRessurected.IconLinker(itemData.iconNum))..(link) )
  else
    EA_ChatWindow.InsertText( link )
  end
end

--add QNA+ menu
function QuickNameActionsRessurected.newEA_ChatWindowOnOpenChatMenu(...)
  oldEA_ChatWindowOnOpenChatMenu(...)
  EA_Window_ContextMenu.AddCascadingMenuItem( L"QNA+", QuickNameActionsRessurected.MenuDisplay, false, 1 )
  EA_Window_ContextMenu.Finalize(EA_Window_ContextMenu.CONTEXT_MENU_1)
end

function QuickNameActionsRessurected.newEA_ChatWindowOnMouseOver()
  SendOpenPartySearchRequest(1)
  oldEA_ChatWindowOnMouseOver()
end

local function SocialSearcher(playerName)
  local tableSub = { - 1}
  return SendPlayerSearchRequest(L""..playerName, L"", L"", tableSub, 0, 40, false)
end


local function nocase (s)
  s=tostring(s)
  s = string.gsub(s, "%a", function (c)
    return string.format("[%s%s]", string.lower(c),
            string.upper(c))
  end)
  return s
end


--[[if QuickNameActionsRessurected.Settings.AlertToggle and textFinder ~= textFinder then
  QuickNameActionsRessurected.Settings.AlertToggle = false
  EA_ChatWindow.Print(link..L"Text Alert scan off.")
elseif
  QuickNameActionsRessurected.Settings.AlertToggle = true;
  QuickNameActionsRessurected.Settings.AlertText = (textFinder)
  EA_ChatWindow.Print(link..L"Text Alert scan on.")
  EA_ChatWindow.Print(link..L"Scanning for: "..towstring(input))
end]]

function QuickNameActionsRessurected.HideBackground(flags)
  if flags == SystemData.ButtonFlags.SHIFT then
    if WindowGetShowing("QNAChatBackround") then
      WindowSetShowing("QNAChatBackround", false)
    else
      WindowSetShowing("QNAChatBackround", true)
    end
  elseif flags==SystemData.ButtonFlags.CONTROL then
    TextLogClear("QNAlertTexter")
  elseif flags==SystemData.ButtonFlags.ALT then
    --if QuickNameActionsRessurected.Settings.AlertToggle then
    TextLogClear("QNAlertTexter")
    --QuickNameActionsRessurected.Settings.AlertToggle = false
    WindowSetShowing("QNAlert", false)
    -- end
  end
end

function QuickNameActionsRessurected.newTooltipsSetAbilityTooltipData(windowName, abilityData, extraText, extraTextColor)
  local ID = L" (ID: "..abilityData.id..L")"
  if (extraText) then
    extraText = extraText .. ID
  else
    extraText = ID
  end
  return oldEA_TooltipsSetAbilityTooltipData(windowName, abilityData, extraText, extraTextColor)
end


function QuickNameActionsRessurected.AlertToggle(input)
  if not WindowGetShowing("QNAlert") then
    TextLogClear("QNAlertTexter")
    WindowSetShowing("QNAlert", true)
  end
  local textFinder = nocase(input)
  local textFinder = textFinder:gsub("%s", "(.*)")
  local textFinder = textFinder
  QuickNameActionsRessurected.Settings.AlertText = (textFinder)

  if input == nil or input ==L"" or input =="" or input==QuickNameActionsRessurected.Settings.AlertText then
    QuickNameActionsRessurected.Settings.AlertToggle = false
    EA_ChatWindow.Print(link..L"Text Alert scan off.")
  elseif input~=nil and input ~=  QuickNameActionsRessurected.Settings.AlertText then
    QuickNameActionsRessurected.Settings.AlertText = (textFinder)
    QuickNameActionsRessurected.Settings.AlertToggle = true;
    EA_ChatWindow.Print(link..L"Scanning for: "..towstring(input))
  end
end

function QuickNameActionsRessurected.newEA_ChatWindowOnRButtonDown(flags)
  --  p(flags)
  -- main chat window function for msgs
  local chatText = QuickNameActionsRessurected.Settings.chatMessage1
  local chatChan = QuickNameActionsRessurected.Settings.chatMessage1Channel
  local chatText2 = QuickNameActionsRessurected.Settings.chatMessage2
  local chatChan2 = QuickNameActionsRessurected.Settings.chatMessage2Channel
  if WindowGetShowing("DefaultTooltip") then
    WindowSetShowing("DefaultTooltip", false)
  end

  if WindowGetShowing("EA_Tooltip_OpenPartyWorld") then
    WindowSetShowing("EA_Tooltip_OpenPartyWorld", false)
  end


  --if ctrl+alt pressed then send msg1
  if flags == 40 then
    if QuickNameActionsRessurected.Settings.smartChannel1 then
      if chatChan ~= ChatSettings.Channels[EA_ChatWindow.prevChannel].serverCmd then
        chatChan = ChatSettings.Channels[EA_ChatWindow.prevChannel].serverCmd
      end
      SendChatText(towstring(chatText), towstring(chatChan))
    elseif not QuickNameActionsRessurected.smartChannel then
      SendChatText(towstring(chatText), towstring(chatChan))
    end
    --if ctrl+shift then send msg2
  elseif flags == 36 then
    if QuickNameActionsRessurected.Settings.smartChannel2 then
      if chatChan ~= ChatSettings.Channels[EA_ChatWindow.prevChannel].serverCmd then
        chatChan = ChatSettings.Channels[EA_ChatWindow.prevChannel].serverCmd
      end
      SendChatText(towstring(chatText2), towstring(chatChan2))
    elseif not QuickNameActionsRessurected.smartChannel then
      SendChatText(towstring(chatText2), towstring(chatChan2))
    end
  elseif flags ==44 then
    TextLogClear("Chat")
    TextLogClear("System")
    EA_ChatWindow.Print(link..L"Chat log cleared.")
  else
    oldEA_ChatWindowOnRButtonDown ()
  end
end


local function IsSlashCommandInChannel( slashCommand, channel )
  return ( slashCommand ~= nil and
          channel ~= nil and
          channel.slashCmds ~= nil and
          channel.slashCmds[slashCommand] == 1 )
end

local function GetChatChannelFromText( text )
  if( wstring.find(text, L"/", 1) ~= 1 )
  then
    return nil
  end


  for ixChannel, curChannel in pairs(ChatSettings.Channels)
  do
    if( IsSlashCommandInChannel(text, curChannel) )
    then
      return ixChannel
    end
  end

  return nil
end

local function ChannelInfo1()
  if QuickNameActionsRessurected.Settings.smartChannel1 then
    chanInfo = L"smart"
  elseif not QuickNameActionsRessurected.Settings.smartChannel1 then
    chanInfo = QuickNameActionsRessurected.Settings.chatMessage1Channel
  end
  return chanInfo
end

local function ChannelInfo2()
  if QuickNameActionsRessurected.Settings.smartChannel2 then
    chanInfo2 = L"smart"
  elseif not QuickNameActionsRessurected.Settings.smartChannel2 then
    chanInfo2 = QuickNameActionsRessurected.Settings.chatMessage2Channel
  end
  return chanInfo2
end

local function ChannelInfo()
  ChannelInfo1()
  ChannelInfo2()
end

function QuickNameActionsRessurected.SetText(input, messageNumber)
  local regex = wstring.match(towstring(input), L"\^\%s")
  local qnaSplit = StringSplit(tostring(input), "#")
  local input = towstring(qnaSplit[1])
  local messageNumber = towstring(qnaSplit[2])

  if input == L"" or input == nil or regex then
    EA_ChatWindow.Print(link..L"Current quick-tell message [1] is: "..towstring(QuickNameActionsRessurected.Settings.tellMessage1))
    EA_ChatWindow.Print(link..L"Current quick-tell message [2] is: "..towstring(QuickNameActionsRessurected.Settings.tellMessage2))
    EA_ChatWindow.Print(link..L"/qnahelp for all available message $functions")
    EA_ChatWindow.Print(link..L"Example usage: /qnatell $level - x - $mastery#2")
  else
    if messageNumber == L"1" or not qnaSplit[2] then
      changedTellMessage = true;
      NameMapper(input)
      --QuickNameActionsRessurected.MessageChanger()
      EA_ChatWindow.Print(link..L"Quick-tell message [1] set to: "..towstring(QuickNameActionsRessurected.Settings.tellMessage1))
    elseif messageNumber == L"2" and qnaSplit[2] then
      changedTellMessage2 = true;
      NameMapper(input)
      EA_ChatWindow.Print(link..L"Quick-tell message [2] set to: "..towstring(QuickNameActionsRessurected.Settings.tellMessage2))
    end
    if changedTellMessage then
      changedTellMessage = false;
    elseif changedTellMessage2 then
      changedTellMessage2 = false;
    end
  end
end