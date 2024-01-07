local TerminalToolbar  = TerminalToolbar
local WINDOW_NAME      = "TerminalDevPad"
local TOOL_NAME        = L"DevPad"
local TOOL_DESCRIPTION = L"A simple Lua text editor to help you design & test on the fly. Supports saving and start-up scripts."
local TOOL_ICON        = 30458

TerminalDevPad     = TerminalToolbar:RegisterTool(TOOL_NAME, TOOL_DESCRIPTION, WINDOW_NAME, TOOL_ICON, {
 },
{
 currentCode = L"",
 currentProject = L"Unnamed",
 savedProjects = {}
 }
)

function TerminalDevPad:GetSavedProjects()
 return self:GetSavedSettings().savedProjects
end

function TerminalDevPad:GetProjectCode(projectName)
 return self:GetSavedSettings().savedProjects[projectName] or L""
end

function TerminalDevPad:GetCurrentProject()
 return self:GetSavedSettings().currentProject
end

function TerminalDevPad:GetCurrentCode()
 return self:GetSavedSettings().currentCode
end

--TODO: include command into TerminalToolbar register

warExtendedTerminal:AddCommand(L"dpad", function () TerminalDevPad:CallActivator() end)
