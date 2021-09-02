warExtendedM2L = warExtended.Register("warExtended Mobs2Level")

local M2L = warExtendedM2L
local formatClock = TimeUtils.FormatClock
local ceil = math.ceil
local strformat = string.format
local tostr = tostring
local isBestiaryUpdated


M2L.Settings = {
	isToggled = false,
	sessionStartTime = nil,
	sessionXP = nil,
}


local function roundNumber(num, numDecimalPlaces)
  return strformat("%." .. (numDecimalPlaces or 0) .. "f", num)
end

local function isM2LToggled()
	local isToggled = M2L.Settings.isToggled
	return isToggled
end

local function getExperienceNeededToLevel()
	local 	totalExperienceNeeded   = GameData.Player.Experience.curXpNeeded
  local   totalExperienceEarned   = GameData.Player.Experience.curXpEarned
  local experiencedNeededToLevelUp = totalExperienceNeeded - totalExperienceEarned
	return experiencedNeededToLevelUp
end


local function setSessionStartTimer()
	if isM2LToggled() then
		M2L.Settings.sessionStartTime = GetGameTime()
		return
	end
	M2L.Settings.sessionStartTime = nil
end


local function addExperienceGainedToSessionData(experienceGained)

	if M2L.Settings.sessionXP == nil then
		M2L.Settings.sessionXP =  experienceGained
		return
	end

	M2L.Settings.sessionXP = M2L.Settings.sessionXP + experienceGained

end


local function registerSelfEvents()
	if isM2LToggled() then
		M2L:RegisterEvent("TOME_BESTIARY_SPECIES_KILL_COUNT_UPDATED", "warExtendedM2L.IsBestiaryUpdated")
		M2L:RegisterEvent("combat", "warExtendedM2L.GetMonsterDataFromCombatLog")
		return
	end

	M2L:UnregisterEvent("TOME_BESTIARY_SPECIES_KILL_COUNT_UPDATED", "warExtendedM2L.IsBestiaryUpdated")
	M2L:UnregisterEvent("combat", "warExtendedM2L.GetMonsterDataFromCombatLog")
end


local function setToggleState()
  if isM2LToggled() then
		M2L:Print("Mobs2Level turned off.")
		M2L.Settings.isToggled=false;
		M2L.Settings.sessionXP=nil;
		return
	end

		M2L:Print("Mobs2Level turned on.")
		M2L.Settings.isToggled=true;
end


local function toggleSelf()
	local isPlayerMaxLevel = GameData.Player.level==40

	if isPlayerMaxLevel and not isToggled then
		M2L:Print("You are already at maximum level.")
		return
	end

	setToggleState()
	setSessionStartTimer()
	registerSelfEvents()
end


local function getExperienceGainedPer(type)
	local timeSinceStartSession = GetGameTime() - M2L.Settings.sessionStartTime
	local xpPerSecond = M2L.Settings.sessionXP / timeSinceStartSession
	local xpPerHour = ceil(xpPerSecond * 3600)

	if type == "second" then
	return xpPerSecond
	elseif type == "hour" then
	return xpPerHour
	end
end


local function getEstimatedTimeToLevel()
	local xpPerSecond = getExperienceGainedPer("second")
	local timeToLevel = formatClock(getExperienceNeededToLevel() / xpPerSecond)
	return tostr(timeToLevel)
end


local function printMonsterNeededToLevelMessage(monsterName, experienceGained)
	local experienceNeeded = getExperienceNeededToLevel()
	local mobsNeededToLevel = roundNumber(experienceNeeded / experienceGained) + 1
	local timeToLevel = getEstimatedTimeToLevel()

	M2L:Print(mobsNeededToLevel.." "..monsterName.." needed to level up.\nEstimated time to level: "..timeToLevel)
	isBestiaryUpdated=false;
end



local slashCommands = {

	m2l = {
		func = toggleSelf,
		desc = "Toggle M2L On/Off."
	}

}


function warExtendedM2L.OnInitialize()

	if isM2LToggled() then
			M2L:RegisterEvent("TOME_BESTIARY_SPECIES_KILL_COUNT_UPDATED", "warExtendedM2L.IsBestiaryUpdated")
			M2L:RegisterEvent("combat", "warExtendedM2L.GetMonsterDataFromCombatLog")
	end

	M2L:RegisterSlash(slashCommands, "warext")
end


function M2L.IsBestiaryUpdated()
	-- this only exists to prevent printing any other type of gained XP as there's no other reliable method to check what did you kill
	isBestiaryUpdated = true;
end


function M2L.GetMonsterDataFromCombatLog(updateType, filterType)
	local isMaxLevel = GameData.Player.level==40

	if isMaxLevel or not isBestiaryUpdated then
		return
	end

  if( updateType == SystemData.TextLogUpdate.ADDED ) then
	local _, _, text = TextLogGetEntry( "Combat", TextLogGetNumEntries("Combat") - 1 )
	  if filterType == SystemData.ChatLogFilters.EXP then
		local experienceGainedFromMonster = tostr(text:match(L"You gain (.+) experience."))
		local nameOfSlayedMonster	=	tostr(TargetInfo:UnitName("selfhostiletarget"))

		if not experienceGainedFromMonster then
			return
		end

		addExperienceGainedToSessionData(experienceGainedFromMonster)
		printMonsterNeededToLevelMessage(nameOfSlayedMonster, experienceGainedFromMonster)
	  end
	end

end
