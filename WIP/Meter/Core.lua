warExtendedMeter = warExtended.Register("warExtended Meter")
local Meter = warExtendedMeter

Meter.Settings = {
  CombatStartTime = 0,
  SavedCombatData = {
  }
}

local meter = {
  register = function (self)
	local combatStartTime = GetGameTime()
	Meter:RegisterUpdate("warExtendedMeter.OnUpdate")
	Meter:RegisterEvent("world obj combat event", "warExtendedMeter.OnWorldObjCombatEvent")
	Meter.Settings.CombatStartTime = combatStartTime
  end,
  
  unregister = function(self)
	Meter:UnregisterUpdate("warExtendedMeter.OnUpdate")
	Meter:UnregisterEvent("world obj combat event", "warExtendedMeter.OnWorldObjCombatEvent")
	Meter.Settings.CombatStartTime = 0
  end,
  
  toggle = function(self, combatState)
	p("toggling")
	if combatState then
	  self:register()
	else
	  self:unregister()
	end
  end
}

local function getPlayerCombatState()
  local combatState = GameData.Player.inCombat
  return combatState
end


local function onCombatStateMeterRegister(isInCombat)
  meter:toggle(isInCombat)
end

local function setMeterState(combatState)
  if Meter:IsPlayerInCombat(combatState) then
	onCombatStateMeterRegister(combatState)
  end
end


function Meter.OnPlayerCombatFlagUpdated(combatState)
  p("here")
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