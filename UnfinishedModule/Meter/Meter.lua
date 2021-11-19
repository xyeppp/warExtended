warExtendedMeter = warExtended.Register("warExtended Meter")
local Meter = warExtendedMeter
local tostring = tostring

Meter.Settings = {
  CombatStartTime = nil,
  SavedCombatData = {
  }
}

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


local meterData = {
}

local meter = {
}

function meter:IsMeter(meterType)
  return self[meterType]
end

function meter:AddMeter(meterType)
  local mData = setmetatable({}, meterData)
  self[meterType] = meterData
end

function meterData:IsMeterEntryType(entryType)
  return self[entryType]
end

function meterData:AddMeterEntryType(entryType)
  self[entryType] = {}
end

local meterDataEntry = {
  name = "",
  value = 0,
  avgValue = 0,
  totalValue = 0,
  totalHits = 0,
  minValue = 0,
  maxValue = 0,
}

function meter:GetAbility(meterType, entryType, abilityName)
  return self[meterType][entryType][abilityName]
end

function meter:GetEntry(meterType, entryType)
  return self[meterType][entryType]
end

function meterDataEntry:AddEntry(value)
  self.value = value
  self.totalValue = self.totalValue + value
end

function meterData:AddAbilityEntry(entryType, abilityName, value)
  self[entryType][abilityName]:AddEntry(value)
  p(self[entryType][abilityName])
end

function meterData:IsMeterEntry(entryType, abilityName)
  if not self[entryType] then
    self[entryType] = {}
  end
  local isEntry = self[entryType][abilityName] ~= nil
  return isEntry
end

function meterData:AddMeterEntryTypeEntry(entryType, abilityName)
  local meterDataEntry = setmetatable({}, meterDataEntry)
  meterDataEntry.name = abilityName
  self[entryType][abilityName] = meterDataEntry
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

--function meterData:AddEntry(abilityName, combatEventType, value, entryType)
  --p(abilityName, combatEventType, value, entryType)
--end


local function addCombatEventToMeter(worldObjId, value, combatEventType, abilityId)
  local isWorldObjPlayerBound = isWorldObjIdPlayerOrPet(worldObjId)
  local entryType = getEntryType(isWorldObjPlayerBound)
  local abilityName = getAbilityName(abilityId)
  local eventType, eventName = getCombatEventType(combatEventType)
  local meterType = meter:IsMeter(entryType)

  if not meterType then
    meter:AddMeter(entryType)
    meterType = meter:IsMeter(entryType)
  end

p(meterType)

  if not meterType:IsMeterEntry(entryType, abilityName) then
    meterType:AddMeterEntryTypeEntry(entryType, abilityName)
  end


 local abilityEntry =  meterType:GetAbility(meterType, entryType, abilityName)
  abilityEntry:AddAbilityEntry(entryType, abilityName, value)
  p(entryType.." - Hit Amount:"..value, "Event Type:"..eventType, eventName, "Ability Info:"..abilityId, abilityName)
  --meterData:AddEntry(abilityName, combatEventType, value, entryType)
end


function warExtendedMeter.OnWorldObjCombatEvent(worldObjId, value, combatEventType, abilityId)
  local isSiegeAbility = isAbilitySiegeType(abilityId)

  if isSiegeAbility then
    return
  end

  addCombatEventToMeter(worldObjId, value, combatEventType, abilityId)
 end