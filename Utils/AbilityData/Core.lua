local warExtended = warExtended
local abilityData = {
}

function warExtended:AddAbilityDataDefinition(abilityDataDefinition)
  for abilityId, abilityDataDefinition in pairs(abilityDataDefinition) do
	if not abilityData[abilityId] then
	  abilityData[abilityId] = abilityDataDefinition
	end
  end
end

function warExtended:GetRandomAbilityId()
local randomTable = {}

for _,v in pairs(abilityData) do
	randomTable[#randomTable+1] = v.id
  end
  local randomEntry = math.random(1, #randomTable)
  local randomAbilityId = randomTable[randomEntry]
  return randomAbilityId
end


local function tryAndFindAbilityData(nameToFind)
  for abilityId, abilityData in pairs(abilityData) do
	local abilityName = abilityData.name
	
	if abilityName == nameToFind then
	  return abilityData[abilityId]
	end
	
  end
end


function warExtended:GetAbilityData(abilityId)
  if abilityId == 0 then
 	local AutoAttackData = GetAbilityData(2490)
	return AutoAttackData
  end
  
  local abilityData = abilityData[abilityId]
  if not abilityData then
	p("NOT FOUND DATA FOR "..abilityId)
	p(GetAbilityName(abilityId))
	tryAndFindAbilityData(GetAbilityName(abilityId))
	p("looking for ability")
  end
  return abilityData
  end

function warExtended:GetAbilityName(abilityId)
  if abilityId == 0 then
	local AutoAttackData = GetAbilityData(2490)
	return AutoAttackData.name
  end

  return abilityData[abilityId].name
end

function warExtended:GetAbilityIcon(abilityId)
  if abilityId == 0 then
	local AutoAttackData = GetAbilityData(2490)
	return AutoAttackData.iconNum
  end

  return abilityData[abilityId].iconNum
end
