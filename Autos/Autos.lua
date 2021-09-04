warExtendedAutos = warExtended.Register("war Extended Autos")
local Autos = warExtendedAutos

Autos.Settings = {
	Accept = "",
	Invite = "",
	Ressurect = "",
	Release = "",
	Reply = "",
}

local function isPlayerInFriendsList(playerName)
  local friendsList = GetFriendsList()
end

local function isPlayerInGuildRoster(playerName)
	local guildRoster = GetGuildMemberData()
end

local function isPlayerInScenario(playerName)
  local scenarioPlayers = GameData.GetScenarioPlayers()
end

local function autosAutoAcceptScenario()
  oldEA_Window_ScenarioLobbyShowJoinPrompt()
  if Autos.Settings.AutoJoin then
	EA_Window_ScenarioLobby.UpdateStartTime(1)
	BroadcastEvent( SystemData.Events.SCENARIO_INSTANCE_JOIN_NOW )
	EA_Window_ScenarioLobby.UpdateStartTime(200)
  end
end

function Autos.AutoAcceptButtonDialog()
  local serverfriendslist = GetFriendsList()
  local rosterData = GetGuildMemberData()
  local interimPlayerData = GameData.GetScenarioPlayers()
  for k, v in pairs(DialogManager.twoButtonDlgs) do
	DialogManager.Update(1)
	if v.inUse then
	  local texter = tostring(LabelGetText("TwoButtonDlg"..k.."BoxText"))

	  for inviterName in string.gmatch(texter, "(.+) has invited you(.*)") do
		invitee = towstring(inviterName)
		if Autos.Settings.AutoAccept.Friends then
		  if( serverfriendslist ~= nil ) then
			for key, friend in ipairs(serverfriendslist) do
			  local friender = towstring(friend.name)
			  if wstring.match(friender, invitee) then
				DialogManager.twoButtonDlgs[k].ButtonCallback1()
				DialogManager.Update(60)
				EA_ChatWindow.Print(link..L"Party invited accepted from "..invitee..L".")
				return end
			end
		  end
		elseif Autos.Settings.AutoAccept.Guild then
		  if( rosterData ~= nil ) then
			for key, guildie in ipairs(rosterData) do
			  local guildier = towstring(guildie.name)
			  if wstring.match(guildier, invitee) then
				DialogManager.twoButtonDlgs[k].ButtonCallback1()
				DialogManager.Update(60)
				EA_ChatWindow.Print(link..L"Party invited accepted from "..invitee..L".")
				return end
			end
		  end
		elseif Autos.Settings.AutoAccept.Scenario then
		  if( interimPlayerData ~= nil ) then
			for key, scplayer in ipairs(interimPlayerData) do
			  local scplay = towstring(scplayer.name)
			  if wstring.match(scplay, invitee) then
				DialogManager.twoButtonDlgs[k].ButtonCallback1()
				DialogManager.Update(60)
				EA_ChatWindow.Print(link..L"Party invited accepted from "..invitee..L".")
				return end
			end
		  end
		elseif Autos.Settings.AutoAccept.Safe then
		  if( rosterData ~= nil ) then
			for key, guildie in ipairs(rosterData) do
			  local guildier = towstring(guildie.name)
			  if wstring.match(guildier, invitee) then
				DialogManager.twoButtonDlgs[k].ButtonCallback1()
				DialogManager.Update(60)
				EA_ChatWindow.Print(link..L"Party invited accepted from "..invitee..L".")
				return end
			end
		  end
		  if( interimPlayerData ~= nil ) then
			for key, scplayer in ipairs(interimPlayerData) do
			  local scplayer = towstring(friend.name)
			  if wstring.match(scplayer, invitee) then
				DialogManager.twoButtonDlgs[k].ButtonCallback1()
				DialogManager.Update(60)
				EA_ChatWindow.Print(link..L"Party invited accepted from "..invitee..L".")
				return end
			end
		  end
		  if( serverfriendslist ~= nil ) then
			for key, friend in ipairs(serverfriendslist) do
			  local friender = towstring(friend.name)
			  if wstring.match(friender, invitee) then
				DialogManager.twoButtonDlgs[k].ButtonCallback1()
				DialogManager.Update(60)
				EA_ChatWindow.Print(link..L"Party invited accepted from "..invitee..L".")
				return end
			end
		  end
		elseif Autos.Settings.AutoAccept.All then
		  DialogManager.twoButtonDlgs[k].ButtonCallback1()
		  DialogManager.Update(60)
		  EA_ChatWindow.Print(link..L"Party invited accepted from "..invitee..L".")
		  return end
	  end


	  for resserName in string.gmatch(texter, "(.+) has offered you(.*)") do
		local resser=towstring(resserName)

		if Autos.Settings.AutoRes.Friends then
		  if( serverfriendslist ~= nil ) then
			for key, friend in ipairs(serverfriendslist) do
			  local friender = towstring(friend.name)
			  if wstring.match(friender, resser) then
				DialogManager.twoButtonDlgs[k].ButtonCallback1()
				DialogManager.Update(60)
				EA_ChatWindow.Print(link..L"Ressurect accepted from "..resser..L".")
				return end
			end
		  end
		elseif Autos.Settings.AutoRes.Guild then
		  if( rosterData ~= nil ) then
			for key, guildie in ipairs(rosterData) do
			  local guildier = towstring(guildie.name)
			  if wstring.match(guildier, resser) then
				DialogManager.twoButtonDlgs[k].ButtonCallback1()
				DialogManager.Update(60)
				EA_ChatWindow.Print(link..L"Ressurect accepted from "..resser..L".")
				return end
			end
		  end
		elseif Autos.Settings.AutoRes.Scenario then
		  if( interimPlayerData ~= nil ) then
			for key, scplayer in ipairs(interimPlayerData) do
			  local scplay = towstring(scplayer.name)
			  if wstring.match(scplay, resser) then
				DialogManager.twoButtonDlgs[k].ButtonCallback1()
				DialogManager.Update(60)
				EA_ChatWindow.Print(link..L"Ressurect accepted from "..resser..L".")
				return end
			end
		  end
		elseif Autos.Settings.AutoRes.Safe then
		  if( rosterData ~= nil ) then
			for key, guildie in ipairs(rosterData) do
			  local guildier = towstring(guildie.name)
			  if wstring.match(guildier, resser) then
				DialogManager.twoButtonDlgs[k].ButtonCallback1()
				DialogManager.Update(60)
				EA_ChatWindow.Print(link..L"Ressurect accepted from "..resser..L".")
				return end
			end
		  end
		  if( interimPlayerData ~= nil ) then
			for key, scplayer in ipairs(interimPlayerData) do
			  local scplay = towstring(friend.name)
			  if wstring.match(scplay, resser) then
				DialogManager.twoButtonDlgs[k].ButtonCallback1()
				DialogManager.Update(60)
				EA_ChatWindow.Print(link..L"Ressurect accepted from "..resser..L".")
				return end
			end
		  end
		  if( serverfriendslist ~= nil ) then
			for key, friend in ipairs(serverfriendslist) do
			  local friender = towstring(friend.name)
			  if wstring.match(friender, resser) then
				DialogManager.twoButtonDlgs[k].ButtonCallback1()
				DialogManager.Update(60)
				EA_ChatWindow.Print(link..L"Ressurect accepted from "..resser..L".")
				return end
			end
		  end
		elseif Autos.Settings.AutoRes.All then
		  DialogManager.twoButtonDlgs[k].ButtonCallback1()
		  DialogManager.Update(60)
		  EA_ChatWindow.Print(link..L"Ressurect accepted from "..resser..L".")
		  return end
	  end
	end
  end
