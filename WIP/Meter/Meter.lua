local Meter = warExtendedMeter
local tostring = tostring


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


 --local abilityEntry =  meterType:GetAbility(meterType, entryType, abilityName)
 -- abilityEntry:AddAbilityEntry(entryType, abilityName, value)
  p(entryType.." - Hit Amount:"..value, "Event Type:"..eventType, eventName, "Ability Info:"..abilityId, abilityName)
  --meterData:AddEntry(abilityName, combatEventType, value, entryType)
end


function warExtendedMeter.OnWorldObjCombatEvent(worldObjId, value, combatEventType, abilityId)
  if worldObjId == GameData.Player.worldObjNum then
    p(GetAbilityData(abilityId))
  end
  
  if warExtendedMeter:CombatIsSiegeAbility(abilityId) or worldObjId == GameData.Player.worldObjNum then
    return
  end
  
  if value < 0 then
    value = value * -1
    elseif value == nil then
    value = 1
  end

  local abilityData = warExtended:GetAbilityData(abilityId)
  Meter.CreateMeterEntry(abilityData, value)
  addCombatEventToMeter(worldObjId, value, combatEventType, abilityId)
 end

function warExtendedMeter.TestFunction123(tabler)
 -- p(tabler)
  --GetBuffs(6)
end

warExtendedMeter:RegisterEvent("player effects updated", "warExtendedMeter.TestFunction123")