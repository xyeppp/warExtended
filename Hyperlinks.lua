local warExtended   = warExtended
local WStringSplit  = WStringSplit
local CreateHyperLink = CreateHyperLink
local wstrmatch     = wstring.match
local LINK_TEMPLATE = L"^([%a%d]+%:)(.*)"
local DELIMETER     = L"[%a%d](%:)"

local hyperlinks    = warExtendedSet:New()

local function prepareLinkData(linkData)
    local delimeter = wstrmatch(linkData, DELIMETER)

    if delimeter then
        linkData = WStringSplit(linkData, delimeter)
    end

    return linkData
end

local function onHyperlinkHook(buttonType, linkData, flags, x, y)
    p(linkData)
    p(flags, x, y)
    local linkName, linkData = wstrmatch(linkData, LINK_TEMPLATE)
    p(linkName, linkData)

    if hyperlinks:Has(linkName) then
        local hyperlink = hyperlinks:Get(linkName).onClick

        if hyperlink[buttonType]
        then
            hyperlink[buttonType](prepareLinkData(linkData), flags, x, y)
            return true
        else
            return false
        end
    end
end

function warExtended:RegisterHyperlinks(hyperlinksTable)
    if not self:GetModuleData().hyperlinks then
        self:GetModuleData().hyperlinks = hyperlinksTable
    end

    for hyperlink, hyperlinkData in pairs(hyperlinksTable) do
        if hyperlinks:Has(hyperlink) then
            error("Unable to add "..hyperlink.." - the hyperlink is already registered.")
        else
            hyperlinks:Add(hyperlink, hyperlinkData)
        end
    end
end

    function warExtended:UnregisterHyperlinks()
        local hyperlink = self:GetSelfHyperlinks()

        for hyperlink,_ in pairs(hyperlink) do
            hyperlinks:Remove(hyperlink)
        end

        hyperlink = nil
    end


function warExtended:GetSelfHyperlinks()
    return self:GetModuleData().hyperlinks
end

function warExtended.GetModuleHyperlinks(moduleName)
    return warExtended.modules[moduleName].hyperlinks
end

function warExtended:CreateHyperlink(hyperlinkData, hyperlinkText, hyperlinkColor)
    if self:IsType(hyperlinkColor, "string")  then
        hyperlinkColor = DefaultColor[warExtended:toStringUpper(hyperlinkColor)]
    end

    local moduleHyperlink = CreateHyperLink(hyperlinkData, (L"["..hyperlinkText..L"]"),
            {warExtended:UnpackRGB(hyperlinkColor)}, {} )
    return moduleHyperlink
end

function warExtended:MakeHyperlink(hyperlink, hyperlinkData)
    if hyperlinks:Has(hyperlink) then
        local hlink = hyperlinks:Get(hyperlink)

        if hlink.onCreate then
            local data, text = hlink.onCreate(hyperlinkData)
            p(hyperlink, data, text)
            return self:CreateHyperlink(hyperlink..data, text, hlink.linkColor)
        end
    end
end

--TODO: add mouseover handler onMouseOver
warExtended:AddEventHandler("InitHyperLinkHooks", "CoreInitialized", function()
    local _EA_ChatWindow_OnHyperLinkRButtonUp               = EA_ChatWindow.OnHyperLinkRButtonUp
    local _EA_ChatWindow_OnHyperLinkLButtonUp               = EA_ChatWindow.OnHyperLinkLButtonUp
    local _EA_ChatWindow_OnHyperLinkRButtonUpChatWindowOnly = EA_ChatWindow.OnHyperLinkRButtonUpChatWindowOnly

    EA_ChatWindow.OnHyperLinkLButtonUp                             = function(...)
        if onHyperlinkHook("OnLButtonUp", ...) then
            return
        end

        _EA_ChatWindow_OnHyperLinkLButtonUp(...)
    end

    EA_ChatWindow.OnHyperLinkRButtonUp                             = function(...)
        if onHyperlinkHook("OnRButtonUp", ...) then
            return
        end

        _EA_ChatWindow_OnHyperLinkRButtonUp(...)
    end

    EA_ChatWindow.OnHyperLinkRButtonUpChatWindowOnly               = function(...)
        if onHyperlinkHook("OnRButtonUp", ...) then
            return
        end

        _EA_ChatWindow_OnHyperLinkRButtonUpChatWindowOnly(...)
    end

    EA_ChatWindow.OnHyperLinkMButtonUp          = function(...)
        if onHyperlinkHook("OnMButtonUp", ...) then
            return
        end
    end
end)