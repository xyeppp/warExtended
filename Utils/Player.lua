local warExtended = warExtended

function warExtended:GetPlayerLevel()
  local playerLevel = GameData.Player.level
  return playerLevel
end

function warExtended:GetPlayerRenownLevel()
  local renownLevel = GameData.Player.Renown.curRank
  return renownLevel
end

function warExtended:GetPlayerCareerId()
  local careerId = GameData.Player.career.id
  return careerId
end

function warExtended:GetPlayerCareerLine()
  local careerLine = GameData.Player.career.line
  return careerLine
end

function warExtended:GetPlayerName()
  local playerName = tostring(GameData.Player.name)
  return playerName
end

function warExtended:GetPlayerMasteryLevels()
  local Specialty = EA_Window_InteractionSpecialtyTraining.initialSpecializationLevels or warExtendedSpecialtyTraining.initialSpecializationLevels
  return Specialty[1], Specialty[2], Specialty[3]
end

function warExtended:GetPlayerGuildData()
    local guildData = GetDatabaseGuildData( GameData.Guild.m_GuildID)
    return guildData
end

function warExtended:GetPlayerLevelString()
  local iconShorthandle = warExtended:GetCareerIconShorthandleString(warExtended:GetPlayerCareerLine())
  local playerLevel = warExtended:GetPlayerLevel()
  local message = iconShorthandle.." "..warExtended:GetIconString(41).." "..playerLevel.." "..warExtended:GetIconString(45).." "..warExtended:GetPlayerRenownLevel()
  
  if playerLevel == 40 then
     message = iconShorthandle.." "..warExtended:GetIconString(45).." "..warExtended:GetPlayerRenownLevel()
  end
  
return message
end