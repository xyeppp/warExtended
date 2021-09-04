warExtendedOpenParty = warExtended.Register("warExtended Open Party")
local OpenParty = warExtendedOpenParty
local isInQueue = false;
local activeQueueGroupLeaderName
local cacheButtonID
local queueIndice
local refreshGroupTimer = 0
local refreshGroupDelay = 3
local sortedGroupCache = {}
local openPartyGroupCache = {}
local activeQueueGroup = {}


local function sortGroupByCareer(a,b)
  return a.m_careerID < b.m_careerID
end

local function isOpenPartyWorldWindow()
  local isWorldWindow = SystemData.ActiveWindow.name:match("(.*)World")
  return isWorldWindow
end

local function isGroupSorted(groupLeaderData)
 local isSorted = sortedGroupCache == groupLeaderData
 return isSorted
end

local function openPartyGroupTooltip ( groupLeaderData )
  local groupHasMoreThanOneMember = groupLeaderData.Group ~= nil
  local TOOLTIP_WIN = "EA_Tooltip_OpenParty"

  local tankCount, dpsCount, healCount = OpenParty:GetGroupRoleCount(groupLeaderData)
  local tankString = OpenParty:GetRoleIconString("tank", true)..": "..tankCount
  local dpsString = OpenParty:GetRoleIconString("dps")..": "..dpsCount
  local healString = OpenParty:GetRoleIconString("heal", true)..": "..healCount
  local fullRoleCountString = towstring(tankString.."   "..dpsString.."   "..healString)

  if groupHasMoreThanOneMember and not isGroupSorted(groupLeaderData.Group) then
      table.sort(groupLeaderData.Group, sortGroupByCareer)
      sortedGroupCache=groupLeaderData.Group
  end

  if isOpenPartyWorldWindow() then
  	TOOLTIP_WIN = TOOLTIP_WIN.."World"
  end

  LabelSetText (TOOLTIP_WIN.."WbText", fullRoleCountString)
end

----------------------------------

local function getGroupFromPopulatorIndiceID(indiceID)
  local groupData = GetOpenPartyFullList()
  openPartyGroupCache = groupData

  if isOpenPartyWorldWindow() then
    local worldIndiceGroup = EA_Window_OpenPartyWorldList.PopulatorIndices[ indiceID ]
    local correspondingIndiceGroup = groupData[worldIndiceGroup]
    return correspondingIndiceGroup
  end

  local nearbyIndiceGroup = EA_Window_OpenPartyNearbyList.PopulatorIndices[ indiceID ]
  local correspondingIndiceGroup = groupData[nearbyIndiceGroup]

  return correspondingIndiceGroup
end


local function getGroupNumberFromLeaderName(leaderName)
  for groupNum,groupData in pairs(openPartyGroupCache) do
    if groupData.leaderName == leaderName then
      return groupNum
    end
  end
end


local function getIndiceIDFromGroupNumber(groupNumber)
  local indiceGroup = EA_Window_OpenPartyNearbyList.PopulatorIndices

  if isOpenPartyWorldWindow() then
    indiceGroup = EA_Window_OpenPartyWorldList.PopulatorIndices
  end

  for indiceID,groupNum in pairs(indiceGroup) do
    if groupNum == groupNumber then
      return indiceID
    end
  end
end


local function getButtonFromPopulatorIndiceID(indiceID)
  local joinButtonString = "EA_Window_OpenPartyNearbyListRow"..indiceID.."JoinPartyButton"

  if isOpenPartyWorldWindow() then
    joinButtonString = "EA_Window_OpenPartyWorldListRow"..indiceID.."JoinPartyButton"
  end
  return joinButtonString
end


local function setButtonTextAndAnimation(indiceID, queueEnabled)
  local joinButton = getButtonFromPopulatorIndiceID(indiceID)

  if queueEnabled then
    p('setting button status on')
    ButtonSetText(joinButton, L"In Queue")
    WindowStartAlphaAnimation( joinButton, Window.AnimationType.LOOP, 0.1, 1.0, 0.75, false, 0.5, 0)
    return
  end

  p('setting button status off')
  ButtonSetText(joinButton, L"Join")
  WindowStopAlphaAnimation( joinButton )
  end