end

local senderCache = L""

function Autos.ResToggle(input)
  local active=false;

  if input=="" or input==nil or not (input=="all" or input=="friends" or input=="guild" or input=="safe" or input=="sc" or input=="off") then
	for k,v in pairs(Autos.Settings.AutoRes) do
	  if v==true then
		active=true;
		EA_ChatWindow.Print(link..L"Auto-Res mode "..towstring(k)..L" currently active.")
		EA_ChatWindow.Print(link..L"Usage: /qnautores friends/guild/sc/safe/all/off")
	  end
	end
	if not active then
	  EA_ChatWindow.Print(link..L"Usage: /qnautores friends/guild/sc/safe/all/off")
	end
  elseif input=="friends" then
	if not Autos.Settings.AutoRes.Friends then
	  for k,v in pairs(Autos.Settings.AutoRes) do
		if v==true then
		  Autos.Settings.AutoRes[k]=false
		end
	  end
	  Autos.Settings.AutoRes.Friends = true;
	  EA_ChatWindow.Print(link..L"Auto-Res mode [Friends] set to: On")
	else
	  Autos.Settings.AutoRes.Friends = false
	  EA_ChatWindow.Print(link..L"Auto-Res mode [Friends] set to: Off")
	end
  elseif input=="guild" then
	if not Autos.Settings.AutoRes.Guild then
	  for k,v in pairs(Autos.Settings.AutoRes) do
		if v==true then
		  Autos.Settings.AutoRes[k]=false
		end
	  end
	  Autos.Settings.AutoRes.Guild = true;
	  EA_ChatWindow.Print(link..L"Auto-Res mode [Guild] set to: On")
	else
	  Autos.Settings.AutoRes.Guild = false
	  EA_ChatWindow.Print(link..L"Auto-Res mode [Guild] set to: Off")
	end
  elseif input=="safe" then
	if not Autos.Settings.AutoRes.Safe then
	  for k,v in pairs(Autos.Settings.AutoRes) do
		if v==true then
		  Autos.Settings.AutoRes[k]=false
		end
	  end
	  Autos.Settings.AutoRes.Safe = true;
	  EA_ChatWindow.Print(link..L"Auto-Res mode [Safe] set to: On")
	else
	  Autos.Settings.AutoRes.Safe = false
	  EA_ChatWindow.Print(link..L"Auto-Res mode [Safe] set to: Off")
	end
  elseif input=="sc" then
	if not Autos.Settings.AutoRes.Scenario then
	  for k,v in pairs(Autos.Settings.AutoRes) do
		if v==true then
		  Autos.Settings.AutoRes[k]=false
		end
	  end
	  Autos.Settings.AutoRes.Scenario = true;
	  EA_ChatWindow.Print(link..L"Auto-Res mode [Scenario] set to: On")
	else
	  Autos.Settings.AutoRes.Scenario = false
	  EA_ChatWindow.Print(link..L"Auto-Res mode [Scenario] set to: Off")
	end
  elseif input=="all" then
	if not Autos.Settings.AutoRes.All then
	  for k,v in pairs(Autos.Settings.AutoRes) do
		if v==true then
		  Autos.Settings.AutoRes[k]=false
		end
	  end
	  Autos.Settings.AutoRes.All = true;
	  EA_ChatWindow.Print(link..L"Auto-Res mode [All] set to: On")
	else
	  Autos.Settings.AutoRes.All = false
	  EA_ChatWindow.Print(link..L"Auto-Res mode [All] set to: Off")
	end
  elseif input=="off" then
	for k,v in pairs(Autos.Settings.AutoRes) do
	  if v==true then
		active=true;
		Autos.Settings.AutoRes[k]=false
	  end
	end
	if active then
	  EA_ChatWindow.Print(link..L"Auto-Res set to: Off")
	else
	  EA_ChatWindow.Print(link..L"Auto-Res not active.")
	end
  end
