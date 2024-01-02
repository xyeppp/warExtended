local warExtended = warExtended
local HEALING = "Healing"
local DAMAGE = "Damage"
local DEFENSIVE = "Defensive"

 siegeAbilities = {
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

function warExtended:GetHitTypeAndValue(hitValue)
	if hitValue > 0 then
	  return HEALING, hitValue
	end

  hitValue = hitValue * (-1)
	return DAMAGE, hitValue
end

function warExtended:IsRessurectionAbility(abilityId)
    return ressurectionAbilities[abilityId]
end

function warExtended:IsSiegeAbility(abilityId)
    return siegeAbilities[abilityId]
end

function warExtended:GetCombatEventType(combatEventId)
  local damageEvent = eventTypes.Damage[combatEventId]
  local defensiveEvent = eventTypes.Defensive[combatEventId]

  if damageEvent then
    return DAMAGE, damageEvent
  elseif defensiveEvent then
    return "Defensive", defensiveEvent
  end
end


function warExtended:IsPlayerInCombat(combatState)
    return GameData.Player.inCombat == combatState
end



