local warExtended = warExtended

local function getLastWhisperPlayerName()
  local lastWhisperPlayerName = ChatManager.LastTell.name

  if lastWhisperPlayerName ~= L"" then
	return lastWhisperPlayerName
  end
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
