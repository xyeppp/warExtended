local warExtended = warExtended
local pairs=pairs
local next=next

--slashCommands = {
--  ["command"] = a
--    {
--      ["func"] = yourFunction,
--      ["desc"] = "function description"
--    }
--}
--All arguments get handled via warExt Slash Handler with an argument split on # character

local slashManager = {
  registeredSlash = {},
  
  registerSlash = function(self, moduleTable, slashCommands, selfSlashCommand)
    
    if not self:isSelfSlashRegistered(selfSlashCommand) then
      local selfSlashHandler = function () self:printSlashCommands(moduleTable.name) end
      LibSlash.RegisterSlashCmd(selfSlashCommand, selfSlashHandler)
    end
  
    for command, _ in pairs(slashCommands) do
      local slashHandler = function (...) warExtended.SlashHandler(command,...) end
      LibSlash.RegisterSlashCmd(command, slashHandler)
    end
    
    self.registeredSlash[moduleTable.name] = {
      hyperlink = moduleTable.hyperlink,
      selfSlash = selfSlashCommand,
      commands = slashCommands
    }
  end,
  
  unregisterSlash = function(self, moduleName)
    self.registeredSlash[moduleName] = nil
    
  end,
  
  getModuleSelfSlashCommand = function(self, moduleName)
    return self.registeredSlash[moduleName].selfSlash
  end,
  
  getModuleSlashCommands = function(self, moduleName)
    local moduleCommands = {}
    local commands = self.registeredSlash[moduleName].commands
    for cmd, cmdData in pairs(commands) do
      moduleCommands[cmd] = cmdData.desc
    end
    return moduleCommands
  end,
  
  getAllSlashCommands = function(self)
    local allRegisteredSlashCommands = {}
    for _, moduleData in pairs(self.registeredSlash) do
      for command, description in pairs(moduleData.commands) do
        allRegisteredSlashCommands[command] = description
      end
    end
    return allRegisteredSlashCommands
  end,
  
  getHyperlink = function(self, moduleName)
    return self.registeredSlash[moduleName].hyperlink
  end,
  
  getAllRegisteredSelfSlashCommands = function(self, selfSlash)
    local allSelfSlashCmds = {}
    
    for moduleName, moduleData in pairs(self.registeredSlash) do
      if moduleData.selfSlash == selfSlash then
        allSelfSlashCmds[moduleName] = {}
        for command, description in pairs(moduleData.commands) do
          allSelfSlashCmds[moduleName][command] = description
        end
      end
    end
    
    return allSelfSlashCmds
  end,
  
  isSelfSlashRegistered = function(self, selfSlash)
    for _, moduleData in pairs(self.registeredSlash) do
      if moduleData.selfSlash == selfSlash then
        p("true")
        return true
      end
    end
    return false
  end,
  
  printSlashCommands = function(self, moduleName)
    local selfSlash = self:getModuleSelfSlashCommand(moduleName)
    local slashCommands = self:getAllRegisteredSelfSlashCommands(selfSlash)
    
    for moduleName, moduleCommands in pairs(slashCommands) do
      local hyperlink = tostring(self:getHyperlink(moduleName))
      for cmd, cmdData in pairs(moduleCommands) do
        warExtended:Print(hyperlink.." /"..cmd.." - "..cmdData.desc, true)
      end
      
      if next(slashCommands, moduleName) ~= nil then
        warExtended:Print("-----------------", true)
      end
      
    end
  end
}

function warExtended:RegisterSlash(slashCommands, selfSlash)
  slashManager:registerSlash(self.mInfo, slashCommands, selfSlash)
  warExtendedOptions.AddOptionChildEntry(self.mInfo.name, "Slash Commands", "warExtendedOptionsSlashCommands")
end

function warExtended.SlashHandler(cmd,...)
  local slashCommands = slashManager:getAllSlashCommands()
  local argumentSplit = StringSplit((...), "#")
  local command = slashCommands[cmd]
  command.func(unpack(argumentSplit))
end

function warExtended.GetModuleSlashCommands(moduleName)
  local slashCommands = slashManager:getModuleSlashCommands(moduleName)
  return slashCommands
end

