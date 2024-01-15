local Terminal = warExtendedTerminal
local DebugWindow = {}
local Events = SystemData.Events
local RegisteredEvents = Terminal.Settings.registeredSpyEvents

function Terminal.EventRegister()
    for eventName, _ in pairs(Events) do
        _G["EventDebug_" .. eventName] = function(...)
            eve(eventName .. ": " .. EventTableConcat({ ... }, ", ")) end
    end
end

-----------REGISTER EVENT SPY---------------
function DebugWindow.RegisterHandleSpy()
    Terminal.EventRegister()

    if next(Terminal.Settings.registeredSpyEvents) == nil then
        for k, v in pairs(Events) do
            if k ~= "UPDATE_PROCESSED" and k ~= "PLAYER_POSITION_UPDATED" and k ~= "RVR_REWARD_POOLS_UPDATED" then
                Terminal.Settings.registeredSpyEvents[k] = v end
        end
    end
end
--------------------CLEAR TABLE ON UNREGISTER--------------------

function DebugWindow.TableClear()
    for k in pairs(Terminal.Settings.registeredSpyEvents) do
        Terminal.Settings.registeredSpyEvents[k] = nil
    end
end

---------CHECK IF SPYING ON RELUI----------
function Terminal.OnInitializeEventSpy()
    if Terminal.Settings.registeredSpyEvents == nil then return end
    if next(Terminal.Settings.registeredSpyEvents) ~= nil then
        p("next is not nil")
        for k, v in pairs(Terminal.Settings.registeredSpyEvents) do
            _G["EventDebug_" .. k] = function(...)
                eve(k .. ": " .. EventTableConcat({ ... }, ", ")) end
        end
    end

    for k, v in pairs(Terminal.Settings.registeredSpyEvents) do
        p("registering")
        RegisterEventHandler(v, "EventDebug_" .. k)
    end
end

-----------007 SPY -----------------
function DebugWindow.Spy()
    if next(Terminal.Settings.registeredSpyEvents) ~= nil then
        p("You are already spying.")
        return
    end
    DebugWindow.RegisterHandleSpy()
    for k, v in pairs(Events) do
        if k ~= "UPDATE_PROCESSED" and k ~= "PLAYER_POSITION_UPDATED" and k ~= "RVR_REWARD_POOLS_UPDATED" then
            Terminal.Settings.registeredSpyEvents[k] = v end end
    for k, v in pairs(Terminal.Settings.registeredSpyEvents) do
        RegisterEventHandler(Terminal.Settings.registeredSpyEvents[k], "EventDebug_" .. k)
    end
    warExtendedTerminal.ConsoleLog("Starting Event Spy")
end

----------------007 SPYSTOP------------------
function DebugWindow.SpyStop()

    if next(Terminal.Settings.registeredSpyEvents) == nil then
        p("You are not spying anything.")
    elseif Terminal.Settings.registeredSpyEvents ~= nil then
        for k, v in pairs(Terminal.Settings.registeredSpyEvents) do
            UnregisterEventHandler(Terminal.Settings.registeredSpyEvents[k], "EventDebug_" .. k)
        end
        DebugWindow.TableClear()
        p("Stopping Event Spy")
    end
end

----------ADD TO SPY-------
function spyadd(text)
    local wasFound = false;

    for k, v in pairs(Events) do
        if string.find(k, text) then
            wasFound = true;
            if Terminal.Settings.registeredSpyEvents[k] == nil then
                Terminal.Settings.registeredSpyEvents[k] = v
                DebugWindow.RegisterHandleSpy()
                p("Adding " .. k .. " to Event Spy.")
                RegisterEventHandler(Terminal.Settings.registeredSpyEvents[k], "EventDebug_" .. k)
            elseif Terminal.Settings.registeredSpyEvents[k] ~= nil then
                p("Already spying on " .. k .. ".")
            end
        end
    end
    if not wasFound then
        p("No matching events found.")
    end
end

----------REMOVE FROM EVENT SPY
function spyrem(text)
    for k, v in pairs(Events) do
        if string.find(k, text) then
            if Terminal.Settings.registeredSpyEvents[k] == nil then p("You are not spying on " .. k .. " currently.")
            end
        end
    end
    for k, v in pairs(Terminal.Settings.registeredSpyEvents) do
        if string.find(k, text) then
            if Terminal.Settings.registeredSpyEvents[k] ~= nil then
                p("Removing " .. k .. " from Event Spy.")
                UnregisterEventHandler(Terminal.Settings.registeredSpyEvents[k], "EventDebug_" .. k)
                Terminal.Settings.registeredSpyEvents[k] = nil
            end
        end
    end
end
-----LIST OF EVENTS SPIED UPON
function DebugWindow.SpyList()
    if next(RegisteredEvents) == nil then
        p("You are not spying anything.")
    elseif next(RegisteredEvents) ~= nil then
        p("Currently spying on:")
        p(RegisteredEvents)
    end
end

------EVENT LIST---------
Terminal:AddCommand(L"e", function() p(Events)  end)
Terminal:AddCommand(L"s", DebugWindow.Spy)
Terminal:AddCommand(L"ss", DebugWindow.SpyStop)

