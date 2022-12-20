local towstring = towstring
local setmetatable = setmetatable
warExtended = {}
warExtended.__index = warExtended

--Register module with object = warExtended.Register(moduleName, hyperlinkName, hyperlinkColor)
--Color uses values from DefaultColor or {r,g,b} table
--Use object:Print to "[hyperlinkName] text" in chosen color or object:Warn to "[hyperlinkName] text" in RED color
--If color is nil then GREEN is set as default.

local function getModuleInfo(moduleName, hyperlinkText, hyperlinkColor)
	local moduleTable = {}
  moduleTable.moduleName = moduleName
  moduleTable.moduleHyperlink = hyperlinkText or "warExt"
  moduleTable.moduleHyperlinkData = moduleTable.moduleHyperlink .. " " .. warExtended.GetAddonVersion(moduleName)
  moduleTable.moduleHyperlinkColor = hyperlinkColor or "GREEN"
	return moduleTable
end

function warExtended.Register(moduleName, hyperlinkText, hyperlinkColor)
	local module = setmetatable(getModuleInfo(moduleName, hyperlinkText, hyperlinkColor), warExtended)
	return module
end

function warExtended.Initialize()
	warExtended:ExtendTable(warExtended, getModuleInfo("warExtended"))
	warExtended:RegisterGameEvent({"all modules initialized"}, "warExtended.InitializeCore")
end

function warExtended.InitializeCore()
	warExtended:TriggerEvent("CoreInitialized")
  
  if warExtendedTerminal ~= nil then
	setmetatable(warExtendedTerminal, warExtended)
  end
end

function warExtended:Print(text, noHyperlink)
	text = towstring(text)

	if noHyperlink then
		EA_ChatWindow.Print(text)
		return
	end

	local hyperLink = warExtended:CreateHyperlink(
		"WAREXT:" .. self.moduleHyperlinkData,
		self.moduleHyperlink,
		self.moduleHyperlinkColor
	)
	EA_ChatWindow.Print(hyperLink .. text)
end

function warExtended:PrintToggle(text, cond)
	local ENABLED = " is enabled."
	local DISABLED = " is disabled."

	local function isToggle(condition)
		if condition then
			return ENABLED
		end
		return DISABLED
	end

	text = towstring(text .. isToggle(cond))
	self:Print(text)
end

function warExtended:Warn(text)
	local warnLink = warExtended:CreateHyperlink("WAREXT:" .. self.moduleHyperlinkData, self.moduleHyperlink, "RED")
	text = towstring(text)

	EA_ChatWindow.Print(warnLink .. text)
end


function warExtended:Alert(text, alertType)
	text = towstring(text)
	alertType = alertType or 0

	AlertTextWindow.AddLine(alertType, text)
end

function warExtended:Send(text, channelType)
	channelType = towstring(warExtended:FormatChannel(channelType))
  	p(text)
	text = towstring(text)
	p(text)
	SendChatText(text, channelType)
end

function warExtended:Script(text)
  return self:Send(L"/script "..text)
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