end


function Autos.ScToggle(input)
  local active=false;
  if input=="" or input==nil or not (input=="on" or input=="off") then
	if Autos.Settings.AutoJoin then
	  EA_ChatWindow.Print(link..L"Auto-Scenario Join mode is currently enabled.")
	  EA_ChatWindow.Print(link..L"Usage: /qnautosc on/off")
	else
	  EA_ChatWindow.Print(link..L"Auto-Scenario Join mode is currently disabled.")
	  EA_ChatWindow.Print(link..L"Usage: /qnautosc on/off")
	end
  elseif input=="on" then
	if Autos.Settings.AutoJoin then
	  EA_ChatWindow.Print(link..L"Auto-Scenario Join mode is already enabled.")
	else
	  Autos.Settings.AutoJoin=true
	  EA_ChatWindow.Print(link..L"Auto-Scenario Join mode set to enabled.")
	end
  elseif input=="off" then
	if not Autos.Settings.AutoJoin then
	  EA_ChatWindow.Print(link..L"Auto-Scenario Join mode is already disabled.")
	else
	  Autos.Settings.AutoJoin=false
	  EA_ChatWindow.Print(link..L"Auto-Scenario Join mode set to disabled.")
	end
  end
end

function Autos.RespawnToggle(input)
  local active=false;
  if input=="" or input==nil or not (input=="on" or input=="off") then
	if Autos.Settings.AutoRespawn then
	  EA_ChatWindow.Print(link..L"Auto-respawn mode is currently enabled.")
	  EA_ChatWindow.Print(link..L"Usage: /qnautoresp on/off")
	else
	  EA_ChatWindow.Print(link..L"Auto-respawn mode is currently disabled.")
	  EA_ChatWindow.Print(link..L"Usage: /qnautosc on/off")
	end
  elseif input=="on" then
	if Autos.Settings.AutoRespawn then
	  EA_ChatWindow.Print(link..L"Auto-respawn mode is already enabled.")
	else
	  Autos.Settings.AutoRespawn=true
	  EA_ChatWindow.Print(link..L"Auto-respawn mode set to enabled.")
	end
  elseif input=="off" then
	if not Autos.Settings.AutoRespawn then
	  EA_ChatWindow.Print(link..L"Auto-respawn mode is already disabled.")
	else
	  Autos.Settings.AutoRespawn=false
	  EA_ChatWindow.Print(link..L"Auto-respawn mode set to disabled.")
	end
  end
