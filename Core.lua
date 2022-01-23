local WAREXT = "warExtended"
local towstring = towstring
warExtended = {}
warExtended.__index = warExtended

--TODO: miraclegrow ligt remix GameData.Player.Cultivation.CurrentPlot = realplot and WindowSetGameAction from warTriage
--TODO: mini war report
--hook Macro stuff on Core from GatherButton to look for currentmacro getactionbar from macro id

--Register module with object = warExtended.Register(moduleName, hyperlinkName, hyperlinkColor)
--Use object:Print to "[hyperlinkName] text" in chosen color or object:Warn to "[hyperlinkName] text" in RED color
--If color is nil then GREEN is set as default. (use values from DefaultColor)

local function getModuleTable(moduleName, hyperlinkText, hyperlinkColor)
  local moduleTable = {}
  moduleTable.name = moduleName
  moduleTable.hyperlink = warExtended.RegisterAddonHyperlink(moduleName, hyperlinkText, hyperlinkColor)
  moduleTable.warnlink = warExtended.RegisterAddonHyperlink(moduleName, hyperlinkText, "RED")
  return moduleTable
end

function warExtended.Register(moduleName, hyperlinkText, hyperlinkColor)
  if not warExtended.mInfo then
    warExtended.mInfo = getModuleTable(WAREXT, nil, nil)
    warExtendedOptions.AddOptionEntry(warExtended.mInfo.name)
  end
  
  local self = setmetatable({}, warExtended);
  self.mInfo = getModuleTable(moduleName, hyperlinkText, hyperlinkColor)
  warExtendedOptions.AddOptionEntry(moduleName)
  return self
  end

function warExtended:Print(text, noHyperlink)
  local hyperLink = self.mInfo.hyperlink
  text = towstring(text)
  
  if noHyperlink then
    hyperLink = L""
  end
  
  EA_ChatWindow.Print(hyperLink..text)
end

function warExtended:PrintToggle(text, cond)
  local ENABLED = "enabled."
  local DISABLED = "disabled."
  
  local function isToggle ( condition )
    if condition then
      return ENABLED
    end
    return DISABLED
  end
  
  text = towstring(text..isToggle(cond))
  self:Print(text)
end


function warExtended:Warn(text)
  local warnLink = self.mInfo.warnlink
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

