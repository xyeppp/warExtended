local warExtended = warExtended

function QuickNameActionsRessurected.newOnHyperLinkRButtonUpChatWindowOnly(linkData, flags, x, y)
  local warbandText = wstring.match (linkData, WARBAND_TAG)
  if warbandText
  then
	linkData = wstring.gsub(linkData, WARBAND_TAG, L"")
	for k, v in pairs(EA_Window_OpenPartyWorld.PartyTable) do
	  for b, f in pairs(EA_Window_OpenPartyWorld.PartyTable[k].Group) do
		if linkData == wstring.match(f.m_memberName, linkData) then
		  if linkData == wstring.match(linkData, EA_Window_OpenPartyWorld.PartyTable[k].leaderName) then
			SendChatText(L"/join "..EA_Window_OpenPartyWorld.PartyTable[k].leaderName, L"")
		  end
		end
	  end
	end
  end
  oldEA_ChatWindowOnHyperLinkRButtonUpChatWindowOnly(linkData, flags, x, y)
end

function QuickNameActionsRessurected.newEA_ChatWindowOnHyperLinkLButtonUp( linkData, flags, x, y )
  local inspectText = wstring.match(linkData, INSPECT_TAG)
  local warbandText = wstring.match (linkData, WARBAND_TAG)
  local tomeLinkText = wstring.match( linkData, DISCORD_TAG )
  local abilityText = wstring.match(linkData, ABILITY_TAG)
  local inviteText = wstring.match(linkData, INVITE_TAG)
  local joinText = wstring.match(linkData, JOIN_TAG)
  local tellText = wstring.match(linkData, WHISPER_TAG)
  local linkText = wstring.match(linkData, LINKER_TAG)

  if linkText
  then
	linkData = wstring.gsub(linkData, LINKER_TAG, L"")
	QuickNameActionsRessurected.OnLinkerLButtonUp(linkData, flags, x, y)
	return
  end

  if inspectText
  then
	QuickNameActionsRessurected.OnInspectLinkLButtonUp(linkData, flags, x, y)
	return
  end


  if tellText
  then
	linkData = wstring.gsub(linkData, WHISPER_TAG, L"")
	QuickNameActionsRessurected.OnTellLinkLButtonUp(linkData, flags, x, y)
	return
  end

  if warbandText
  then
	linkData = wstring.gsub(linkData, WARBAND_TAG, L"")
	QuickNameActionsRessurected.OnWarbandLinkLButtonUp(linkData, flags, x, y)
	return
  end

  if abilityText
  then
	QuickNameActionsRessurected.OnAbilityLinkLButtonUp(linkData, flags, x, y)
	return
  end

  if tomeLinkText
  then
	tomelink = true;
	QuickNameActionsRessurected.newEA_ChatWindowOnTomeLinkLButtonUp( linkData, flags, x, y )
	return
  end

  if joinText
  then
	linkData = wstring.gsub(linkData, JOIN_TAG, L"")
	joinlink = linkData
	QuickNameActionsRessurected.OnJoinLinkLButtonUp(linkData, flags, x, y)
	return
  end


  if inviteText
  then
	linkData = wstring.gsub(linkData, INVITE_TAG, L"")
	QuickNameActionsRessurected.OnInviteLinkLButtonUp(linkData, flags, x, y)
	return
  end
  oldEA_ChatWindowOnHyperLinkLButtonUp( linkData, flags, x, y )
end

function QuickNameActionsRessurected.OnTellLinkLButtonUp(linkData, flags, x, y)
  whisperPrompt = EA_ChatWindow.FormatWhisperPrompt (linkData)
  EA_ChatWindow.SwitchToChatChannel (SystemData.ChatLogFilters.TELL_SEND, whisperPrompt, L"")
  EA_ChatWindow.InsertText(L"")
end

function QuickNameActionsRessurected.URLLinker(input)
  local linkData = "LINK:"..input
  local data = linkData
  local text = input
  local color = DefaultColor.LIGHT_BLUE
  local link = CreateHyperLink( towstring(data), towstring(text), {color.r, color.g, color.b}, {} )
  return towstring(link)
end

