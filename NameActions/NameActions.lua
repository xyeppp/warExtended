function QuickNameActionsRessurected.OnLoad()
  while GameData.Player.career.line==0 or GameData.Player.career.line==nil do return end
  --if firstLoad == true then
  QuickNameActionsRessurected.setHook()
  --end
end

local function OnEnterOnce()
  while GameData.Player.career.line==0 or GameData.Player.career.line==nil do return end
  if firstLoad then return end
  QuickNameActionsRessurected.MessageMaker()
  QuickNameActionsRessurected.MasteryMessageMaker()
  firstLoad = true;
  loadedFull=true;
end

function QuickNameActionsRessurected.OnLoadFull()
  while GameData.Player.career.line==0 or GameData.Player.career.line==nil do return end
  if DataUtils.IsWorldLoading() == true then return end
  --if not firstLoad then return end
  if firstLoad == true then
	firstLoad = false
	--  if careerCache == nil or careerCache ~= GameData.Player.career.line or careerCache == 0 then
	OnEnterOnce()
	-- end
  end
end


--update level count
function QuickNameActionsRessurected.OnLevel()
  if DataUtils.IsWorldLoading() == true then return end
  --  if firstLoadMessage then return end
  levelChanged = true;
  QuickNameActionsRessurected.MessageMaker()
end

--update respec count
function QuickNameActionsRessurected.OnRespec()
  if DataUtils.IsWorldLoading() == true then return end
  -- if firstLoadMessage then return end
  masteryChanged = true;
  QuickNameActionsRessurected.MasteryMessageMaker()
end

function QuickNameActionsRessurected.MessageMaker()
  while GameData.Player.career.line==0 or GameData.Player.career.line==nil do return end
  if DataUtils.IsWorldLoading() == true then return end
  if QuickNameActionsRessurected.Settings.Career == 0 or QuickNameActionsRessurected.Settings.Career == nil then
	QuickNameActionsRessurected.Settings.Career = GameData.Player.career.line
  end
  local career = GameData.Player.career.line
  if careerCache ~= QuickNameActionsRessurected.Settings.Career or career ~= QuickNameActionsRessurected.Settings.Career or QuickNameActionsRessurected.Settings.Career == nil or QuickNameActionsRessurected.Settings.Career == 0 then
	QuickNameActionsRessurected.Settings.Career = GameData.Player.career.line
	career=QuickNameActionsRessurected.Settings.Career
  end
  -- while GameData.Player.career.line==0 or GameData.Player.career.line==nil do return end
  local QNAiconID = L"<icon"..Icons.GetCareerIconIDFromCareerLine(career)..L">"
  local QNAcareerName = QuickNameActionsRessurected.careerToArchetype[career]
  local QNArenownLevel = GameData.Player.Renown.curRank
  local QNArankLevel = GameData.Player.level
  oldQNAlevel= GameData.Player.level
  oldQNArenownLevel = GameData.Player.Renown.curRank
  local QNArankID = L"<icon41>"
  local QNArenownID = L"<icon45>"
  if QNArankLevel == 40 then
	QNAmessage = QNAiconID..L" "..QNAcareerName..L" "..QNArenownID..L" "..QNArenownLevel
  else
	QNAmessage = QNAiconID..L" "..QNAcareerName..L" "..QNArankID..L" "..QNArankLevel..L" "..QNArenownID..L" "..QNArenownLevel
  end
  if levelChanged then
	QuickNameActionsRessurected.MessageChanger()
	levelChanged = false;
  end
  newQNAmessage = QNAmessage
end

function QuickNameActionsRessurected.MasteryMessageMaker()
  while GameData.Player.career.line==0 or GameData.Player.career.line==nil do return end
  QuickNameActionsRessurected.Settings.Career=GameData.Player.career.line
  if careerCache ~= QuickNameActionsRessurected.Settings.Career then
    career = QuickNameActionsRessurected.Settings.Career
  end
  local QNArole = QuickNameActionsRessurected.careerToArchetype2[GameData.Player.career.line]

  local QNAicon = L""
  if QNArole == "healers" then QNAicon = QNAhealIcon end
  if QNArole == "tanks" then QNAicon = QNAtankIcon end
  if QNArole == "rdps" or QNArole == "mdps" then QNAicon = QNAdpsIcon end

  EA_Window_InteractionSpecialtyTraining.LoadAdvances()
  QNAmasteryMessage = (tostring(QNAicon).." "..EA_Window_InteractionSpecialtyTraining.initialSpecializationLevels[1].."/"..EA_Window_InteractionSpecialtyTraining.initialSpecializationLevels[2].."/"..EA_Window_InteractionSpecialtyTraining.initialSpecializationLevels[3])
  newQNAmasteryMessage = QNAmasteryMessage

  if masteryChanged then
    QuickNameActionsRessurected.MessageChanger()
    masteryChanged = false;
  end

