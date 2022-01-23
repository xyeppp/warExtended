warExtendedAbilityData = warExtended.Register("warExtended Abilities Data")
local AbilityData = warExtendedAbilityData
local abilitiesData = {
}

classData = {}


function warExtended:GetCareerAbilityData(career, abilityType)
  local abilityData = classData[career]

  if abilityType then
	local abData = {}
	for abilityId, abilityData in pairs(abilityData) do
	  if abilityData.abilityType == abilityType then
		abData[abilityId] = abilityData
	  end
	end
	return abData
  end
  
  return abilityData
end


function warExtended:AddAbilityDataDefinition(abilityDefs, career)
  if career then
	local career = (warExtended:GetCareerLine(career))
	classData[career] = abilityDefs
  end
  
  for abilityId, _ in pairs(abilityDefs) do
	local abilityTable = abilityDefs[abilityId]
	
	if not abilitiesData[abilityId] then
	  abilitiesData[abilityId] = abilityTable
	end
	
  end
end

function warExtended:GetRandomAbilityId()
local randomAbilityTable = {}

for _,v in pairs(abilitiesData) do
	randomAbilityTable[#randomAbilityTable+1] = v.id
  end
  
  return randomAbilityTable[ math.random(1, #randomAbilityTable)]
end


local function tryAndFindAbilityData(abilityId)
  local abilityName = GetAbilityName(abilityId)
  
  if abilityId == 0 then
	local autoAttack = GetAbilityData(2490)
	return autoAttack
  end
  
  for abilityId, abilityData in pairs(abilitiesData) do
	local abName = abilityData.name
	
	if abName == abilityName then
	  return abilityData[abilityId]
	end
  end
  
  local abilityData = GetAbilityData(abilityId)
  return abilityData
end


function warExtended:GetAbilityData(abilityId)
  local abilityData = abilitiesData[abilityId]
  if not abilityData then
	abilityData = tryAndFindAbilityData(abilityId)
  end
  return abilityData
  end

function warExtended:GetAbilityName(abilityId)
  if abilityId == 0 then
	local AutoAttackData = GetAbilityData(2490)
	return AutoAttackData.name
  end

  return abilitiesData[abilityId].name
end

function warExtended:GetAbilityIcon(abilityId)
  if abilityId == 0 then
	local AutoAttackData = GetAbilityData(2490)
	return AutoAttackData.iconNum
  end

  return abilitiesData[abilityId].iconNum
end


function warExtended:GetAbilityDataByAbilityType(type)


end

