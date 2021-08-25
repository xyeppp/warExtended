if not warExtended then
  warExtended={}
end

local EA_ChatWindow = EA_ChatWindow
local pairs=pairs
local ipairs=ipairs
local string=string
local modules = {}

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
  local HyperlinkColor = DefaultColor[string.upper(hyperlinkColor)]
    return CreateHyperLink( HyperlinkData, HyperlinkText, {HyperlinkColor.r, HyperlinkColor.g, HyperlinkColor.b}, {} )
end

function warExtended:Print(text)
  text = towstring(text)
  return EA_ChatWindow.Print(self.module.hyperlink..text)
end

function warExtended:Warn(text)
  text = towstring(text)
  return EA_ChatWindow.Print(self.module.warnlink..text)
end

function warExtended.Register(moduleName, hyperlinkText, hyperlinkColor)
  local self = setmetatable({}, warExtended);

  self.module = {};
  self.module.name = moduleName;
  self.module.hyperlinkText = hyperlinkText
  self.module.version = getModuleVersion(moduleName);
  self.module.warnlink = getModuleHyperlink(moduleName, hyperlinkText, "RED") ;
  self.module.hyperlink = getModuleHyperlink(moduleName, hyperlinkText) ;
  self.module.cmd = false;

  return self
end


local function isLastWhisperPresent()
  local lastWhisperPlayer = ChatManager.LastTell.name ~= L""
  return lastWhisperPlayer
end

function TellTarget(text)
  local _, FriendlyTargetName = warExtended:GetTargetNames()
  if FriendlyTargetName then
    SendChatText(L"/tell "..FriendlyTargetName..L" "..towstring(text), L"")
  end
end

function ReplyLastWhisper(text)
  if isLastWhisperPresent() then
    SendChatText(L"/tell "..ChatManager.LastTell.name..L" "..towstring(text), L"")
  end
end

function InviteLastWhisper()
  if isLastWhisperPresent() then
    SendChatText(L"/invite "..ChatManager.LastTell.name, L"")
  end
end

