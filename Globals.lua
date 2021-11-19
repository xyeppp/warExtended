local warExtended = warExtended

local function getLastWhisperPlayerName()
  local lastWhisperPlayerName = ChatManager.LastTell.name
  local isLastWhisperPlayerName = lastWhisperPlayerName ~= L""

  if isLastWhisperPlayerName then
	return lastWhisperPlayerName
  end

end

function TellTarget(text)
  local friendlyTargetName = warExtended:GetTargetName("friendly")

  if friendlyTargetName then
	warExtended:Send("/tell "..friendlyTargetName.." "..text)
  end

end

function ReplyLastWhisper(text)
  local lastWhisperPlayerName = getLastWhisperPlayerName()

  if lastWhisperPlayerName then
	warExtended:Send("/tell "..lastWhisperPlayerName.." "..text)
  end

end

function InviteLastWhisper()
  local lastWhisperPlayerName = getLastWhisperPlayerName()

  if lastWhisperPlayerName then
	warExtended:Send("/invite "..lastWhisperPlayerName)
  end

end
