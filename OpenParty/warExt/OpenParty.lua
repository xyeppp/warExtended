local function OpenPartySearcher(linkData)
  local tanks = 0
  local healers = 0
  local dps = 0
  local TOOLTIP_WIN = "EA_Tooltip_OpenPartyWorld"
  if WindowGetShowing("EA_Tooltip_OpenPartyWorld") then
	WindowSetShowing("EA_Tooltip_OpenPartyWorld", false)
  else
	if search then
	  for k, v in ipairs(EA_Window_OpenPartyWorld.PartyTable) do
		for b, f in pairs(EA_Window_OpenPartyWorld.PartyTable[k].Group) do
		  if linkData == wstring.match(f.m_memberName, linkData) then
			local group = EA_Window_OpenPartyWorld.PartyTable[k].Group
			for list, _ in ipairs(group) do
			  local WBrole = QuickNameActionsRessurected.careerToArchetype2[_.m_careerID]
			  if WBrole == "healers" then healers = healers + 1 end
			  if WBrole == "tanks" then tanks = tanks + 1 end
			  if WBrole == "rdps" or WBrole == "mdps" then dps = dps + 1 end
			end
			foundmatch = true;
			local anchorWindow = Tooltips.ANCHOR_CURSOR
			EA_Window_OpenPartyWorld.CreateOpenPartyTooltip( EA_Window_OpenPartyWorld.PartyTable[k], SystemData.MouseOverWindow.name, anchorWindow )
			search = false;
			if (EA_Window_OpenPartyWorld.PartyTable[k].isWarband == true)
			then
			  local warbandColor = EA_Window_OpenParty.WarbandTextColor
			  LabelSetText (TOOLTIP_WIN.."PartyTypeText", EA_Window_OpenPartyWorld.PartyTable[k].leaderName..L"'s "..GetStringFromTable("SocialStrings", StringTables.Social.LABEL_SOCIAL_TYPE_BATTLEGROUP))
			  LabelSetTextColor(TOOLTIP_WIN.."PartyTypeText", warbandColor.r, warbandColor.b, warbandColor.g)
			else
			  LabelSetText (TOOLTIP_WIN.."PartyTypeText", EA_Window_OpenPartyWorld.PartyTable[k].leaderName..L"'s "..GetStringFromTable("SocialStrings", StringTables.Social.LABEL_SOCIAL_TYPE_GROUP))
			  LabelSetTextColor(TOOLTIP_WIN.."PartyTypeText", 253, 253, 253)
			end
		  end
		end
		LabelSetText (TOOLTIP_WIN.."SpecificInterest2", QNAtankIcon..L" Tanks: "..tanks..L"  "..QNAdpsIcon..L" DPS: "..dps..L"  "..QNAhealIcon..L" Healers: "..healers)
	  end
	end
  end
end

function QuickNameActionsRessurected.OnWarbandLinkLButtonUp(linkData, flags, x, y)
  local linker = linkData
  local foundmatch = false;
  search = true;
  OpenPartySearcher(linkData)
end

function QuickNameActionsRessurected.PartyJoiner(id)
  if EA_Window_OpenPartyNearbyList.PopulatorIndices== nil then return end
  --  if not WindowGetShowing("EA_Window_OpenPartyTab") then return end
  QNAwindowId = WindowGetId( SystemData.ActiveWindow.name )
  QNAdataId = EA_Window_OpenPartyNearbyList.PopulatorIndices[ QNAwindowId ]
  QNAgroupData = EA_Window_OpenPartyNearby.OpenPartyTable[ QNAdataId ]
  QNApartyButton="EA_Window_OpenPartyNearbyListRow"..QNAwindowId.."JoinPartyButton"
  --p(QNAgroupData)
  p("ID"..QNAwindowId)
  p("dataID"..QNAdataId)
  p(QNApartyButton)

  if QNAgroupData.numGroupMembers==24 and not QuickNameActionsRessurected.Settings.PartyJoinerStart then
	WindowStartAlphaAnimation( QNApartyButton, Window.AnimationType.LOOP, 0.1, 1.0, 0.75, false, 0.5, 0)
	ButtonSetText(QNApartyButton, L"In Queue")
	QNApassID=QNAdataId
	QNApassButton=QNApartyButton
	QuickNameActionsRessurected.Settings.PartyJoinerStart=true;
  elseif QuickNameActionsRessurected.Settings.PartyJoinerStart and QNAgroupData.numGroupMembers==24 then
	QuickNameActionsRessurected.Settings.PartyJoinerStart=false;
	ButtonSetText(QNApartyButton, L"Join")
	WindowStopAlphaAnimation( QNApartyButton)

  end
  oldEA_Window_OpenPartyNearbyJoinPartySpecified ()
end

function QuickNameActionsRessurected.newEA_Window_OpenPartyOnShown()
  if QuickNameActionsRessurected.Settings.PartyJoinerStart then
	WindowStartAlphaAnimation( QNApassButton, Window.AnimationType.LOOP, 0.1, 1.0, 0.75, false, 0.5, 0)
	ButtonSetText(QNApassButton, L"In Queue")
  end
  p("test")
  oldEA_Window_OpenPartyOnShown()
end

function QuickNameActionsRessurected.PartyStarter(timeElapsed)
  if EA_Window_OpenPartyNearbyList.PopulatorIndices== nil then return end
  if not QuickNameActionsRessurected.Settings.PartyJoinerStart then return end
  ButtonSetText(QNApassButton, L"In Queue")
  updateCounter=updateCounter+timeElapsed
  testerCounter=testerCounter+timeElapsed
  queueCounter=(queueCounter+timeElapsed)
  p(queueCounter)
  QNAgroupData = EA_Window_OpenPartyNearby.OpenPartyTable[ QNApassID ]

  if testerCounter>=1 then
	LabelSetText("QNAQueueText", L"In Queue: "..QNAgroupData.leaderName..L"'s Warband "..TimeUtils.FormatTime((queueCounter)))
	testerCounter=0
  end


  if updateCounter >=5 then
	SendOpenPartySearchRequest(1)
	--for k,v in ipairs(QNAgroupData) do
	p(updateCounter)
	p(QNAgroupData.leaderName)
	p(QNAgroupData.numGroupMembers)
	--  p(QNAgroupData)
	if QNAgroupData.numGroupMembers~=24 then
	  p(QNAgroupData.leaderName)
	  local text = L"/partyjoin "..QNAgroupData.leaderName
	  if( QNAgroupData.isWarband == true )
	  then
		text = L"/warbandjoin "..QNAgroupData.leaderName
	  end
	  SendChatText( text, L"" )
	  EA_Window_OpenParty.ToggleFullWindow()
	  WindowStopAlphaAnimation(QNApassButton)
	  --  ButtonSetText(QNApassButton, L"Join")
	  p(QuickNameActionsRessurected.Settings.PartyJoinerStart)
	  QuickNameActionsRessurected.Settings.PartyJoinerStart=false;
	  ButtonSetText(QNApassButton, L"Join")
	  --end
	end
	timeElapsed=0
	updateCounter=0
  end

end

oldEA_Window_OpenPartyNearbyJoinPartySpecified = EA_Window_OpenPartyNearby.JoinPartySpecified
oldEA_Window_OpenPartyOnShown = EA_Window_OpenParty.OnShown



