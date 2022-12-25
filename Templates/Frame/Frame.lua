local warExtended                      = warExtended
local Frame                            = Frame
local WindowRegisterCoreEventHandler   = WindowRegisterCoreEventHandler
local WindowUnregisterCoreEventHandler = WindowUnregisterCoreEventHandler
local WindowRegisterEventHandler       = WindowRegisterEventHandler
local WindowUnregisterEventHandler     = WindowUnregisterEventHandler
local TextLogGetUpdateEventId		   = TextLogGetUpdateEventId
local type = type

function Frame:SetTextLogScript(textLog, func)
  self:SetScript(TextLogGetUpdateEventId(textLog), func)
end

function Frame:SetTextLogScripts(textLogs, ...)
  p(arg)
  p(arg[n])
  local args = {...}
  for event=1,#textLogs do
	for func = 1, #args do
	  self:SetTextLogScript(textLogs[event], args[func])
	end
  end
end

function Frame:SetScript(event, func)
  local GameEvent = warExtended:GetGameEvent(event) or type(event) == "number"
  
  if func then
	if GameEvent then
	  WindowRegisterEventHandler(self:GetName(), GameEvent, func)
	else
	  WindowRegisterCoreEventHandler(self:GetName(), event, func)
	end
	return
  end
  
  if GameEvent then
	WindowUnregisterEventHandler(self:GetName(), GameEvent)
  else
	WindowUnregisterCoreEventHandler(self:GetName(), event)
  end
end

function Frame:SetScripts(events, ...)
 -- local arg=select(1,...)
  for event=1,#events do
	local arg=select(1,...)
	  self:SetScript(events[event], arg)
	end
end

function Frame:SetId(id)
  self.m_Id = id
end

function Frame:SetHandleInput(doesHandleInput)
  WindowSetHandleInput(self:GetName(), doesHandleInput)
end

function Frame:OnScrollPosChanged (scrollPos)            end
function Frame:OnShown ()            end
function Frame:OnHidden ()            end
function Frame:OnMouseDrag ()            end

