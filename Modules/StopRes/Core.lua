warExtendedStopRes = warExtended.Register("warExtended StopRes")
local StopRes = warExtendedStopRes

StopRes.Settings = {
  isRessing=false;
  currentRessurectTarget = ""
}

local ressingState = {

  getState = function ()
	local isRessing = StopRes.Settings.isRessing
	return isRessing
  end,

  toggleState = function (self)
	StopRes.Settings.isRessing = not self:getState()
  end,

  setRessurectTargetName = function (self, targetName)
	StopRes.Settings.currentRessurectTarget = targetName
  end,

  getCurrentFriendlyTargetName = function ()
	local currentFriendlyTarget = StopRes:GetTargetName("friendly")
	return currentFriendlyTarget
  end,

 getCurrentRessurectTargetName = function ()
   local currentRessurectTarget = StopRes.Settings.currentRessurectTarget
   return currentRessurectTarget
 end,

  registerUpdate = function()
	StopRes:RegisterUpdate("warExtendedStopRes.OnUpdate")
  end,

  unregisterUpdate = function ()
	StopRes:UnregisterUpdate("warExtendedStopRes.OnUpdate")
  end,

  start = function (self)
	self:setRessurectTargetName(self:getCurrentFriendlyTargetName())
	self:toggleState()
	self:registerUpdate()
  end,

  stop = function (self)
	self:setRessurectTargetName(nil)
	self:toggleState()
	self:unregisterUpdate()
  end
}

function StopRes.OnInitialize()
    StopRes:RegisterEvent("player end cast", "warExtendedStopRes.OnEndCast")
    StopRes:RegisterEvent("player begin cast", "warExtendedStopRes.OnBeginCast")
end

function StopRes.OnShutdown()
  StopRes:UnregisterEvent("player end cast", "warExtendedStopRes.OnEndCast")
  StopRes:UnregisterEvent("player begin cast", "warExtendedStopRes.OnBeginCast")
end


function StopRes.OnUpdate()
  local ressurectTarget = ressingState:getCurrentRessurectTargetName()
  local currentTarget = ressingState:getCurrentFriendlyTargetName()

  if currentTarget ~= ressurectTarget then
	return
  end

  local isTargetRessurected = StopRes:GetTargetHealth("friendly") ~= 0

  if isTargetRessurected then
	CancelSpell()
  end
end



function StopRes.OnBeginCast(abilityId)
  if StopRes:CombatIsRessurectionAbility(abilityId) then
	ressingState:start()
  end
end

function StopRes.OnEndCast()
  local isRessingState = ressingState:getState()

  if isRessingState then
	ressingState:stop()
  end

end