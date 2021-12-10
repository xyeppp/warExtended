warExtendedDeathWindow = warExtended.Register("warExtended Death Window")
local DeathRecap = warExtendedDeathWindow
local MAX_RECAP_ENTRIES = 5

DeathRecap.Settings = {
  timeOfDeath = nil
}

local function setAbilityTooltipPath(windowName, abilityData, extraText, extraTextColor)
LabelSetText( windowName.."SpecLine",     abilityData.specline or DataUtils.GetAbilitySpecLine (abilityData))
end

local deathRecap = {
  push = function (self, entry)
    if #self < MAX_RECAP_ENTRIES then
      self[#self+1] = entry
      return
    end

    for i=1,MAX_RECAP_ENTRIES-1 do
      self[i] = self[i+1]
      self[i].id = self[i].id - 1
    end

    self[MAX_RECAP_ENTRIES]=entry
  end,


  createTemplates = function(self)
    for i=1,MAX_RECAP_ENTRIES do
      local entries = self[i]
      entries:createSelfTemplate()
    end
  end
}

function DeathRecap.RefreshWindow()
  deathRecap:createTemplates()
end

function DeathRecap.OnPlayerDeath()
  DeathRecap.Settings.timeOfDeath = DeathRecap:GetGameTime()

  DeathRecap.RefreshWindow()
end

function DeathRecap.GetMouseOverTemplateData(windowId)
  return deathRecap[windowId]
end

function DeathRecap.OnPlayerDeathCleared()
  for i=1,MAX_RECAP_ENTRIES do
    local entries = deathRecap[i]
    entries:destroySelf()
  end

  DeathRecap.Settings.timeOfDeath = nil
  DeathRecap.Hide()
end

function DeathRecap.OnInitialize()
  DeathRecap:RegisterEvent("world obj combat event", "warExtendedDeathWindow.OnWorldObjCombatEvent")
  DeathRecap:RegisterEvent("player death", "warExtendedDeathWindow.OnPlayerDeath")
  DeathRecap:RegisterEvent("player death cleared", "warExtendedDeathWindow.OnPlayerDeathCleared")
  DeathRecap:Hook(Tooltips.SetAbilityTooltipData, setAbilityTooltipPath, true )

  DeathRecap.SetWindowLabel()
end

function warExtendedDeathWindow.OnWorldObjCombatEvent(worldObjId, value, combatEventType, abilityId)
  if DeathRecap:IsPlayerWorldObjNum(worldObjId) and DeathRecap:CombatGetEventType(combatEventType) == "Damage" then
    local abilityType, abilityDamage = DeathRecap:CombatGetHitTypeAndValue(value)

    if abilityType == "Healing" then
      return
    end

    local hitTime = DeathRecap:GetGameTime()
    local newEntry = DeathRecap.RegisterRecapEntry(abilityDamage, abilityId, hitTime)
  
    deathRecap:push(newEntry)
  end
end

