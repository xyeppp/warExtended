local warExtended = warExtended
local tostring=tostring
local IsWarBandActive = IsWarBandActive
local GetNumGroupmates = GetNumGroupmates

local WARBAND = L"Warband"
local GROUP = L"Group"
local SOLO = nil

function warExtended:IsGroupLeader()
  return GameData.Player.isGroupLeader
end

function warExtended:GetGroupType()
    if IsWarBandActive() then
        return WARBAND
    elseif GetNumGroupmates() > 0 then
        return GROUP
    else
        return SOLO
    end
end

local function getLeaderNameFromGroupData()
  local groupData = GetGroupData()

  for player = 1,#groupData do
	local playerData = groupData[player]
	local isLeader = playerData.isMainAssist

	if isLeader then
	  return playerData.name
	end

  end
end


function warExtended:GetLeaderName()
  local gType =  self:GetGroupType()

  if self:IsGroupLeader() or gType == SOLO then
	return self:GetPlayerName()
  elseif gType == WARBAND then
	return PartyUtils.GetWarbandLeader().name
  elseif gType == GROUP then
	local leaderName = getLeaderNameFromGroupData()
	return leaderName
  end
end


local function getWarbandMemberNames()
  local groupData = GetBattlegroupMemberData()
  local memberNames = {}

  for warbandGroup=1,4 do
	local warbandParty = groupData[warbandGroup].players
	memberNames[warbandGroup] = {}

	for partyMember = 1,#warbandParty do
	  local playerName = warbandParty[partyMember].name
	  memberNames[warbandGroup][partyMember] = playerName
	end

  end

  return memberNames
end


local function getGroupMemberNames()
  local playerName = GameData.Player.name
  local groupData = GetGroupData()
  local memberNames = { [1] = { } }

  for player = 1,#groupData do
	local isMember = groupData[player].name ~= L""
	local memberName = groupData[player].name
	if isMember then
	  memberNames[1][player+1] = memberName
	end
  end

  memberNames[1][1] = playerName
  return memberNames
end


function warExtended:GetGroupNames()
  local gType =  warExtended:GetGroupType()


  if gType == "BATTLEGROUP" then
	groupNames = getWarbandMemberNames()
	return groupNames
  elseif gType == "GROUP" then
	groupNames = getGroupMemberNames()
	return groupNames
  end

end


local function getGroupNumberAndMemberNumberFromPlayerName(playerName)
  local memberNames = warExtended:GetGroupNames()

  for warbandGroup=1,#memberNames do
  	local groupMembers = memberNames[warbandGroup]
	for memberNumber = 1,#groupMembers do
	  local memberName = tostring((groupMembers[memberNumber]))
	  local isPlayerInGroup = memberName:match(playerName)

	  if isPlayerInGroup then
		local playerGroupNumber, memberNum = warbandGroup, memberNumber
		return playerGroupNumber, memberNum
	  end

	end
  end
end

function warExtended:GetPlayerMemberNumber(playerName)
  local gType =  warExtended:GetGroupType()
  local memberNumber

  if gType then
	_, memberNumber = getGroupNumberAndMemberNumberFromPlayerName(playerName)
  end

  return memberNumber
end


function warExtended:GetPlayerGroupNumber(playerName)
  local gType =  warExtended:GetGroupType()
  local groupNumber

  if gType then
	groupNumber = getGroupNumberAndMemberNumberFromPlayerName(playerName)
  end

  return groupNumber
end


function warExtended:GetGroupRoleCount(groupData)
  local groupRoleCount = {0,0,0}

    if groupData.Group == nil then
        local leaderRole = self:GetCareerRole(groupData.leaderCareer)
        groupRoleCount[leaderRole] = groupRoleCount[leaderRole] + 1
    else
        for member=1,#groupData.Group do
            local memberCareer=groupData.Group[member].m_careerID
            local careerRole = self:GetCareerRole(memberCareer)
            groupRoleCount[careerRole] = groupRoleCount[careerRole] + 1
        end
    end

    return unpack(groupRoleCount)
end