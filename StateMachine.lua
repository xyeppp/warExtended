--[[register OnUpdate function self:RegisterOnUpdate(whatever)
self:UnregisterOnUpdate(whatever)]]

local warExtended = warExtended


local function delayLooper(timeElapsed, delay, func)

  -- p(timeElapsed)
  -- p(timeDelay)
  local timeDelay = 0.07
local timer=0
timer = timer + timeElapsed

   if timer >= timeDelay then
      timer=0
      return true
   else
      return false
   end
end
gee = {}
local g = gee
  g.timers={}
  g.testcond=false;


local delayTimer=0.07
local craftDelay = 0.25

local craftCounter = 0

function warExtended:TestPrint()
   p("test printer")
end

function warExtended:Test()
   if not self.timers then
      self.timers={}
   end
   p(self.timers)
end

 --gee = {}


function warExtended:Tester2(arg1, arg2)
    p(arg1)
    p(arg2)
end


function warExtended:Not(func, delay, condition, ...)
   p(func)
   local args = {...}
   if not self.timers[func] then
      self.timers[func]= {["delay"] = delay,
                        ["args"] = args,
                        ["condition"] = condition,
                          ["counter"] = 0}
   end
   if not g.timers[func] then
      g.timers[func] = {["delay"] = delay,
                        ["args"] = args,
                        ["condition"] = condition,
                        ["counter"] = 0}
   end
   p(self.timers[func])
   p(g.timers[func])
end



function warExtended:TestUpdate()
   p("yes")
end


local throttle = 0.25
local t=0.25
local time = 0


function warExtended.Updater(timeElapsed)
   throttle = throttle - timeElapsed
   if throttle > 0 then return else
      p("not 0")
      throttle=t
   end
end

local function UnregisterTimer(func)
  g.timers[func] = nil
end

local function UnregisterSelf()
  if next(g.timers) ~= nil then g.timers={}
    UnregisterEventHandler(SystemData.Events.UPDATE_PROCESSED, "warExtended.RegisterUpdate")
  end
end

local counter=0

--[[function warExtended.RegisterUpdate(timeElapsed)

  if next(g.timers) == nil then p("unregistering") return UnregisterSelf() end

   for func,delay in pairs(g.timers) do
    delay.counter=delay.counter + timeElapsed
      if delay.condition ~= nil then
        if delay.condition then
          if delay.counter >= delay.delay then
            func(unpack(delay.args))
            delay.counter=0
          end
        else return end
      else
        if delay.counter >= delay.delay then
            func(unpack(delay.args))
         delay.counter=0
       end
   end
end
end]]

function warExtended.Registrator()
   --craftCounter=
   --for k,v in pairs(g.timers) do

end

--[[

warExtended:RegisterUpdate(func, delay)

      self.timers={}
      self.timers.func=delay

end
]]





function warExtended.RegisterDelay(timeElapsed)
   local lastupdate=timeElapsed
   local throttle = 0.02
   craftCounter=craftCounter+timeElapsed
            if craftCounter >= craftDelay  then
               craftCounter=0
        return warExtended:Test()
      end


  --if delayLooper(timeElapsed) then
   --   return p("true")
  -- else return
     -- p("false")
   --end
  -- p(timeElapsed)
end

function warExtended:AllJoin()
   p("all joing")
end

function warExtended:AllJoin2()
   p("all joingGBBG")
end


local isStateRunning = false
local SEND_BEGIN = 1
local SEND_FINISH = 2
local SEND_END = 3
warExtended.TIMER = 0.15
warExtended.TIMER2 = 0.30
warExtended.stateMachineName = "ItemStack"
warExtended.state = {[SEND_BEGIN] = { handler=nil,time=warExtended.TIMER,nextState=SEND_FINISH } , [SEND_FINISH] = { handler=warExtended.AllJoin,time=warExtended.TIMER,nextState=SEND_END, } ,[SEND_END] = { handler=warExtended.AllJoin2,time=warExtended.TIMER2,nextState=SEND_BEGIN } }
isStateRunning = false

function warExtended:RegisterUpdater()
   local stateMachine = TimedStateMachine.New( warExtended.state,SEND_BEGIN)
	TimedStateMachineManager.AddStateMachine( warExtended.stateMachineName, stateMachine )
end

function warExtended:PauseMachine()
  local stateMachine = warExtended.state
  TimedStateMachine.Pause( stateMachine )
end