end

function Autos.AutoRespawner()
  if not Autos.Settings.AutoRespawn then return end
  BroadcastEvent( SystemData.Events.RELEASE_CORPSE )
  Sound.Play( Sound.BUTTON_CLICK )
  DeathWindow.Close()
end

function Autos.AccToggle(input)
  local active=false;

  if input=="" or input==nil or not (input=="all" or input=="friends" or input=="guild" or input=="safe" or input=="sc" or input=="off") then
	for k,v in pairs(Autos.Settings.AutoAccept) do
	  if v==true then
		active=true;
		EA_ChatWindow.Print(link..L"Auto-Party accept mode "..towstring(k)..L" currently active.")
		EA_ChatWindow.Print(link..L"Usage: /qnautoacc friends/guild/sc/safe/all/off")
	  end
	end
	if not active then
	  EA_ChatWindow.Print(link..L"Usage: /qnautoacc friends/guild/sc/safe/all/off")
	end
  elseif input=="friends" then
	if not Autos.Settings.AutoAccept.Friends then
	  for k,v in pairs(Autos.Settings.AutoAccept) do
		if v==true then
		  Autos.Settings.AutoAccept[k]=false
		end
	  end
	  Autos.Settings.AutoAccept.Friends = true;
	  EA_ChatWindow.Print(link..L"Auto-Party accept mode [Friends] set to: On")
	else
	  Autos.Settings.AutoAccept.Friends = false
	  EA_ChatWindow.Print(link..L"Auto-Party accept mode [Friends] set to: Off")
	end
  elseif input=="guild" then
	if not Autos.Settings.AutoAccept.Guild then
	  for k,v in pairs(Autos.Settings.AutoAccept) do
		if v==true then
		  Autos.Settings.AutoAccept[k]=false
		end
	  end
	  Autos.Settings.AutoAccept.Guild = true;
	  EA_ChatWindow.Print(link..L"Auto-Party accept mode [Guild] set to: On")
	else
	  Autos.Settings.AutoAccept.Guild = false
	  EA_ChatWindow.Print(link..L"Auto-Party accept mode [Guild] set to: Off")
	end
  elseif input=="safe" then
	if not Autos.Settings.AutoAccept.Safe then
	  for k,v in pairs(Autos.Settings.AutoAccept) do
		if v==true then
		  Autos.Settings.AutoAccept[k]=false
		end
	  end
	  Autos.Settings.AutoAccept.Safe = true;
	  EA_ChatWindow.Print(link..L"Auto-Party accept [Safe] set to: On")
	else
	  Autos.Settings.AutoAccept.Safe = false
	  EA_ChatWindow.Print(link..L"Auto-Party accept mode [Safe] set to: Off")
	end
  elseif input=="sc" then
	if not Autos.Settings.AutoAccept.Scenario then
	  for k,v in pairs(Autos.Settings.AutoAccept) do
		if v==true then
		  Autos.Settings.AutoAccept[k]=false
		end
	  end
	  Autos.Settings.AutoAccept.Scenario = true;
	  EA_ChatWindow.Print(link..L"Auto-Party accept mode [Scenario] set to: On")
	else
	  Autos.Settings.AutoAccept.Scenario = false
	  EA_ChatWindow.Print(link..L"Auto-Party accept mode [Scenario] set to: Off")
	end
  elseif input=="all" then
	if not Autos.Settings.AutoAccept.All then
	  for k,v in pairs(Autos.Settings.AutoAccept) do
		if v==true then
		  Autos.Settings.AutoAccept[k]=false
		end
	  end
	  Autos.Settings.AutoAccept.All = true;
	  EA_ChatWindow.Print(link..L"Auto-Party accept mode [All] set to: On")
	else
	  Autos.Settings.AutoAccept.All = false
	  EA_ChatWindow.Print(link..L"Auto-Party accept mode [All] set to: Off")
	end
  elseif input=="off" then
	for k,v in pairs(Autos.Settings.AutoAccept) do
	  if v==true then
		active=true;
		Autos.Settings.AutoAccept[k]=false
	  end
	end
	if active then
	  EA_ChatWindow.Print(link..L"Auto-Party accept set to: Off")
	else
	  EA_ChatWindow.Print(link..L"Auto-Party accept not active.")
	end
  end
