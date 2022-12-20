local warExtended    = warExtended
local chatLogFilters = SystemData.ChatLogFilters
local initialized    = false;

local chatFilters    = {}

function warExtended:GetChannelHandle(chatType)
  local Channels = ChatSettings.Channels
  local channelHandle
  
  if type(chatType) == "string" then
	local channelName = warExtended:GetChannelType(chatType)
	channelHandle     = warExtended:toString(Channels[channelName].serverCmd)
  else
	channelHandle = warExtended:toString(Channels[chatType].serverCmd)
  end
  
  return channelHandle
end

function warExtended:GetChannelType(chatType)
  local filterName = warExtended:toStringUpper(chatType)
  local channel    = chatLogFilters[filterName] or chatType
  return channel
end


function warExtended:IsChatChannel(chatType, ...)
  for chatChannel = 1, select('#', ...) do
	local channel   = select(chatChannel, ...)
	local isChannel = chatType == (channel or warExtended:GetChannelType(channel))
	
	if isChannel then
	  return isChannel
	end
  end
end

function warExtended.OnChatTextArrived()
  local chat_type = GameData.ChatData.type
  local text      = GameData.ChatData.text
  
  if (text == nil or text == L"") then return end
  
  --if (chat_type == chatLogFilters.USER_ERROR)
  --then
  --if (text:find (L"Slow down!"))
  --then
  --end
  -- else
  if (chatFilters[chat_type] ~= nil)
  then
	local name = GameData.ChatData.name
	warExtended:TriggerEvent("ChatTextArrived", chat_type, warExtended:FixString(name), text)
  end
end

function warExtended:RegisterChat(func, ...)
  if not initialized then
	warExtended:RegisterGameEvent({"chat text arrived"}, "warExtended.OnChatTextArrived")
  end
  
  for filters = 1, select('#', ...) do
	local filter  = select(filters, ...)
	local channel = warExtended:GetChannelType(filter)
	
	if not chatFilters[channel] then
	  chatFilters[channel] = {}
	end
	
	chatFilters[channel][func] = func
  end
  
  warExtended:AddEventHandler(warExtended:toString(func), "ChatTextArrived", function(chat_type, name, text)
	if chatFilters[chat_type][func] then
	  func(chat_type, name, text)
	end
  end)
end
