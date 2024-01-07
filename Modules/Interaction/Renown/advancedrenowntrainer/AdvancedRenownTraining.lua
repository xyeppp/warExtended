-- Variables

-- InteractionUtils.IsRenownAdvance(id)  -> id : number

AdvancedRenownTraining = {}

AdvancedRenownTraining.BASIC = "TabsBasicTab"
AdvancedRenownTraining.ADVANCED = "TabsAdvancedTab"
AdvancedRenownTraining.ACTIVE = "TabsActiveTab"
AdvancedRenownTraining.DEF = "TabsDefTab"

local availablePoints = 0
local spentPoints = 0
local CheckButton = false
local currentSpecSave = nil

local  ANCHOR_CURSOR    = { Point = "topleft", RelativeTo = "CursorWindow", RelativePoint = "bottomleft", XOffset = 30, YOffset = -20 }
local LookUpTable = {
	[9902] = {window="MightIWindow",
			  followedBy=9903,
			  first=true,
			  tier = "t1"},
	[9903] = {window="MightIIWindow",
			  followedBy=9904,
			  tier = "t2"},
	[9904] = {window="MightIIIWindow",
			  followedBy=9905,
			  tier = "t3"},
	[9905] = {window="MightIVWindow",
			  followedBy=9906,
			  tier = "t4"},
	[9906] = {window="MightVWindow",
			  last=true,
			  tier = "t5"},
	[9908] = {window="BladeMasterIWindow",
			  followedBy=9909,
			  first=true,
			  tier = "t1"},
	[9909] = {window="BladeMasterIIWindow",
			  followedBy=9910,
			  tier = "t2"},
	[9910] = {window="BladeMasterIIIWindow",
			  followedBy=9911,
			  tier = "t3"},
	[9911] = {window="BladeMasterIVWindow",
			  followedBy=9912,
			  tier = "t4"},
	[9912] = {window="BladeMasterVWindow",
			  last=true,
			  tier = "t5"},
	[9914] = {window="MarksmenIWindow",
			  followedBy=9915,
			  first=true,
			  tier = "t1"},
	[9915] = {window="MarksmenIIWindow",
			  followedBy=9916,
			  tier = "t2"},
	[9916] = {window="MarksmenIIIWindow",
			  followedBy=9917,
			  tier = "t3"},
	[9917] = {window="MarksmenIVWindow",
			  followedBy=9918,
			  tier = "t4"},
	[9918] = {window="MarksmenVWindow",
			  last=true,
			  tier = "t5"},
	[9920] = {window="ImpetusIWindow",
			  followedBy=9921,
			  first=true,
			  tier = "t1"},
	[9921] = {window="ImpetusIIWindow",
			  followedBy=9922,
			  tier = "t2"},
	[9922] = {window="ImpetusIIIWindow",
			  followedBy=9923,
			  tier = "t3"},
	[9923] = {window="ImpetusIVWindow",
			  followedBy=9924,
			  tier = "t4"},
	[9924] = {window="ImpetusVWindow",
			  last=true,
			  tier = "t5"},
	[9926] = {window="AcumenIWindow",
			  followedBy=9927,
			  first=true,
			  tier = "t1"},
	[9927] = {window="AcumenIIWindow",
			  followedBy=9928,
			  tier = "t2"},
	[9928] = {window="AcumenIIIWindow",
			  followedBy=9929,
			  tier = "t3"},
	[9929] = {window="AcumenIVWindow",
			  followedBy=9930,
			  tier = "t4"},
	[9930] = {window="AcumenVWindow",
			  last=true,
			  tier = "t5"},
	[9932] = {window="ResolveIWindow",
			  followedBy=9933,
			  first=true,
			  tier = "t1"},
	[9933] = {window="ResolveIIWindow",
			  followedBy=9934,
			  tier = "t2"},
	[9934] = {window="ResolveIIIWindow",
			  followedBy=9935,
			  tier = "t3"},
	[9935] = {window="ResolveIVWindow",
			  followedBy=9936,
			  tier = "t4"},
	[9936] = {window="ResolveVWindow",
			  last=true,
			  tier = "t5"},
	[9938] = {window="FortitudeIWindow",
			  followedBy=9939,
			  first=true,
			  tier = "t1"},
	[9939] = {window="FortitudeIIWindow",
			  followedBy=9940,
			  tier = "t2"},
	[9940] = {window="FortitudeIIIWindow",
			  followedBy=9941,
			  tier = "t3"},
	[9941] = {window="FortitudeIVWindow",
			  followedBy=9942,
			  tier = "t4"},
	[9942] = {window="FortitudeVWindow",
			  last=true,
			  tier = "t5"},
	[9944] = {window="VigorIWindow",
			  followedBy=9945,
			  first=true,
			  tier = "t1"},
	[9945] = {window="VigorIIWindow",
			  followedBy=9946,
			  tier = "t2"},
	[9946] = {window="VigorIIIWindow",
			  followedBy=9947,
			  tier = "t3"},
	[9947] = {window="VigorIVWindow",
			  followedBy=9948,
			  tier = "t4"},
	[9948] = {window="VigorVWindow",
			  last=true,
			  tier = "t5"},
	[9952] = {window="ReflexesIWindow",
			  followedBy=9953,
			  first=true,
			  tier = "t1"},
	[9953] = {window="ReflexesIIWindow",
			  followedBy=9954,
			  tier = "t2"},
	[9954] = {window="ReflexesIIIWindow",
			  followedBy=9955,
			  tier = "t3"},
	[9955] = {window="ReflexesIVWindow",
			  last=true,
			  tier = "t4"},
	[9958] = {window="DefenderIWindow",
			  followedBy=9959,
			  first=true,
			  tier = "t1"},
	[9959] = {window="DefenderIIWindow",
			  followedBy=9960,
			  tier = "t2"},
	[9960] = {window="DefenderIIIWindow",
			  followedBy=9961,
			  tier = "t3"},
	[9961] = {window="DefenderIVWindow",
			  last=true,
			  tier = "t4"},
	[9964] = {window="HardyConcessionIWindow",
			  followedBy=9965,
			  first=true,
			  tier = "t1"},
	[9965] = {window="HardyConcessionIIWindow",
			  followedBy=9966,
			  tier = "t2"},
	[9966] = {window="HardyConcessionIIIWindow",
			  followedBy=9967,
			  tier = "t3"},
	[9967] = {window="HardyConcessionIVWindow",
			  followedBy=9968,
			  tier = "t4"},
	[9968] = {window="HardyConcessionVWindow",
			  last=true,
			  tier = "t5"},
	[9970] = {window="DeftDefenderIWindow",
			  followedBy=9971,
			  first=true,
			  tier = "t1"},
	[9971] = {window="DeftDefenderIIWindow",
			  followedBy=9972,
			  tier = "t2"},
	[9972] = {window="DeftDefenderIIIWindow",
			  followedBy=9973,
			  tier = "t3"},
	[9973] = {window="DeftDefenderIVWindow",
			  last=true,
			  tier = "t4"},
	[9977] = {window="OpportunistIWindow",
			  followedBy=9978,
			  first=true,
			  tier = "t1"},
	[9978] = {window="OpportunistIIWindow",
			  followedBy=9979,
			  tier = "t2"},
	[9979] = {window="OpportunistIIIWindow",
			  followedBy=9980,
			  tier = "t3"},
	[9980] = {window="OpportunistIVWindow",
			  last=true,
			  tier = "t4"},
	[9983] = {window="SureShotIWindow",
			  followedBy=9984,
			  first=true,
			  tier = "t1"},
	[9984] = {window="SureShotIIWindow",
			  followedBy=9985,
			  tier = "t2"},
	[9985] = {window="SureShotIIIWindow",
			  followedBy=9986,
			  tier = "t3"},
	[9986] = {window="SureShotIVWindow",
			  last=true,
			  tier = "t4"},
	[9989] = {window="FocusedPowerIWindow",
			  followedBy=9990,
			  first=true,
			  tier = "t1"},
	[9990] = {window="FocusedPowerIIWindow",
			  followedBy=9991,
			  tier = "t2"},
	[9991] = {window="FocusedPowerIIIWindow",
			  followedBy=9992,
			  tier = "t3"},
	[9992] = {window="FocusedPowerIVWindow",
			  last=true,
			  tier = "t4"},
	[9995] = {window="SpiritualRefinementIWindow",
			  followedBy=9996,
			  first=true,
			  tier = "t1"},
	[9996] = {window="SpiritualRefinementIIWindow",
			  followedBy=9997,
			  tier = "t2"},
	[9997] = {window="SpiritualRefinementIIIWindow",
			  followedBy=9998,
			  tier = "t3"},
	[9998] = {window="SpiritualRefinementIVWindow",
			  last=true,
			  tier = "t4"},
	[10001] = {window="FutileStrikesIWindow",
			  followedBy=10002,
			  first=true,
			  tier = "t1"},
	[10002] = {window="FutileStrikesIIWindow",
			  followedBy=10003,
			  tier = "t2"},
	[10003] = {window="FutileStrikesIIIWindow",
			  followedBy=10004,
			  tier = "t3"},
	[10004] = {window="FutileStrikesIVWindow",
			   last=true,
			  tier = "t4"},
	[10007] = {window="TrivalBlowsIWindow",
			  followedBy=10008,
			  first=true,
			  tier = "t1"},
	[10008] = {window="TrivalBlowsIIWindow",
			  followedBy=10009,
			  tier = "t2"},
	[10009] = {window="TrivalBlowsIIIWindow",
			  followedBy=10010,
			  tier = "t3"},
	[10010] = {window="TrivalBlowsIVWindow",
			  last=true,
			  tier = "t4"},
	[10016] = {window="ExpandedCapacityIWindow",
			  followedBy=10017,
			  first=true,
			  tier = "t1"},
	[10017] = {window="ExpandedCapacityIIWindow",
			  followedBy=10018,
			  tier = "t2"},
	[10018] = {window="ExpandedCapacityIIIWindow",
			  last=true,
			  tier = "t3"},
	[10022] = {window="RegenerationIWindow",
			  followedBy=10023,
			  first=true,
			  tier = "t1"},
	[10023] = {window="RegenerationIIWindow",
			  followedBy=10024,
			  tier = "t2"},
	[10024] = {window="RegenerationIIIWindow",
			  last=true,
			  tier = "t3"},
	[10028] = {window="QuickEscapeIWindow",
			  followedBy=10029,
			  first=true,
			  tier = "t1"},
	[10029] = {window="QuickEscapeIIWindow",
			  followedBy=10030,
			  tier = "t2"},
	[10030] = {window="QuickEscapeIIIWindow",
			  last=true,
			  tier = "t3"},
	[10034] = {window="ImprovedFleeIWindow",
			  followedBy=10035,
			  first=true,
			  tier = "t1"},
	[10035] = {window="ImprovedFleeIIWindow",
			  last=true,
			  tier = "t2"},
	[10051] = {window="CleansingWindIWindow",
			  followedBy=10052,
			  first=true,
			  tier = "t1",
			  minimum = 20},
	[10052] = {window="CleansingWindIIWindow",
			  followedBy=10053,
			  tier = "t2"},
	[10053] = {window="CleansingWindIIIWindow",
			  last=true,
			  tier = "t3"},
	[10057] = {window="ResoluteDefenseIWindow",
			  followedBy=10058,
			  first=true,
			  tier = "t1",
			  minimum = 20},
	[10058] = {window="ResoluteDefenseIIWindow",
			  followedBy=10059,
			  tier = "t2"},
	[10059] = {window="ResoluteDefenseIIIWindow",
			  last=true,
			  tier = "t3"},
	[10063] = {window="EfficiencyIWindow",
			  followedBy=10064,
			  first=true,
			  tier = "t1",
			  minimum = 20},
	[10064] = {window="EfficiencyIIWindow",
			  last=true,
			  tier = "t2"},
	[10069] = {window="LastStandIWindow",
			  followedBy=10070,
			  first=true,
			  tier = "t1",
			  minimum = 20},
	[10070] = {window="LastStandIIWindow",
			  last=true,
			  tier = "t2"},
}

