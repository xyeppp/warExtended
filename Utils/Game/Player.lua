local warExtended = warExtended
local tostring = tostring
local mfloor = math.floor
local GetDatabaseGuildData = GetDatabaseGuildData

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
  local playerName = self:FixString(GameData.Player.name)
  return playerName
end

function warExtended:GetPlayerHPCurrent()
  local currentPlayerHP = GameData.Player.hitPoints.current
  return currentPlayerHP
end

function warExtended:GetPlayerHPPercentage()
  local hpPercentage = mfloor((self:GetPlayerHPCurrent()/self:GetPlayerHPMax()) * 100)
  return hpPercentage
end

function warExtended:GetPlayerHPMax()
  local maxPlayerHP = GameData.Player.hitPoints.maximum
  return maxPlayerHP
end

function warExtended:GetPlayerWorldObjNum()
  local playerWorldObj = GameData.Player.worldObjNum
  return playerWorldObj
end

function warExtended:GetPlayerAdvanceData()
  local playerAdvanceData = GameData.Player.GetAdvanceData()
  return playerAdvanceData
end

function warExtended:GetPlayerMasteryLevels()
  local Specialty

  if warExtendedSpecialtyTraining then
    Specialty = warExtendedSpecialtyTraining.initialSpecializationLevels
  else
    Specialty = EA_Window_InteractionSpecialtyTraining.initialSpecializationLevels
  end

  return Specialty[1], Specialty[2], Specialty[3]
end


function warExtended:GetPlayerPetWorldObjNum()
  local playerPetWorldObjNum = GameData.Player.Pet.objNum
  return playerPetWorldObjNum
end


function warExtended:GetPlayerGuildData()
    local guildData = GetDatabaseGuildData( GameData.Guild.m_GuildID)
    return guildData
end

function warExtended:GetPlayerLevelString()
  local iconShorthandle = self:toWString(self:GetCareerIconShorthandleString(self:GetPlayerCareerLine()))


  local playerLevel = self:GetPlayerLevel()
  local message = iconShorthandle..L" "..self:GetIconString(41)..L" "..playerLevel..L" "..self:GetIconString(45)..L" "..self:GetPlayerRenownLevel()
  
  if playerLevel == 40 then
     message = iconShorthandle..L" "..self:GetIconString(45)..L" "..self:GetPlayerRenownLevel()
  end

return self:toString(message)
end