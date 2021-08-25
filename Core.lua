if not warExtended then
  warExtended={}
  warExtended.__index = warExtended
end

local EA_ChatWindow = EA_ChatWindow
local string=string
local modules = {}

--TODO:make core item link icons invisible by subbing test from sendchattext
--Register module with object = warExtended.Register(moduleName, hyperlinkName, hyperlinkColor)
--Use object:Print to "[hyperlinkName] text" or object:Warn to "[hyperlinkName] text" in RED color
--If color is nil then GREEN is set as default.

local function getModuleVersion(module)
  local ModuleData = ModulesGetData()

  for Addons=1,#ModuleData do
    local AddonData = ModuleData[Addons]
     if AddonData.name == module then
        return towstring("v."..AddonData.version)
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

local function addToModulesList(moduleName, hyperlinkText, hyperlinkColor)
  local isInModuleTable = modules[moduleName]

  if isInModuleTable then
    return
  end

  modules[moduleName] = {}
  modules[moduleName].version = getModuleVersion(moduleName) or false
  modules[moduleName].hyperlink = getModuleHyperlink(moduleName, hyperlinkText)
  modules[moduleName].warninglink = getModuleHyperlink(moduleName, hyperlinkText, "RED")
end

function warExtended:Print(text)
  local hyperLink = modules[self.moduleName].hyperlink

  text = towstring(text)
  return EA_ChatWindow.Print(hyperLink..text)
end

function warExtended:Warn(text)
  local warnLink = modules[self.moduleName].warnlink

  text = towstring(text)
  return EA_ChatWindow.Print(warnLink..text)
end

function warExtended.Register(moduleName, hyperlinkText, hyperlinkColor)
  local self = setmetatable({}, warExtended);

  self.moduleName = moduleName;
  addToModulesList(moduleName, hyperlinkText, hyperlinkColor)

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