AdvancedRenownTraining.AbilityData = {}

local WindowName = "AdvancedRenownTrainingWindow"
local PresetWindowName = "AdvancedRenownTrainingPresetsWindow"

local pointsAvailable = 0
local pointsSpend = 0

AdvancedRenownTraining.selectedAdvantages = {
	t1 = {},
	t2 = {},
	t3 = {},
	t4 = {},
	t5 = {}
}
AdvancedRenownTraining.purchasedAdvantages = {}

AdvancedRenownTraining.Presets = {}

-- local Functions

local function ResetSelect()
	AdvancedRenownTraining.selectedAdvantages = {
		t1 = {},
		t2 = {},
		t3 = {},
		t4 = {},
		t5 = {}
	}
	for i,v in pairs(LookUpTable) do
		if v.first then
			v.enabled = true
		else
			v.enabled = false
		end
	end
end

function AdvancedRenownTraining.UpdatePointsLabel()
	availablePoints = EA_Window_InteractionRenownTraining.GetPointsAvailable()
	spentPoints = EA_Window_InteractionRenownTraining.GetPointsSpent()
	LabelSetText(WindowName.."RenownLabel", GetStringFormatFromTable("TrainingStrings", StringTables.Training.LABEL_RENOWN_PURSE, { L""..availablePoints, L""..spentPoints } ))