function QuickNameActionsRessurected.OnInspectLinkLButtonUp(linkData, flags, x, y)
  linkData = wstring.gsub(linkData, INSPECT_TAG, L"")
  local QNAequippedData = GetEquipmentData()
  local itemData = {}
  itemData = QNAequippedData


  SendChatText(L"/tell "..linkData..L" Body: "..QuickNameActionsRessurected.ItemLinker(itemData[9].uniqueID, itemData[9].name)..QuickNameActionsRessurected.ItemLinker(itemData[10].uniqueID, itemData[10].name)..QuickNameActionsRessurected.ItemLinker(itemData[13].uniqueID, itemData[13].name)..QuickNameActionsRessurected.ItemLinker(itemData[6].uniqueID, itemData[6].name)..QuickNameActionsRessurected.ItemLinker(itemData[7].uniqueID, itemData[7].name)..QuickNameActionsRessurected.ItemLinker(itemData[14].uniqueID, itemData[14].name)..QuickNameActionsRessurected.ItemLinker(itemData[8].uniqueID, itemData[8].name)..L" Weapons: "..QuickNameActionsRessurected.ItemLinker(itemData[1].uniqueID, itemData[1].name)..QuickNameActionsRessurected.ItemLinker(itemData[2].uniqueID, itemData[2].name)..QuickNameActionsRessurected.ItemLinker(itemData[3].uniqueID, itemData[3].name)..QuickNameActionsRessurected.ItemLinker(itemData[4].uniqueID, itemData[4].name)..QuickNameActionsRessurected.ItemLinker(itemData[5].uniqueID, itemData[5].name)..L" Jewelry: "..QuickNameActionsRessurected.ItemLinker(itemData[17].uniqueID, itemData[17].name)..QuickNameActionsRessurected.ItemLinker(itemData[18].uniqueID, itemData[18].name)..QuickNameActionsRessurected.ItemLinker(itemData[19].uniqueID, itemData[19].name)..QuickNameActionsRessurected.ItemLinker(itemData[20].uniqueID, itemData[20].name), L"")
end

function QuickNameActionsRessurected.OnLinkerLButtonUp( linkData, flags, x, y )
  if( WindowGetShowing( "EA_TextEntryGroupEntryBox" ) == false )
  then
	EA_ChatWindow.SwitchChannelWithExistingText( linkData)
  else
	TextEditBoxInsertText( "EA_TextEntryGroupEntryBoxTextInput", L" "..linkData )
  end
end


function QuickNameActionsRessurected.OnMacroLinkLButtonUp( linkData, flags, x, y )
  if( WindowGetShowing( "EA_TextEntryGroupEntryBox" ) == false )
  then
	EA_ChatWindow.SwitchChannelWithExistingText(linkData)
  else
	TextEditBoxInsertText( "EA_TextEntryGroupEntryBoxTextInput", L" "..linkData )
  end
end

function QuickNameActionsRessurected.PlayerLinker(input)
  local linkData = tostring(L"PLAYERNS:"..input)
  local data = linkData
  local text = L"["..input..L"]"
  local color = DefaultColor.LIGHT_BLUE
  local link = CreateHyperLink( towstring(data), towstring(text), {color.r, color.g, color.b}, {} )
  return link
end

function QuickNameActionsRessurected.OnJoinLinkLButtonUp(linkData, flags, x, y)
  local  invlink= towstring(QuickNameActionsRessurected.InviteLinker(GameData.Player.name))
  local levelmsg=  towstring(QuickNameActionsRessurected.QNAmessage())
  local openWB = false;
  for k, v in pairs(EA_Window_OpenPartyWorld.PartyTable) do
	if linkData == wstring.match(linkData, EA_Window_OpenPartyWorld.PartyTable[k].leaderName) then
	  SendChatText(L"/join "..linkData, L"")
	  openWB=true;
	  return end
  end
  if not openWB then
	SendChatText(L"/tell "..linkData..L" "..invlink..L" - "..levelmsg, L"")
  end
end

function QuickNameActionsRessurected.OnInviteLinkLButtonUp(linkData, flags, x, y)
  return SendChatText(L"/invite "..linkData, L"")
end


function QuickNameActionsRessurected.IconLinker(id)
  local icon=(id)
  local linkData= tostring("ICON:"..tostring(icon))
  local data=linkData
  local text="<icon"..icon..">"
  if icon==0 then
	text=""
  end
  return text
end

function QuickNameActionsRessurected.ItemLinker(id, itemName)
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
  local iconer=GetDatabaseItemData(id)
  local icon=iconer.iconNum


  if not QuickNameActionsRessurected.Settings.ItemIcons then
	return towstring(itemLink)
  else return towstring(towstring(QuickNameActionsRessurected.IconLinker(icon))..towstring((itemLink)))
  end
end