end






function Autos.ReplyToggle(input)
  for k, v in pairs(Autos.NameMap) do
	input = wstring.gsub((towstring(input)), towstring(k), towstring(v()))
  end

  if input==nil or input==L"" or input=="" then
	if Autos.Settings.AutoReply then
	  EA_ChatWindow.Print(link..L"Whisper Auto-Reply mode on.")
	  EA_ChatWindow.Print(link..L"Whisper Auto-Reply message set to: "..towstring(Autos.Settings.AutoReplyMessage))
	  sactive=true;
	else
	  EA_ChatWindow.Print(link..L"Whisper Auto-Reply mode off.")
	end
	EA_ChatWindow.Print(link..L"Usage: /qnautorep text/off")
  elseif input==L"off" then
	if Autos.Settings.AutoReply then
	  Autos.Settings.AutoReply = false;
	  EA_ChatWindow.Print(link..L"Whisper Auto-Reply mode off.")
	else
	  EA_ChatWindow.Print(link..L"Whisper Auto-Reply not active.")
	end
  elseif input~=L"off" and input ~=L"" then
	senderCache = ChatManager.LastTell.name
	Autos.Settings.AutoReply = true;
	Autos.Settings.AutoReplyMessage = input
	EA_ChatWindow.Print(towstring(link)..L"Whisper Auto-Reply mode on.")
	EA_ChatWindow.Print(link..L"Auto-Reply message set to: "..towstring(input))
  end
