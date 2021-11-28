warExtendedAutos = warExtended.Register("war Extended Autos")
local Autos = warExtendedAutos
local tostring=tostring
local pairs=pairs

Autos.CustomList = {
  whitelist = {},
  blacklist = {}
}

Autos.Settings = {
  	AutoScenario = {
	  mode = ""
  	},
	AutoRelease = {
	  mode = ""
	},
	AutoReply = {
	  mode = "",
	  text = ""
	},
	PartyAccept = {
	  mode = "",
	  list = ""
	},
	PartyInvite = {
	  mode = "",
	  text = "",
	  channels = ""
	},
	RessurectAccept = {
	  mode = "",
	  list = ""
	}
}

local function getCustomNameWhitelist()
  local customNameList = Autos.CustomList.whitelist
  return customNameList
end

local playerLists = {
  guild = GetGuildMemberData,
  friends = GetFriendsList,
  scenario = GameData.GetScenarioPlayers,
  custom = getCustomNameWhitelist,
}

local function getAllPlayerLists()
  local allPlayerLists = {}

  for _, listFunction in pairs(playerLists) do
	local playerList = listFunction()

	if playerList then
	  for playerData = 1,#playerList do
		allPlayerLists[#allPlayerLists+1] = playerList[playerData]
	  end
	end
  end

	return allPlayerLists
end

 autoModes = {
   autoShorthandles = {
	 acc = "PartyAccept",
	 inv = "PartyInvite",
	 res = "RessurectAccept",
	 rel = "AutoRelease",
	 rep = "AutoReply",
	 sc = "AutoScenario"
   },
  lists = {
	guild = playerLists.guild,
	friends = playerLists.friends,
	scenario = playerLists.scenario,
	custom = playerLists.custom,
	safe = getAllPlayerLists,
	all = ""
  },
  modes = {
	on = true,
	off = false
  },
  text = "",
  channels = "",
}


local function getFullAutoPathFromShorthandle(autoShorthandle)
	local fullAutoName = autoModes.autoShorthandles[autoShorthandle]
   	local fullAutoPath = Autos.Settings[fullAutoName]
	return fullAutoPath
 end

local function isAutoModeOn(autoMode)
  local autoMode = getFullAutoPathFromShorthandle(autoMode)
  local isAutoEnabled = autoMode.mode
  return isAutoEnabled
end

local function getAutoList(autoMode)
  local autoMode = getFullAutoPathFromShorthandle(autoMode)
  local autoList = autoMode.list
  return autoList
end

local function getAutoText(autoMode)
  local autoMode = getFullAutoPathFromShorthandle(autoMode)
  local autoText = autoMode.text
  return autoText
end

local function getPlayerListFromListType(specifiedList)
  local playerList = Autos.CustomList[specifiedList] or autoModes.lists[specifiedList]()
  return playerList
end


local function getNamesFromPlayerList(specifiedList)
  local playerList = getPlayerListFromListType(specifiedList)
  local nameList= {}

  if playerList then
	for playerData=1,#playerList do
	  local playerName = tostring(playerList[playerData].name)
	  nameList[#nameList+1] = playerName
	end
  end

  return nameList
end


local function isPlayerInAutoList(nameToCheck, listType)
  local autoList = getNamesFromPlayerList(listType)
  local isInList = false;

	for _, playerName in pairs(autoList) do
	  local isPlayerInList = Autos:CompareString(nameToCheck, playerName)

	  if isPlayerInList then
		isInList = true;
	  end

	end

  return isInList
end


local function removePlayerFromCustomList(playerName, listType)
  local autoList = getPlayerListFromListType(listType)

  for playerNumber, playerData in pairs(autoList) do
	local isPlayerName = playerData.name == playerName

	if isPlayerName then
	  autoList[playerNumber] = nil
	end

  end

  Autos:Print("Player "..playerName.." removed from custom "..listType..".")
end


local function addPlayerToCustomNameList(playerName, listType)
  local autoList = getPlayerListFromListType(listType)

  if not autoList[#autoList+1] then
	autoList[#autoList+1] = {["name"] = playerName}
  end

  Autos:Print("Player "..playerName.." added to custom "..listType..".")
end

local function getOppositeCustomList(listType)
  local opposite = {
	blacklist = "whitelist",
	whitelist = "blacklist"
  }
  return opposite[listType]
end


local function addOrRemovePlayerFromCustomList(playerName, listType)

  if playerName == "" then
	Autos:Print("Unspecified player name.")
	return
  end

  local isPlayerInList = isPlayerInAutoList(playerName, listType)
  local isPlayerInOppositeList = isPlayerInAutoList(playerName, getOppositeCustomList(listType))

  if isPlayerInList then
	removePlayerFromCustomList(playerName, listType)
	return
  end

  if isPlayerInOppositeList then
	removePlayerFromCustomList(playerName, oppositeList)
  end

  addPlayerToCustomNameList(playerName, listType)
end


function setAutoMode(autoShorthandle, mode)
  local autoMode = autoModes.modes[mode]

  for fullAutoName,_ in pairs(autoModes.autoShorthandles[autoShorthandle]) do
	Autos.Settings[fullAutoName].mode = autoMode
 end
end


local slashCommands =  {
  auto = {
	func = function (autoType, autoState, channels) setAutoMode(autoType, autoState, channels) end,
	desc = "Set your autos: res/rel/acc/sc/inv/rep # friends/guild/sc/safe/all/text # channel"
  },
  autowhite = {
	func = function (playerName) addOrRemovePlayerFromCustomList(playerName, "whitelist") end,
	desc = "Add or remove a player from custom whitelist."
  },
  autoblack = {
	func = function (playerName) addOrRemovePlayerFromCustomList(playerName, "blacklist") end,
	desc = "Add or remove a player from custom blacklist."
  }
}


local function getDialogData()
  local dlgIndex = DialogManager.FindAvailableDialog (DialogManager.twoButtonDlgs, DialogManager.NUM_TWO_BUTTON_DLGS)
  local dialogData = SystemData.Dialogs.AppDlg
  local dialogText = tostring(dialogData.text)
  local partyDialog = dialogText:match("(.+) has invited you")
  local ressurectDialog = dialogText:match("(.+) has offered you")
  return partyDialog, ressurectDialog, dlgIndex
  end


local function onDialogButonAccept(dlgIndex)
  	DialogManager.Update(1)
    DialogManager.twoButtonDlgs[ dlgIndex ].ButtonCallback1()
  	DialogManager.Update(1)
  	DialogManager.ReleaseDialog(DialogManager.twoButtonDlgs[ dlgIndex ], "TwoButtonDlg"..dlgIndex)
  end

local function onDialogButtonDecline(dlgIndex)
  DialogManager.Update(1)
  DialogManager.twoButtonDlgs[ dlgIndex ].ButtonCallback2()
  DialogManager.Update(1)
  DialogManager.ReleaseDialog(DialogManager.twoButtonDlgs[ dlgIndex ], "TwoButtonDlg"..dlgIndex)
end


local function printAutoMessage(autoType, buttonCallbackType, extraText)
  extraText = extraText or ""
  local autoMessages = {
	acc = {
	  accept = "Accepted party invite from "..extraText..".",
	  decline = "Declined party invite from "..extraText.."."
	},
	res = {
	  accept = "Accepted ressurect offer from "..extraText..".",
	  decline = "Declined ressurect offer from "..extraText.."."
	},
	sc = {
	  accept = "Accepted scenario pop.",
	},
	rel = {
	  accept = "Automatic respawn has been triggered.",
	},
	inv = {
	  accept = "Sent group invite to "..extraText..".",
	  decline = "Group invite to ".. extraText.. " not sent."
	}
  }
  local message = autoMessages[autoType][buttonCallbackType]

  if buttonCallbackType == "accept" then
	Autos:Print(message)
  else
  	Autos:Warn(message)
  end

end

local function isPlayerInBlacklist(playerName)
  local isInBlacklist = isPlayerInAutoList(playerName, "blacklist")
  return isInBlacklist
end


local function selectCorrectListBasedButtonCallback(playerName, autoType, dlgIndex)
  local isAutoListSet = getAutoList(autoType) ~= ""

  if isPlayerInBlacklist(playerName) then
	onDialogButtonDecline(dlgIndex)
	printAutoMessage(autoType, "decline", playerName)
	return
  end

  if isAutoListSet then
	autoList = getAutoList(autoType)
	if isPlayerInAutoList(playerName, autoList) then
	  onDialogButonAccept(dlgIndex)
	  printAutoMessage(autoType, "accept", playerName)
	end
	return
  end

  onDialogButonAccept(dlgIndex)
  printAutoMessage(autoType, "accept", playerName)
  return
end


local function onAutoAcceptButtonDialog()
  local isAutoAccOn =  isAutoModeOn("acc")
  local isAutoResOn = isAutoModeOn("res")
  local inviterName, ressurecterName, dlgIndex = getDialogData()

  if isAutoAccOn and inviterName then
	selectCorrectListBasedButtonCallback(inviterName, "acc",dlgIndex)
  elseif isAutoResOn and ressurecterName then
	selectCorrectListBasedButtonCallback(ressurecterName, "res",dlgIndex)
  end
end


local function processDeathWindow()
  local deathWindowID = WindowGetId("DeathWindowRespawnButton")
  DeathWindow.Update(1)
  GameData.DeathRespawnData.selectedId = GameData.DeathRespawnData.Locations[deathWindowID].id
  BroadcastEvent( SystemData.Events.RELEASE_CORPSE )
  Sound.Play( Sound.BUTTON_CLICK )
  DeathWindow.Close()
end


function Autos.OnPlayerDeath()
  if isAutoModeOn("rel") then
	processDeathWindow()
	printAutoMessage("rel", "accept", nil)
  end
end

local function isAutoInviteText(chatText)
local isAutoText = chatText == (getAutoText("inv"))
return isAutoText
end


local function processAutoReply(chatText, senderName)
  if (Autos:IsCorrectChannel("TELL_RECEIVE", "GUILD"))
		  and not isAutoInviteText(chatText) then
	local replyMessage = "Auto-Reply: "..getAutoText("rep")
	Autos:TellPlayer(senderName, replyMessage)
  end
end



local function processAutoInvite(chatText, senderName)
if (Autos:IsCorrectChannel("GUILD", "TELL_RECEIVE"))
		and isAutoInviteText(chatText) then
	if isPlayerInBlacklist(tostring(senderName)) then
	  printAutoMessage("inv", "decline", tostring(senderName))
	else
	  Autos:InvitePlayer(senderName)
	  printAutoMessage("inv", "accept", tostring(senderName))
	end
end
end



function warExtendedAutos.OnChatText()
  local chatText = tostring(GameData.ChatData.text)
  local senderName = GameData.ChatData.name

  if isAutoModeOn("rep") then
	processAutoReply(chatText, senderName)
  end

  if isAutoModeOn("inv") then
	processAutoInvite(chatText, senderName)
  end

end


local function autoAcceptScenario()
  EA_Window_ScenarioLobby.UpdateStartTime( 1 )
  BroadcastEvent( SystemData.Events.SCENARIO_INSTANCE_JOIN_NOW )
  WindowSetShowing("EA_Window_ScenarioJoinPrompt", false)
  LabelSetText( "EA_Window_InScenarioQueueTimer", GetString( StringTables.Default.TEXT_WAITING_ON_PLAYERS ))
  EA_Window_ScenarioLobby.startTime = 0.1
  WindowSetShowing( "EA_Window_ScenarioStarting", true )
end

local function onScenarioDialogButton()
  if isAutoModeOn("sc") then
	autoAcceptScenario()
  end
end


Autos:RegisterSlash(slashCommands, "warext")
Autos:RegisterChat("warExtendedAutos.OnChatText")
Autos:RegisterEvent("player death", "warExtendedAutos.OnPlayerDeath")
Autos:Hook(DialogManager.OnApplicationTwoButtonDialog, onAutoAcceptButtonDialog, true)
Autos:Hook(EA_Window_ScenarioLobby.ShowJoinPrompt, onScenarioDialogButton, true)

