warExtendedAutos = warExtended.Register("war Extended Autos")
local Autos = warExtendedAutos
local tostring=tostring

Autos.CustomList = {
  Whitelist = {},
  Blacklist = {}
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

local function getCustomNameList()
  local customNameList = Autos.CustomNameList
  return customNameList
end

 autoModes = {
  list = {
	guild = GetGuildMemberData,
	friends = GetFriendsList,
	scenario = GameData.GetScenarioPlayers,
	custom = getCustomNameList
  },
  mode = {
	safe = "safe",
	all = "all",
	guild = "guild",
	scenario = "scenario",
	custom = "custom",
	on = true,
	off = false
  },
  text = "",
  channels = "",
}

 autoData = {
  acc = {PartyAccept = autoModes},
  inv = {PartyInvite = autoModes},
  res = {RessurectAccept = autoModes},
  rel = {AutoRelease = autoModes},
  rep = {AutoReply = autoModes},
  sc = {AutoScenario = autoModes}
}


 function getFullAutoPath(shorthandle)
  local fullAutoName = autoData[shorthandle]
   for name,_ in pairs(fullAutoName) do
	 local fullAutoPath = Autos.Settings[name]
	 return fullAutoPath
   end
end

 function getAutoPlayerList(specifiedList)
  local playerList = autoModes.list[specifiedList]()
  return playerList
end


 function getNamesFromAutoPlayerList(specifiedList)
  local playerList = getAutoPlayerList(specifiedList)
  local nameList= {}

  if playerList then
	for playerData=1,#playerList do
	  local playerName = tostring(playerList[playerData].name)
	  nameList[#nameList+1] = playerName
	end
  end

  return nameList
end


 function getNamesFromAllAutoPlayerLists()
   local nameList = {}

  for playerList,_ in pairs(autoModes.list) do
	local list = getNamesFromAutoPlayerList(playerList)
	for player=1,#list do
	  nameList[#nameList+1] = list[player]
	end
  end

  return nameList
end


local function isModeAList(mode)
  for list,_ in pairs(autoModes.list) do
	local isList = mode == list
	if isList then
	  return isList
	end
  end
end


  function getNameListFromAutoMode(autoMode)
	local isSafeMode = autoMode == "safe"

	if isSafeMode then
	  local autoNameList = getNamesFromAllAutoPlayerLists()
	  return autoNameList
	elseif isModeAList(autoMode) then
	  local autoNameList = getNamesFromAutoPlayerList(autoMode)
	  return autoNameList
	end

 end


function isPlayerInAutoModeList(playerName, autoMode)
  local isAllMode = (autoMode == nil or autoMode == "all")
  local autoModeNameList = getNameListFromAutoMode(autoMode)

  if isAllMode then
	return isAllMode
  end

  for name=1,#autoModeNameList do
	local nameToCheck = autoModeNameList[name]
	local isInList = Autos:CompareString(playerName, nameToCheck)

	if isInList then
	  return isInList
	end

  end
end


function getAutoMode(autoShorthandle)
  local autoPath = getFullAutoPath(autoShorthandle)
  local autoMode = autoPath.mode
  return autoMode
end

local function isModeValid(autoShorthandle, autoMode)
  for autoName,autoModes in pairs(autoData[autoShorthandle]) do
	for _, modes in pairs(autoModes) do
	  local isValid = modes == autoMode

	  if isValid then
		return isValid
	  end

	end
  end
end


function setAutoMode(autoShorthandle, autoMode,...)
  if not autoData[autoShorthandle] then
	return d("unknown type")
  end

  local isValidMode = isModeValid(autoShorthandle, autoMode)
  if not isValidMode then
	return
  end

  local currentAutoMode = getAutoMode(autoShorthandle)
  local isCurrentMode = currentAutoMode == autoMode


end



local function getAutoMessage()

end


function warExtendedAutos.OnChatText()
  local chatText = GameData.ChatData.text
  local playerName = GameData.ChatData.name

	if Autos:IsCorrectChannel("GUILD") then
	  p("yes")
  end

end



local slashCommands =  {
  auto = {
	func = function (autoType, autoState) setAutoStatus(autoType, autoState) end,
	desc = "Set your autos: res/resp/acc/sc/inv/rep#friends/guild/sc/safe/all/text#channel"
  }
}



Autos:RegisterSlash(slashCommands, "warext")
--Autos:RegisterChat("warExtendedAutos.OnChatText")
Autos:RegisterEvent("APPLICATION_TWO_BUTTON_DIALOG", "warExtendedAutos.AutoAcceptButtonDialog")









--[[local function autosAutoAcceptScenario()
  oldEA_Window_ScenarioLobbyShowJoinPrompt()
  if Autos.Settings.AutoJoin then
	EA_Window_ScenarioLobby.UpdateStartTime(1)
	BroadcastEvent( SystemData.Events.SCENARIO_INSTANCE_JOIN_NOW )
	EA_Window_ScenarioLobby.UpdateStartTime(200)
  end
end


local function getAutoFromDialogButtonText()
 -- DialogManager.Update(1)
  for dialogNumber=1,#DialogManager.twoButtonDlgs do
	local dialogData = DialogManager.twoButtonDlgs[dialogNumber]
	p(dialogData)
	--if v.inUse then
	  --local texter = tostring(LabelGetText("TwoButtonDlg"..k.."BoxText"))

	--inviterName in string.gmatch(texter, "(.+) has invited you(.*)") do
	-- for resserName in string.gmatch(texter, "(.+) has offered you(.*)") do
  end
end


function Autos.AutoAcceptButtonDialog()
  local serverfriendslist = GetFriendsList()
  local rosterData = GetGuildMemberData()
  local interimPlayerData = GameData.GetScenarioPlayers()
  p("yes")
end


function Autos.AutoRespawner()
  if not Autos.Settings.AutoRespawn then return end
  BroadcastEvent( SystemData.Events.RELEASE_CORPSE )
  Sound.Play( Sound.BUTTON_CLICK )
  DeathWindow.Close()
end]]
