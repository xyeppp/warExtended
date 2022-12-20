local warExtended  = warExtended
--local flagIds      = SystemData.ButtonFlags

local flagIds      = {
  ["SHIFT"] = 4,
  ["CTRL"] = 8,
  ["CTRL + SHIFT"] = 12,
  ["ALT"] = 32,
  ["ALT + SHIFT"] = 36,
  ["CTRL + ALT"] = 40,
  ["CTRL + ALT + SHIFT"] = 44,
}

local flagIdToText = {
  [4] = "SHIFT",
  [8] = "CTRL",
  [12] = "CTRL + SHIFT",
  [32] = "ALT",
  [36] = "ALT + SHIFT",
  [40] = "CTRL + ALT",
  [44] = "CTRL + ALT + SHIFT"
}

function warExtended:GetFlagText(flagId)
  local flagText = flagIdToText[flagId]
  return flagText
end

function warExtended:IsFlagText(flagName, flag)
  local isFlagText = flagIdToText[flag] == flagName
  return isFlagText
end

function warExtended:IsShiftPressed (flags)
  return (flags == flagIds["SHIFT"] or flags == flagIds["CTRL + SHIFT"] or flags == flagIds["ALT + SHIFT"] or flags == flagIds["CTRL + ALT + SHIFT"])
end

function warExtended:IsControlPressed (flags)
  return (flags == SystemData.ButtonFlags.CONTROL or
		  flags == SystemData.ButtonFlags.CONTROL + SystemData.ButtonFlags.SHIFT or
		  flags == SystemData.ButtonFlags.CONTROL + SystemData.ButtonFlags.ALT or
		  flags == SystemData.ButtonFlags.CONTROL + SystemData.ButtonFlags.SHIFT + SystemData.ButtonFlags.ALT)
end

function warExtended:IsAltPressed (flags)
  return (flags == SystemData.ButtonFlags.ALT or
		  flags == SystemData.ButtonFlags.ALT + SystemData.ButtonFlags.SHIFT or
		  flags == SystemData.ButtonFlags.ALT + SystemData.ButtonFlags.CONTROL or
		  flags == SystemData.ButtonFlags.ALT + SystemData.ButtonFlags.SHIFT + SystemData.ButtonFlags.CONTROL)
end

