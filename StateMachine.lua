local warExtended = warExtended
local warExtendedLinkedList = warExtendedLinkedList
local STATE_THROTTLE = 0.15

local g = {}

warExtendedTimer = {}
warExtendedTimer.__index = warExtendedTimer


--
-- key can be null (if not null the existed timer with the same key will be replaced)
-- duration is seconds
-- callback: function (timer, data) - should return true if timer must be removed or false if timer must be reset
-- data will be passed to callback (can be null)
--

function warExtendedTimer.New (key, duration, callback, data)
    if not g.isRunning then
        warExtended.StateMachineInitialize ()
    end

    local obj = {}
    setmetatable(obj, warExtendedTimer)

    obj.key = key
    obj.duration = duration
    obj.callback = callback
    obj.data = data

    obj.enabled = true

    if (obj.key) then
        g.timers:Remove(obj.key)
    end
    obj.item = g.timers:Add(obj.key, obj)

    obj:Reset()

    return obj
end

function warExtendedTimer:Remove (key)
    if not g.isRunning then
        return
    end

    if key then
        g.timers:Remove(key)
        else
        g.timers:Remove(self.item)
    end
end

function warExtendedTimer:Reset ()
    self.timeout = warExtended.m_Time + self.duration
end

function warExtendedTimer:_Update ()

    if (warExtended.m_Time >= self.timeout)
    then
        if (self.callback(self, self.data))
        then
            self:Remove()
        else
            self:Reset()
        end
    end
end


--------------------------------------------------------------- Main

function warExtended.StateMachineInitialize ()
    warExtended.stateMachine = g
    g.throttle = STATE_THROTTLE
    g.isRunning = true;

    g.tasks = warExtendedLinkedList.New()
    g.timers = warExtendedLinkedList.New()

    warExtended.m_Time = 0
    warExtended.m_Date = warExtended:GetCurrentDateInSeconds()
    warExtended:RegisterUpdate("warExtended.OnUpdateStateMachine")
end

--------------------------------------------------------------- tasks
function warExtended.GetTask (name)

    local task_item = g.tasks:Get(name)
    if (task_item == nil) then
        return nil
    end

    return task_item.data
end

function warExtended.AddTask (name)
    if not g.isRunning then
        warExtended.StateMachineInitialize ()
    end

    local task_item = g.tasks:Get(name)
    if (task_item) then
        return task_item.data
    end

    local task = {
        name = name,
        actions = warExtendedLinkedList.New()
    }

    task_item = g.tasks:Add(name, task)

    return task
end

--
-- Callback should return true for action to be removed or false for action to stay in queue
--
function warExtended.AddTaskAction (name, callback)
    if not g.isRunning then
        warExtended.StateMachineInitialize ()
    end

    local task = warExtended.AddTask(name)
    task.actions:Add(callback)

    return task
end

function warExtended.RemoveTask (name)

    local task_item = g.tasks:Get(name)
    if (task_item ~= nil)
    then
        g.tasks:Remove(task_item)
    end
end

--------------------------------------------------------------- Update
function warExtended.OnUpdateStateMachine (elapsed)
    -- global time
    warExtended.m_Time = warExtended.m_Time + elapsed

    -- global throttle
    g.throttle = g.throttle - elapsed
    if (g.throttle > 0) then
        return
    end
    p(g.throttle)
    g.throttle = STATE_THROTTLE

    -- global datetime
    warExtended.m_Today = warExtended:GetCurrentDateInSeconds()

    -- run all timers
    local timer_item = g.timers.first
    while (timer_item)
    do
        timer_item.data:_Update()
        timer_item = timer_item.next
    end

    -- run all tasks
    local task_item = g.tasks.first

    while (task_item)
    do


        local task_is_done = true

        local action_item = task_item.data.actions.first

        while (action_item)
        do


            if (action_item.data())
            then

                task_item.data.actions:Remove(action_item)


            else
                task_is_done = false
                break
            end

            action_item = action_item.next
        end

        if (task_is_done)
        then
            g.tasks:Remove(task_item)
        end

        task_item = task_item.next
    end

    if g.timers:Count() == 0 and g.tasks:Count() == 0 then
        warExtended:UnregisterUpdate("warExtended.OnUpdateStateMachine")
        g.isRunning = false
    end
end

--[[machine = {}
machine.__index = machine

local NONE = "none"
local ASYNC = "async"

local function call_handler(handler, params)
    if handler then
        return handler(unpack(params))
    end
end

local function create_transition(name)
    local can, to, from, params

    local function transition(self, ...)
        if self.asyncState == NONE then
            can, to = self:can(name)
            from = self.current
            params = { self, name, from, to, ...}

            if not can then return false end
            self.currentTransitioningEvent = name

            local beforeReturn = call_handler(self["onbefore" .. name], params)
            local leaveReturn = call_handler(self["onleave" .. from], params)

            if beforeReturn == false or leaveReturn == false then
                return false
            end

            self.asyncState = name .. "WaitingOnLeave"

            if leaveReturn ~= ASYNC then
                transition(self, ...)
            end

            return true
        elseif self.asyncState == name .. "WaitingOnLeave" then
            self.current = to

            local enterReturn = call_handler(self["onenter" .. to] or self["on" .. to], params)

            self.asyncState = name .. "WaitingOnEnter"

            if enterReturn ~= ASYNC then
                transition(self, ...)
            end

            return true
        elseif self.asyncState == name .. "WaitingOnEnter" then
            call_handler(self["onafter" .. name] or self["on" .. name], params)
            call_handler(self["onstatechange"], params)
            self.asyncState = NONE
            self.currentTransitioningEvent = nil
            return true
        else
            if string.find(self.asyncState, "WaitingOnLeave") or string.find(self.asyncState, "WaitingOnEnter") then
                self.asyncState = NONE
                transition(self, ...)
                return true
            end
        end

        self.currentTransitioningEvent = nil
        return false
    end

    return transition
end

local function add_to_map(map, event)
    if type(event.from) == 'string' then
        map[event.from] = event.to
    else
        for _, from in ipairs(event.from) do
            map[from] = event.to
        end
    end
end

function machine.create(options)
    assert(options.events)

    local fsm = {}
    setmetatable(fsm, machine)

    fsm.options = options
    fsm.current = options.initial or 'none'
    fsm.asyncState = NONE
    fsm.events = {}

    for _, event in ipairs(options.events or {}) do
        local name = event.name
        fsm[name] = fsm[name] or create_transition(name)
        fsm.events[name] = fsm.events[name] or { map = {} }
        add_to_map(fsm.events[name].map, event)
    end

    for name, callback in pairs(options.callbacks or {}) do
        fsm[name] = callback
    end

    return fsm
end

function machine:is(state)
    return self.current == state
end

function machine:can(e)
    local event = self.events[e]
    local to = event and event.map[self.current] or event.map['*']
    return to ~= nil, to
end

function machine:cannot(e)
    return not self:can(e)
end

function machine:transition(event)
    if self.currentTransitioningEvent == event then
        return self[self.currentTransitioningEvent](self)
    end
end

function machine:cancelTransition(event)
    if self.currentTransitioningEvent == event then
        self.asyncState = NONE
        self.currentTransitioningEvent = nil
    end
end

machine.NONE = NONE
machine.ASYNC = ASYNC


--]]