function QuickNameActionsRessurected.OnAbilityLinkLButtonUp(linkData, flags, x, y)
  if WindowGetShowing("DefaultTooltip") then
	WindowSetShowing("DefaultTooltip", false)
  else
	local mouseOverWindow = SystemData.ActiveWindow.name
	local anchor = Tooltips.ANCHOR_CURSOR
	linkData = wstring.gsub(linkData, ABILITY_TAG, L"")
	local dasTexter=GetAbilityName(tonumber(linkData))
	local	SplitList = WStringSplit (linkData, L"#")
	local dasTest = tonumber(SplitList[1])
	local abilityData = GetAbilityData(tonumber(SplitList[1]))
	local extraText = GetAbilityDesc(dasTest, 40)
	local extraTextColor = 255, 0, 255
	if SplitList[2] then
	  texter2 = L"<icon"..SplitList[2]..L"> "..GetAbilityName(dasTest)
	elseif not SplitList[2] then
	  texter2 = dasTexter
	end
	local ID = L"ID: "..dasTest
	Tooltips.CreateTextOnlyTooltip( SystemData.ActiveWindow.name, nil)
	Tooltips.SetTooltipColor(1, 1, 255, 255, 0)
	Tooltips.SetTooltipText (1, 1, texter2) --Topleft name
	Tooltips.SetTooltipColor (2, 1, 255, 255, 255)
	Tooltips.SetTooltipText (2, 1, towstring(extraText))
	Tooltips.SetTooltipActionText( ID ) --topright
	Tooltips.AnchorTooltip(anchor)
	Tooltips.Finalize()
  end
end

function QuickNameActionsRessurected.newAbilitiesWindowActionLButtonDown(flags, x, y)
  local abilityData = AbilitiesWindow.abilityData[ AbilitiesWindow.GetAbilityFromMouseOverEntry() ]
  local mode = AbilitiesWindow.currentMode
  local filter = AbilitiesWindow.FilterTabSelected[mode]

  if( abilityData ~= nil) and (mode ~= AbilitiesWindow.Modes.MODE_GENERAL_ABILITIES)
  then

	-- Create Chat HyperLinks on Shift-Left-Button-Down
	if( flags == SystemData.ButtonFlags.SHIFT )
	then
	  QuickNameActionsRessurected.InsertAbilityLink( abilityData )
	  return
	end
  end
  -- call original hook
  oldAbilitiesWindowActionLButtonDown(flags, x, y)
end


function QuickNameActionsRessurected.InsertAbilityLink( abilityData )
  if( abilityData == nil )
  then
	return
  end
  local text = L"["..abilityData.name..L"]"
  local icon=  abilityData.iconNum
  local data = ABILITY_TAG..abilityData.id..L"#"..icon
  local color = DefaultColor.LIGHT_BLUE
  local link = CreateHyperLink( data, text, {color.r, color.g, color.b}, {} )

  EA_ChatWindow.InsertText( towstring(link ))
end

function QuickNameActionsRessurected.WarbandLinker(input)
  local gtype = getGroupType()
  if gtype == 3 then
	local warband = GetBattlegroupMemberData()
	for k, v in ipairs(warband) do -- Schleife bilden, um die Gruppen auszulesen
	  for l, z in ipairs(v.players) do -- Schleife um die einzelnen Mitglieder der Gruppe zu durchsuchen
		if z.isGroupLeader == true then -- Ist das Gruppenmmitglied Leader ?
		  --DebugText(L"Found Leader")
		  input = z.name
		end
	  end
	end
  end

  if input == nil or input == "" or input == L"" then
	input = GameData.Player.name
  end
  local linkData = tostring("WARBAND:"..tostring(input))
  local data = linkData
  local text = tostring("[Warband]")
  local color = DefaultColor.GREEN
  local link = CreateHyperLink( towstring(data), towstring(text), {color.r, color.g, color.b}, {} )
  QuickNameActionsRessurected.Warband = link
  return QuickNameActionsRessurected.Warband
end

function QuickNameActionsRessurected.newEA_ChatWindowOnTomeLinkLButtonUp( linkData, flags, x, y )
  if tomelink then
	if( WindowGetShowing( "EA_TextEntryGroupEntryBox" ) == false )
	then
	  EA_ChatWindow.SwitchChannelWithExistingText( linkData)
	  tomelink = false;
	else
	  TextEditBoxInsertText( "EA_TextEntryGroupEntryBoxTextInput", L" "..linkData )
	  tomelink = false;
	end
	return end
  oldEA_ChatWindowOnTomeLinkLButtonUp(linkData, flags, x, y)
end


