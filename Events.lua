local registeredEvents = {}

local function setStringToUpperCaseAndSubSpace(str)
  str = string.upper(str)
  return str:gsub("%s", "_")
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
  if not isFunctionRegistered then
	d("Function ".. func .. " is not currently registered to event "..eventName)
  end
	return isFunctionRegistered
end

local function registerFunctionToEvent(moduleName, eventName, func)
  registeredEvents[moduleName][eventName][func] = func
  RegisterEventHandler(SystemData.Events[eventName], func)
end

local function removeFromRegisteredEvents(moduleName, eventName, func)
  UnregisterEventHandler(SystemData.Events[eventName], func)
  registeredEvents[moduleName][eventName][func] = nil

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
  local doesEventExist = SystemData.Events[event]

  if not doesEventExist then
	d("Invalid event name. Event "..event.." does not exist.")
  end
  return doesEventExist
end

function warExtended:RegisterEvent(eventName, func)
  local event = setStringToUpperCaseAndSubSpace(eventName)
  local moduleName = self.module.name
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
	return d("Function ".. func .. " is already registered to event "..event)
  end

  registerFunctionToEvent(moduleName, event, func)

end

function warExtended:UnregisterEvent(eventName, func)
  local moduleName = self.module.name
  local event = setStringToUpperCaseAndSubSpace(eventName)

  if not isEventValid(event) then
	return
  end

  if not isEventInTable(moduleName, event) then
	return d("Event ".. event .. " is not currently registered to anything.")
  end

  if not isFunctionRegisteredToEvent(moduleName, event, func) then
	return
  end

	removeFromRegisteredEvents(moduleName, event, func)
end

function warExtended:UnregisterEventAll(eventName)
  local moduleName = self.module.name
  local event = setStringToUpperCaseAndSubSpace(eventName)
  if not isEventValid(event) then
	return
  end

  if not isEventInTable(moduleName, event) then
	return d("Event ".. event .. " is not currently registered to anything.")
  end

  removeAllRegisteredEvents(moduleName, event)

end

function warExtended:RegisterUpdate(func)
  return warExtended:RegisterEvent("on update", func)
end

function warExtended:UnregisterUpdate(func)
  return warExtended:UnregisterEvent("on update", func)
end