local warExtended = warExtended
local warExtendedTerminal = warExtendedTerminal

function warExtendedTerminal.DevPadOnInitialize()
	warExtendedTerminal:RegisterToolbarItem(L"DevPad", L"Quickly create new LUA scripts, define scripts to run on startup.", "TerminalDevPad", 11010)
end