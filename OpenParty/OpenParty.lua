warExtendedOpenParty = warExtended.Register("warExtended Open Party")
local OpenParty = warExtendedOpenParty
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


function OpenParty.OnInitialize()
OpenParty:Hook(EA_Window_OpenPartyWorld.CreateOpenPartyTooltip, openPartyGroupTooltip)
OpenParty:Hook(EA_Window_OpenPartyNearby.CreateOpenPartyTooltip, openPartyGroupTooltip)
end
