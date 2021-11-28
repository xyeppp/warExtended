local warExtended = warExtended
local onChatText = {}


function warExtended:GetChannelFromChatType(chatType)
  chatType = tonumber(chatType)

  for chatFilterName, chatFilterNumber in pairs(SystemData.ChatLogFilters) do
	if chatType == chatFilterNumber then
	  local channelHandle = tostring(ChatSettings.Channels[SystemData.ChatLogFilters[chatFilterName]].serverCmd)
	  return channelHandle
	end
  end

end


function warExtended:GetChannelFromFilterName(filterName)
  for chatFilterName, _ in pairs(SystemData.ChatLogFilters) do
	if filterName == chatFilterName then
	  local channelHandle = tostring(ChatSettings.Channels[SystemData.ChatLogFilters[chatFilterName]].serverCmd)
	  return channelHandle
	end
  end
end

function warExtended:FormatChannel(channel)

  if channel then
	channel = tostring(channel)
	channel = string.format("/%s", channel:gsub("/",""))
	return channel
  end

  return ""
end

function warExtended:GetChatText()
  local chatText = tostring(GameData.ChatData.text)
  return chatText
end




function warExtended.OnChatText(updateType, filterType)
  if( updateType ~= SystemData.TextLogUpdate.ADDED )
  then
	return
  end

  for chatFunction=1,#onChatText do
	onChat = onChatText[chatFunction]
	local isFilterType = isCorrectChannel(filterType, onChat.filters)
	if isFilterType then
	  onChat.func()
	end
  end
end


function warExtended:RegisterChat(func)
  self:RegisterEvent("chat text arrived", func)
end

function warExtended:IsCorrectChannel(...)
  for chatChannel=1,select('#', ...) do
	local channel = (select(chatChannel, ...))
	local currentChatFilter = GameData.ChatData.type
	local desiredFilter = SystemData.ChatLogFilters[channel]
	local isCorrect = currentChatFilter == desiredFilter or GameData.ChatData.type == channel

	if isCorrect then
	  return isCorrect
	end

  end
end
