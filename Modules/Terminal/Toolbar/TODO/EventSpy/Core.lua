local warExtended = warExtended
local warExtendedTerminal = warExtendedTerminal
local WINDOW_NAME = "TerminalEventSpy"
local tsort = table.sort
local events = SystemData.Events

local eventSpy = {
  events = {};
  sets = warExtendedSet.RegisterNewSet("comboBoxName"),
  isSpying = false;
}

do
  for eventName,eventId in pairs(events) do
	eventSpy.events[#eventSpy.events+1] = {
	  eventId = eventId,
	  eventName = warExtended:toWString(eventName)
	}
  end
  
  tsort(eventSpy.events, function(a,b)
	return a.eventName < b.eventName
  end)
end

function warExtendedTerminal.EventSpyOnInitialize()
  LabelSetText(WINDOW_NAME.."TitleBarLabel", L"Event Spy")
  warExtendedTerminal:RegisterToolbarItem(L"Event Spy", L"Provides for a way to look at in-game events firing and ability to check their arguments.", "TerminalEventSpy",07988, eventSpy)
end

function warExtendedTerminal.EventSpyEventsRefreshList()
  local settings=warExtendedTerminal.GetToolbarButtonSettings(WINDOW_NAME)
  local events = settings.events
  
  local displayOrder = {}
  
  for index, data in pairs(events)
  do
	table.insert(displayOrder, index)
  end
  
  ListBoxSetDisplayOrder("TerminalEventSpyEventsList", displayOrder)
end

function warExtendedTerminal.EventSpyEventsPopulateList()
  local settings = warExtendedTerminal.GetToolbarButtonSettings(WINDOW_NAME)
  -- Post-process any conditional formatting
  for row, data in ipairs(TerminalEventSpyEventsList.PopulatorIndices)
  do
	local objectiveData = settings.events[data]
	local rowFrame = WINDOW_NAME.."EventsListRow"..row
	
	--[[local idText = L"ID #"..objectiveData.id..L" "
	if (objectiveData.Quest ~= nil) then idText = idText..L"(Active)" end
	LabelSetText(rowFrame.."Details1", idText )
	
	local typeText = L""
	if (objectiveData.isPublicQuest)          then typeText = typeText..L"PQ "   end
	if (objectiveData.isBattlefieldObjective) then typeText = typeText..L"BO "   end
	if (objectiveData.isKeep)                 then typeText = typeText..L"Keep " end
	if (objectiveData.isCityBoss)             then typeText = typeText..L"City " end
	LabelSetText(rowFrame.."Details2", typeText )]]
  end
  
  warExtendedTerminal.EventSpyEventsSetListRowTints()
end

function warExtendedTerminal.EventSpyEventsSetListRowTints()
  local settings = warExtendedTerminal.GetToolbarButtonSettings(WINDOW_NAME)
  for row = 1, TerminalEventSpyEventsList.numVisibleRows
  do
	-- Show the background for every other button
	local color = { ["a"]=1,["r"]=255,["g"]=0,["b"]=0 }
	
	local event = nil
	
	if ( settings.events ~= nil ) then
	  event = settings.events[ ListBoxGetDataIndex(WINDOW_NAME.."EventsList", row) ]
	end
	
	local row_mod = math.mod(row, 2)
	local color = DataUtils.GetAlternatingRowColor( row_mod )
	local targetRowWindow = WINDOW_NAME.."EventsListRow"..row
	
	if (event ~= nil)
	then
	  WindowSetTintColor(targetRowWindow.."Background", color.r, color.g, color.b )
	  WindowSetAlpha(targetRowWindow.."Background", color.a)
	end
  end
end


-----------REGISTER MAIN FUNCTION---------------
function DebugWindow.EventRegister()
  for k, v in pairs(DebugWindow.spyfilter) do
	_G["EventDebug_" .. k] = function(...)
	  eve(k .. ": " .. DebugWindow.tableConcat({ ... }, ", ")) end
  end
end

