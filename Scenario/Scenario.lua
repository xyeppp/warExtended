local function das(text)
  SendChatText(towstring(text), L"")
end

function GetSCData()
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



function GetSCLink(order, destro, time)
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

  if not QuickNameActionsRessurected.Settings.ItemIcons then
	return towstring(itemLink)
  else return towstring(towstring(QuickNameActionsRessurected.IconLinker(id))..towstring((itemLink)))
  end
end