end

local function CreateAbilityWindow(t, tab)
	CreateWindowFromTemplate(t.windowName, "AbilityButtonTemplate", WindowName..tab)
	WindowAddAnchor(t.windowName, t.relativePoint, t.relativeTo, t.point, t.x, t.y)
	WindowSetId(t.windowName, t.id)
	DynamicImageSetTexture(t.windowName.."Square", GetIconData(t.icon), 0,0)
end

local function SetLabels()
	LabelSetText(WindowName.."TitleBarText",         GetStringFromTable("TrainingStrings", StringTables.Training.LABEL_RENOWN_TRAINING_TITLE ) )
	LabelSetText(PresetWindowName.."SaveLabel", L"Save name:")
	LabelSetText(PresetWindowName.."LoadLabel", L"Load preset:")
	LabelSetText(PresetWindowName.."SaveSelectedLabel", L"Also save selected abilities")
	LabelSetText(PresetWindowName.."PointNeededLabel", L"Points needed:")
	LabelSetText(PresetWindowName.."PointLabel", L"0")
	ButtonSetText(WindowName.."RespecializeButton", GetString( StringTables.Default.LABEL_PURCHASE_RESPECIALIZATION ) )
	ButtonSetText(WindowName.."PurchaseButton",     GetStringFromTable("TrainingStrings", StringTables.Training.LABEL_PURCHASE_TRAINING ) )
	ButtonSetText(WindowName.."CancelButton",       GetStringFromTable("TrainingStrings", StringTables.Training.LABEL_CANCEL_TRAINING ) )
	ButtonSetText(WindowName.."PresetButton",       L"Presets" )
	ButtonSetText(PresetWindowName.."SaveButton", L"Save")
	ButtonSetText(PresetWindowName.."LoadButton", L"Load")
	ButtonSetText(PresetWindowName.."DeleteButton", L"Delete")
	ButtonSetText(WindowName.."TabsAdvancedTab",L"Advanced")
	ButtonSetText(WindowName.."TabsActiveTab",L"Abilities")
	ButtonSetText(WindowName.."TabsBasicTab",L"Basic")
	ButtonSetText(WindowName.."TabsDefTab",L"Defensive")
	ButtonSetPressedFlag(PresetWindowName.."SaveSelectedCheckBox" , CheckButton)
	for k,v in pairs (AdvancedRenownTraining.Presets) do
		ComboBoxAddMenuItem(PresetWindowName.."LoadComboBox", k)
	end
	AdvancedRenownTraining.UpdatePointsLabel()
