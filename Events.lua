local warExtended = warExtended
local registeredEvents = {}

local function setStringToUpperCaseAndSubSpace(str)
  str = string.upper(str)
  str = str:gsub("%s", "_")
  return str
end


local function isTableCreated(moduleName)
  local doesTableExist = registeredEvents[moduleName]
  return doesTableExist
end


local function isEventInTable(moduleName, eventName)
  if not isTableCreated(moduleName) then return end

  local isInTable = registeredEvents[moduleName][eventName]
  return isInTable
end


local function addEventToTable(moduleName,eventName)
  if not registeredEvents[moduleName][eventName] then
	registeredEvents[moduleName][eventName] = {}
  end
end


local function isTableEmpty(moduleName, eventName)
  local isEmpty = next(registeredEvents[moduleName][eventName]) == nil
  return isEmpty
end


local function isFunctionRegisteredToEvent(moduleName, eventName, func)
  local isFunctionRegistered = registeredEvents[moduleName][eventName][func]
  return isFunctionRegistered
end


local function registerFunctionToEvent(moduleName, eventName, func)
  registeredEvents[moduleName][eventName][func] = func
  if eventName == "COMBAT" then
    RegisterEventHandler(TextLogGetUpdateEventId("Combat"), func)
    return
  end
  RegisterEventHandler(SystemData.Events[eventName], func)
end


local function removeFromRegisteredEvents(moduleName, eventName, func)
  registeredEvents[moduleName][eventName][func] = nil
  if eventName == "COMBAT" then
    UnregisterEventHandler(TextLogGetUpdateEventId("Combat"), func)
    return
  end

  UnregisterEventHandler(SystemData.Events[eventName], func)

  if isTableEmpty(moduleName, eventName) then
	registeredEvents[moduleName][eventName] = nil
  end
end


local function removeAllRegisteredEvents(moduleName, eventName)
  for RegisteredFunction,_ in pairs(registeredEvents[moduleName][eventName]) do
	removeFromRegisteredEvents(moduleName, eventName, RegisteredFunction)
  end
end


local function isEventValid(event)
  local doesEventExist = SystemData.Events[event] or event == "COMBAT"

  if not doesEventExist then
	d("Invalid event name. Event "..event.." does not exist.")
  end
  return doesEventExist
end


function warExtended:RegisterEvent(eventName, func)
  local event = setStringToUpperCaseAndSubSpace(eventName)
  local moduleName = self.moduleInfo.moduleName

  if not isEventValid(event) then
	return
  end

  if not isTableCreated(moduleName) then
	registeredEvents[moduleName] = {}
  end

  if not isEventInTable(moduleName, event) then
	addEventToTable(moduleName, event)
  end

  if isFunctionRegisteredToEvent(moduleName, event, func) then
	d("Function ".. func .. " is already registered to event "..event)
	return
  end

  registerFunctionToEvent(moduleName, event, func)
end


function warExtended:Broadcast(eventName)
  local event = setStringToUpperCaseAndSubSpace(eventName)

  if not isEventValid(event) then
	return
  end

  BroadcastEvent(SystemData.Events[event])
end

function warExtended:RegisterWindowEvent(windowName, eventName, func)
  local event = setStringToUpperCaseAndSubSpace(eventName)

  if not isEventValid(event) then
	return
  end

  WindowRegisterEventHandler(windowName, SystemData.Events[event], func)
end

function warExtended:UnregisterWindowEvent(windowName, eventName, func)
  WindowUnregisterCoreEventHandler(windowName, eventName, func)
end

function warExtended:RegisterCoreWindowEvent(windowName, eventName, func)
  WindowRegisterCoreEventHandler(windowName, eventName, func)
end

function warExtended:UnregisterWindowEvent(windowName, eventName, func)
  local event = setStringToUpperCaseAndSubSpace(eventName)
  
  if not isEventValid(event) then
	return
  end
  
  WindowUnregisterEventHandler(windowName, SystemData.Events[event], func)
end




function warExtended:UnregisterEvent(eventName, func)
  local moduleName = self.moduleInfo.moduleName
  local event = setStringToUpperCaseAndSubSpace(eventName)

  if not isEventValid(event) then
	return
  end

  if not isEventInTable(moduleName, event) then
	d("Event ".. event .. " is not currently registered to anything.")
	return
  end

  if not isFunctionRegisteredToEvent(moduleName, event, func) then
	d("Function ".. func .. " is not registered to event "..event)
	return
  end

  removeFromRegisteredEvents(moduleName, event, func)
end


function warExtended:UnregisterEventAll(eventName)
  local moduleName = self.moduleInfo.moduleName
  local event = setStringToUpperCaseAndSubSpace(eventName)

  if not isEventValid(event) then
	return
  end

  if not isEventInTable(moduleName, event) then
	d("Event ".. event .. " is not currently registered to anything.")
	return
  end

  removeAllRegisteredEvents(moduleName, event)
end


function warExtended:RegisterUpdate(func)
  self:RegisterEvent("update processed", func)
end


function warExtended:UnregisterUpdate(func)
  self:UnregisterEvent("update processed", func)
end
