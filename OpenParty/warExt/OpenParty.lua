warExtendedOpenParty = warExtended.Register("warExtended Open Party")
local OpenParty = warExtendedOpenParty
local isInQueue = false;
local cacheButtonID = nil
local sortedGroupCache = {}


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

local function openPartyGroupTooltip ( groupLeaderData, mouseoverWindow, anchor)
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

local updateCounter=0
local testerCounter=0
local queueCounter=0


local function getGroupFromPopulatorIndiceID(indiceID)
  local groupData = GetOpenPartyFullList()
  local nearbyIndiceGroup = EA_Window_OpenPartyNearbyList.PopulatorIndices[ indiceID ]
  local correspondingIndiceGroup = groupData[nearbyIndiceGroup]

  if isOpenPartyWorldWindow() then
    local worldIndiceGroup = EA_Window_OpenPartyNearbyList.PopulatorIndices[ indiceID ]
    correspondingIndiceGroup = groupData[worldIndiceGroup]
    return correspondingIndiceGroup
  end

  return correspondingIndiceGroup
end


local function getButtonFromPopulatorIndiceID(indiceID)
  local joinButtonString = "EA_Window_OpenPartyNearbyListRow"..indiceID.."JoinPartyButton"

  if isOpenPartyWorldWindow() then
    joinButtonString = "EA_Window_OpenPartyWorldListRow"..indiceID.."JoinPartyButton"
  end

  return joinButtonString
end

local function getNewIndiceIDFromLeaderName(leaderName)
  local indiceID = 0


end

local function setButtonTextAndAnimation(indiceID, enableButtonAnimation)
  local joinButton = getButtonFromPopulatorIndiceID(indiceID)

  if enableButtonAnimation then
    p('setting button status on')
    ButtonSetText(joinButton, L"In Queue")
    WindowStartAlphaAnimation( joinButton, Window.AnimationType.LOOP, 0.1, 1.0, 0.75, false, 0.5, 0)
    return
  end

  p('setting button status off')
  ButtonSetText(joinButton, L"Join")
  WindowStopAlphaAnimation( joinButton )
  end




local function startQueue(indiceID)
  isInQueue=true;
  cacheButtonID = indiceID
  setButtonTextAndAnimation(indiceID, true)


end

local function stopQueue(indiceID)
  isInQueue=false;
  setButtonTextAndAnimation(indiceID, false)
end

local function isGroupFull(groupData)
  local isFull = groupData.numGroupMembers == 24
  return isFull
end


local function queueOpenParty()
  local indiceID = WindowGetId(SystemData.ActiveWindow.name)
  p(indiceID)
  local groupData = getGroupFromPopulatorIndiceID(indiceID)
  local groupLeaderName = groupData.leaderName
  p(groupLeaderName)

  if isGroupFull(groupData) and not isInQueue then
    startQueue(indiceID)
    p("joining queue")
    return
  elseif isInQueue then
    p("leaving queue")
    stopQueue(indiceID)
    return
  end
  --elseif settings.inQueue and QNAgroupData.numGroupMembers==24 then
    --settings.inQueue=false;
   -- ButtonSetText(joinButton, L"Join")
  --  WindowStopAlphaAnimation( joinButton
end

local function setButtonStatusOnShown()
  if isInQueue then
    p("test")
    return setButtonTextAndAnimation(cacheButtonID, true)
  end
end

OpenParty:Hook(EA_Window_OpenParty.OnShown, setButtonStatusOnShown, true)
OpenParty:Hook(EA_Window_OpenPartyWorld.CreateOpenPartyTooltip, openPartyGroupTooltip)
OpenParty:Hook(EA_Window_OpenPartyNearby.CreateOpenPartyTooltip, openPartyGroupTooltip)
OpenParty:Hook(EA_Window_OpenPartyNearby.JoinPartySpecified , queueOpenParty)
OpenParty:Hook(EA_Window_OpenPartyWorld.JoinPartySpecified , queueOpenParty)


function OpenParty.QueueOnUpdate(timeElapsed)
  if not isInQueue then return end
  local joinButton = getButtonFromPopulatorIndiceID(cacheButtonID)
  ButtonSetText(joinButton, L"In Queue")
  updateCounter=updateCounter+timeElapsed
  testerCounter=testerCounter+timeElapsed
  queueCounter=(queueCounter+timeElapsed)
  local groupData = getGroupFromPopulatorIndiceID(cacheButtonID)

  --[[QNAgroupData = EA_Window_OpenPartyNearby.OpenPartyTable[ QNApassID ]

  if testerCounter>=1 then
    LabelSetText("QNAQueueText", L"In Queue: "..QNAgroupData.leaderName..L"'s Warband "..TimeUtils.FormatTime((queueCounter)))
    testerCounter=0
  end]]


  if updateCounter >=3 then
    p(updateCounter)
    SendOpenPartySearchRequest(1)
    --for k,v in ipairs(QNAgroupData) do
    --p(QNAgroupData.leaderName)
    --p(QNAgroupData.numGroupMembers)
    --  p(QNAgroupData)
    p("trying to join")
    if not isGroupFull(groupData) then
      p("joining")
      p(groupData.leaderName)
      local text = L"/partyjoin "..groupData.leaderName
      if( groupData.isWarband == true )
      then
        text = L"/warbandjoin "..groupData.leaderName
      end
      SendChatText( text, L"" )
      p("joining group")
      stopQueue(cacheButtonID)
      return
      --WindowStopAlphaAnimation(QNApassButton)
      --  ButtonSetText(QNApassButton, L"Join")
      --p(settings.PartyJoinerStart)
      --settings.PartyJoinerStart=false;
     -- ButtonSetText(QNApassButton, L"Join")
      --end
    end
    --timeElapsed=0
    updateCounter=0
  end

end

--OpenParty:RegisterUpdate("warExtendedOpenParty.QueueOnUpdate")