end

local function UpdatePurchasedAdvantages()
	AdvancedRenownTraining.purchasedAdvantages = {}
	for _,d in ipairs(AdvancedRenownTraining.AbilityData) do
		if d.timesPurchased > 0 then
			AdvancedRenownTraining.purchasedAdvantages[d.advanceID] = true
		end
	end
end

local function SetPurchased(id)
	WindowSetTintColor(LookUpTable[id].window.."Square", 20,255,20)
	local follow = LookUpTable[id].followedBy
	if follow then
		for i,_ in pairs(AdvancedRenownTraining.purchasedAdvantages) do
			if i == follow then
				return
			end
		end
		LookUpTable[follow].enabled = true
		WindowSetTintColor(LookUpTable[follow].window.."Square", 255,255,255)
		return
	end
end

local function SelectAdvantage(id)
	local pointCost = LookUpTable[id].pointCost
	local window = LookUpTable[id].window
	if pointCost <= availablePoints then
		table.insert(AdvancedRenownTraining.selectedAdvantages[LookUpTable[id].tier], id)
		WindowSetTintColor(window.."Square", 60,60,250)
		local follow = LookUpTable[id].followedBy
		local previous = LookUpTable[id].previous
		availablePoints = availablePoints - LookUpTable[id].pointCost
		LabelSetText(WindowName.."RenownLabel", GetStringFormatFromTable("TrainingStrings", StringTables.Training.LABEL_RENOWN_PURSE, { L""..availablePoints, L""..spentPoints } ))
		if follow then
			LookUpTable[follow].enabled = true
			WindowSetTintColor(LookUpTable[follow].window.."Square", 255,255,255)
		end
		if previous then
			LookUpTable[previous].enabled = false
		end
	end
end

local function UnselectAdvantage(pos, id, window)
	AdvancedRenownTraining.selectedAdvantages[LookUpTable[id].tier][pos] = nil
	WindowSetTintColor(window.."Square", 255,255,255)
	availablePoints = availablePoints + LookUpTable[id].pointCost
	LabelSetText(WindowName.."RenownLabel", GetStringFormatFromTable("TrainingStrings", StringTables.Training.LABEL_RENOWN_PURSE, { L""..availablePoints, L""..spentPoints } ))
	if LookUpTable[id].first then
		LookUpTable[LookUpTable[id].followedBy].enabled = false
		WindowSetTintColor(LookUpTable[LookUpTable[id].followedBy].window.."Square", 240,40,40)
	elseif LookUpTable[id].followedBy == nil then
		LookUpTable[LookUpTable[id].previous].enabled = true
	else
		LookUpTable[LookUpTable[id].previous].enabled = true
		LookUpTable[LookUpTable[id].followedBy].enabled = false
		WindowSetTintColor(LookUpTable[LookUpTable[id].followedBy].window.."Square", 240,40,40)
	end
end

-- Public functions

function AdvancedRenownTraining.OnReload()
	UnregisterEventHandler(SystemData.Events.PLAYER_CAREER_CATEGORY_UPDATED, "AdvancedRenownTraining.CreateDataTable")
	AdvancedRenownTraining.CreateDataTable()
end

function AdvancedRenownTraining.CreateDataTable()
	AdvancedRenownTraining.AbilityData = {}
	local abilityData = GameData.Player.GetAdvanceData()
	for _,data in pairs(abilityData) do
		if InteractionUtils.IsRenownAdvance(data) then
			table.insert(AdvancedRenownTraining.AbilityData, data)
			local id = data.advanceID
			if LookUpTable[id] ~= nil then
				LookUpTable[id].pointCost = data.pointCost
				if LookUpTable[id].followedBy then
					LookUpTable[LookUpTable[id].followedBy].previous = id
				end
				if LookUpTable[id].first then
					LookUpTable[id].enabled = true
				else
					LookUpTable[id].enabled = false
				end
			end
		end
	end
	UpdatePurchasedAdvantages()
	AdvancedRenownTraining.FullRefresh()
end

local function GetPointsAvailable()
	if currentSpecSave then
		return 80
	end
	return EA_Window_InteractionRenownTraining.GetPointsAvailable()
end

local function GetPointsSpent()
	if currentSpecSave then
		return 0
	end
	return EA_Window_InteractionRenownTraining.GetPointsSpent()
end