-----------REGISTER EVENT SPY---------------
function DebugWindow.RegisterHandleSpy()
  DebugWindow.EventRegister()
  if next(RegisteredEvents) == nil then
	for k, v in pairs(DebugWindow.spyfilter) do
	  if k ~= "UPDATE_PROCESSED" and k ~= "PLAYER_POSITION_UPDATED" and k ~= "RVR_REWARD_POOLS_UPDATED" then
		RegisteredEvents[k] = v end
	end
  end
end
--------------------CLEAR TABLE ON UNREGISTER--------------------

function DebugWindow.TableClear()
  for k in pairs(RegisteredEvents) do
	RegisteredEvents[k] = nil
  end
end

---------CHECK IF SPYING ON RELUI----------
function DebugWindow.SpyCheck()
  if RegisteredEvents == nil then return end
  if next(RegisteredEvents) ~= nil then
	for k, v in pairs(RegisteredEvents) do
	  _G["EventDebug_" .. k] = function(...)
		eve(k .. ": " .. DebugWindow.tableConcat({ ... }, ", ")) end
	end
  end
  for k, v in pairs(RegisteredEvents) do
	RegisterEventHandler(RegisteredEvents[k], "EventDebug_" .. k)
  end
end

-----------007 SPY -----------------
function DebugWindow.Spy()
  if next(RegisteredEvents) ~= nil then
	pp("You are already spying.")
	return
  end
  DebugWindow.RegisterHandleSpy()
  for k, v in pairs(DebugWindow.spyfilter) do
	if k ~= "UPDATE_PROCESSED" and k ~= "PLAYER_POSITION_UPDATED" and k ~= "RVR_REWARD_POOLS_UPDATED" then
	  RegisteredEvents[k] = v end end
  for k, v in pairs(RegisteredEvents) do
	RegisterEventHandler(RegisteredEvents[k], "EventDebug_" .. k)
  end
  pp(L "Starting Event Spy")
end

----------------007 SPYSTOP------------------
function DebugWindow.SpyStop()
  
  if next(RegisteredEvents) == nil then
	pp("You are not spying anything.")
  elseif RegisteredEvents ~= nil then
	for k, v in pairs(RegisteredEvents) do
	  UnregisterEventHandler(RegisteredEvents[k], "EventDebug_" .. k)
	end
	DebugWindow.TableClear()
	pp(L "Stopping Event Spy")
  end
end

----------ADD TO SPY-------
function spyadd(text)
  local wasFound = false;
  
  for k, v in pairs(DebugWindow.spyfilter) do
	if string.find(k, text) then
	  wasFound = true;
	  if RegisteredEvents[k] == nil then
		RegisteredEvents[k] = v
		DebugWindow.RegisterHandleSpy()
		pp("Adding " .. k .. " to Event Spy.")
		RegisterEventHandler(RegisteredEvents[k], "EventDebug_" .. k)
	  elseif RegisteredEvents[k] ~= nil then
		pp("Already spying on " .. k .. ".")
	  end
	end
  end
  if not wasFound then
	pp("No matching events found.")
  end
end

----------REMOVE FROM EVENT SPY
function spyrem(text)
  for k, v in pairs(DebugWindow.spyfilter) do
	if string.find(k, text) then
	  if RegisteredEvents[k] == nil then pp("You are not spying on " .. k .. " currently.")
	  end
	end
  end
  for k, v in pairs(RegisteredEvents) do
	if string.find(k, text) then
	  if RegisteredEvents[k] ~= nil then
		pp("Removing " .. k .. " from Event Spy.")
		UnregisterEventHandler(RegisteredEvents[k], "EventDebug_" .. k)
		RegisteredEvents[k] = nil
	  end
	end
  end
end
-----LIST OF EVENTS SPIED UPON
function DebugWindow.SpyList()
  if next(RegisteredEvents) == nil then
	pp("You are not spying anything.")
  elseif next(RegisteredEvents) ~= nil then
	pp("Currently spying on:")
	p(RegisteredEvents)
  end
end

---------------------------------
------EVENT LIST---------
function DebugWindow.EventList()
  p(SystemData.Events)
end