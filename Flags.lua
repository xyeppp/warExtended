local warExtended = warExtended
local flagActions = {}

local flagNumberToFlagText = {
  [4] = "isShiftPressed",
  [8] = "isCtrlPressed",
  [12] = "isCtrlShiftPressed",
  [32] = "isAltPressed",
  [36] = "isAltShiftPressed",
  [40] = "isCtrlAltPressed",
  [44] = "isCtrlAltShiftPressed"
}


function warExtended:RegisterFlags(flagCommands)
  local isSlashModuleTableCreated = flagActions[self.moduleInfo.moduleName]

  if not isSlashModuleTableCreated then
	flagActions[self.moduleInfo.moduleName] = {}
  end

  flagActions[self.moduleInfo.moduleName] = flagCommands
end



function warExtended:UnregisterFlags()

end


function warExtended:GetFunctionFromFlag(flags, functionType,...)
  local flagText = flagNumberToFlagText[flags]
  local isFlagMatching = flagActions[self.moduleInfo.moduleName][functionType][flagText]

  if isFlagMatching then
	isFlagMatching(...)
	return isFlagMatching
  end

  return isFlagMatching
end