end


--set discord text and substitute everywhere
function QuickNameActionsRessurected.SetDiscordText(input)
  local messagechangerdd = false;
  discordURL = QuickNameActionsRessurected.Settings.discord
  local regex = wstring.match(towstring(input), L"\^\%s")
  input = towstring(input)
  if input == L"" or input == nil or regex then
    EA_ChatWindow.Print(link..L"Current discord link is: "..towstring(QuickNameActionsRessurected.DiscordLinker()))
  else
    QuickNameActionsRessurected.Settings.discorder = input
    EA_ChatWindow.Print(link..L"New discord link is: "..towstring(QuickNameActionsRessurected.DiscordLinker()))
    messagechangerdd = true;
    if QuickNameActionsRessurected.Settings.tellMessage1 ~= wstring.match(QuickNameActionsRessurected.Settings.tellMessage1, QuickNameActionsRessurected.Settings.discord)
    then
      QuickNameActionsRessurected.Settings.tellMessage1 = wstring.gsub((QuickNameActionsRessurected.Settings.tellMessage1), towstring(discordURL), towstring(QuickNameActionsRessurected.DiscordLinker()))
    end
    if QuickNameActionsRessurected.Settings.tellMessage2 ~= wstring.match(QuickNameActionsRessurected.Settings.tellMessage2, QuickNameActionsRessurected.Settings.discord)
    then
      QuickNameActionsRessurected.Settings.tellMessage2 = wstring.gsub((QuickNameActionsRessurected.Settings.tellMessage2), towstring(discordURL), towstring(QuickNameActionsRessurected.DiscordLinker()))
    end
    if QuickNameActionsRessurected.Settings.chatMessage1 ~= wstring.match(QuickNameActionsRessurected.Settings.chatMessage1, QuickNameActionsRessurected.Settings.discord)
    then
      QuickNameActionsRessurected.Settings.chatMessage1 = wstring.gsub((QuickNameActionsRessurected.Settings.chatMessage1), towstring(discordURL), towstring(QuickNameActionsRessurected.DiscordLinker()))
    end
    if QuickNameActionsRessurected.Settings.chatMessage2 ~= wstring.match(QuickNameActionsRessurected.Settings.chatMessage2, QuickNameActionsRessurected.Settings.discord)
    then
      QuickNameActionsRessurected.Settings.chatMessage2 = wstring.gsub((QuickNameActionsRessurected.Settings.chatMessage2), towstring(discordURL), towstring(QuickNameActionsRessurected.DiscordLinker()))
    end
  end

  if messagechangerdd then
    local macroData = DataUtils.GetMacros ()
    for k, v in pairs(macroData) do

      if wstring.match(v.text, towstring(discordURL)) then
        v.text = wstring.gsub(v.text, towstring(discordURL), towstring(QuickNameActionsRessurected.DiscordLinker()))
        SetMacroData( v.name, v.text, v.iconNum, k )
        --EA_Window_Macro.OnSave()


        messagechangerdd = false;
      end
    end
  end
  return QuickNameActionsRessurected.DiscordLinker()
end



function QuickNameActionsRessurected.QNAmessage()
  while GameData.Player.career.line==0 or GameData.Player.career.line==nil do return end
  if DataUtils.IsWorldLoading() == true then return end
  QuickNameActionsRessurected.Settings.oldQNAmessage = QNAmessage
  if firstLoad and careercache ~= GameData.Player.career.line or QuickNameActionsRessurected.Settings.Career == 0 then
    QuickNameActionsRessurected.Settings.Career = GameData.Player.career.line
  end
  if cacheCareer ~= GameData.Player.career.line then QuickNameActionsRessurected.Settings.Career = GameData.Player.career.line
  end
  if oldQNAlevel ~= GameData.Player.level or QuickNameActionsRessurected.Settings.Career ~= GameData.Player.career.line then
    QuickNameActionsRessurected.MessageMaker()
  end
  --end
  return (QNAmessage)
end

function QuickNameActionsRessurected.QNAmastery()
  while GameData.Player.career.line==0 or GameData.Player.career.line==nil do return end
  if DataUtils.IsWorldLoading() == true then return end
  QuickNameActionsRessurected.Settings.oldQNAmasteryMessage = QNAmasteryMessage
  if firstLoad and careercache ~= GameData.Player.career.line then
    QuickNameActionsRessurected.Settings.Career = GameData.Player.career.line
  end
  if cacheCareer ~= GameData.Player.career.line then
    QuickNameActionsRessurected.Settings.Career = GameData.Player.career.line
  end
  return (QNAmasteryMessage)
