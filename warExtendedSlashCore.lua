local warExtended = warExtended
local pairs=pairs

local function getSlashCommands()
  for Module,_ in pairs(warExtended.Modules) do
      for Command,_ in pairs(warExtended.Modules[Module]["cmd"]) do
        local CommandDescription = warExtended.Modules[Module]["cmd"][Command]["description"]
           warExtended.ModuleChatPrint(Module, "/"..(Command).." - "..CommandDescription)
      end
    EA_ChatWindow.Print(L"-----------------")
  end
end

local slashCommands = {

  ["warext"] = {
    ["function"] = getSlashCommands,
    ["description"] = "Prints this menu."
  }
}

function warExtended.SlashHandler(cmd,...)

  for Module,_ in pairs(warExtended.Modules) do
      for Command,_ in pairs(warExtended.Modules[Module]["cmd"]) do
        if cmd == Command then
          local CommandFunction = warExtended.Modules[Module]["cmd"][Command]["function"]
          local argumentsSplit =  StringSplit((...), "#")
              return  CommandFunction(unpack(argumentsSplit))
          end
      end
  end
end


function warExtended.RegisterSlashCore()

  warExtended.ModuleRegister("Core", slashCommands)

  local CoreVersionNumber = warExtended.Modules["Core"]["version"]
  warExtended.ModuleChatPrint("Core", CoreVersionNumber..L" loaded. /warext for help.")

end
