local warExtended = warExtended
local pairs=pairs
local slash = {}

--To create slash commands for modules use the following table format:
--
--slashCommands = {
--  ["command"] = a
--    {
--      ["function"] = yourFunction,
--      ["description"] = c
--    }
--}
--
--If yourFunction doesn't work do function (...) return yourFunction (...) end
--All arguments get handled via warExt Slash Handler with an argument split on # character
--A nil argument is equivalent to ""

local function getSlashCommands()
  for Module,_ in pairs(warExtended.Modules) do
      for Command,_ in pairs(warExtended.Modules[Module]["cmd"]) do
        local CommandDescription = warExtended.Modules[Module]["cmd"][Command]["description"]
           --warExtended.ModuleChatPrint(Module, "/"..(Command).." - "..CommandDescription)
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

--[[local function getModuleSelfSlashCommands(module)

  for Command,_ in pairs(warExtended.Modules[module]["cmd"]) do
     local CommandDescription = warExtended.Modules[module]["cmd"][Command]["description"]
     warExtended.ModuleChatPrint(module, "/"..Command.." - "..CommandDescription)
  end

end

local function registerModuleSlashCommands(module)

  for Command,_ in pairs(warExtended.Modules[module]["cmd"]) do
      LibSlash.RegisterSlashCmd(Command, function (...) warExtended.SlashHandler(Command,...) end)
    end

  end

  local function registerModuleSelfSlash(module)
    local selfSlash = "warExtended"..module
    local selfSlashFunction = function () return getModuleSelfSlashCommands(module) end

    LibSlash.RegisterSlashCmd(selfSlash, selfSlashFunction)

  end]]


function warExtended:GetSelfSlash(moduleName)

end


function warExtended:RegisterSlash(slashCommands, selfSlash)
  if not slash[self.moduleName] then
    slash[self.moduleName] = slashCommands
  end

  --self.module.cmd = true

end

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

 --warExtended.ModuleRegister("Core", slashCommands)

  local CoreVersionNumber = warExtended.Modules["Core"]["version"]
 -- warExtended.ModuleChatPrint("Core", CoreVersionNumber..L" loaded. /warext for help.")

end
