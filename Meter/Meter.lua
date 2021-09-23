warExtendedMeter = warExtended.Register("warExtended Meter")
local Meter = warExtendedMeter
local tostring = tostring
local MAX_METER_LENGTH = 10

Meter.Settings = {
  CombatStartTime = nil
}

local eventTypes = {
  Damage = {
    [0] = "Attack Damage",
    [1] = "Ability Damage",
    [2] = "Critical Damage",
    [3] = "Ability Critical Damage",
  },
  Defensive = {
    [4] =  "Block",
    [5] =  "Parry",
    [6] = "Evade",
    [7] =  "Disrupt",
    [8] = "Absorb",
    [9] = "Immune"
  },
}

local siegeAbilities = {
  14435, -- Oil
  24684, -- Ram
  24694, -- ST Cannon
  24682  -- AoE Cannon
}

local function isAbilitySiegeType(abilityId)
  local siegeAbility = siegeAbilities[abilityId]
  return siegeAbility
end

local meterData = {
  Damage = {
    Taken = "DamageTaken",
    Given = "DamageGiven",
  },
  Healing = {
    Taken = "HealingTaken",
    Given = "HealingGiven"
  }
}

local meterEntry = {
  name = "",
  value = 0,
  totalValue = 0,
  totalHits = 0,
  minValue = 0,
  maxValue = 0,
}

local function getCombatEventType(combatEventType)
  for eventType,_ in pairs(eventTypes) do
    local eventTypeName = eventTypes[eventType][combatEventType]
    if eventTypeName then
      return eventType, eventTypeName
    end
  end
end

function meterEntry:AddDefensiveCount(damageType)

end


function meterEntry:AddValue(value, damageType)
  local isDefensiveEvent = isDefensiveEvent(damageType)

  if value > 0 then
    self.totalHits = self.totalHits + 1
    self.totalValue = self.totalValue + value
  end
end

function meterEntry.Register(abilityName, damageType, value)
  self.name = abilityName
  self:AddValue(damageType, value)
  return self
end

local function getValuePerSecond(totalValue)
  local timeSinceCombatStart = GetGameTime() - Meter.Settings.CombatStartTime
  local damagePerSecond = totalValue / timeSinceCombatStart
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

local function registerMeterUpdate(combatState)
  if combatState then
    registerMeter()
    return
  end
  unregisterMeter()
end

local function setMeterState(combatState)
  local isCombatState = getPlayerCombatState() == combatState

  if isCombatState then
    registerMeterUpdate(combatState)
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


function warExtendedMeter.OnUpdate(timeElapsed)
end


local function isWorldObjIdPlayerOrPet(worldObjId)
  local playerWorldObjId, petWorldObjId = GameData.Player.worldObjNum, GameData.Player.Pet.objNum
  local isPlayerWorldObjId, isPetWorldObjId = worldObjId == playerWorldObjId, worldObjId == petWorldObjId
  return isPlayerWorldObjId or isPetWorldObjId
end

function getMeterTableTypeAndValue(value)
  local isHealing, isDamage
  if value > 0 then
    isHealing = "Healing"
    return isHealing, value
  end

  isDamage = "Damage"
  value = value * (-1)
  return isDamage, value
end

local function getAbilityName(abilityId)
  local abilityName = tostring(GetAbilityName(abilityId))
  if abilityName == "" then
    abilityName = "Auto Attack"
  end
  return abilityName
end

local function addMeterValue(meterTable, value, eventTypeName, abilityName)
  p(meterTable, value,eventTypeName, abilityName)
end


local function addCombatEventToMeter(worldObjId, value, combatEventType, abilityId)
  local isWorldObjPlayerBound = isWorldObjIdPlayerOrPet(worldObjId)
  local abilityName = getAbilityName(abilityId)
  local meterTable, value = getMeterTableTypeAndValue(value)
  local eventType, eventTypeName = getCombatEventType(combatEventType)
  p(meterTable)

  if isWorldObjPlayerBound then
    meterTable = meterData[meterTable].Taken
    addMeterValue(meterTable, value, eventTypeName, abilityName)
    return
  end

  meterTable = meterData[meterTable].Given
  addMeterValue(meterTable, value, eventTypeName, abilityName)
end


function warExtendedMeter.OnWorldObjCombatEvent(worldObjId, value, combatEventType, abilityId)
  local isImmunityEvent = isImmunityEvent(combatEventType)
  local isSiegeAbility = isAbilitySiegeType(abilityId)

  if isImmunityEvent or isSiegeAbility then
    return
  end

  addCombatEventToMeter(worldObjId, value, combatEventType, abilityId)
 end