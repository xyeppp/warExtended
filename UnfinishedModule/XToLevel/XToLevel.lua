warExtendedM2L = warExtended.Register("warExtended Mobs2Level")

--[[WarBoard_Session = {}
--
--local GetGameTime, towstring, FormatClock, Tooltips = GetGameTime, towstring, TimeUtils.FormatClock, Tooltips;
--
--local settings = {
--	initialXP = 0,
--	initialRenown = 0,
--	initialClock = 0,
--	initialKills = 0,
--	initialDBs = 0,
--	initialDeaths = 0,
--
--	sessionXP = 0,
--	sessionRenown = 0,
--	sessionKills = 0,
--	sessionDBs = 0,
--	sessionDeaths = 0,
--
--	sessionXPTotal = 0,
--	sessionRenownTotal = 0,
--	initialClockTotal = 0,
--
--	timeToRank = L"-",
--	timeToRenown = L"-",
--	xpInUse = false,
--	renownInUse = false,
--	version = L"0.6"
--}
--
--function WarBoard_Session.Initialize()
--	if (WarBoard.AddMod("WarBoard_Session")) then
--	    LabelSetTextColor("WarBoard_SessionText", 255, 200, 0)
--	    LabelSetText( "WarBoard_SessionText", L"Session Stats\n" )
--
--	    settings.renownInUse = not WarBoard_Session.cappedRenown();
--		settings.xpInUse = not WarBoard_Session.cappedExp();
--
--        if settings.xpInUse or settings.renownInUse then
--            if settings.xpInUse then
--				-- Events
--				--RegisterEventHandler(SystemData.Events.PLAYER_EXP_UPDATED, "WarBoard_Session.showTimeToRank")
--				RegisterEventHandler(SystemData.Events.WORLD_OBJ_XP_GAINED, "WarBoard_Session.addXP")
--		    end
--		    if settings.renownInUse then
--				-- Events
--				--RegisterEventHandler(SystemData.Events.PLAYER_RENOWN_UPDATED, "WarBoard_Session.showTimeToRenown");
--				RegisterEventHandler(SystemData.Events.WORLD_OBJ_RENOWN_GAINED, "WarBoard_Session.addRenown");
--		    end
--        end
--		WarBoard_Session.ResetStatsAll();
--	end
--end
--
--function WarBoard_Session.ResetStats()
--	settings.initialClock = GetGameTime();
--
--	settings.timeToRank = L"-";
--	settings.timeToRenown = L"-";
--
--	settings.initialXP = GameData.Player.Experience.curXpEarned;
--	settings.initialRenown = GameData.Player.Renown.curRenownEarned;
--	settings.initialKills = GameData.Player.RvRStats.LifetimeKills;
--	settings.initialDBs = GameData.Player.RvRStats.LifetimeDeathBlows;
--	settings.initialDeaths = GameData.Player.RvRStats.LifetimeDeaths;
--
--	settings.sessionKills = 0;
--	settings.sessionDBs = 0;
--	settings.sessionDeaths = 0;
--	settings.sessionXP = 0;
--	settings.sessionRenown = 0;
--
--	WarBoard_Session.showTimeToRank();
--	WarBoard_Session.showTimeToRenown();
--end
--
--function WarBoard_Session.updateSessionTime()
--	return GetGameTime() - settings.initialClock;
--end
--
--function WarBoard_Session.updateTotalTime()
--	return GetGameTime() - settings.initialClockTotal;
--end
--
--function WarBoard_Session.ResetStatsAll()
--	WarBoard_Session.ResetStats();
--	settings.initialClockTotal = GetGameTime();
--	settings.sessionXPTotal = 0;
--	settings.sessionRenownTotal = 0;
--end
--
--function WarBoard_Session.showTimeToRank()
--	settings.xpInUse = not WarBoard_Session.cappedExp();
--
--	local timeDiff = WarBoard_Session.updateSessionTime();
--	if timeDiff == 0 or settings.sessionXP == 0 or not settings.xpInUse then
--		settings.timeToRank=L"-";
--		return;
--	end
--
--	local xpNeeded = GameData.Player.Experience.curXpNeeded -GameData.Player.Experience.curXpEarned;
--	local xpPerSecond = settings.sessionXP / timeDiff;
--	local secToLevel = xpNeeded / xpPerSecond;
--	secToLevel = WarBoard_Session.round(secToLevel, 0);
--
--	local ltime, _, _ = FormatClock(secToLevel);
--
--	if (secToLevel == 0 or secToLevel >= 360000) then
--		settings.timeToRank=towstring(L"-");
--	else
--		local ltime, _, _ = FormatClock(secToLevel);
--		settings.timeToRank=towstring(L""..ltime);
--	end
--end
--
--function WarBoard_Session.addXP(_, amount)
--	settings.sessionXP = settings.sessionXP + amount;
--	settings.sessionXPTotal = settings.sessionXPTotal + amount;
--end
--
--function WarBoard_Session.cappedRenown()
--	if GameData.Player.Renown.curRank == 80 or GameData.Player.Renown.curRenownNeeded == nil then
--		settings.renownInUse = false;
--		return true;
--	end
--	return false;
--end
--
--function WarBoard_Session.cappedExp()
--	if GameData.Player.level == 40 or GameData.Player.Experience.curXpNeeded == nil then
--		settings.xpInUse = false;
--		return true;
--	end
--	return false;
--end
--
--function WarBoard_Session.showTimeToRenown()
--	settings.renownInUse = not WarBoard_Session.cappedRenown();
--
--	local timeDiff = WarBoard_Session.updateSessionTime();
--	if timeDiff == 0 or settings.sessionRenown == 0 or not settings.renownInUse then
--		settings.timeToRenown=L"-";
--		return;
--	end
--
--	local renownNeeded = GameData.Player.Renown.curRenownNeeded - GameData.Player.Renown.curRenownEarned;
--	local renownPerSecond = settings.sessionRenown / timeDiff;
--	local secToLevel = renownNeeded / renownPerSecond;
--
--	secToLevel = WarBoard_Session.round(secToLevel, 0);
--
--	local ltime, _, _ = FormatClock(secToLevel);
--
--	if (secToLevel == 0 or secToLevel >= 360000) then
--		settings.timeToRenown=towstring(L"-");
--	else
--		local ltime, _, _ = FormatClock(secToLevel);
--		settings.timeToRenown=towstring(L""..ltime);
--	end
--
--end
--
--function WarBoard_Session.addRenown(_,amount)
--	settings.sessionRenown = settings.sessionRenown + amount;
--	settings.sessionRenownTotal = settings.sessionRenownTotal + amount
--end
--
--function WarBoard_Session.UpdateStuff()
--
--	settings.renownInUse = not WarBoard_Session.cappedRenown();
--	settings.xpInUse = not WarBoard_Session.cappedExp();
--
--    -- Update session stats
--	settings.sessionKills = GameData.Player.RvRStats.LifetimeKills-settings.initialKills;
--	settings.sessionDBs = GameData.Player.RvRStats.LifetimeDeathBlows-settings.initialDBs;
--	settings.sessionDeaths = GameData.Player.RvRStats.LifetimeDeaths-settings.initialDeaths;
--    -- more stats here !
--end
--
--function WarBoard_Session.OnUpdate()
--	-- apparantly i need to have this for some reason ?
--end
--
--function WarBoard_Session.round(num, idp)
--  local mult = 10^(idp or 0)
--  return math.floor(num * mult + 0.5) / mult
--end
--
--function WarBoard_Session.OnLClick()
--    WarBoard_Session.ResetStats();
--end
--function WarBoard_Session.OnRClick()
--    WarBoard_Session.ResetStatsAll();
--end
--
--function WarBoard_Session.OnMouseOver()
--	if settings.xpInUse then
--		WarBoard_Session.showTimeToRank();
--	end
--	if settings.renownInUse then
--		WarBoard_Session.showTimeToRenown();
--	end
--	WarBoard_Session.UpdateStuff();
--
--	Tooltips.CreateTextOnlyTooltip( "WarBoard_Session", nil)
--	Tooltips.AnchorTooltip( WarBoard.GetModToolTipAnchor( "WarBoard_Session" ) )
--
--	local toolTipStringXPNeeded = L"";
--	local toolTipStringRenownNeeded = L"";
--
--	local timeDiff = WarBoard_Session.updateSessionTime();
--	local xpPerSecond = settings.sessionXP / timeDiff;
--	local xpPerHour = WarBoard_Session.round(xpPerSecond * 3600,0);
--
--	local renownPerSecond = settings.sessionRenown / timeDiff;
--	local renownPerHour = WarBoard_Session.round(renownPerSecond * 3600,0);
--
--	local timeDiffTotal = WarBoard_Session.updateTotalTime();
--	local xpPerSecondTotal = settings.sessionXPTotal / timeDiffTotal;
--	local xpPerHourTotal = WarBoard_Session.round(xpPerSecondTotal * 3600,0);
--
--	local renownPerSecondTotal = settings.sessionRenownTotal / timeDiffTotal;
--	local renownPerHourTotal = WarBoard_Session.round(renownPerSecondTotal * 3600,0);
--
--	if settings.xpInUse then
--		local xpNeeded = GameData.Player.Experience.curXpNeeded - GameData.Player.Experience.curXpEarned;
--		toolTipStringXPNeeded = L"\nXP to level: "..xpNeeded;
--	end
--
--	if settings.renownInUse then
--		local renownNeeded = GameData.Player.Renown.curRenownNeeded - GameData.Player.Renown.curRenownEarned;
--		toolTipStringRenownNeeded = L"\nRP to level: "..renownNeeded;
--	end
--
--	local ltime, _, _ = FormatClock(timeDiff);
--
--	if (timeDiff == 0 or timeDiff >= 360000) then
--		ltime = "-";
--	end
--
--	local ltimeTotal, _, _ = FormatClock(timeDiffTotal);
--
--	if (timeDiffTotal == 0 or timeDiffTotal >= 360000) then
--		ltimeTotal = "-";
--	end
--	local row = 1;
--	Tooltips.SetTooltipText( row,1,L"Session Stats\nLeft Mouse resets session, Right mouse resets all.");
--	row=row+1;
--	Tooltips.SetTooltipText( row, 1, L"Session time: "..towstring(ltime));
--	row=row+1;
--	Tooltips.SetTooltipText( row, 1, L"Playtime: "..towstring(ltimeTotal)..L"\n--------------------------");
--	row=row+1;
--	if settings.xpInUse then
--		Tooltips.SetTooltipText( row, 1, L"XP Session: "..settings.sessionXP..L"\nXP per hour: "..xpPerHour..toolTipStringXPNeeded..L"\nTime to rank: "..settings.timeToRank..L"\nXP Playtime: "..settings.sessionXPTotal..L"\nXP per hour: "..xpPerHourTotal..L"\n--------------------------")
--		row=row+1;
--	end
--	if settings.renownInUse then
--		Tooltips.SetTooltipText( row, 1, L"RP Session: "..settings.sessionRenown..L"\nRP per hour: "..renownPerHour..toolTipStringRenownNeeded..L"\nTime to Renown rank: "..settings.timeToRenown..L"\nRP Playtime: "..settings.sessionRenownTotal..L"\nRP per hour: "..renownPerHourTotal..L"\n--------------------------");
--		row=row+1;
--	end
--	Tooltips.SetTooltipText( row, 1, L"Session Kills: "..settings.sessionKills..L"\nSession DBs: "..settings.sessionDBs..L"\nSession Deaths: "..settings.sessionDeaths);
--	row=row+1;
--
--	Tooltips.Finalize()
--end]]



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

  if isPlayerMaxLevel and not isM2LToggled() then
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


function M2L.OnInitialize()

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
