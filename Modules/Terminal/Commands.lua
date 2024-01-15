local Terminal = warExtendedTerminal

local function printGuildId()
    p("Your Guild ID is: " .. tostring(GameData.Guild.m_GuildID))
end

local function toggleCombatLog()
    local state = not TextLogGetEnabled("Combat")
    local toggleText = warExtended:PrintToggle("Combat log", state)
    p(toggleText)
    TextLogSetEnabled("Combat", state)
end

local function scJoin()
    p("Attempting to join a scenario.")
    warExtended:BroadcastEvent("scenario instance join now")
end

local function scGroup()
        p("Toggling Scenario Groups Window.")
        WindowSetShowing("ScenarioGroupWindow", not WindowGetShowing("ScenarioGroupWindow"))
end

local function getRegisteredFunctions()
    local registeredfunctionlist = {}
    for i, v in pairs(_G) do
        if type(v) == "function" then
            registeredfunctionlist[i] = v
        end
    end
    table.sort(registeredfunctionlist)
    p(registeredfunctionlist)
end

local function getKeepIds()
    local keepIds = warExtended:GetConstants("keepIds")
    p(keepIds)
end

local function getFontList()
    local fonts = warExtended:GetConstants("fonts")
    p(fonts)
end

local commands = {
    [L"r"] = InterfaceCore.ReloadUI,
    [L"guildid"] = printGuildId,
    [L"clog"]  = toggleCombatLog,
    [L"scjoin"]  = scJoin,
    [L"scgroup"]  = scGroup,
    [L"regfun"]  = getRegisteredFunctions,
    [L"keepid"]  = getKeepIds,
    [L"fontlist"]  = getFontList,
}

local function addInputAndScrollToBottom()
    inp(TextEditBoxGetText("DebugWindowTextBox"))
    TextEditBoxSetText(SystemData.ActiveWindow.name, L"")

    Terminal.LogDisplayScrollToBottom()
end

function Terminal:AddCommand(cmd, callback)
    if not commands[cmd] then
        commands[cmd] = callback
    else
        error("Unable to add command - name is already registered.")
    end
end

function Terminal:GetCommand(cmd)
    return commands[cmd]
end


function Terminal.TextBoxOnKeyEnterTextSend()
    text = TextEditBoxGetText(SystemData.ActiveWindow.name)
    local cmd = Terminal:GetCommand(text)

    addInputAndScrollToBottom()

    if cmd then
        cmd()
    else
        warExtended:Script(text)
    end
end

function Terminal.TextBoxOnTextChanged(text)
    if not warExtendedTerminal.Settings.autoCommands then
        return
    end

    local cmd = Terminal:GetCommand(text)
    if cmd then
        addInputAndScrollToBottom()
         cmd()
    end
end




