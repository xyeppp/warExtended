local warExtended = warExtended
local TargetInfo = TargetInfo
local tostr = tostring

local targetInfoUnitID = {
  friendly = 'selffriendlytarget',
  enemy = 'selfhostiletarget',
  mouseover = 'mouseovertarget',
}

local function getTargetName(unitID)
  local targetName = tostr(TargetInfo:UnitName(unitID):match(L"([^^]+)^?[^^]*")) or false
  return targetName
end

local function getTargetHealth(unitID)
 local targetHealth = TargetInfo:UnitHealth(unitID)
  return targetHealth
 end


function warExtended:GetTargetName(targetType)
  local unitID = targetInfoUnitID[targetType]
  local targetName = getTargetName(unitID)

  return targetName
end

function warExtended:GetTargetHealth(targetType)
  local unitID = targetInfoUnitID[targetType]
  local targetHealth = getTargetHealth(unitID)

  return targetHealth
end


--TODO:maybe delete this function?
function warExtended:GetAllTargets()
  local targetNames = {}

  for _, targetUnitId in pairs(targetInfoUnitID) do
    targetNames[#targetNames+1] = getTargetName(targetUnitId)
  end

  local mouseoverTarget, friendlyTarget, hostileTarget = unpack(targetNames)
  return mouseoverTarget, friendlyTarget, hostileTarget
end