end




function Autos.InviteToggle(input)
  local sactive=false;
  input=towstring(input)
  local	SplitList = WStringSplit (input, L"#")

  if input==nil or input==L"" or input=="" then
	if Autos.Settings.AutoInvite then
	  EA_ChatWindow.Print(link..L"Whisper Auto-Invite mode on.")
	  sactive=true;
	end
	if Autos.Settings.AutoInviteGuild then
	  EA_ChatWindow.Print(link..L"Guild Auto-Invite mode on.")
	  sactive=true;
	end
	EA_ChatWindow.Print(link..L"Usage: /qnautoinv text/off or /qnautoinv text/off#guild")
  else
	if SplitList[1]==L"off" and not SplitList[2] then
	  if  Autos.Settings.AutoInvite then
		Autos.Settings.AutoInvite = false;
		EA_ChatWindow.Print(link..L"Whisper Auto-Invite mode off.")
	  else
		EA_ChatWindow.Print(link..L"Auto-Invite not active.")
	  end
	elseif SplitList[1]~=nil and not SplitList[2] then
	  if not Autos.Settings.AutoInvite then
		Autos.Settings.AutoInvite = true;
		EA_ChatWindow.Print(link..L"Whisper Auto-Invite mode on.")
		Autos.Settings.AutoInviteMessage = SplitList[1]
		EA_ChatWindow.Print(link..L"Whisper Auto-Invite message key set to: "..SplitList[1])
	  else
		Autos.Settings.AutoInviteMessage = SplitList[1]
		EA_ChatWindow.Print(link..L"Auto-Invite message key set to: "..SplitList[1])
	  end
	elseif SplitList[1]==L"off" and SplitList[2]==L"guild" then
	  Autos.Settings.AutoInviteGuild = false;
	  EA_ChatWindow.Print(link..L"Guild Auto-Invite mode off.")
	elseif SplitList[1]~=nil and SplitList[2]==L"guild" then
	  if not Autos.Settings.AutoInviteGuild then
		Autos.Settings.AutoInviteGuild = true;
		Autos.Settings.AutoInviteGuildMessage = SplitList[1]
		EA_ChatWindow.Print(link..L"Guild Auto-Invite mode on.")
		EA_ChatWindow.Print(link..L"Guild Auto-Invite message key set to: "..SplitList[1])
	  else
		Autos.Settings.AutoInviteGuildMessage = SplitList[1]
		EA_ChatWindow.Print(link..L"Guild Auto-Invite message key set to: "..SplitList[1])
	  end
	end
  end
end

local function isCorrectChannel(channelFilter)
  local currentChatFilter = GameData.ChatData.type
  local desiredFilter = SystemData.ChatLogFilters[channelFilter]
  return currentChatFilter == desiredFilter
end

local function getAutoMessage()

end


