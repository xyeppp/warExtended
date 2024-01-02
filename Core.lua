local towstring = towstring
local setmetatable = setmetatable

warExtended = {
    modules = {}
}

warExtended.__index = warExtended

--Register module with object = warExtended.Register(moduleName, hyperlinkName, hyperlinkColor)
--Color uses values from DefaultColor or {r,g,b} table
--Use object:Print to "[hyperlinkName] text" in chosen color or object:Warn to "[hyperlinkName] text" in RED color
--If color is nil then GREEN is set as default.

local function getModuleInfo(moduleName, hyperlinkText, hyperlinkColor)
    local moduleTable = {}

    moduleTable.moduleName = moduleName
    moduleTable.moduleHyperlink = warExtended:toWString(hyperlinkText) or L"warExt"
    moduleTable.moduleHyperlinkData = warExtended:toWString(moduleName) .. L" " .. warExtended:toWString(warExtended.GetAddonVersion(moduleName))
    moduleTable.moduleHyperlinkColor = hyperlinkColor or "GREEN"
    return moduleTable
end

function warExtended.Register(moduleName, hyperlinkText, hyperlinkColor)
    local module = setmetatable(getModuleInfo(moduleName, hyperlinkText, hyperlinkColor), warExtended)
    warExtended.modules[moduleName] = {}

    warExtended._Settings.modules[moduleName] = {}
    warExtended._Settings.AddEntry(towstring(moduleName))

    return module
end

function warExtended:GetModuleData()
    return self.modules[self.moduleName]
end

function warExtended.Initialize()
    warExtended:ExtendTable(warExtended, getModuleInfo("warExtended"))
    warExtended:RegisterGameEvent({ "all modules initialized" }, "warExtended.InitializeCore")
end

function warExtended.InitializeCore()
    p("initializing core after all modules init")
    warExtended:TriggerEvent("CoreInitialized")
end

function warExtended:Print(text, noHyperlink)
    text = towstring(text)

    if noHyperlink then
        EA_ChatWindow.Print(text)
        return
    end

    local hyperLink = warExtended:CreateHyperlink(
            L"WAREXT:" .. self.moduleHyperlinkData,
            self.moduleHyperlink,
            self.moduleHyperlinkColor
    )
    EA_ChatWindow.Print(hyperLink .. text)
end

function warExtended:PrintToggle(text, cond)
    local ENABLED = L" set to enabled."
    local DISABLED = L" set to disabled."

    local function isToggle(condition)
        if condition then
            return ENABLED
        end
        return DISABLED
    end

    text = text .. isToggle(cond)
    return text
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
    text = towstring(text)

    SendChatText(text, channelType)
end

function warExtended:Script(text)
    return self:Send(L"/script " .. text)
end

function warExtended:TellPlayer(playerName, text)
    if not playerName and not text then
        return
    end

    text=towstring(text)

    warExtended:Send(L"/tell " .. playerName .. L" " .. text)
end

function warExtended:InvitePlayer(playerName)
    if not playerName then
        return
    end

    warExtended:Send("/invite " .. playerName)
end