local warExtended = warExtended
local RegisterEventHandler = RegisterEventHandler
local UnregisterEventHandler = UnregisterEventHandler
local TextLogGetUpdateEventId = TextLogGetUpdateEventId
local BroadcastEvent = BroadcastEvent
local Events = SystemData.Events

local function fixString(str)
    str = warExtended:toStringOrEmpty(str)
    str = warExtended:toStringUpper(str)
    str = str:gsub("%s", "_")
    return str
end

function warExtended:GetGameEvent(event)
    if self:IsType(event, "number") then
        return event
    else
        event = fixString(event)
        return Events[event]
    end
end


function warExtended:Broadcast(event)
    event = self:GetGameEvent(event)

    if not event then
        return
    end

    BroadcastEvent(event)
end

function warExtended:RegisterUpdate(...)
    self:RegisterGameEvent({"update processed"}, ...)
end

function warExtended:UnregisterUpdate(...)
    self:UnregisterGameEvent({"update processed"}, ...)
end

function warExtended:RegisterGameEvent(eventsTable, ...)
    local args={...}
    for event=1,#eventsTable do
        event = self:GetGameEvent(eventsTable[event])

        for func = 1, #args do
            RegisterEventHandler(event, args[func])
        end
    end
end


function warExtended:UnregisterGameEvent(eventsTable, ...)
    local args={...}
    for event=1,#eventsTable do
        event = self:GetGameEvent(eventsTable[event])

        for func = 1, #args do
            UnregisterEventHandler(event, args[func])
        end
    end
end

function warExtended:RegisterTextLogEvent(textLog, ...)
    textLog=self:Capitalize(textLog)
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

function warExtended:GetTextLogUpdateEventId(textLog)
    local textLogUpdateEventId = TextLogGetUpdateEventId(textLog)
    return textLogUpdateEventId
end