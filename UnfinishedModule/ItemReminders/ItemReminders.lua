-- local warExtendedItemReminders =
--local Reminder = warExtededItemReminders

function QuickNameActionsRessurected.TestToggle(input)
  local newLine = input:gsub("<", "")
  newLine = newLine:gsub(">", "")
  local itemID, goal = newLine:match('LINK.*data="ITEM:([^"]*)".*text="[%a%s%p]*".*color="[%d%p]*"%D*([%d]*)')
  itemID = tonumber(itemID)
  goal = tonumber(goal)
  --p(input)


  if(not itemID) then
	EA_ChatWindow.Print(link..L"Unable to add to reminders.")
	EA_ChatWindow.Print(link..L"[item link]goal - is the correct method to add a reminder.")
  else
	QuickNameActionsRessurected.AddReminder(itemID, goal)
  end

  local linker=QuickNameActionsRessurected.ItemLinker
  --  p(input)

  --EA_ChatWindow.Print(link..linker(itemdb.uniqueID, itemdb.name)..L" minimum changed. New Minimum: "..goal)

  if input=="list" then
	--  if next(QuickNameActionsRessurected.Settings.Tester)~= nil then
	EA_ChatWindow.Print((link)..L"Current Reminder List")
	for k,v in pairs(QuickNameActionsRessurected.Settings.Tester) do
	  local itemdb=GetDatabaseItemData(k)
	  --p(linker(itemdb.uniqueID, itemdb.name))
	  EA_ChatWindow.Print(towstring(tostring(link)..tostring(linker(itemdb.uniqueID, itemdb.name)).." Minimum: "..(v.goal)))
	  --  end
	end
  end

end


--[[function table.removekey(table, key)
    local element = table[key]
    table[key] = nil
    return element
end]]

local function percentage(count,goal)
  local percents = ((count - 1) * 100) / (goal - 1)
  return percents
end


local function testlinker(count,goal)
  local linkData = "LINK:"..count..goal
  local data = linkData
  local text = count.." / "..goal
  local color = DefaultColor.MAGENTA
  local link = CreateHyperLink( towstring(data), towstring(text), {color.r, color.g, color.b}, {} )
  return tostring(link)
end

function QuickNameActionsRessurected.ReminderToggle()
  if not WindowGetShowing("QNAlert") then
	TextLogClear("QNAlertTexter")
	WindowSetShowing("QNAlert", true)
  end
  if next(QuickNameActionsRessurected.Settings.Tester) == nil then return end
  for k,v in pairs(QuickNameActionsRessurected.Settings.Tester) do
	tester=DataUtils.FindItem (k)
	local testing2=QuickNameActionsRessurected.ItemLinker
	local percentage=(percentage(tester.stackCount,v.goal))
	--p(percentage)
	if percentage <= 115 then
	  TextLogAddEntry ("QNAlertTexter", 99, towstring(tostring(testing2(tester.uniqueID, tester.name)).." Running low!  Have: "..testlinker(tester.stackCount,v.goal)))
	end
  end
end

function QuickNameActionsRessurected.AddReminder(itemID, goal)
  local itemdb=GetDatabaseItemData(itemID)
  local linker=QuickNameActionsRessurected.ItemLinker
  local flag=false;
  if goal~= nil then
	if not QuickNameActionsRessurected.Settings.Tester[itemID] then
	  QuickNameActionsRessurected.Settings.Tester[itemID] = {}
	  QuickNameActionsRessurected.Settings.Tester[itemID].goal = goal
	  EA_ChatWindow.Print(link..linker(itemdb.uniqueID, itemdb.name)..L" added to reminders. Minimum: "..goal)
	elseif QuickNameActionsRessurected.Settings.Tester[itemID] then
	  if QuickNameActionsRessurected.Settings.Tester[itemID].goal ~= goal then
		QuickNameActionsRessurected.Settings.Tester[itemID].goal = goal
		EA_ChatWindow.Print(link..linker(itemdb.uniqueID, itemdb.name)..L" minimum changed. New Minimum: "..goal)
	  end
	end
  end
  if goal==nil then
	if QuickNameActionsRessurected.Settings.Tester[itemID] then
	  table.removekey(QuickNameActionsRessurected.Settings.Tester,itemID)
	  EA_ChatWindow.Print(link..linker(itemdb.uniqueID, itemdb.name)..L" removed from reminders.")
	end
  end
end
