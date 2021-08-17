local warExtended = warExtended
local pairs=pairs

local function getSlashCommands()
  for Module,_ in pairs(warExtended.Modules) do
    local ModuleHyperlink = warExtended.Modules[Module]["hyperlink"]
    for Command,_ in pairs(warExtended.Modules[Module]["cmd"]) do
      local CommandDescription = warExtended.Modules[Module]["cmd"][Command]["description"]
      EA_ChatWindow.Print(ModuleHyperlink..L"/"..towstring(Command)..L" - "..CommandDescription)
    end
    EA_ChatWindow.Print(L"-----------------")
  end
end

local slashCommands = {

  ["warext"] = {
    ["function"] = function() return getSlashCommands() end,
    ["description"] = L"Prints this menu."
  }
}


function warExtended.RegisterCoreAndSlashCmd()

  warExtended.RegisterModule("Core", slashCommands)

  local ModuleHyperlink = warExtended.Modules["Core"]["hyperlink"]
  local CoreVersionNumber = warExtended.Modules["Core"]["version"]
  EA_ChatWindow.Print(ModuleHyperlink..CoreVersionNumber..L" loaded. /warext for help.")

end