function AdvancedRenownTraining.FullRefresh()
	for _,v in pairs(LookUpTable) do
		if v.minimum then
			if v.minimum > GameData.Player.Renown.curRank then
				v.enabled = false
			else
				v.enabled = true
			end
		end
		if v.enabled then
			WindowSetTintColor(v.window.."Square", 255,255,255)
		else
			WindowSetTintColor(v.window.."Square", 240,40,40)
		end
	end
	for i,_ in pairs(AdvancedRenownTraining.purchasedAdvantages) do
		SetPurchased(i)
	end
	availablePoints = GetPointsAvailable()
	spentPoints = GetPointsSpent()
	LabelSetText(WindowName.."RenownLabel", GetStringFormatFromTable("TrainingStrings", StringTables.Training.LABEL_RENOWN_PURSE, { L""..availablePoints, L""..spentPoints} ))
end

local function CreateTab(window)
	CreateWindowFromTemplate(window,"RenownTabTemplate",WindowName)
	LabelSetText(window.."Level1", L"1")
	LabelSetText(window.."Level2", L"2")
	LabelSetText(window.."Level3", L"3")
	LabelSetText(window.."Level4", L"4")
	LabelSetText(window.."Level5", L"5")
end

function AdvancedRenownTraining.Initialize()
	CreateWindow("AdvancedRenownTrainingPresetsWindow",false)
	--WindowSetParent("AdvancedRenownTrainingPresetsWindow", WindowName)
	SetLabels()
	CreateTab("AdvancedRenownTrainingWindowBasicTab")
	CreateTab("AdvancedRenownTrainingWindowAdvancedTab")
	CreateTab("AdvancedRenownTrainingWindowAbilityTab")
	CreateTab("AdvancedRenownTrainingWindowDefensiveTab")
	for _,v in ipairs(AdvancedRenownTraining.GetBasicCreateTable()) do
		CreateAbilityWindow(v, "BasicTab")
	end
	for _,v in ipairs(AdvancedRenownTraining.GetAdvancedCreateTable()) do
		CreateAbilityWindow(v, "AdvancedTab")
	end
	for _,v in ipairs(AdvancedRenownTraining.GetDefensiveCreateTable()) do
		CreateAbilityWindow(v, "DefensiveTab")
	end
	for _,v in ipairs(AdvancedRenownTraining.GetAbilityCreateTable()) do
		CreateAbilityWindow(v, "AbilityTab")
	end
	pointsAvailable = EA_Window_InteractionRenownTraining.GetPointsAvailable()
	pointsSpend = EA_Window_InteractionRenownTraining.GetPointsSpent()

	EA_Window_InteractionRenownTraining.Show = AdvancedRenownTraining.Show
	EA_Window_InteractionRenownTraining.Hide = AdvancedRenownTraining.Hide

	RegisterEventHandler(SystemData.Events.LOADING_END, "AdvancedRenownTraining.OnReload")
	RegisterEventHandler(SystemData.Events.PLAYER_CAREER_CATEGORY_UPDATED, "AdvancedRenownTraining.CreateDataTable")
	RegisterEventHandler(SystemData.Events.RELOAD_INTERFACE, "AdvancedRenownTraining.OnReload")
	AdvancedRenownTraining.InitializeImportExport()
end

function AdvancedRenownTraining.Show()
	--if (InteractionUtils.GetLastRequestedTrainingType() == GameData.InteractTrainerType.RENOWN) then
		AdvancedRenownTraining.FullRefresh()
		WindowSetShowing(WindowName,true)
		return
	--end
end

local function SaveCurrentSpecAsPreset(build)
	local name = L"Current Build"
	local save = {
		t1 = {},
		t2 = {},
		t3 = {},
		t4 = {},
		t5 = {}
	}
	for k,_ in pairs(build) do
		table.insert(save[LookUpTable[k].tier], k)
	end
	AdvancedRenownTraining.Presets[name] = save
	ComboBoxClearMenuItems(PresetWindowName.."LoadComboBox")
	for k,v in pairs (AdvancedRenownTraining.Presets) do
		ComboBoxAddMenuItem(PresetWindowName.."LoadComboBox", k)
	end
end

function AdvancedRenownTraining.AnywhereShow()
	ButtonSetDisabledFlag(WindowName.."PurchaseButton",true)
	--ButtonSetDisabledFlag(WindowName.."RespecializeButton",true)
	ButtonSetText(WindowName.."RespecializeButton",L"Clear")
	--ButtonSetDisabledFalg(WindowName.."ModeCB",true)
	currentSpecSave = AdvancedRenownTraining.purchasedAdvantages
	AdvancedRenownTraining.purchasedAdvantages = {}
	ResetSelect()
	AdvancedRenownTraining.FullRefresh()
	SaveCurrentSpecAsPreset(currentSpecSave)
	AdvancedRenownTraining.LoadPreset(L"Current Build")
	WindowSetShowing(WindowName,true)
end

function AdvancedRenownTraining.Hide()
	WindowSetShowing(WindowName,false)
end

local function BuyAbility(tier, category, packageID)
	BuyCareerPackage(tier, category, packageID)
end

