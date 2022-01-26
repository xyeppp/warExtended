local warExtended                      = warExtended
local RegisterEventHandler             = RegisterEventHandler
local UnregisterEventHandler           = UnregisterEventHandler
local WindowRegisterEventHandler       = WindowRegisterEventHandler
local WindowUnregisterEventHandler     = WindowUnregisterEventHandler
local WindowRegisterCoreEventHandler   = WindowUnregisterCoreEventHandler
local WindowUnregisterCoreEventHandler = WindowUnregisterCoreEventHandler
local TextLogGetUpdateEventId          = TextLogGetUpdateEventId
local BroadcastEvent                   = BroadcastEvent
local Events                           = SystemData.Events
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
	d("Invalid event name. Event " .. event .. " does not exist.")
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

function warExtended:AddEventHandler (key, name, callback)
  if (not callback)
  then
    d("Wrong arguments for AddEventHandler: " .. key .. ", " .. name .. ", " .. type(callback))
  end
  
  warExtended:RemoveEventHandler(key, name)
  
  local e = events[name]
  if (e == nil)
  then
    e            = warExtendedLinkedList.New()
    events[name] = e
  end
  
  e:Add(key, callback)
end

function warExtended:TriggerEvent (name, ...)
  local e = events[name]
  if (e == nil) then return end
  
  local item = e.first
  while (item)
  do
    item.data(select(1, ...))
    item = item.next
  end
end

function warExtended:GetEvent(key, name)
  local e = events[name]
  if (e == nil) then return end
  local item = e:Get(key)
  return item
end

function warExtended:RemoveEventHandler (key, name)
  local e = events[name]
  if (e == nil) then return end
  e:Remove(key)
end

function warExtended:RegisterTextLogEvent(textLog, func)
  RegisterEventHandler(TextLogGetUpdateEventId(textLog), func)
end

function warExtended:UnregisterTextLogEvent(textLog, func)
  UnregisterEventHandler(TextLogGetUpdateEventId(textLog), func)
end

function warExtended:RegisterEvent(event, func)
  event = getEventFromName(event)
  RegisterEventHandler(event, func)
end

function warExtended:UnregisterEvent(event, func)
  event = getEventFromName(event)
  UnregisterEventHandler(event, func)
end

function warExtended:RegisterWindowEvent(windowName, event, func, core)
  if core then
	WindowRegisterCoreEventHandler(windowName, event, func)
	return
  end
  
  event = getEventFromName(event)
  WindowRegisterEventHandler(windowName, event, func)
end

function warExtended:UnregisterWindowEvent(windowName, event, func, core)
  if core then
	WindowUnregisterCoreEventHandler(windowName, event, func)
	return
  end
  
  event = getEventFromName(event)
  WindowUnregisterEventHandler(windowName, event)
end

function warExtended:RegisterUpdate(func)
  self:RegisterEvent("update processed", func)
end

function warExtended:UnregisterUpdate(func)
  self:UnregisterEvent("update processed", func)
end