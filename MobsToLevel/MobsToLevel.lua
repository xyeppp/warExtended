function QuickNameActionsRessurected.ExpToLevel()
  if GameData.Player.level==40 then return end
  if TargetInfo:UnitName("selfhostiletarget") == L"" then return end
  local totalNeeded   = GameData.Player.Experience.curXpNeeded
  local   totalEarned   = GameData.Player.Experience.curXpEarned

  local hasRest     = GameData.Player.Experience.restXp > 0
  if hasRest then
	totalRest = QuickNameActionsRessurected.GetRestPercent()
  end

  x2l = totalNeeded - totalEarned


end

function QuickNameActionsRessurected.GetRestPercent()
  local restPercent = (GameData.Player.Experience.curXpEarned + GameData.Player.Experience.restXp )/GameData.Player.Experience.curXpNeeded
  return restPercent
end

function QuickNameActionsRessurected.Round2(num, numDecimalPlaces)
  return towstring(string.format("%." .. (numDecimalPlaces or 0) .. "f", num))
end

function QuickNameActionsRessurected.MobToggle()
  if not QuickNameActionsRessurected.Settings.ExpPrinter then
	EA_ChatWindow.Print(towstring(link)..L"Mobs2Level on.")
	QuickNameActionsRessurected.Settings.ExpPrinter=true;
  else
	EA_ChatWindow.Print(towstring(link)..L"Mobs2Level off.")
	QuickNameActionsRessurected.Settings.ExpPrinter=false;
  end
end


function QuickNameActionsRessurected.ExpPrinter(updateType, filterType)
  if not QuickNameActionsRessurected.Settings.ExpPrinter or GameData.Player.level==40 then return end
  if TargetInfo:UnitName("selfhostiletarget") ==L"" or TargetInfo:UnitIsNPC("selfhostiletarget")==false then return end

  if( updateType == SystemData.TextLogUpdate.ADDED ) then
	local currenttime, filterId, text = TextLogGetEntry( "Combat", TextLogGetNumEntries("Combat") - 1 )
	if GameData.Player.level==40 then return else
	  if filterType == SystemData.ChatLogFilters.EXP then
		local totalNeeded   = GameData.Player.Experience.curXpNeeded
		local   totalEarned   = GameData.Player.Experience.curXpEarned
		Experience = text:match(L"You gain (.+) experience.")
		local slayed=tostring(TargetInfo:UnitName("selfhostiletarget"))
		x2l = totalNeeded - totalEarned
		--p(slayed)
		m2l = QuickNameActionsRessurected.Round2(x2l / Experience)+1
		--p("Experience Gained: "..tostring(Experience))
		EA_ChatWindow.Print(towstring(tostring(link).."Kill "..m2l.." more "..slayed.." to level up. Need "..x2l.." XP more to level up. "..Experience.." XP gained from last target."))
	  end
	end
  end
end