function AdvancedRenownTraining.PurchaseAdvances()
	if ButtonGetDisabledFlag(WindowName.."PurchaseButton") then
		return
	end
	for _,id in pairs(AdvancedRenownTraining.selectedAdvantages["t1"]) do
		for k,v in pairs(AdvancedRenownTraining.AbilityData) do
			if v.advanceID == id then
				BuyAbility(v.tier,v.category,v.packageId)
				AdvancedRenownTraining.purchasedAdvantages[id] = true
			end
		end
	end
	for _,id in pairs(AdvancedRenownTraining.selectedAdvantages["t2"]) do
		for k,v in pairs(AdvancedRenownTraining.AbilityData) do
			if v.advanceID == id then
				BuyAbility(v.tier,v.category,v.packageId)
				AdvancedRenownTraining.purchasedAdvantages[id] = true
			end
		end
	end
	for _,id in pairs(AdvancedRenownTraining.selectedAdvantages["t3"]) do
		for k,v in pairs(AdvancedRenownTraining.AbilityData) do
			if v.advanceID == id then
				BuyAbility(v.tier,v.category,v.packageId)
				AdvancedRenownTraining.purchasedAdvantages[id] = true
			end
		end
	end
	for _,id in pairs(AdvancedRenownTraining.selectedAdvantages["t4"]) do
		for k,v in pairs(AdvancedRenownTraining.AbilityData) do
			if v.advanceID == id then
				BuyAbility(v.tier,v.category,v.packageId)
				AdvancedRenownTraining.purchasedAdvantages[id] = true
			end
		end
	end
	for _,id in pairs(AdvancedRenownTraining.selectedAdvantages["t5"]) do
		for k,v in pairs(AdvancedRenownTraining.AbilityData) do
			if v.advanceID == id then
				BuyAbility(v.tier,v.category,v.packageId)
				AdvancedRenownTraining.purchasedAdvantages[id] = true
			end
		end
	end
	ResetSelect()
	AdvancedRenownTraining.FullRefresh()
end

function AdvancedRenownTraining.Select()
	local activeWindow = SystemData.ActiveWindow.name
	local id = WindowGetId(activeWindow)
	if AdvancedRenownTraining.purchasedAdvantages[id] then return end
	if not LookUpTable[id].enabled then return end
	for i,v in pairs (AdvancedRenownTraining.selectedAdvantages[LookUpTable[id].tier]) do
		if id == v then
			UnselectAdvantage(i,id,activeWindow)
			return
		end
	end
	SelectAdvantage(id)
end

function AdvancedRenownTraining.AbilityTooltip()
    local advanceId = WindowGetId(SystemData.MouseOverWindow.name)

    if (advanceIndex ~= 0)
    then

			local advanceData
			for _,t in ipairs(AdvancedRenownTraining.AbilityData) do
				if t.advanceID == advanceId then
					advanceData = t
				end
			end
			if advanceData == nil then
				return
			end
            local abilityData = advanceData.abilityInfo
			p(abilityData)
            local priceString = GetStringFormatFromTable("TrainingStrings", StringTables.Training.TEXT_RENOWN_POINT_COST, { L""..advanceData.pointCost } )

            if (abilityData ~= nil)
            then
                local dependencyText = priceString --L"Point Cost:"..towstring(advanceData.pointCost)--EA_Window_InteractionRenownTraining.GetDependencyText(advanceData)

                Tooltips.CreateAbilityTooltip( abilityData, SystemData.ActiveWindow.name, EA_Window_InteractionRenownTraining.ANCHOR_CURSOR, dependencyText )
            else
                Tooltips.CreateTextOnlyTooltip(SystemData.ActiveWindow.name)

                Tooltips.SetTooltipText( 1, 1, advanceData.advanceName )
                Tooltips.SetTooltipColorDef( 1, 1, Tooltips.COLOR_HEADING )
                Tooltips.SetTooltipText( 2, 1, GetStringFromTable( "PackageDescriptions", advanceData.advanceID ) )
                Tooltips.SetTooltipText( 3, 1, priceString )
                Tooltips.Finalize()

                Tooltips.AnchorTooltip( ANCHOR_CURSOR )
            end

    end

end

function AdvancedRenownTraining.Respecialize()
	if ButtonGetText(WindowName.."RespecializeButton") == L"Clear" then
		ResetSelect()
		AdvancedRenownTraining.FullRefresh()
		return
	end
	if EA_Window_InteractionRenownTraining.GetPointsAlreadyPurchased() == 0 then
		ResetSelect()
		AdvancedRenownTraining.FullRefresh()
		return
	end
	local respecCost = GameData.Player.GetRenownRefundCost()
	local pointsSpent = EA_Window_InteractionRenownTraining.GetPointsAlreadyPurchased()
	if (respecCost > GameData.Player.money) then
		DialogManager.MakeOneButtonDialog (GetStringFormatFromTable ("TrainingStrings", StringTables.Training.TEXT_RESPEC_NOT_ENOUGH_MONEY, {MoneyFrame.FormatMoneyString (respecCost)}), GetString (StringTables.Default.LABEL_OKAY),nil)
	else
		DialogManager.MakeTwoButtonDialog (GetStringFormatFromTable ("TrainingStrings", StringTables.Training.TEXT_RESPEC_CONFIRMATION, { MoneyFrame.FormatMoneyString (respecCost)}), GetString(StringTables.Default.LABEL_YES), AdvancedRenownTraining.RefundRenownPoints, GetString(StringTables.Default.LABEL_NO) )
	end