function QuickNameActionsRessurected.newEA_ChatWindowOnPlayerLinkLButtonUp(playerName, flags, x, y )
  --left click hook for player links
  if flags == 4 then
	--shift to social search
	SocialSearcher(playerName)
  elseif flags == 8 then
	--ctrl to invite to group
	SendChatText(L"/invite "..playerName, L"")
  elseif flags == 32 then
	--alt to friend list
	SendChatText(L"/friend "..playerName, L"")
  else
	--old
	oldEA_ChatWindowOnPlayerLinkLButtonUp(playerName, flags, x, y )
  end
end

function QuickNameActionsRessurected.newEA_ChatWindowOnPlayerLinkRButtonUp(playerName, flags, x, y, wndGroupId)
  local tellmsg1 = QuickNameActionsRessurected.Settings.tellMessage1
  local tellmsg2 = QuickNameActionsRessurected.Settings.tellMessage2

  if flags == 8 then
	--ctrl right click to join group
	SendChatText(L"/join "..playerName, L"")
  elseif flags == 4 then
	--shift right click to tellmsg1
	SendChatText(L"/tell "..playerName..L" "..towstring(tellmsg1), L"")
  elseif flags == 32 then
	--alt right click to tellmsg2
	SendChatText(L"/tell "..playerName..L" "..towstring(tellmsg2), L"")
  else
	--old behaviour
	oldEA_ChatWindowOnPlayerLinkRButtonUp(playerName, flags, x, y, wndGroupId)
  end
end

function QuickNameActionsRessurected.JoinLinker(input)
  local gtype = getGroupType()
  if gtype == 3 then
	local warband = GetBattlegroupMemberData()
	for k, v in ipairs(warband) do -- Schleife bilden, um die Gruppen auszulesen
	  for l, z in ipairs(v.players) do -- Schleife um die einzelnen Mitglieder der Gruppe zu durchsuchen
		if z.isGroupLeader == true then -- Ist das Gruppenmmitglied Leader ?
		  --DebugText(L"Found Leader")
		  input = z.name
		end
	  end
	end
  elseif gtype==2 then
	local group= GetGroupData()
	for k, v in ipairs(group) do
	  if v.isMainAssist==true then
		input=v.name
	  end
	end
  elseif gtype==0 then
	input=GameData.Player.name
  end


  if input == nil or input == "" or input == L"" then
	input = GameData.Player.name
  end

  local linkData = tostring(L"JOIN:"..input)
  local data = linkData
  local text = L"[Join]"
  local color = DefaultColor.TEAL
  local link = CreateHyperLink( towstring(data), towstring(text), {color.r, color.g, color.b}, {} )
  return link
end


function QuickNameActionsRessurected.InviteLinker(input)
  local linkData = tostring(L"INVITE:"..input)
  local data = linkData
  local text = L"[Invite]"
  local color = DefaultColor.MAGENTA
  local link = CreateHyperLink( towstring(data), towstring(text), {color.r, color.g, color.b}, {} )
  invitelink = link
  return link
end

function QuickNameActionsRessurected.WhisperLinker(input)
  local linkData = tostring(L"WHISPER:"..input)
  local data = linkData
  local text = L"[Tell]"
  local color = DefaultColor.RARITY_ARTIFACT
  local link = CreateHyperLink( towstring(data), towstring(text), {color.r, color.g, color.b}, {} )
  return link
end



function QuickNameActionsRessurected.DiscordLinker()
  --prints your discord
  local linkData = tostring("discord.gg/"..tostring(QuickNameActionsRessurected.Settings.discorder))
  local data = linkData
  local text = linkData
  local color = DefaultColor.LIGHT_BLUE
  local link = CreateHyperLink( towstring(data), towstring(text), {color.r, color.g, color.b}, {} )
  QuickNameActionsRessurected.Settings.discord = link
  olddiscer = link
  return QuickNameActionsRessurected.Settings.discord
end

function QuickNameActionsRessurected.InspectLinker(input)
  local linkData = L"INSPECT:"..input
  local data = linkData
  local text = L"[Inspect]"
  local color = DefaultColor.GOLD
  local link = CreateHyperLink( towstring(data), towstring(text), {color.r, color.g, color.b}, {} )
  return link
end

function QuickNameActionsRessurected.GuildLinker()
  local guildData = GetDatabaseGuildData( GameData.Guild.m_GuildID)
  local data = L"GUILD:"..guildData.id
  local text = L"["..guildData.name..L"]"
  local color = DefaultColor.ORANGE
  if guildData.name == L"" or GameData.Guild.m_GuildID==0 then
	text = L"[Guildless]"
	data = L"GUILD:999999999"
  end
  local link = CreateHyperLink( data, text, {color.r, color.g, color.b}, {} )
  --  QuickNameActionsRessurected.Settings.GuildLink = link
  return link
end