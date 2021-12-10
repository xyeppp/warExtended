local Specialty = warExtendedSpecialtyTraining
local SPECIALTY_WINDOW = "warExtendedSpecialtyTraining"
-- linked advances to abilities ktore sa polaczone z glowna sciezka

local specialization = {
  [1] = GameData.Player.SPECIALIZATION_PATH_1,
  [2] = GameData.Player.SPECIALIZATION_PATH_2,
  [3] = GameData.Player.SPECIALIZATION_PATH_3
}

local function getMasteryPointText()
  local masteryPointUseString = tostring(GetStringFromTable("TrainingStrings", StringTables.Training.TEXT_MASTERY_POINT_USE ))
  local tooltipText = tostring(GetSpecializationPathDescription(specialization[1]))
  tooltipText = tooltipText:gsub("(.*)<BR>", "")
  tooltipText = masteryPointUseString.."<BR><BR>"..tooltipText
  return tooltipText
end

local function getMasteryPathDescription(pathIndex)
  local tooltipText =  tostring(GetSpecializationPathDescription(specialization[pathIndex]))
  local tooltipText = tooltipText:gsub("<BR>(.*)", "")
  tooltipText = towstring(tooltipText)
  return tooltipText
end

local function getPathAbilitiesString(pathIndex)
  local pathAbilitiesString = GetStringFormat( StringTables.Default.LABEL_BONUS_SPEC_X, { GetSpecializationPathName( specialization[pathIndex]) } )
  return pathAbilitiesString
end

local function setPathTextures()
  for i=1,3 do
	DynamicImageSetTexture( SPECIALTY_WINDOW.."Path"..i.."Background", "career_mastery_image"..i, 0, 0 )
	DynamicImageSetTexture( SPECIALTY_WINDOW.."Path"..i.."Background", "career_mastery_image"..i, 0, 0 )
	DynamicImageSetTexture( SPECIALTY_WINDOW.."Path"..i.."Background", "career_mastery_image"..i, 0, 0 )
  end
end

local function setLabelText()
  for i=1,3 do
	LabelSetText(SPECIALTY_WINDOW.."Path"..i.."Title", GetStringFormat(StringTables.Default.LABEL_SPECIALIZATION_TITLE, { GetSpecializationPathName(specialization[i])}))
	LabelSetText(SPECIALTY_WINDOW..i.."Title", GetStringFormat(StringTables.Default.LABEL_SPECIALIZATION_TITLE, { GetSpecializationPathName(specialization[i])}))
	LabelSetText(SPECIALTY_WINDOW..i.."Title", GetStringFormat(StringTables.Default.LABEL_SPECIALIZATION_TITLE, { GetSpecializationPathName(specialization[i])}))
 
	LabelSetText(SPECIALTY_WINDOW.."Path"..i.."Description", getMasteryPathDescription(i))
	LabelSetText(SPECIALTY_WINDOW..i.."Description", getMasteryPathDescription(i))
	LabelSetText(SPECIALTY_WINDOW..i.."Description", getMasteryPathDescription(i))
 
	LabelSetText(SPECIALTY_WINDOW.."Path"..i.."AbilityDescription", L"Core Abilities")
	LabelSetText(SPECIALTY_WINDOW..i.."AbilityDescription", L"Core Abilities")
	LabelSetText(SPECIALTY_WINDOW..i.."AbilityDescription", L"Core Abilities")
	
	ButtonSetText(SPECIALTY_WINDOW.."Path"..i.."PathIncrement", L"+" )
	ButtonSetText(SPECIALTY_WINDOW.."Path"..i.."PathDecrement", L"-" )
 
	for index, frame in pairs(warExtendedSpecialtyTraining.pathFrames[i])
	do
	  frame:SetText(L""..index)
	end
  end
	
	LabelSetText(SPECIALTY_WINDOW.."TitleBarText", GetString( StringTables.Default.TITLE_TRAINING ))
	--LabelSetText(SPECIALTY_WINDOW.."MasteryPointsDescription",  GetStringFromTable("TrainingStrings", StringTables.Training.TEXT_MASTERY_POINT_USE ) )
  	--LabelSetText(SPECIALTY_WINDOW.."MasteryPointsDescription2", towstring(getMasteryPointText()))
 
	ButtonSetText( SPECIALTY_WINDOW.."RespecializeButton", GetString( StringTables.Default.LABEL_PURCHASE_RESPECIALIZATION ) )
	ButtonSetText( SPECIALTY_WINDOW.."PurchaseButton",     GetStringFromTable("TrainingStrings", StringTables.Training.LABEL_PURCHASE_TRAINING ) )
	ButtonSetText( SPECIALTY_WINDOW.."CancelButton",       GetStringFromTable("TrainingStrings", StringTables.Training.LABEL_CANCEL_TRAINING ) )
end


local function initializeFrames()
  for specializationPath=1,3 do
	Specialty.pathFrames[specializationPath] = {}
	for frameNumber = 1, 15
	do
	  Specialty.pathFrames[specializationPath][frameNumber] = EA_Window_InteractionSpecialtyTrainingLevel:CreateFrameForExistingWindow("warExtendedSpecialtyTrainingPath"..specializationPath.."SpecializationStep"..frameNumber)
	end
  end
