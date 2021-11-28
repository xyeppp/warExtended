warExtendedOpenParty = warExtended.Register("warExtended Open Party")
local OpenParty = warExtendedOpenParty

local TOOLTIP_WIN = "EA_Tooltip_OpenParty"
local OPEN_PARTY_NEARBY_WINDOW = "EA_WindowOpenPartyNearby"

local sortedGroupCache = {}

local function sortGroupByCareer(a,b)
  return a.m_careerID < b.m_careerID
end

local function getTooltipWindowName()
  if OpenParty:IsActiveWindow(OPEN_PARTY_NEARBY_WINDOW) then
    return TOOLTIP_WIN.."World"
  end
  return TOOLTIP_WIN
end


local function isGroupSorted(groupLeaderData)
 local isSorted = sortedGroupCache == groupLeaderData
 return isSorted
end

local function openPartyGroupTooltip ( groupLeaderData )
  local groupHasMoreThanOneMember = groupLeaderData.Group ~= nil
  local tooltipWindow = getTooltipWindowName()

  local tankCount, dpsCount, healCount = OpenParty:GetGroupRoleCount(groupLeaderData)

  local tankString = OpenParty:GetRoleIconString("tank", true)..": "..tankCount
  local dpsString = OpenParty:GetRoleIconString("dps")..": "..dpsCount
  local healString = OpenParty:GetRoleIconString("heal", true)..": "..healCount

  local fullRoleCountString = towstring(tankString.."   "..dpsString.."   "..healString)

  if groupHasMoreThanOneMember and not isGroupSorted(groupLeaderData.Group) then
      table.sort(groupLeaderData.Group, sortGroupByCareer)
      sortedGroupCache=groupLeaderData.Group
  end

  LabelSetText (tooltipWindow.."WbText", fullRoleCountString)
end


function OpenParty.OnInitialize()
OpenParty:Hook(EA_Window_OpenPartyWorld.CreateOpenPartyTooltip, openPartyGroupTooltip)
OpenParty:Hook(EA_Window_OpenPartyNearby.CreateOpenPartyTooltip, openPartyGroupTooltip)
end
