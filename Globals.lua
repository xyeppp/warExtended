local warExtended = warExtended

local function getLastWhisperPlayerName()
  local lastWhisperPlayerName = ChatManager.LastTell.name

  if lastWhisperPlayerName ~= L"" then
	return lastWhisperPlayerName
  end
end

--[[function ChatMacro(chatText,chatChannel)
    if not chatChannel then chatChannel = "/s" end

    chatText  =  substituteChatText(chatText)
    chatChannel = towstring(chatChannel)

    SendChatText(chatText, chatChannel)
end]]

function ChatMacro(chatText,chatChannel)
    if not chatChannel then chatChannel = L"/s" end

    if not warExtended:IsType(chatText, "wstring")
            or not warExtended:IsType(chatChannel, "wstring") then
        chatText  =  warExtended:toWString(chatText)
        chatChannel = warExtended:toWString(chatChannel)
    end

    SendChatText(chatText, chatChannel)
end

function TellTarget(text)
  local friendlyTargetName = warExtended:GetTargetName("friendly")

  if friendlyTargetName then
	warExtended:TellPlayer(friendlyTargetName, text)
  end

end

function ReplyToLastWhisper(text)
  local lastWhisperPlayerName = getLastWhisperPlayerName()

  if lastWhisperPlayerName then
	warExtended:TellPlayer(lastWhisperPlayerName, text)
  end

end

function InviteLastWhisper()
  local lastWhisperPlayerName = getLastWhisperPlayerName()

  if lastWhisperPlayerName then
	warExtended:InvitePlayer(lastWhisperPlayerName)
  end

end
