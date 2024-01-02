local warExtended = warExtended
local tostr = tostring

local targetUnitType = {
  friendly = 'selffriendlytarget',
  enemy = 'selfhostiletarget',
  mouseover = 'mouseovertarget',
}

function warExtended:GetTargetName(targetType)
  local unitType = targetUnitType[targetType] or targetType
  local targetName = TargetInfo:UnitName(unitType):match(L"([^^]+)^?[^^]*") or L"nil"
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

  return unitCareer or "NPC"
end

function warExtended:GetTargetData(targetType)
  local unitType = targetUnitType[targetType] or targetType
  local targetData =  TargetInfo.m_Units[unitType]

  return targetData
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
