local warExtended            = warExtended
--TODO: Add (RoR_CitySiege.GetCity(GameData.CityId.EMPIRE//GameData.Player.zone) & GetCampaignZoneData(GameData.Player.zone)
--TODO: add mouseover on circle image with lock yadda yadda


local WINDOW_NAME            = "TerminalAreaViewer"
local ICON_FRAME             = 1
local NAME_COLUMN            = 2
local NAME_LABEL             = 3
local SORT_BUTTON_1          = 4
local SORT_BUTTON_2          = 5
local SORT_BUTTON_3          = 6
local AREA_LIST_WINDOW       = 7
local REFRESH_BUTTON_WINDOW  = 8
local OBJECTIVE_TITLE_BUTTON = 9
local OBJECTIVE_LIST_WINDOW  = 10
local OUTPUT_TEXT            = 11
local TITLEBAR               = 12
local LOCK_BUTTON            = 13

local TerminalAreaViewer     = TerminalAreaViewer

local WINDOW                 = Frame:Subclass(WINDOW_NAME)
local AREA_LIST              = ListBox:CreateFrameForExistingWindow(WINDOW_NAME .. "OutputAreaList")
local OBJECTIVE_LIST         = ListBox:CreateFrameForExistingWindow(WINDOW_NAME .. "OutputObjectivesList")
local REFRESH_BUTTON         = ButtonFrame:CreateFrameForExistingWindow(WINDOW_NAME .. "OutputRefreshButton")
local CIRCLE_ICON            = DynamicImage:CreateFrameForExistingWindow(WINDOW_NAME .. "OutputCircle")

function WINDOW:Create()
  self:CreateFromTemplate(WINDOW_NAME)
  AREA_LIST:SetSelfTable(TerminalAreaViewerOutputAreaList)
  OBJECTIVE_LIST:SetSelfTable(TerminalAreaViewerOutputObjectivesList)
  
  if not CIRCLE_ICON.m_Windows then
	CIRCLE_ICON.m_Windows = {
	  [LOCK_BUTTON] = DynamicImage:CreateFrameForExistingWindow(WINDOW_NAME .. "OutputCircleLock")
	}
  end
  
  self.m_Windows = {
	[TITLEBAR] = Label:CreateFrameForExistingWindow(WINDOW_NAME .. "TitleBarLabel"),
	[ICON_FRAME] = CIRCLE_ICON,
	[NAME_COLUMN] = Label:CreateFrameForExistingWindow(WINDOW_NAME .. "OutputAreaNameColumn"),
	[NAME_LABEL] = Label:CreateFrameForExistingWindow(WINDOW_NAME .. "OutputAreaNameElement"),
	[SORT_BUTTON_1] = ButtonFrame:CreateFrameForExistingWindow(WINDOW_NAME .. "OutputAreaSortButton1"),
	[SORT_BUTTON_2] = ButtonFrame:CreateFrameForExistingWindow(WINDOW_NAME .. "OutputAreaSortButton2"),
	[SORT_BUTTON_3] = ButtonFrame:CreateFrameForExistingWindow(WINDOW_NAME .. "OutputAreaSortButton3"),
	[AREA_LIST_WINDOW] = AREA_LIST,
	[REFRESH_BUTTON_WINDOW] = REFRESH_BUTTON,
	[OBJECTIVE_TITLE_BUTTON] = ButtonFrame:CreateFrameForExistingWindow(WINDOW_NAME .. "OutputObjectiveTitleButton"),
	[OBJECTIVE_LIST_WINDOW] = OBJECTIVE_LIST,
	[OUTPUT_TEXT] = TextEditBox:CreateFrameForExistingWindow(WINDOW_NAME .. "OutputText")
  }
  
  local win      = self.m_Windows
  
  win[TITLEBAR]:SetText(L"Area Viewer")
  win[SORT_BUTTON_1]:SetText(L"Area ID")
  win[SORT_BUTTON_2]:SetText(L"Area Name")
  win[SORT_BUTTON_3]:SetText(L"Influence ID")
  win[REFRESH_BUTTON_WINDOW]:SetText(L"Refresh")
  win[OBJECTIVE_TITLE_BUTTON]:SetText(L"Objectives")
  win[OBJECTIVE_TITLE_BUTTON]:SetDisabled(true)
  
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

function CIRCLE_ICON:UpdateControlIcon()
  local zoneData = GetCampaignZoneData(GameData.Player.zone)
  
  if not zoneData or not self.m_Windows then
	return
  end
  
  local currentSliceName = EA_Window_WorldMap.GetIconSliceForZone(GameData.Player.zone, zoneData.pairingId, zoneData.controllingRealm, 1)
  self.m_Windows[LOCK_BUTTON]:Show(zoneData.isLocked or zoneData.controlPoints[0] == 100)
  self:SetTextureSlice(currentSliceName)
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
