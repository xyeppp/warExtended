local warExtended  = warExtended
local flagIds      = SystemData.ButtonFlags

local flagText = {
  ["SHIFT"] = flagIds.SHIFT,
  ["CTRL"] = flagIds.CONTROL,
  ["CTRL+SHIFT"] = flagIds.CONTROL + flagIds.SHIFT,
  ["ALT"] = flagIds.ALT,
  ["ALT+SHIFT"] = flagIds.ALT + flagIds.SHIFT,
  ["CTRL+ALT"] = flagIds.CONTROL + flagIds.ALT,
  ["CTRL+ALT+SHIFT"] = flagIds.CONTROL + flagIds.ALT + flagIds.SHIFT
}

function warExtended:GetFlag(flagName)
 return flagText[flagName]
 end

function warExtended:IsFlagPressed(flagName, flags)
  return flagText[flagName] == flags
end

function warExtended:IsShiftPressed (flags)
  return (flags == flagText["SHIFT"] or
  flags == flagText["CTRL+SHIFT"] or
  flags == flagText["ALT+SHIFT"] or
  flags == flagText["CTRL+ALT+SHIFT"])
end


function warExtended:IsControlPressed (flags)
  return (flags == flagText["CTRL"] or
		  flags == flagText["CTRL+SHIFT"] or
		  flags == flagText["CTRL+ALT"] or
		  flags == flagText["CTRL+ALT+SHIFT"])
end

function warExtended:IsAltPressed (flags)
  return (flags == flagText["ALT"] or
  flags == flagText["ALT+SHIFT"] or
  flags == flagText["CTRL+ALT"] or
  flags == flagText["CTRL+ALT+SHIFT"])
end