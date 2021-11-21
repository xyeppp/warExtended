warExtended = {}
warExtended.__index = warExtended

--TODO: miraclegrow ligt remix GameData.Player.Cultivation.CurrentPlot = realplot and WindowSetGameAction from warTriage
--hook Macro stuff on Core from GatherButton to look for currentmacro getactionbar from macro id


local SendChatText = SendChatText
local strupper = string.upper
local towstring = towstring

--Register module with object = warExtended.Register(moduleName, hyperlinkName, hyperlinkColor)
--Use object:Print to "[hyperlinkName] text" in chosen color or object:Warn to "[hyperlinkName] text" in RED color
--If color is nil then GREEN is set as default. (use values from DefaultColor)

local function getModuleVersion(moduleName)
  local ModuleData = ModulesGetData()
  local addonVersion = ""

  for Addons=1,#ModuleData do
    local AddonData = ModuleData[Addons]
     if AddonData.name == moduleName then
       addonVersion = "v."..AddonData.version
     break end
  end

  return addonVersion
end

local function getModuleHyperlink(moduleName, version, hyperlinkText, hyperlinkColor)
  hyperlinkText = hyperlinkText or "warExt"
  hyperlinkColor = hyperlinkColor or "GREEN"

  local HyperlinkData = "WAREXT:"  ..  moduleName .." ".. version
  local HyperlinkText = "["..hyperlinkText.."] "
  local HyperlinkColor = DefaultColor[strupper(hyperlinkColor)]
  local moduleHyperlink = CreateHyperLink( towstring(HyperlinkData), towstring(HyperlinkText),
          {HyperlinkColor.r, HyperlinkColor.g, HyperlinkColor.b}, {} )

  return moduleHyperlink
end



function warExtended.Register(moduleName, hyperlinkText, hyperlinkColor)

  local self = setmetatable({}, warExtended);
  local moduleVersion = getModuleVersion(moduleName);

    self.moduleInfo = {
      moduleName = moduleName,
      version = moduleVersion,
      hyperlink =  getModuleHyperlink(moduleName, moduleVersion, hyperlinkText, hyperlinkColor),
      warnlink = getModuleHyperlink(moduleName, moduleVersion, hyperlinkText, "RED"),
    }

  return self
end





function warExtended:Print(text)
  local hyperLink = self.moduleInfo.hyperlink
  text = towstring(text)

  EA_ChatWindow.Print(hyperLink..text)
end


function warExtended:Warn(text)
  local warnLink = self.moduleInfo.warnlink
  text = towstring(text)

  EA_ChatWindow.Print(warnLink..text)
end


function warExtended:Alert(text, alertType)
  text = towstring(text)
  alertType = alertType or 0

  AlertTextWindow.AddLine(alertType, text)
end


function warExtended:Send(text, channelType)
  channelType = warExtended:FormatChannel(channelType)
  text = towstring(text)
  channelType = towstring(channelType)

  SendChatText(text, channelType)
end


function warExtended:TellPlayer(playerName, text)
  if not playerName and not text then
    return
  end

  warExtended:Send("/tell "..playerName.." "..text)
end


function warExtended:InvitePlayer(playerName)
  if not playerName then
    return
  end

  warExtended:Send("/invite "..playerName)
end

