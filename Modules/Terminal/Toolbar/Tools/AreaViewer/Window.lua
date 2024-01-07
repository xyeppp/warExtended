local warExtended            = warExtended
--TODO: Add (RoR_CitySiege.GetCity(GameData.CityId.EMPIRE//GameData.Player.zone) & GetCampaignZoneData(GameData.Player.zone)
--TODO: add mouseover on circle image with lock yadda yadda


local WINDOW_NAME            = "TerminalAreaViewer"
local ICON_FRAME             = 1
local NAME_COLUMN            = 2
local NAME_LABEL             = 3
local AREA_LIST_WINDOW       = 7
local REFRESH_BUTTON_WINDOW  = 8
local OBJECTIVE_LIST_WINDOW  = 10
local OUTPUT_TEXT            = 11
local TITLEBAR               = 12
local LOCK_BUTTON            = 13

local TerminalAreaViewer     = TerminalAreaViewer

local WINDOW                 = Frame:Subclass(WINDOW_NAME)
local AREA_LIST              = ListBox:Subclass(WINDOW_NAME .. "OutputAreaList")
local OBJECTIVE_LIST         = ListBox:Subclass(WINDOW_NAME .. "OutputObjectivesList")
local REFRESH_BUTTON         = ButtonFrame:Subclass(WINDOW_NAME .. "OutputRefreshButton")
local CIRCLE_ICON            = Frame:Subclass(WINDOW_NAME .. "OutputCircle")


function WINDOW:Create()
  self:CreateFromTemplate(WINDOW_NAME)

   AREA_LIST              = AREA_LIST:CreateFrameForExistingWindow(WINDOW_NAME .. "OutputAreaList")
   OBJECTIVE_LIST         = OBJECTIVE_LIST:CreateFrameForExistingWindow(WINDOW_NAME .. "OutputObjectivesList")
   REFRESH_BUTTON         = REFRESH_BUTTON:CreateFrameForExistingWindow(WINDOW_NAME .. "OutputRefreshButton")
  CIRCLE_ICON            = CIRCLE_ICON:CreateFrameForExistingWindow(WINDOW_NAME .. "OutputCircle")

  local areaSort = {
	[1] = {text=L"Area ID",  sortFunc = function (a, b) return a.areaID < b.areaID end},
	[2] = {text = L"Area Name", sortFunc =  function (a, b) return(WStringsCompare(a.areaName, b.areaName) == -1) end},
	[3] = {text = L"Influence ID", sortFunc = function (a,b) return a.influenceID < b.influenceID end},
  }

  local objectiveSort = {
	[1] = {text=L"Objective Name", sortFunc = function(a,b) return(WStringsCompare(a.name, b.name) == -1)  end}
  }

  AREA_LIST:SetSelfTable(TerminalAreaViewerOutputAreaList)
  AREA_LIST:SetSortButtons(areaSort, WINDOW_NAME.."OutputArea", 2)

  OBJECTIVE_LIST:SetSelfTable(TerminalAreaViewerOutputObjectivesList)
  OBJECTIVE_LIST:SetSortButtons(objectiveSort, WINDOW_NAME.."OutputObjective")

  if not CIRCLE_ICON.m_Windows then
	CIRCLE_ICON.m_Windows = {
	  [LOCK_BUTTON] = DynamicImage:CreateFrameForExistingWindow(WINDOW_NAME .. "OutputCircle")
	}
  end

  self.m_Windows = {
	[TITLEBAR] = Label:CreateFrameForExistingWindow(WINDOW_NAME .. "TitleBarLabel"),
	[ICON_FRAME] = CIRCLE_ICON,
	[NAME_COLUMN] = Label:CreateFrameForExistingWindow(WINDOW_NAME .. "OutputAreaNameColumn"),
	[NAME_LABEL] = Label:CreateFrameForExistingWindow(WINDOW_NAME .. "OutputAreaNameElement"),
	[AREA_LIST_WINDOW] = AREA_LIST,
	[REFRESH_BUTTON_WINDOW] = REFRESH_BUTTON,
	[OBJECTIVE_LIST_WINDOW] = OBJECTIVE_LIST,
	[OUTPUT_TEXT] = TextEditBox:CreateFrameForExistingWindow(WINDOW_NAME .. "OutputText")
  }

  local win      = self.m_Windows

  win[TITLEBAR]:SetText(L"Area Viewer")
  win[REFRESH_BUTTON_WINDOW]:SetText(L"Refresh")


  if win[OUTPUT_TEXT]:TextAsWideString() == L"" then
	win[OUTPUT_TEXT]:SetTextCache("Hover over an entry to see more information.")
  end

  win[OBJECTIVE_LIST_WINDOW]:SetRowDefinition()
  win[AREA_LIST_WINDOW]:SetRowDefinition()
end

function WINDOW:OnRButtonUp()
  EA_Window_ContextMenu.CreateOpacityOnlyContextMenu(WINDOW_NAME)
end

function WINDOW:UpdateAreaText()
  local win = self.m_Windows
  if win then
	local zoneText = GameData.Player.area.name

	if (text == L"") then
	  zoneText = GetZoneName(GameData.Player.zone)
	end

	if (text == L"") then
	  zoneText = L"Zone " .. GameData.Player.zone
	end

	if (TerminalAreaViewer.IsInPQ()) then
	  zoneText = text .. L" (PQ)"
	  win[NAME_LABEL]:SetText(zoneText)
	  win[NAME_LABEL]:SetTextColor(128, 204, 102)
	else
	  win[NAME_LABEL]:SetText(zoneText)
	  win[NAME_LABEL]:SetTextColor(255, 204, 102)
	end

	win[NAME_COLUMN]:SetText(GetZoneName(GameData.Player.zone))
  end
end

function WINDOW:OnShown()
  local settings = TerminalAreaViewer:GetSavedSettings()

  if settings.isRegistered then
	TerminalAreaViewer.UpdateDisplay()
	return
  end

  warExtended:RegisterGameEvent({
	"player area name changed",
	"player area changed",
	"player zone changed",
	"public quest added",
	"public quest updated",
	"public quest condition updated",
	"public quest completed",
	"public quest failed",
	"public quest resetting",
	"public quest info updated",
	"public quest list updated",
	"public quest removed"
  }, "TerminalAreaViewer.UpdateDisplay")

  settings.isRegistered = true

  TerminalAreaViewer.UpdateDisplay()
end

function WINDOW:OnShutdown()
  local settings      = TerminalAreaViewer:GetSettings()
  local savedSettings = TerminalAreaViewer:GetSavedSettings()

  savedSettings.isRegistered = false;
  settings.areaData          = {}
  settings.objectivesData    = {}
end

function WINDOW:OnHidden()
  local settings      = TerminalAreaViewer:GetSettings()
  local savedSettings = TerminalAreaViewer:GetSavedSettings()


  if not savedSettings.isRegistered then
	return
  end

  warExtended:UnregisterGameEvent({
	"player area name changed",
	"player area changed",
	"player zone changed",
	"public quest added",
	"public quest updated",
	"public quest condition updated",
	"public quest completed",
	"public quest failed",
	"public quest resetting",
	"public quest info updated",
	"public quest list updated",
	"public quest removed"
  }, "TerminalAreaViewer.UpdateDisplay")

  savedSettings.isRegistered = false;
  settings.areaData          = {}
  settings.objectivesData    = {}
end

function CIRCLE_ICON:UpdateControlIcon()
  local zoneData = GameData.Player.zone

  if not zoneData or not self.m_Windows then
	return
  end

  WindowSetShowing(  self:GetName().."Lock1", false )
  WindowSetShowing(  self:GetName().."Lock2", false )
  WindowSetShowing(  self:GetName().."ControlIconLock", false )


  EA_Window_WorldMap.currentPairing = GetZonePairing()
  EA_Window_WorldMap.UpdateIconForZone( GameData.Player.zone, 1, self:GetName() )
end

function REFRESH_BUTTON:OnLButtonUp()
  TerminalAreaViewer.UpdateDisplay()
end

function AREA_LIST:GetAreaData()
  local settings        = TerminalAreaViewer:GetSettings()
  local currentAreaData = GetAreaData()

  settings.areaData     = {}
  settings.areaData     = currentAreaData
  return settings.areaData
end

function WINDOW:SetOutputText(data)
  local EDIT_BOX = WINDOW.m_Windows[OUTPUT_TEXT]
  local str      = objToString(data)
  EDIT_BOX:SetTextCache(str)
end

function AREA_LIST:IsInPQ()
  local isInPQ = TerminalAreaViewer:GetSettings().isInPQ
  return isInPQ
end

function AREA_LIST.OnMouseOverItem(rowItem)
  local rowData = TerminalAreaViewer:GetSettings().areaData[rowItem]
  WINDOW:SetOutputText(rowData)
end

function OBJECTIVE_LIST.OnMouseOverItem(rowItem)
  local rowData = TerminalAreaViewer:GetSettings().objectivesData[rowItem]
  WINDOW:SetOutputText(rowData)
end

function OBJECTIVE_LIST:GetObjectivesData()
  local settings          = TerminalAreaViewer:GetSettings()
  settings.objectivesData = {}

  local activeObjectives  = GetActiveObjectivesData()
  local areaObjectives    = GetGameDataObjectives()

  settings.objectivesData = warExtended:CombineTable(activeObjectives, areaObjectives)
  return settings.objectivesData
end

function TerminalAreaViewer.UpdateDisplay()
  local areaData       = AREA_LIST:GetAreaData()
  local objectivesData = OBJECTIVE_LIST:GetObjectivesData()

  WINDOW:UpdateAreaText()
  CIRCLE_ICON:UpdateControlIcon()

  OBJECTIVE_LIST:SetDisplayOrder(objectivesData)
  AREA_LIST:SetDisplayOrder(areaData)
end

function OBJECTIVE_LIST:SetRowDefinition()
  local settings     = TerminalAreaViewer:GetSettings()

  local rowCallbacks = {
	["OnMouseOver"] = OBJECTIVE_LIST.OnMouseOverItem
  }

  local labelData    = {
	["Details1"] = { subclass = Label, callback = function(self, index)
	  local obj    = settings.objectivesData[index]
	  local idText = L"ID #" .. obj.id .. L" "

	  if (obj.Quest ~= nil)
	  then idText = idText .. L"(Active)"
	  end

	  self:SetText(idText)
	end,
	},

	["Details2"] = { subclass = Label, callback = function(self, index)
	  local obj      = settings.objectivesData[index]
	  local typeText = L""

	  if (obj.isPublicQuest) then typeText = typeText .. L"PQ " end
	  if (obj.isBattlefieldObjective) then typeText = typeText .. L"BO " end
	  if (obj.isKeep) then typeText = typeText .. L"Keep " end
	  if (obj.isCityBoss) then typeText = typeText .. L"City " end

	  self:SetText(typeText)
	end
	}
  }

  self:SetRowCallbacks(rowCallbacks)
  self:SetRowPopulation(labelData)
end

function AREA_LIST:SetRowDefinition()
  local rowCallbacks = {
	["OnMouseOver"] = AREA_LIST.OnMouseOverItem
  }

  self:SetRowCallbacks(rowCallbacks)
end

function TerminalAreaViewer.OnPopulateObjectives()
  OBJECTIVE_LIST:SetRowData()
  OBJECTIVE_LIST:SetRowTints()
end

function TerminalAreaViewer.OnPopulateArea()
  AREA_LIST:SetRowTints()
end

WINDOW:Create()
