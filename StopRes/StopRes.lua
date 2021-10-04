warExtendedStopRes = warExtended.Register("warExtended StopRes")
local StopRes = warExtendedStopRes

StopRes.Settings = {
  isRessing=false;
  currentRessurectTarget = ""
}

local ressurectionAbilityIDs = {
	[1598] = "Rune Of Life",
	[1908] = "Gedup!",
	[8248] = "Breath Of Sigmar",
	[8555] = "Tzeentch Shall Remake You",
	[9246] = "Gift Of Life",
	[9558] = "Stand, Coward!"
}

local function getRessingStatus()
  local isRessing = StopRes.Settings.isRessing
  return isRessing
end

local function setRessingStatus(ressingStatus)
  StopRes.Settings.isRessing = ressingStatus
end

local function isRessingAbility(abilityId)
  local isRessingAbility = ressurectionAbilityIDs[abilityId]
  return isRessingAbility
end

local function setRessurectTargetName(targetName)
  StopRes.Settings.currentRessurectTarget = targetName
end

local function getCurrentRessurectTarget()
  local currentRessurectTarget = StopRes.Settings.currentRessurectTarget
  return currentRessurectTarget
end


function StopRes.OnInitialize()
    StopRes:RegisterEvent("player end cast", "warExtendedStopRes.OnEndCast")
    StopRes:RegisterEvent("player begin cast", "warExtendedStopRes.OnBeginCast")
end

function StopRes.OnShutdown()
  StopRes:RegisterEvent("player end cast", "warExtendedStopRes.OnEndCast")
  StopRes:RegisterEvent("player begin cast", "warExtendedStopRes.OnBeginCast")
end


function StopRes.OnUpdateCheckRessurectState()
  local ressurectTarget = getCurrentRessurectTarget()
  local _, currentSelectedTarget, _ = StopRes:GetTargetNames()

  if currentSelectedTarget == ressurectTarget then
	local isTargetRessurected = TargetInfo:UnitHealth("selffriendlytarget") ~= 0

	if isTargetRessurected then
	  CancelSpell()
	end

  end

end



local function registerRessurectUpdate(ressurectTargetName)
  setRessurectTargetName(ressurectTargetName)
  setRessingStatus(true)
  StopRes:RegisterUpdate("warExtendedStopRes.OnUpdateCheckRessurectState")
end

local function unregisterRessurectUpdate()
  setRessurectTargetName(nil)
  setRessingStatus(false)
  StopRes:UnregisterUpdate("warExtendedStopRes.OnUpdateCheckRessurectState")
end


local function setRessingModeStatus(isRessing)

  if isRessing then
	local _, friendlyTarget, _ = StopRes:GetTargetNames()
	registerRessurectUpdate(friendlyTarget)
	return
  end

  unregisterRessurectUpdate()
end

function StopRes.OnBeginCast(abilityId)

  if isRessingAbility(abilityId) then
	setRessingModeStatus(true)
  end

end

function StopRes.OnEndCast()
  local isRessingStatus = getRessingStatus()

  if isRessingStatus then
	setRessingModeStatus()
  end

end
