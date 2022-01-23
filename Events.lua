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

local eventManager = {
      fixString = function(self, str)
      if not str or str == "" then
        str = "nil"
      end
      
      str = string.upper(str)
      str = str:gsub("%s", "_")
      return str
    end,
    
    getEvent = function(self, event)
      event = self:fixString(event)
      
      if not Events[event] then
        d("Invalid event name. Event "..event.." does not exist.")
        return
      end
      
      return Events[event]
    end,
    
    registerTextLogEvent = function(self, textLog, func)
      RegisterEventHandler(TextLogGetUpdateEventId(textLog), func)
    end,
    
    unregisterTextLogEvent = function(self, textLog, func)
      UnregisterEventHandler(TextLogGetUpdateEventId(textLog), func)
    end,
    
    registerEvent = function(self, event, func)
      event = self:getEvent(event)
      RegisterEventHandler(event, func)
    end,
    
    unregisterEvent = function(self, event, func)
      event = self:getEvent(event)
      UnregisterEventHandler(event, func)
    end,
    
    registerWindowEvent = function(self, window, event, func, core)
      if core then
        WindowRegisterCoreEventHandler(window, event, func)
        return
      end
      
      event = self:getEvent(event)
      WindowRegisterEventHandler(window, event, func)
    end,
    
    unregisterWindowEvent = function(self, window, event,func, core)
      if core then
        WindowUnregisterCoreEventHandler(window, event, func)
        return
      end
      
      event = self:getEvent(event)
      WindowUnregisterEventHandler(window, event)
    end,
    
  }

function warExtended:RegisterTextLogEvent(textLog, func)
  eventManager:registerTextLogEvent(textLog, func)
end

function warExtended:UnregisterTextLogEvent(textLog, func)
  eventManager:unregisterTextLogEvent(textLog, func)
end

function warExtended:RegisterEvent(event, func)
  eventManager:registerEvent(event, func)
end

function warExtended:UnregisterEvent(event, func)
  eventManager:unregisterEvent(event, func)
end

function warExtended:RegisterWindowEvent(windowName, event, func)
  eventManager:registerWindowEvent(windowName, event, func)
end

function warExtended:UnregisterWindowEvent(windowName, event, func)
  eventManager:unregisterWindowEvent(windowName, event, func)
end

function warExtended:UnregisterCoreWindowEvent(windowName, event, func)
  eventManager:unregisterWindowEvent(windowName, event, func, true)
end

function warExtended:RegisterCoreWindowEvent(windowName, event, func)
  eventManager:registerWindowEvent(windowName, event, func, true)
end

function warExtended:RegisterUpdate(func)
  self:RegisterEvent("update processed", func)
end

function warExtended:UnregisterUpdate(func)
  self:UnregisterEvent("update processed", func)
end

function warExtended:Broadcast(event)
  event = eventManager:getEvent(event)

  if not event then
	return
  end

  BroadcastEvent(event)
end