end

function AdvancedRenownTraining.RefundRenownPoints()
	RefundRenownPoints()
	AdvancedRenownTraining.purchasedAdvantages = {}
	ResetSelect()
	AdvancedRenownTraining.FullRefresh()
end

function AdvancedRenownTraining.OnLButtonUpTab()
	local id = WindowGetId(SystemData.ActiveWindow.name)
	AdvancedRenownTraining.ChangeTab(id)
end

function AdvancedRenownTraining.OnShown()
	WindowUtils.OnShown(AdvancedRenownTraining.OnHidden, WindowUtils.Cascade.MODE_AUTOMATIC)
	ButtonSetPressedFlag (WindowName..AdvancedRenownTraining.ADVANCED, false)
	ButtonSetPressedFlag (WindowName..AdvancedRenownTraining.ACTIVE, false)
	ButtonSetPressedFlag (WindowName..AdvancedRenownTraining.DEF, false)
	ButtonSetPressedFlag (WindowName..AdvancedRenownTraining.BASIC, true)
	WindowSetShowing("AdvancedRenownTrainingWindowBasicTab", true)
	WindowSetShowing("AdvancedRenownTrainingWindowAdvancedTab", false)
	WindowSetShowing("AdvancedRenownTrainingWindowAbilityTab", false)
	WindowSetShowing("AdvancedRenownTrainingWindowDefensiveTab", false)
	if not currentSpecSave then
		LabelSetText(WindowName.."RenownLabel", GetStringFormatFromTable("TrainingStrings", StringTables.Training.LABEL_RENOWN_PURSE, { L""..EA_Window_InteractionRenownTraining.GetPointsAvailable(), L""..EA_Window_InteractionRenownTraining.GetPointsSpent() } ))
	end
end

function AdvancedRenownTraining.OnHidden()
	ButtonSetDisabledFlag(WindowName.."PurchaseButton",false)
	--ButtonSetDisabledFlag(WindowName.."RespecializeButton",false)
	ButtonSetText(WindowName.."RespecializeButton",GetString( StringTables.Default.LABEL_PURCHASE_RESPECIALIZATION ))
	if currentSpecSave then
		AdvancedRenownTraining.purchasedAdvantages = currentSpecSave
		currentSpecSave = nil
		AdvancedRenownTraining.FullRefresh()
	end
	WindowSetShowing("AdvancedRenownTrainingPresetsWindow",false)
	ResetSelect()
	WindowUtils.OnHidden()
end

function AdvancedRenownTraining.PresetOnShown()
	WindowUtils.OnShown(AdvancedRenownTraining.PresetOnHidden, WindowUtils.Cascade.MODE_AUTOMATIC)
end

function AdvancedRenownTraining.PresetOnHidden()
	WindowUtils.OnHidden()
end

function AdvancedRenownTraining.ChangeTab(id)
	ButtonSetPressedFlag (WindowName..AdvancedRenownTraining.ADVANCED, false)
	ButtonSetPressedFlag (WindowName..AdvancedRenownTraining.ACTIVE, false)
	ButtonSetPressedFlag (WindowName..AdvancedRenownTraining.BASIC, false)
	ButtonSetPressedFlag (WindowName..AdvancedRenownTraining.DEF, false)

	WindowSetShowing("AdvancedRenownTrainingWindowBasicTab", false)
	WindowSetShowing("AdvancedRenownTrainingWindowAdvancedTab", false)
	WindowSetShowing("AdvancedRenownTrainingWindowDefensiveTab", false)
	WindowSetShowing("AdvancedRenownTrainingWindowAbilityTab", false)

	if id == 1 then
		ButtonSetPressedFlag (WindowName..AdvancedRenownTraining.BASIC, true)
		WindowSetShowing("AdvancedRenownTrainingWindowBasicTab", true)
		return
	elseif id == 2 then
		ButtonSetPressedFlag (WindowName..AdvancedRenownTraining.ADVANCED, true)
		WindowSetShowing("AdvancedRenownTrainingWindowAdvancedTab", true)
		return
	elseif id == 3 then
		ButtonSetPressedFlag (WindowName..AdvancedRenownTraining.ACTIVE, true)
		WindowSetShowing("AdvancedRenownTrainingWindowAbilityTab", true)
	else
		ButtonSetPressedFlag (WindowName..AdvancedRenownTraining.DEF, true)
		WindowSetShowing("AdvancedRenownTrainingWindowDefensiveTab", true)
	end

end

function AdvancedRenownTraining.OnButtonPressedBasicTab ()
	ButtonSetPressedFlag (WindowName..AdvancedRenownTraining.ADVANCED, false)
	ButtonSetPressedFlag (WindowName..AdvancedRenownTraining.ACTIVE, false)
	ButtonSetPressedFlag (WindowName..AdvancedRenownTraining.BASIC, true)
	LabelSetText(WindowName.."TitleBarText", L"Basic")