end

function Specialty.OnMouseOverMasteryPoints()
  local tooltipText = towstring(getMasteryPointText())
  
  Tooltips.CreateTextOnlyTooltip(SystemData.MouseOverWindow.name, tooltipText)
  Tooltips.AnchorTooltip(Tooltips.ANCHOR_WINDOW_BOTTOM)
end

function Specialty.OnMouseOverPathName()
  local pathIndex = WindowGetId(WindowGetParent(SystemData.MouseOverWindow.name))
  local description = getMasteryDescriptionTooltipText(pathIndex)
  
  Tooltips.CreateTextOnlyTooltip(SystemData.MouseOverWindow.name, description)
  Tooltips.AnchorTooltip(Tooltips.ANCHOR_WINDOW_BOTTOM)
end

function Specialty.OnMouseOverAbilitiesDescription()
  local tooltipText = GetStringFromTable("TrainingStrings", StringTables.Training.TEXT_LINKED_ABILITY_EXPLANATION )
  
  Tooltips.CreateTextOnlyTooltip(SystemData.MouseOverWindow.name, tooltipText)
  Tooltips.AnchorTooltip(Tooltips.ANCHOR_WINDOW_BOTTOM)
end

function Specialty.UpdateMasteryPointsAvailable()
  local pointsTotal     = GameData.Player.GetAdvancePointsAvailable()[GameData.CareerCategory.SPECIALIZATION]
  local pointsSpent     = EA_Window_InteractionSpecialtyTraining.GetSelectedAdvanceCount() + EA_Window_InteractionSpecialtyTraining.GetSelectedSpecLevelCount()
  local pointsRemaining = pointsTotal - pointsSpent
  local pointText       = GetStringFormatFromTable("TrainingStrings", StringTables.Training.LABEL_SPECIALIZATION_POINTS_LEFT, { L""..pointsRemaining } )
  
  LabelSetText(SPECIALTY_WINDOW.."MasteryPoints", pointText)
end

function Specialty.OnInitializeWindow()
  initializeFrames()
  setLabelText()
  setPathTextures()
  
  WindowRegisterEventHandler(SPECIALTY_WINDOW, SystemData.Events.PLAYER_CAREER_CATEGORY_UPDATED,  "warExtendedSpecialtyTraining.Refresh")
  WindowRegisterEventHandler(SPECIALTY_WINDOW, SystemData.Events.PLAYER_MONEY_UPDATED,            "warExtendedSpecialtyTraining.UpdateMasteryPointsAvailable" )
  WindowRegisterEventHandler(SPECIALTY_WINDOW, SystemData.Events.PLAYER_ABILITIES_LIST_UPDATED,   "warExtendedSpecialtyTraining.Refresh" )
  WindowRegisterEventHandler(SPECIALTY_WINDOW, SystemData.Events.PLAYER_SINGLE_ABILITY_UPDATED,   "warExtendedSpecialtyTraining.Refresh" )
  WindowRegisterEventHandler(SPECIALTY_WINDOW, SystemData.Events.PLAYER_CAREER_LINE_UPDATED,      "warExtendedSpecialtyTraining.SetMasteryImages" )
  
  Specialty.LoadAdvances()
end


function Specialty.OnShutdownWindow()
  
  for path=1,3 do
	for index, frame in pairs(Specialty.pathFrames[path])
	do
	  frame:Destroy()
	end
	
	for index, frame in pairs(Specialty.abilityFrames[path])
	do
	  frame:Destroy()
	end
  end
  
  Specialty.abilityFrames = {}
end

function Specialty.Refresh()
  
  if (WindowGetShowing(SPECIALTY_WINDOW ) == false)
  then
	return
  end
  
  Specialty.LoadAdvances()
  Specialty.RefreshDisplayPanel()
  

  Specialty.PopulateSpecialty()
  Specialty.RefreshInteractivePanel()
  
  Specialty.ClearSelection()
end

function Specialty.RefreshInteractivePanel()
  Specialty.RefreshPathLevel()
  Specialty.RefreshPathAbilities()
  Specialty.SetPurchaseButtonStates()
end



function Specialty.PopulateSpecialty()
  Specialty.PopulateAdvanceTables()
  
	-- Wipe out the dynamic layout frames
  for i=1,3 do
	for _, frame in pairs(Specialty.abilityFrames[i])
	do
	  frame:Destroy()
	end
	
  end
  
  Specialty.abilityFrames = {}
  
  Specialty.PopulatePathAbilities()
  Specialty.PopulateLinkedAbilities()
  Specialty.RefreshInteractivePanel()
end


function Specialty.OnShown()
  WindowUtils.OnShown(warExtendedSpecialtyTraining.Hide, WindowUtils.Cascade.MODE_AUTOMATIC)
end

function Specialty.ClearSelection()
  Specialty.selectedSpecializationLevels = { 0, 0, 0 }
  Specialty.selectedAdvances             = { {}, {}, {} }
end

function Specialty.OnHidden()
	WindowUtils.RemoveFromOpenList(SPECIALTY_WINDOW)
  Specialty.ClearSelection()
end

function Specialty.Hide()
  WindowSetShowing(SPECIALTY_WINDOW, false)
end