end

function QuickNameActionsRessurected.MasteryChanger()
end


function QuickNameActionsRessurected.MessageChanger()
  if DataUtils.IsWorldLoading() == true then return end
  local oldQNAmasteryMessage = QuickNameActionsRessurected.Settings.oldQNAmasteryMessage
  local oldQNAmessage = QuickNameActionsRessurected.Settings.oldQNAmessage
  -- oldQNAmasteryMessage = towstring(oldQNAmasteryMessage)
  --oldQNAmessage = towstring(oldQNAmessage)
  if wstring.match(QuickNameActionsRessurected.Settings.tellMessage1, towstring(oldQNAmessage)) or QuickNameActionsRessurected.Settings.tellMessage1 ~= wstring.match(QuickNameActionsRessurected.Settings.tellMessage1, towstring(oldQNAmessage))
  then
    QuickNameActionsRessurected.Settings.tellMessage1 = wstring.gsub((QuickNameActionsRessurected.Settings.tellMessage1), towstring(oldQNAmessage), towstring(QuickNameActionsRessurected.QNAmessage()))
  end
  if wstring.match(QuickNameActionsRessurected.Settings.tellMessage2, towstring(oldQNAmessage)) or QuickNameActionsRessurected.Settings.tellMessage2 ~= wstring.match(QuickNameActionsRessurected.Settings.tellMessage1, towstring(oldQNAmessage))
  then
    QuickNameActionsRessurected.Settings.tellMessage2 = wstring.gsub((QuickNameActionsRessurected.Settings.tellMessage2), towstring(oldQNAmessage), towstring(QuickNameActionsRessurected.QNAmessage()))
  end
  if wstring.match(QuickNameActionsRessurected.Settings.chatMessage1, towstring(oldQNAmessage)) or QuickNameActionsRessurected.Settings.chatMessage1 ~= wstring.match(QuickNameActionsRessurected.Settings.chatMessage1, towstring(oldQNAmessage))
  then
    QuickNameActionsRessurected.Settings.chatMessage1 = wstring.gsub((QuickNameActionsRessurected.Settings.chatMessage1), towstring(oldQNAmessage), towstring(QuickNameActionsRessurected.QNAmessage()))
  end
  if wstring.match(QuickNameActionsRessurected.Settings.chatMessage2, towstring(oldQNAmessage)) or QuickNameActionsRessurected.Settings.chatMessage2 ~= wstring.match(QuickNameActionsRessurected.Settings.chatMessage2, towstring(oldQNAmessage))
  then
    QuickNameActionsRessurected.Settings.chatMessage2 = wstring.gsub((QuickNameActionsRessurected.Settings.chatMessage2), towstring(oldQNAmessage), towstring(QuickNameActionsRessurected.QNAmessage()))
  end


  --- mastery
  if wstring.match(QuickNameActionsRessurected.Settings.tellMessage1, towstring(oldQNAmasteryMessage)) or QuickNameActionsRessurected.Settings.tellMessage1 ~= wstring.match(QuickNameActionsRessurected.Settings.tellMessage1, towstring(oldQNAmasteryMessage))
  then
    QuickNameActionsRessurected.Settings.tellMessage1 = wstring.gsub((QuickNameActionsRessurected.Settings.tellMessage1), towstring(oldQNAmasteryMessage), towstring(QuickNameActionsRessurected.QNAmastery()))
  end
  if wstring.match(QuickNameActionsRessurected.Settings.tellMessage2, towstring(oldQNAmasteryMessage)) or QuickNameActionsRessurected.Settings.tellMessage2 ~= wstring.match(QuickNameActionsRessurected.Settings.tellMessage1, towstring(oldQNAmasteryMessage))
  then
    QuickNameActionsRessurected.Settings.tellMessage2 = wstring.gsub((QuickNameActionsRessurected.Settings.tellMessage2), towstring(oldQNAmasteryMessage), towstring(QuickNameActionsRessurected.QNAmastery()))
  end
  if wstring.match(QuickNameActionsRessurected.Settings.chatMessage1, towstring(oldQNAmasteryMessage)) or QuickNameActionsRessurected.Settings.chatMessage1 ~= wstring.match(QuickNameActionsRessurected.Settings.chatMessage1, towstring(oldQNAmasteryMessage))
  then
    QuickNameActionsRessurected.Settings.chatMessage1 = wstring.gsub((QuickNameActionsRessurected.Settings.chatMessage1), towstring(oldQNAmasteryMessage), towstring(QuickNameActionsRessurected.QNAmastery()))
  end
  if wstring.match(QuickNameActionsRessurected.Settings.chatMessage2, towstring(oldQNAmasteryMessage)) or QuickNameActionsRessurected.Settings.chatMessage2 ~= wstring.match(QuickNameActionsRessurected.Settings.chatMessage2, towstring(oldQNAmasteryMessage))
  then
    QuickNameActionsRessurected.Settings.chatMessage2 = wstring.gsub((QuickNameActionsRessurected.Settings.chatMessage2), towstring(oldQNAmasteryMessage), towstring(QuickNameActionsRessurected.QNAmastery()))
  end

  local macroTest = DataUtils.GetMacros ()
  for k, v in pairs(macroTest) do
    if v.text == wstring.match(v.text, towstring(oldQNAmessage)) then
      v.text = wstring.gsub(v.text, towstring(oldQNAmessage), towstring(QuickNameActionsRessurected.QNAmessage()))
      SetMacroData( v.name, v.text, v.iconNum, k )
    end
    if v.text == string.match(tostring(v.text), (oldQNAmasteryMessage)) then
      v.text = string.gsub(v.text, tostring(oldQNAmasteryMessage), tostring(QuickNameActionsRessurected.QNAmastery()))
      SetMacroData( v.name, v.text, v.iconNum, k )
    end
  end

