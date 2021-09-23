warExtendedScenario = warExtended.Register("warExtended Scenario")
local Scenario = warExtendedScenario
local CityTracker = EA_Window_CityTracker
local mathfloor = math.floor

local countdownMessages = {
  [30] = "Scenario starting in 30s.",
  [15] = "Scenario starting in 15s.",
  [0] = "Scenario started.",
}

local function das(text)
  SendChatText(towstring(text), L"")
end

function Scenario.GetSCData()
  local scenarioPlayerData = GameData.GetScenarioPlayers()
  local s = ":"
  local e = "#"
  local destro2={}
  local order2={}
  if scenarioPlayerData ~= nil then
	for k,v in pairs(scenarioPlayerData) do
	  local playerDmg = v.damagedealt
	  local playerHealing = v.healingdealt
	  local playerRank = v.rank
	  local playerProt = v.solokills
	  local playerKills = v.groupkills
	  local playerDeaths = v.deaths
	  local playerCareer=v.careerId
	  local playerName = tostring(v.name)

	  if v.realm==1 then
		order2[#order2+1] = playerName..s..playerCareer..s..playerRank..s..
				playerKills..s..playerDeaths..s..playerDmg..s..
				playerHealing..s..playerProt..e
	  elseif v.realm==2 then
		destro2[#destro2+1]=playerName..s..playerCareer..s..playerRank..s..
				playerKills..s..playerDeaths..s..playerDmg..s..
				playerHealing..s..playerProt..e
	  end    end

	p("Order Points: "..GameData.ScenarioData.orderPoints )
	p( "Destruction Points: "..GameData.ScenarioData.destructionPoints)
	p("Time Left: "..tostring(TimeUtils.FormatClock( GameData.ScenarioData.timeLeft ) ))
  else
	p("not in sc")
  end
  local str = table.concat(order2)..table.concat(destro2)
  das(str)
end



--[[function GetSCLink(order, destro, time)
  itemName = tostring(itemName)
  local linkData = tostring("ITEM:"..tostring(id))
  local data = linkData
  local text = "["..itemName.."]"

  local color = DataUtils.GetItemRarityColor( GetDatabaseItemData(id))
  if itemName == "" or itemName == "nil" then
	text = ""
  end
  if text == "[nil]" then
	text = ""
  end
  local itemLink = CreateHyperLink( towstring(data), towstring(text), {color.r, color.g, color.b}, {} )

end
end]]

local function getTimerAlertMessage(timeLeft)
  local timerMessage = countdownMessages[timeLeft]
  return timerMessage
end

local function isCityPreMode()
  for objectiveIndex = 1, CityTracker.NUM_OBJECTIVES do
	for questIndex = 1, CityTracker.NUM_QUESTS do
	  local objectiveData = DataUtils.activeObjectivesData[objectiveIndex]
	  if objectiveData ~= nil then
		local questData = objectiveData.Quest[questIndex]
		if questData ~= nil then
		  local isPreMode = objectiveData.Quest[questIndex].name == L"Prepare for Battle!"
		  local isRunning = objectiveData.timerState == GameData.PQTimerState.RUNNING
		  if isPreMode and isRunning then
			return isPreMode
		  end
		end
	  end
	end
  end
end

local function printTimerAlertMessage(timeLeft)
  local timerMessage = countdownMessages[timeLeft]
  Scenario:Alert(timerMessage)
end


local function onScenarioTimerUpdate(timePassed)
  local isPreMode = GameData.ScenarioData.mode == GameData.ScenarioMode.PRE_MODE
  if isPreMode then
	local timeLeft2 = DataUtils.FormatClock(GameData.ScenarioData.timeLeft)
	local timeLeft = mathfloor(GameData.ScenarioData.timeLeft)+0.5
	local isTimerMessage = getTimerAlertMessage(timeLeft)
	local isTimerMessage2 = getTimerAlertMessage(timeLeft2)
	if isTimerMessage then
	  printTimerAlertMessage(timeLeft)
	  p("tleft1")
	elseif isTimerMessage2 then
	  printTimerAlertMessage(timeLeft2)
	  p("tleft2")
	end
  end
end

local function onCityTimerUpdate(timePassed)
  local isPreMode = isCityPreMode()
  if isPreMode then
	p("premode")
  end
end


function Scenario.OnInitialize()
  Scenario:Hook(EA_Window_CityTracker.Update, onCityTimerUpdate, true)
  Scenario:Hook(EA_Window_ScenarioTracker.Update, onScenarioTimerUpdate, true)
end