end

function AdvancedRenownTraining.OnButtonPressedAdvancedTab ()
	ButtonSetPressedFlag (WindowName..AdvancedRenownTraining.BASIC, false)
	ButtonSetPressedFlag (WindowName..AdvancedRenownTraining.ACTIVE, false)
	ButtonSetPressedFlag (WindowName..AdvancedRenownTraining.ADVANCED, true)
	LabelSetText(WindowName.."TitleBarText", L"Advanced")
end

function AdvancedRenownTraining.OnButtonPressedActiveTab ()
	ButtonSetPressedFlag (WindowName..AdvancedRenownTraining.ACTIVE, true)
	ButtonSetPressedFlag (WindowName..AdvancedRenownTraining.BASIC, false)
	ButtonSetPressedFlag (WindowName..AdvancedRenownTraining.ADVANCED, false)
	LabelSetText(WindowName.."TitleBarText", L"Active")
end

-- Preset Window

function AdvancedRenownTraining.TogglePresets()
	WindowSetShowing(PresetWindowName, not WindowGetShowing(PresetWindowName))
end

-- ComboBoxAddMenuItem("AdvancedRenownTrainingPresetsWindowLoadComboBox",L"Test item")

function AdvancedRenownTraining.SavePreset()
	local name = TextEditBoxGetText(PresetWindowName.."SaveNameInput")
	if name ~= L"" and name ~= L"Current Build" then
		local save = {
			t1 = {},
			t2 = {},
			t3 = {},
			t4 = {},
			t5 = {}
		}
		for k,_ in pairs(AdvancedRenownTraining.purchasedAdvantages) do
			table.insert(save[LookUpTable[k].tier], k)
		end
		if CheckButton then
			for k,v in pairs(AdvancedRenownTraining.selectedAdvantages) do
				for _,n in pairs(v) do
					table.insert(save[k], n)
				end
			end
		end
		AdvancedRenownTraining.Presets[name] = save
		ComboBoxClearMenuItems(PresetWindowName.."LoadComboBox")
		for k,v in pairs (AdvancedRenownTraining.Presets) do
			ComboBoxAddMenuItem(PresetWindowName.."LoadComboBox", k)
		end
	end
end

--ComboBoxGetSelectedText("AdvancedRenownTrainingPresetsWindowLoadComboBox")

function AdvancedRenownTraining.OnLoadPressed()
	local presetitem = ComboBoxGetSelectedText(PresetWindowName.."LoadComboBox")
	AdvancedRenownTraining.LoadPreset(presetitem)
end

function AdvancedRenownTraining.LoadPreset(presetitem)
	local preset = AdvancedRenownTraining.Presets[presetitem]
	local costs = 0
	for _,v in pairs (preset) do
		for __,id in pairs(v) do
			costs = costs + LookUpTable[id].pointCost
		end
	end
	if costs > availablePoints then
		return
	end
	ResetSelect()
	for _,v in pairs(preset["t1"]) do
		if not AdvancedRenownTraining.purchasedAdvantages[v] then
			SelectAdvantage(v)
		end
	end
	for _,v in pairs(preset["t2"]) do
		if not AdvancedRenownTraining.purchasedAdvantages[v] then
			SelectAdvantage(v)
		end
	end
	for _,v in pairs(preset["t3"]) do
		if not AdvancedRenownTraining.purchasedAdvantages[v] then
			SelectAdvantage(v)
		end
	end
	for _,v in pairs(preset["t4"]) do
		if not AdvancedRenownTraining.purchasedAdvantages[v] then
			SelectAdvantage(v)
		end
	end
	for _,v in pairs(preset["t5"]) do
		if not AdvancedRenownTraining.purchasedAdvantages[v] then
			SelectAdvantage(v)
		end
	end
end

function AdvancedRenownTraining.DeletePreset()
	local presetitem = ComboBoxGetSelectedText(PresetWindowName.."LoadComboBox")
	AdvancedRenownTraining.Presets[presetitem] = nil
	ComboBoxClearMenuItems(PresetWindowName.."LoadComboBox")
	for k,v in pairs (AdvancedRenownTraining.Presets) do
		ComboBoxAddMenuItem(PresetWindowName.."LoadComboBox", k)
	end
end

function AdvancedRenownTraining.ToggleSaveSettings()
	CheckButton = not CheckButton
	ButtonSetPressedFlag(PresetWindowName.."SaveSelectedCheckBox" , CheckButton)
end

function AdvancedRenownTraining.SelectedItemChanged(sel)
	if sel == 0 then
		LabelSetText(PresetWindowName.."PointLabel", L"0")
	end
	local pointsNeeded = 0
	local selectedItem = ComboBoxGetSelectedText(PresetWindowName.."LoadComboBox")
	for _,v in pairs(AdvancedRenownTraining.Presets[selectedItem]) do
		for __,n in pairs(v) do
			pointsNeeded = pointsNeeded + LookUpTable[n].pointCost
		end
	end
	LabelSetText(PresetWindowName.."PointLabel", towstring(pointsNeeded))
end

function AdvancedRenownTraining.GetLookUpTable()
	return LookUpTable
end
