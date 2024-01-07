local TerminalToolbar  = TerminalToolbar
local WINDOW_NAME      = "TerminalSoundPlayer"
local TOOL_NAME        = L"Sound Player"
local TOOL_DESCRIPTION = L"Preview in-game sounds."
local TOOL_ICON        = 00580

local soundList = {}
for soundName, _ in pairs(warExtended.GetSoundList()) do
    soundList[#soundList+1] = soundName
end

TerminalSoundPlayer     = TerminalToolbar:RegisterTool(TOOL_NAME, TOOL_DESCRIPTION, WINDOW_NAME, TOOL_ICON, {
    sounds = soundList
}, nil)