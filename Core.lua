warExtended={}
warExtended.__index = warExtended

local EA_ChatWindow = EA_ChatWindow
local string=string
local SendChatText = SendChatText
local modules = {}

--TODO:make core item link icons invisible by subbing test from sendchattext
--Register module with object = warExtended.Register(moduleName, hyperlinkName, hyperlinkColor)
--Use object:Print to "[hyperlinkName] text" or object:Warn to "[hyperlinkName] text" in RED color
--If color is nil then GREEN is set as default.

local function getModuleVersion(module)
  local ModuleData = ModulesGetData()
  local addonVersion = ""

  for Addons=1,#ModuleData do
    local AddonData = ModuleData[Addons]
     if AddonData.name == module then
       addonVersion = "v."..AddonData.version
     break end
  end
  return towstring(addonVersion)
end

local function getModuleHyperlink(moduleName, hyperlinkText, hyperlinkColor)
  hyperlinkText = hyperlinkText or "warExt"
  hyperlinkColor = hyperlinkColor or "GREEN"

  local HyperlinkData = L"WAREXT:"  ..  towstring(moduleName) ..L" ".. getModuleVersion(moduleName)
  local HyperlinkText = towstring("["..hyperlinkText.."] ")
  local HyperlinkColor = DefaultColor[string.upper(hyperlinkColor)]
  return CreateHyperLink( HyperlinkData, HyperlinkText, {HyperlinkColor.r, HyperlinkColor.g, HyperlinkColor.b}, {} )
end

function warExtended.Register(moduleName, hyperlinkText, hyperlinkColor)

  local self = setmetatable({}, warExtended);

  self.moduleInfo={}
  self.moduleInfo.moduleName = moduleName
  self.moduleInfo.version = getModuleVersion(moduleName) or false
  self.moduleInfo.hyperlink = getModuleHyperlink(moduleName, hyperlinkText, hyperlinkColor)
  self.moduleInfo.warninglink = getModuleHyperlink(moduleName, hyperlinkText, "RED")

  return self
end


function warExtended:RegisterChat(func)
  self:RegisterEvent("chat text arrived", func)
end

function warExtended:Print(text)
  local hyperLink = self.moduleInfo.hyperlink

  text = towstring(text)
  EA_ChatWindow.Print(hyperLink..text)
end

function warExtended:Warn(text)
  local warnLink = self.moduleInfo.warninglink

  text = towstring(text)
  EA_ChatWindow.Print(warnLink..text)
end



function warExtended:Alert(text, alertType)
  alertType = alertType or 1
  AlertTextWindow.AddLine (alertType, towstring(text))
end

function warExtended:TellPlayer(playerName, text)
  if not playerName and not text then return end
  SendChatText(L"/tell "..towstring(playerName)..L" "..towstring(text), L"")
end

function warExtended:InvitePlayer(playerName)
  if not playerName then return end
  SendChatText(L"/invite "..towstring(playerName), L"")
end

function warExtended:Send(text, channelType)
  channelType = warExtended:FormatChannel(channelType) or ""
  SendChatText(towstring(text), towstring(channelType))
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
