warExtendedMeter = warExtended.Register("warExtended Meter")
local Meter = warExtendedMeter
local tostring = tostring

Meter.Settings = {
  CombatStartTime = nil,
  SavedCombatData = {
  }
}

local meterData = {
}

local meterEntry = {
  name = "",
  value = 0,
  avgValue = 0,
  totalValue = 0,
  totalHits = 0,
  minValue = 0,
  maxValue = 0,
}

function meterData:GetTotal(totalOf)
  local returnValue = 0

  for meterIndex=1,#self do
    local totalValue = self[meterIndex][totalOf]
    local returnValue = returnValue + totalValue
  end

  return returnValue
end

function meterEntry:PrintSelf()
  p("self")
end









local eventTypes = {
  Damage = {
    [0] = "Attack Damage",
    [1] = "Ability Damage",
    [2] = "Critical Damage",
    [3] = "Ability Critical Damage",
  },
  Defensive = {
    [4] = "Block",
    [5] = "Parry",
    [6] = "Evade",
    [7] = "Disrupt",
    [8] = "Absorb",
    [9] = "Immune"
  },
}

local siegeAbilities = {
  [14435] = "Oil",
  [24684] = "Ram",
  [24694] = "ST Cannon",
  [24682] = "AoE Cannon"
}


local function isAbilitySiegeType(abilityId)
  local isSiegeAbility = siegeAbilities[abilityId] ~= nil
  return isSiegeAbility
end


local function getCombatEventType(combatEventId)
  local damageEvent = eventTypes.Damage[combatEventId]
  local defensiveEvent = eventTypes.Defensive[combatEventId]

  if damageEvent then
    return "Damage", damageEvent
  end

  return "Defensive", defensiveEvent
end

local function isDefensiveEvent(eventTypeName)
  local isDefensiveEvent = eventTypeName == "Defensive"
  return isDefensiveEvent
end

local function getAverageValuePerSecond(totalValue)
  local timeSinceCombatStart = GetGameTime() - Meter.Settings.CombatStartTime
  local damagePerSecond = Meter:RoundTo((totalValue / timeSinceCombatStart), 2)
  return damagePerSecond
end


local function getPlayerCombatState()
  local combatState = GameData.Player.inCombat
  return combatState
end

local function setCombatStartTimer(time)
  Meter.Settings.CombatStartTime = time
end

local function registerMeter()
  local combatStartTime = GetGameTime()
  Meter:RegisterUpdate("warExtendedMeter.OnUpdate")
  Meter:RegisterEvent("world obj combat event", "warExtendedMeter.OnWorldObjCombatEvent")
  setCombatStartTimer(combatStartTime)
end

local function unregisterMeter()
  Meter:UnregisterUpdate("warExtendedMeter.OnUpdate")
  Meter:UnregisterEvent("world obj combat event", "warExtendedMeter.OnWorldObjCombatEvent")
  setCombatStartTimer(0)
end

local function onCombatStateMeterRegister(isInCombat)
  if isInCombat then
    registerMeter()
    return
  end
  unregisterMeter()
end

local function setMeterState(combatState)
  local isCombatState = getPlayerCombatState() == combatState

  if isCombatState then
    onCombatStateMeterRegister(combatState)
  end
end


function Meter.OnPlayerCombatFlagUpdated(combatState)
  setMeterState(combatState)
end


function Meter.OnInterfaceReloaded()
  local combatState = getPlayerCombatState()
  setMeterState(combatState)
end


function Meter.OnInitialize()
  Meter:RegisterEvent("player combat flag updated","warExtendedMeter.OnPlayerCombatFlagUpdated")
  Meter:RegisterEvent("interface reloaded", "warExtendedMeter.OnInterfaceReloaded")
end


function Meter.OnUpdate(timeElapsed)
end

local function getMaxHitValue(maxValue, hitValue)
  if maxValue < hitValue then
    return hitValue
  end
  return maxValue
end

local function getMinHitValue(minValue, hitValue)
  if minValue > hitValue and hitValue > 0 then
    return hitValue
  end
  return minValue
end


local function getEntryType(isWorldObjPlayerBound)
  if isWorldObjPlayerBound then
    return "Taken"
  end

  return "Given"
end


local function getHitTypeAndValue(value)

  if value > 0 then
    return "Healing", value
  end

  value = value * (-1)
  return "Damage", value
end


local function isWorldObjIdPlayerOrPet(worldObjId)
  local isPlayerWorldObjId = worldObjId == GameData.Player.worldObjNum
  local isPetWorldObjId = worldObjId == GameData.Player.Pet.objNum
  return isPlayerWorldObjId or isPetWorldObjId
end



local function getAbilityName(abilityId)
  local abilityName = tostring(GetAbilityName(abilityId))
  if abilityName == "" then
    abilityName = "Auto Attack"
  end
  return abilityName
end

function meterData:AddEntry(abilityName, combatEventType, value, entryType)
  p(abilityName, combatEventType, value, entryType)
end


local function addCombatEventToMeter(worldObjId, value, combatEventType, abilityId)
  local isWorldObjPlayerBound = isWorldObjIdPlayerOrPet(worldObjId)
  local entryType = getEntryType(isWorldObjPlayerBound)
  local abilityName = getAbilityName(abilityId)
  local eventType, eventName = getCombatEventType(combatEventType)

  p(entryType.." - Hit Amount:"..value, "Event Type:"..eventType, eventName, "Ability Info:"..abilityId, abilityName)
  meterData:AddEntry(abilityName, combatEventType, value, entryType)
end


function warExtendedMeter.OnWorldObjCombatEvent(worldObjId, value, combatEventType, abilityId)
  local isSiegeAbility = isAbilitySiegeType(abilityId)

  if isSiegeAbility then
    return
  end

  addCombatEventToMeter(worldObjId, value, combatEventType, abilityId)
 end