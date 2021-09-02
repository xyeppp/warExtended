local warExtended = warExtended
local pairs=pairs
local next=next
local registeredSlashCmds = {}
local registeredSelfSlashCmds = {}

--To create slash commands for modules use the following table format:
--
--slashCommands = {
--  ["command"] = a
--    {
--      ["func"] = yourFunction,
--      ["desc"] = "function description"
--    }
--}
--
--If yourFunction doesn't work do function (...) return yourFunction (...) end
--All arguments get handled via warExt Slash Handler with an argument split on # character
--A nil argument is equivalent to ""


local function getModuleTable(selfSlashCommand)
  local moduleTable = {}

  for moduleName,moduleSlashTable in pairs(registeredSlashCmds) do
    for selfSlash,slashCommands in pairs(moduleSlashTable) do
      if not selfSlashCommand then
        moduleTable[moduleName] = slashCommands
      elseif selfSlashCommand == selfSlash then
        moduleTable[moduleName] = moduleSlashTable
      end
    end
  end

  return moduleTable
end


local function getModuleSlashCommands(selfSlashCommand)
  local moduleTable = getModuleTable(selfSlashCommand)

  for _,moduleData in pairs(moduleTable) do
    local hyperlink = moduleData.hyperlink

    for command, commandData in pairs(moduleData[selfSlashCommand]) do
      local cmd=towstring(command)
      local description = towstring(commandData.desc)
      EA_ChatWindow.Print(hyperlink..L"/"..cmd..L" - "..description)
    end

    if next(moduleTable, _) ~= nil then
      EA_ChatWindow.Print(L"-----------------")
    end

  end
end


local function registerModuleSelfSlash(selfSlashCommand)
  local selfSlashFunction = function () getModuleSlashCommands(selfSlashCommand) end
  LibSlash.RegisterSlashCmd(selfSlashCommand, selfSlashFunction)
end


local function registerSlashCommand(slashCommand)
  local slashHandlerFunction = function (...) warExtended.SlashHandler(slashCommand,...) end
  LibSlash.RegisterSlashCmd(slashCommand, slashHandlerFunction)
end


local function registerModuleSlashCommands(moduleName)

  for selfSlashCommand,slashCommands in pairs(registeredSlashCmds[moduleName]) do
    local isSelfSlashRegistered = registeredSelfSlashCmds[selfSlashCommand]
    if type(slashCommands) ~= "wstring" then
      for slashCommand,_ in pairs(slashCommands) do
        registerSlashCommand(slashCommand)
      end

      if not isSelfSlashRegistered then
        registerModuleSelfSlash(selfSlashCommand)
        registeredSelfSlashCmds[selfSlashCommand] = selfSlashCommand
      end

      return
    end

  end

end


function warExtended:RegisterSlash(slashCommands, selfSlash)
  local isSlashModuleTableCreated = registeredSlashCmds[self.moduleInfo.moduleName]

  if not isSlashModuleTableCreated then
    registeredSlashCmds[self.moduleInfo.moduleName] = {}
  end

  if not registeredSlashCmds[self.moduleInfo.moduleName][selfSlash] then
    registeredSlashCmds[self.moduleInfo.moduleName]["hyperlink"] = self.moduleInfo.hyperlink
    registeredSlashCmds[self.moduleInfo.moduleName][selfSlash] = slashCommands
  end

  registerModuleSlashCommands(self.moduleInfo.moduleName)
end


function warExtended.SlashHandler(cmd,...)
  local moduleTable = getModuleTable()
  local argumentSplit = StringSplit((...), "#")

  for _,commandTable in pairs(moduleTable) do
    for command, commandData in pairs(commandTable) do
      if cmd == command then
        local CommandFunction = commandData.func
        CommandFunction(unpack(argumentSplit))
        return
      end
    end
  end


end
