local warExtended = warExtended

local siegeAbilities = {
  [14435] = "Oil",
  [24684] = "Ram",
  [24694] = "ST Cannon",
  [24682] = "AoE Cannon"
}

local ressurectionAbilities = {
  [1598] = "Rune Of Life",
  [1908] = "Gedup!",
  [8248] = "Breath Of Sigmar",
  [8555] = "Tzeentch Shall Remake You",
  [9246] = "Gift Of Life",
  [9558] = "Stand, Coward!"
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

function warExtended:CombatGetHitTypeAndValue(hitValue)
	if hitValue > 0 then
	  return "Healing", hitValue
	end

  hitValue = hitValue * (-1)
	return "Damage", hitValue
end

function warExtended:CombatIsRessurectionAbility(abilityId)
  local isRessurectionAbility = ressurectionAbilities[abilityId]
  return isRessurectionAbility
end

function warExtended:CombatIsSiegeAbility(abilityId)
  local isRessurectionAbility = siegeAbilities[abilityId]
  return isRessurectionAbility
end

function warExtended:CombatGetEventType(combatEventId)
  local damageEvent = eventTypes.Damage[combatEventId]
  local defensiveEvent = eventTypes.Defensive[combatEventId]

  if damageEvent then
	return "Damage", damageEvent
  end

  return "Defensive", defensiveEvent
end

function warExtended:CombatGetStartTime()
  local startTime = GetGameTime()
  return startTime
end

function warExtended:IsPlayerInCombat(combatState)
  local combatState = GameData.Player.inCombat == combatState
  return combatState
end



