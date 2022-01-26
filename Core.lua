local towstring     = towstring
warExtended         = {}
warExtended.__index = warExtended

local function getModuleTable(moduleName, hyperlinkText, hyperlinkColor)
  local self     = {}
  self.moduleName      = moduleName
  self.moduleHyperlink = hyperlinkText or "warExt"
  self.moduleHyperlinkData = self.moduleHyperlink.." "..warExtended.GetAddonVersion(moduleName)
  self.moduleHyperlinkColor  = hyperlinkColor or "GREEN"
  return self
end

--Register module with object = warExtended.Register(moduleName, hyperlinkName, hyperlinkColor)
--Color uses values from DefaultColor or {r,g,b} table
--Use object:Print to "[hyperlinkName] text" in chosen color or object:Warn to "[hyperlinkName] text" in RED color
--If color is nil then GREEN is set as default.

function warExtended.Register(moduleName, hyperlinkText, hyperlinkColor)
  local self = setmetatable(getModuleTable(moduleName, hyperlinkText, hyperlinkColor), warExtended);
  warExtended:TriggerEvent("CreateSettingsEntry", moduleName)
  return self
end

function warExtended.Initialize()
  warExtended:ExtendTable (warExtended, getModuleTable("warExtended"))
  warExtended:RegisterEvent("interface reloaded", "warExtended._Initialize")
end

function warExtended._Initialize()
  warExtended:TriggerEvent("CoreInitialized")
end

function warExtended:Print(text, noHyperlink)
  local hyperLink = warExtended:CreateHyperlink("WAREXT:"..self.moduleHyperlinkData, self.moduleHyperlink, self.moduleHyperlinkColor)
  text            = towstring(text)
  
  if noHyperlink then
	hyperLink = L""
  end
  
  EA_ChatWindow.Print(hyperLink .. text)
end

function warExtended:PrintToggle(text, cond)
  local ENABLED  = " is enabled."
  local DISABLED = " is disabled."
  
  local function isToggle (condition)
	if condition then
	  return ENABLED
	end
	return DISABLED
  end
  
  text = towstring(text .. isToggle(cond))
  self:Print(text)
end

function warExtended:Warn(text)
  local warnLink = warExtended:CreateHyperlink("WAREXT:"..self.moduleHyperlinkData, self.moduleHyperlink, "RED")
  text           = towstring(text)
  
  EA_ChatWindow.Print(warnLink .. text)
end

function warExtended:Alert(text, alertType)
  text      = towstring(text)
  alertType = alertType or 0
  
  AlertTextWindow.AddLine(alertType, text)
end

function warExtended:Send(text, channelType)
  channelType = warExtended:FormatChannel(channelType)
  text        = towstring(text)
  channelType = towstring(channelType)
  
  SendChatText(text, channelType)
end

function warExtended:TellPlayer(playerName, text)
  if not playerName and not text then
	return
  end
  
  warExtended:Send("/tell " .. playerName .. " " .. text)
end

function warExtended:InvitePlayer(playerName)
  if not playerName then
	return
  end
  
  warExtended:Send("/invite " .. playerName)
end