local function autosOnChatText()
  local channelType
  local channel = SystemData.ChatLogFilters[channelType]
  local chatText = GameData.ChatData.text
  local textSender = GameData.ChatData.name

  if isCorrectChannel("SAY") then
	p("yes")
  end

  if channel == "SAY" then
	p("yes")
  elseif channel == "GUILD" then
  p('no')
  end
  local word = ("(.*)"..tostring(Autos.Settings.AlertText).."(.*)")
  local autoReply = tostring(Autos.Settings.AutoReplyMessage)
  local autoInvite = tostring(Autos.Settings.AutoInviteMessage)
  p(str)
  p(str2)



  if Autos.Settings.AlertToggle then
  if GameData.ChatData.type ~= SystemData.ChatLogFilters.CHANNEL_9 then
  for text in string.gmatch(str, word) do
  local numEntries = TextLogGetNumEntries( "Chat")
  local timestamp, filterId, text = TextLogGetEntry( "Chat", numEntries - 1)
  TextLogAddEntry ("QNAlertTexter", 99, timestamp..L" "..(Autos.PlayerLinker(sender))..L": "..towstring(str)..L"  /  "..towstring(Autos.JoinLinker(sender))..L" "..towstring(Autos.InviteLinker(sender))..L" "..towstring(Autos.WhisperLinker(sender)))
  Sound.Play(Sound.PLAYER_RECEIVES_TELL)
  end
  end
  end


  if Autos.Settings.AutoInviteGuild then
  if GameData.ChatData.type == SystemData.ChatLogFilters.GUILD then
  if GameData.ChatData.text==Autos.Settings.AutoInviteGuildMessage then
  SendChatText(L"/invite "..sender,L"")
  end
  end
  end

  if Autos.Settings.AutoInvite or Autos.Settings.AutoReply or GetAFKFlag()== true then
  if GameData.ChatData.type == SystemData.ChatLogFilters.TELL_RECEIVE then
  if Autos.Settings.AutoInvite then
  if GameData.ChatData.text==Autos.Settings.AutoInviteMessage then
  SendChatText(L"/invite "..sender,L"")
  end
  end
  if Autos.Settings.AutoReply and not GetAFKFlag() == true then
  SendChatText(L"/tell "..sender..L" "..link..L"Auto Reply: "..towstring(Autos.Settings.AutoReplyMessage), L"")
  end
  if GetAFKFlag() == true then
  afkNote = TextEditBoxGetText("SocialWindowTabOptionsAFKNoteEditBox")
  if afkNote ~= L"" then
  SendChatText(L"/tell "..sender..L" "..afkNote,L"")
  else
  SendChatText(L"/tell "..sender..L" AFK",L"")
  end
  end
  end
  end
  end

local function setAutoStatus(autoType, autoState)
  p(autoType)
  p(autoState)
end


local slashCommands =  {
  auto = {
	func = function (autoType, autoState) setAutoStatus(autoType, autoState) end,
	desc = "Set your autos: res/resp/acc/sc/inv/rep#friends/guild/sc/safe/all or text"
  }
}


Autos:RegisterSlash(slashCommands, "warext")
Autos:Hook(ChatManager.OnChatText,autosOnChatText)
Autos:RegisterEvent("APPLICATION_TWO_BUTTON_DIALOG", "warExtendedAutos.AutoAcceptButtonDialog")

--[[function Autos.AutoPrinter()
  for k,v in pairs(Autos.Settings.AutoRes) do
	if v==true then
	  EA_ChatWindow.Print(link..L"Auto-Res mode ["..towstring(k)..L"] currently enabled.")
	end
  end
  for c,f in pairs(Autos.Settings.AutoAccept) do
	if f==true then
	  EA_ChatWindow.Print(link..L"Auto-Accept mode ["..towstring(c)..L"] currently enabled.")
	end
  end
  EA_ChatWindow.Print(link..L"-----------------")
  EA_ChatWindow.Print(link..L"/qnautores - to set auto-res-accept mode.")
  EA_ChatWindow.Print(link..L"/qnautoresp on/off - to set auto-respawn mode.")
  EA_ChatWindow.Print(link..L"/qnautoacc - to set auto-party-accept mode.")
  EA_ChatWindow.Print(link..L"/qnautosc on/off - to set auto-scjoin mode.")
  EA_ChatWindow.Print(link..L"/qnautoinv text - to set an auto-invite key.")
  EA_ChatWindow.Print(link..L"/qnautorep text - to set an auto-reply message.")
end]]