end

function QuickNameActionsRessurected.SetChatText(input, channel, messageNumber)
  local regex = wstring.match(towstring(input), L"\^\%s")

  local qnaSplit = StringSplit(tostring(input), "#")
  local input = towstring(qnaSplit[1])
  local channel = towstring(qnaSplit[2])
  local messageNumber = towstring(qnaSplit[3])


  if input == L"" or input == nil or regex then
    ChannelInfo()
    EA_ChatWindow.Print(link..towstring("Current quick-chat message [1 "..tostring(QuickNameActionsRessurected.Settings.chatMessage1Channel).."] is: "..tostring(QuickNameActionsRessurected.Settings.chatMessage1)))
    EA_ChatWindow.Print(link..towstring("Current quick-chat message [2 "..tostring(QuickNameActionsRessurected.Settings.chatMessage2Channel).."] is: "..tostring(QuickNameActionsRessurected.Settings.chatMessage2)))
  else
    if messageNumber == L"1" or not qnaSplit[3] then
      NameMapper(input)
      if channel == nil or channel == L"" or channel == "" or channel == L"smart" then
        changedChatMessage = true;
        NameMapper(input)
        QuickNameActionsRessurected.Settings.smartChannel1 = true;
        QuickNameActionsRessurected.Settings.chatMessage1Channel = ChatSettings.Channels[EA_ChatWindow.prevChannel].serverCmd
      else
        changedChatMessage = true;
        NameMapper(input)
        QuickNameActionsRessurected.Settings.smartChannel1 = false;
        QuickNameActionsRessurected.Settings.chatMessage1Channel = tostring(channel)
      end
    elseif messageNumber == L"2" then
      if channel == nil or channel == L"" or channel == "" or channel == L"smart" then
        changedChatMessage2 = true;
        NameMapper(input)
        QuickNameActionsRessurected.Settings.smartChannel2 = true;
        QuickNameActionsRessurected.Settings.chatMessage2Channel = ChatSettings.Channels[EA_ChatWindow.prevChannel].serverCmd
      else
        changedChatMessage2 = true;
        NameMapper(input)
        QuickNameActionsRessurected.Settings.smartChannel2 = false;
        QuickNameActionsRessurected.Settings.chatMessage2Channel = tostring(channel)
      end
    end
  end
  if changedChatMessage then
    ChannelInfo()
    EA_ChatWindow.Print(link..L"Quick-chat message [1] set to: "..towstring(QuickNameActionsRessurected.Settings.chatMessage1))
    EA_ChatWindow.Print(link..L"Quick-chat channel [1] set to: "..towstring(chanInfo))
    changedChatMessage = false;
  elseif changedChatMessage2 then
    ChannelInfo()
    EA_ChatWindow.Print(link..L"Quick-chat message [2] set to: "..towstring(QuickNameActionsRessurected.Settings.chatMessage2))
    EA_ChatWindow.Print(link..L"Quick-chat channel [2] set to: "..towstring(chanInfo2))
    changedChatMessage2 = false;
  end
end