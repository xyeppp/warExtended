local warExtended = warExtended
local TargetInfo = TargetInfo
local tostr = tostring

local targetUnitType = {
  friendly = 'selffriendlytarget',
  enemy = 'selfhostiletarget',
  mouseover = 'mouseovertarget',
}

function warExtended:GetTargetName(targetType)
  local unitType = targetUnitType[targetType] or targetType
  local targetName = tostr(TargetInfo:UnitName(unitType)):match("([^^]+)^?[^^]*") or "nil"
  return targetName
end

function warExtended:GetTargetHealth(targetType)
  local unitType = targetUnitType[targetType] or targetType
  local targetHealth = TargetInfo:UnitHealth(unitType)

  return targetHealth
end

function warExtended:GetTargetCareer(targetType)
  local unitType = targetUnitType[targetType] or targetType
  local unitCareer = TargetInfo:UnitCareer(unitType)
  return unitCareer
end

function warExtended:GetTargetLevel(targetType)
  local unitType = targetUnitType[targetType] or targetType
  local targetLevel =  TargetInfo:UnitLevel(unitType)
  return targetLevel
end

function warExtended:GetAllTargets()
  local mouseoverTarget =  warExtended:GetTargetName("mouseover")
  local friendlyTarget = warExtended:GetTargetName("friendly")
  local hostileTarget = warExtended:GetTargetName("enemy")
  return friendlyTarget, hostileTarget, mouseoverTarget
end
