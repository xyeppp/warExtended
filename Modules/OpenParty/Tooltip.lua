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

function OpenParty.OnCreateOpenPartyTooltip ( groupLeaderData )
  local groupHasMoreThanOneMember = groupLeaderData.Group ~= nil
  local tooltipWindow = getTooltipWindowName()

  local tankCount, dpsCount, healCount = OpenParty:GetGroupRoleCount(groupLeaderData)
  local tankIconText = OpenParty:GetRoleIconString(1, true)
  local dpsIconText = OpenParty:GetRoleIconString(2)
  local healIconText = OpenParty:GetRoleIconString(3, true)


  local tankString = tankIconText..": "..tankCount
  local dpsString = dpsIconText..": "..dpsCount
  local healString = healIconText..": "..healCount

  local fullRoleCountString = towstring(tankString.."   "..dpsString.."   "..healString)

  if groupHasMoreThanOneMember and not isGroupSorted(groupLeaderData.Group) then
	table.sort(groupLeaderData.Group, sortGroupByCareer)
	sortedGroupCache=groupLeaderData.Group
  end

  LabelSetText (tooltipWindow.."WbText", fullRoleCountString)
end