local function setLocalVariables(queueEnabled, groupLeaderName)

  if queueEnabled then
    isInQueue=true;
    activeQueueGroupLeaderName = groupLeaderName
    return
  end

  queueIndice = nil
  isInQueue=false;
  activeQueueGroupLeaderName = nil
end



local function startQueue(indiceID, groupLeaderName)
  setLocalVariables(true, groupLeaderName)
  OpenParty:RegisterUpdate("warExtendedOpenParty.OpenPartyQueue")
  OpenParty:RegisterEvent("SOCIAL_OPENPARTY_UPDATED", "warExtendedOpenParty.GetNewGroupIndices")
  OpenParty:RegisterEvent("SOCIAL_OPENPARTY_WORLD_UPDATED", "warExtendedOpenParty.GetNewGroupIndices")
  setButtonTextAndAnimation(indiceID, true)
end

local function stopQueue(indiceID)
  setLocalVariables(false)
  OpenParty:UnregisterUpdate("warExtendedOpenParty.OpenPartyQueue")
  OpenParty:UnregisterEvent("SOCIAL_OPENPARTY_UPDATED", "warExtendedOpenParty.GetNewGroupIndices")
  OpenParty:UnregisterEvent("SOCIAL_OPENPARTY_WORLD_UPDATED", "warExtendedOpenParty.GetNewGroupIndices")
  setButtonTextAndAnimation(indiceID, false)
end


local function isGroupFull()
  local isFull = activeQueueGroup.numGroupMembers == 24
  return isFull
end




local function queueOpenParty()
  local indiceID = WindowGetId(SystemData.ActiveWindow.name)
  activeQueueGroup = getGroupFromPopulatorIndiceID(indiceID)
  local groupLeaderName = activeQueueGroup.leaderName

  if isGroupFull() and not isInQueue then
    queueIndice = indiceID
    startQueue(queueIndice, groupLeaderName)
    p("joining queue")
    return
  elseif isInQueue then
    p("leaving queue")
    stopQueue(indiceID)
    return
  end

end



function OpenParty.GetNewGroupIndices()
  local newGroupData = GetOpenPartyFullList()
  if openPartyGroupCache  ~= groupData then
    setButtonTextAndAnimation(queueIndice, false)
    openPartyGroupCache = newGroupData
    local groupNumber = getGroupNumberFromLeaderName(activeQueueGroupLeaderName)
    queueIndice = getIndiceIDFromGroupNumber(groupNumber)
    setButtonTextAndAnimation(queueIndice, true)
  end
end


function OpenParty.OpenPartyQueue(timeElapsed)
  local joinButton = getButtonFromPopulatorIndiceID(queueIndice)
  ButtonSetText(joinButton, L"In Queue")
  refreshGroupTimer=refreshGroupTimer+timeElapsed

  if refreshGroupTimer >= refreshGroupDelay then
    p(refreshGroupTimer)
    SendOpenPartySearchRequest(1)
    p("trying to join")
    if not isGroupFull() then
      p("joining")
      local joinText = L"/partyjoin "..activeQueueGroupLeaderName
      if( activeQueueGroup.isWarband == true )
      then
        joinText = L"/warbandjoin "..activeQueueGroupLeaderName
      end
      SendChatText( joinText, L"" )
      p("joining group")
      stopQueue(queueIndice)
      return
    end
    refreshGroupTimer=0
  end

end

local function setButtonStatusOnShown()
  if isInQueue then
    local groupNumber = getGroupNumberFromLeaderName(activeQueueGroupLeaderName)
    queueIndice = getIndiceIDFromGroupNumber(groupNumber)
    setButtonTextAndAnimation(queueIndice, true)
    return
  end
end


OpenParty:Hook(EA_Window_OpenParty.OnShown, setButtonStatusOnShown, true)
OpenParty:Hook(EA_Window_OpenParty.SelectTab, setButtonStatusOnShown, true)

OpenParty:Hook(EA_Window_OpenPartyWorld.CreateOpenPartyTooltip, openPartyGroupTooltip)
OpenParty:Hook(EA_Window_OpenPartyNearby.CreateOpenPartyTooltip, openPartyGroupTooltip)

OpenParty:Hook(EA_Window_OpenPartyNearby.JoinPartySpecified , queueOpenParty)
OpenParty:Hook(EA_Window_OpenPartyWorld.JoinPartySpecified , queueOpenParty)







--OpenParty:RegisterUpdate("warExtendedOpenParty.QueueOnUpdate")
