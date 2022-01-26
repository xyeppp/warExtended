local warExtended = warExtended
local chatLogFilters = SystemData.ChatLogFilters
local initialized = false;

local funcFilters = {}
local chatFilters = {}

function warExtended:GetChannelHandle(chatType)
  local channelHandle = nil
  
  if type(chatType) == "string" then
	local channelName = warExtended:GetChannelType(chatType)
	channelHandle = warExtended:toString(ChatSettings.Channels[channelName].serverCmd)
  else
	channelHandle = warExtended:toString(ChatSettings.Channels[chatType].serverCmd)
  end
  
  return channelHandle
end

function warExtended:GetChannelType(chatType)
  local channel = chatLogFilters[warExtended:toStringUpper(chatType)] or chatType
  return channel
end

function warExtended:IsChatChannel(chatType, ...)
  for chatChannel=1,select('#', ...) do
	local channel = select(chatChannel, ...)
	local isChannel = chatType == (warExtended:GetChannelType(channel) or channel)
 
	if isChannel then
	  return isChannel
	end
  end
end

function warExtended.OnChatTextArrived()
  local chat_type = GameData.ChatData.type
  local text = GameData.ChatData.text
  
  if (text == nil or text == L"") then return end
  
  --if (chat_type == chatLogFilters.USER_ERROR)
  --then
	--if (text:find (L"Slow down!"))
	--then
	--end
 -- else
  if (chatFilters[chat_type] == true)
  then
	local name = GameData.ChatData.name
	warExtended:TriggerEvent ("ChatTextArrived", chat_type, warExtended:FixString (name), text)
  end
end

function warExtended:RegisterChat(func, ...)
  if not initialized then
	warExtended:RegisterEvent("chat text arrived", "warExtended.OnChatTextArrived")
  end
  
  funcFilters[func] = {}
  
  for filters=1,select('#', ...) do
	local filter = select(filters, ...)
	chatFilters[warExtended:GetChannelType(filter)] = true;
	funcFilters[func][filter] = filter
  end
  
  warExtended:AddEventHandler(warExtended:toString(func), "ChatTextArrived", function(chat_type, name, text)
	if funcFilters[func][chat_type] then
		func(chat_type, name, text)
	  end
  end)
end