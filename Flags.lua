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

local registeredFlags = {
}

local flagManager = {
}


function warExtended:RegisterFlags(flagCommands)
  local isSlashModuleTableCreated = flagActions[self.mInfo.name]

  if not isSlashModuleTableCreated then
	flagActions[self.mInfo.name] = {}
  end

  flagActions[self.mInfo.name] = flagCommands
end



function warExtended:GetFlagName(flag)
  local flagName = flagNumberToFlagText[flag]
  return flagName
end

function warExtended:IsFlagName(flagName, flag)
  local isFlagName = flagNumberToFlagText[flag] == flagName
  return isFlagName
end

function warExtended:UnregisterFlags()

end


function warExtended:GetFunctionFromFlag(flags, functionType,...)
  local flagText = flagNumberToFlagText[flags]
  local isFlagMatching = flagActions[self.mInfo.name][functionType][flagText]

  if isFlagMatching then
	isFlagMatching(...)
	return isFlagMatching
  end

  return isFlagMatching
end