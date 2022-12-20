local warExtended = warExtended
local RegisterEventHandler = RegisterEventHandler
local UnregisterEventHandler = UnregisterEventHandler
local WindowRegisterEventHandler = WindowRegisterEventHandler
local WindowUnregisterEventHandler = WindowUnregisterEventHandler
local WindowRegisterCoreEventHandler = WindowUnregisterCoreEventHandler
local WindowUnregisterCoreEventHandler = WindowUnregisterCoreEventHandler
local TextLogGetUpdateEventId = TextLogGetUpdateEventId
local BroadcastEvent = BroadcastEvent
local Events = SystemData.Events
local select = select

local events = {}

local function fixString(str)
	str = warExtended:toStringOrEmpty(str)
	str = warExtended:toStringUpper(str)
	str = str:gsub("%s", "_")
	return str
end

local function getEventFromName(event)
	event = fixString(event)

	if not Events[event] then
		error("Invalid event name. Event " .. event .. " does not exist.")
		return
	end

	return Events[event]
end

function warExtended:Broadcast(event)
	event = getEventFromName(event)

	if not event then
		return
	end

	BroadcastEvent(event)
end

function warExtended:AddEventHandler(key, name, callback)
	if not callback then
		d("Wrong arguments for AddEventHandler: " .. key .. ", " .. name .. ", " .. type(callback))
	end

	warExtended:RemoveEventHandler(key, name)

	local e = events[name]
	if e == nil then
		e = warExtendedLinkedList.New()
		events[name] = e
	end

	e:Add(key, callback)
end

function warExtended:TriggerEvent(name, ...)
	local e = events[name]
	if e == nil then
		return
	end

	local item = e.first
	while item do
		item.data(select(1, ...))
		item = item.next
	end
end

function warExtended:GetEvent(key, name)
	local e = events[name]
	if e == nil then
		return
	end
	local item = e:Get(key)
	return item
end

function warExtended:RemoveEventHandler(key, name, func)
	local e = events[name]
	if e == nil then
		return
	end
	e:Remove(key)
  
  if func ~= nil then
	func = nil
  end
end

function warExtended:RegisterTextLogEvent(textLog, ...)
  local args={...}
	for func = 1, #args do
	  RegisterEventHandler(TextLogGetUpdateEventId(textLog), args[func])
	end
end

function warExtended:UnregisterTextLogEvent(textLog, ...)
  local args={...}
  for func = 1, #args do
	UnregisterEventHandler(TextLogGetUpdateEventId(textLog), args[func])
  end
end

function warExtended:WindowRegisterTextLogEvent(windowName, textLog, ...)
  local args={...}
  for func = 1, #args do
	WindowRegisterEventHandler(windowName, TextLogGetUpdateEventId(textLog), args[func])
  end
end

function warExtended:GetTextLogUpdateEventId(textLog)
  local textLogUpdateEventId = TextLogGetUpdateEventId(textLog)
  return textLogUpdateEventId
end

function warExtended:RegisterGameEvent(eventsTable, ...)
  local args={...}
  for event=1,#eventsTable do
	event = getEventFromName(eventsTable[event])
	
	for func = 1, #args do
	  RegisterEventHandler(event, args[func])
	end
  end
end


function warExtended:UnregisterGameEvent(eventsTable, ...)
  local args={...}
  for event=1,#eventsTable do
	event = getEventFromName(eventsTable[event])
	
	for func = 1, #args do
	  UnregisterEventHandler(event, args[func])
	end
  end
end


function warExtended:RegisterWindowCoreEvent(windowName, eventsTable, ...)
  local args= { ... }
  for event=1,#eventsTable do
	for func = 1, #args do
	  WindowRegisterCoreEventHandler(windowName, event, args[func])
	end
  end
end


function warExtended:UnregisterWindowCoreEvent(windowName, eventsTable)
  for event=1,#eventsTable do
	WindowUnregisterCoreEventHandler(windowName, eventsTable[event])
  end
end



function warExtended:RegisterWindowEvent(windowName, eventsTable, ...)
  local args= { ... }
  for event=1,#eventsTable do
	for func = 1, #args do
	  if eventsTable[event] ~= nil then
	  event=getEventFromName(eventsTable[event])
		WindowRegisterEventHandler(windowName, event, args[func])
	  end
	end
  end
end

function warExtended:UnregisterWindowEvent(windowName, eventsTable)
  for event=1,#eventsTable do
	  event=getEventFromName(eventsTable[event])
	  WindowUnregisterEventHandler(windowName, event)
	end
end

function warExtended:RegisterUpdate(...)
	self:RegisterGameEvent({"update processed"}, ...)
end

function warExtended:UnregisterUpdate(...)
	self:UnregisterGameEvent({"update processed"}, ...)
end
