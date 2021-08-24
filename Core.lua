if not warExtended then
  warExtended={}
end

local EA_ChatWindow = EA_ChatWindow
local pairs=pairs
local ipairs=ipairs
local string=string
local events = {}

--TODO:make core item link icons invisible by subbing test from sendchattext
--To create slash commands for modules use the following table format:
--
--slashCommands = {
--  ["command"] = a
--    {
--      ["function"] = yourFunction,
--      ["description"] = c
--    }
--}
--
--If yourFunction doesn't work do function (...) return yourFunction (...) end
--All arguments get handled via warExt Slash Handler with an argument split on # character
--A nil argument is equivalent to ""
--Register module with object = warExtended.Register(moduleName, hyperlinkName, hyperlinkColor)
--Use object:Print to "[hyperlinkName] text"

warExtended.__index = warExtended

local function setStringToUpperCaseAndSubSpace(str)
  local str = string.upper(str)
  return str:gsub("%s", "_")
end

local function getModuleVersion(module)
  local Addons = ModulesGetData()
  local moduleName = module

  for _, moduleData in ipairs(Addons) do
    if moduleData.name == moduleName then
      return towstring("v"..moduleData.version)
    end
  end
end

local function getModuleHyperlink(moduleName, hyperlinkText, hyperlinkColor)
  hyperlinkText = hyperlinkText or "warExt"
  hyperlinkColor = hyperlinkColor or "GREEN"

  local HyperlinkData = L"WAREXT:"  ..  towstring(moduleName) ..L" ".. getModuleVersion(moduleName)
  local HyperlinkText = towstring("["..hyperlinkText.."] ")
  local HyperlinkColor = DefaultColor[setStringToUpperCaseAndSubSpace(hyperlinkColor)]
    return CreateHyperLink( HyperlinkData, HyperlinkText, {HyperlinkColor.r, HyperlinkColor.g, HyperlinkColor.b}, {} )
end

function warExtended:Print(text)
  text = towstring(text)
  return EA_ChatWindow.Print(self.module.hyperlink..text)
end


function warExtended.TestPrint()
  p("test")
end


local function isValidEvent(event)
  local doesEventExist = true == SystemData.Events[event] or false == not SystemData.Events[event]

  if not doesEventExist then
    d("Invalid event name. Event "..event.." does not exist.")
  end

  return doesEventExist
end

function warExtended:EventRegister(eventName, func)
  local event = setStringToUpperCaseAndSubSpace(eventName)
  if not isValidEvent(event) then return end

  if not self.module.events[event] then
    self.module.events[event] = {}
  end

 if not self.module.events[event][func] then
    self.module.events[event][func] = {}
    self.module.events[event][func] = func
    RegisterEventHandler(SystemData.Events[event], func)
  else
    return d("Function "..func.." is already registered to event "..event)
  end
end

function warExtended:EventUnregister(eventName, func)
  local event = setStringToUpperCaseAndSubSpace(eventName)
  if not isValidEvent(event) then return end

  if self.module.events[event][func] ~= nil then
    UnregisterEventHandler(SystemData.Events[event], func)
    self.module.events[event][func] = nil
  else
    return d("Function "..func.." is not registered to event "..event)
  end

end

function warExtended:EventUnregisterAll(eventName)
  local event = setStringToUpperCaseAndSubSpace(eventName)
  if not isValidEvent(event) then return end


  if (self.module.events[event]) then
    for RegisteredFunction,_ in pairs(self.module.events[event]) do
      p("unregistering "..RegisteredFunction.." from "..event)
      UnregisterEventHandler(SystemData.Events[event], RegisteredFunction)
    end
    self.module.events[event] = nil
  else
    return d("There are no functions registered to event "..event)
  end

end


function warExtended:Reloader()
  p("reloaderrr")
end


function warExtended.Register(moduleName, hyperlinkText, hyperlinkColor)

  local self = setmetatable({}, warExtended);

  self.module = {};
  self.module.name = moduleName;
  self.module.hyperlinkText = hyperlinkText
  self.module.version = getModuleVersion(moduleName);
  self.module.hyperlink = getModuleHyperlink(moduleName, hyperlinkText, hyperlinkColor) ;
  self.module.cmd = false;
  self.module.events = {};
  self.module.hooks = {};

  return self
end




function warExtended:GetTargetNames()
  local FriendlyTargetName     = TargetInfo:UnitName('selffriendlytarget'):match(L"([^^]+)^?[^^]*") or false
  local HostileTargetName      = TargetInfo:UnitName('selfhostiletarget'):match(L"([^^]+)^?[^^]*") or false
  local MouseoverTargetName    = TargetInfo:UnitName('mouseovertarget'):match(L"([^^]+)^?[^^]*") or false
  return HostileTargetName, FriendlyTargetName, MouseoverTargetName
end


--- Define new global functions
function ChatMacro(text,channel)
  text = towstring(text)
  channel = towstring(channel)

  --textFilter(text)

  local enemyTarget = TargetInfo:UnitName("selfhostiletarget"):match(L"([^^]+)^?[^^]*")
  local friendTarget = TargetInfo:UnitName("selffriendlytarget"):match(L"([^^]+)^?[^^]*")
  local mouseTarget = TargetInfo:UnitName("mouseovertarget"):match(L"([^^]+)^?[^^]*")

  text = text:gsub(L"%$et", enemyTarget or L"<no target>")
  text = text:gsub(L"%$ft", friendTarget or L"<no target>")
  text = text:gsub(L"%$mt", mouseTarget or L"<no target>")

  SendChatText(text, channel)
end

function TellTarget(text)
  local target = (TargetInfo:UnitName("selffriendlytarget"))
  if target == L"" then return end
  SendChatText(L"/tell "..target..L" "..towstring(text), L"")
end

function ReplyLastWhisper(text)
  local lastWhisperPlayer = ChatManager.LastTell.name
  if lastWhisperPlayer == L"" then return end
  SendChatText(L"/tell "..lastWhisperPlayer..L" "..towstring(text), L"")
end

function InviteLastWhisper()
  local lastWhisperPlayer = ChatManager.LastTell.name
  if lastWhisperPlayer == L"" then return end
  SendChatText(L"/invite "..lastWhisperPlayer, L"")
end
