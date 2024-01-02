local warExtendedSettings = warExtendedSettings

--warExtended:AddEventHandler("CreateEntry", "CreateSettingsEntry", warExtendedSettings.AddOptionEntry)

-------- TEST SETTINGS

--------------------------------------------------------------- UI: Configuration
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
---
--[[warExtended:AddEventHandler ("Guard", "SettingsChanged", warExtendedSettings.Guard_OnSettingsChanged)

warExtended:AddEventHandler ("Guard", "ConfigDialogInitializeSections", function (sections)
  table.insert (sections,
		  {
			name = "Guard",
			title = L"Guard",
			templateName = "EnemyGuardConfiguration",
			onInitialize = Enemy.GuardUI_ConfigDialog_OnInitialize,
			onLoad = Enemy.GuardUI_ConfigDialog_OnLoad,
			onSave = Enemy.GuardUI_ConfigDialog_OnSave,
			onReset = Enemy.GuardUI_ConfigDialog_OnReset
		  })
end)


local config_dlg = {}

config_dlg.properties =
{
  guardEnabled =
  {
	key = "guardEnabled",
	order = 10,
	name = L"Enable guarding enhancements",
	type = "bool",
	default = warExtendedSettings.DefaultSettings.guardEnabled
  },

  guardDistanceIndicatorTitle =
  {
	key = "guardDistanceIndicatorTitle",
	order = 20,
	name = L"Guard distance indicator",
	type = "title",
	paddingTop = 30
  },
  guardDistanceIndicator =
  {
	key = "guardDistanceIndicator",
	order = 30,
	name = L"Distance indicator",
	type = "select",
	default = warExtendedSettings.DefaultSettings.guardDistanceIndicator,
	values =
	{
	  { text = L"hide", value = 1 },
	  { text = L"show when available", value = 2 },
	  { text = L"show when available and PvP flagged", value = 3 }
	}
  },
  guardDistanceIndicatorMovable =
  {
	key = "guardDistanceIndicatorMovable",
	order = 35,
	name = L"Movable",
	type = "bool",
	default = warExtendedSettings.DefaultSettings.guardDistanceIndicatorMovable
  },
  guardDistanceIndicatorClickThrough =
  {
	key = "guardDistanceIndicatorClickThrough",
	order = 36,
	name = L"Click through",
	type = "bool",
	default = warExtendedSettings.DefaultSettings.guardDistanceIndicatorClickThrough,
	tooltip = L"If checked guard indicator will not be clickable (and movable too)"
  },
  guardDistanceIndicatorWarningDistance =
  {
	key = "guardDistanceIndicatorWarningDistance",
	order = 40,
	name = L"Warning distance",
	type = "int",
	min = 0,
	max = 1000,
	default = warExtendedSettings.DefaultSettings.guardDistanceIndicatorWarningDistance,
	tooltip = L"If the distance between you and guarder (or guarded player) will be more than this value, the indicator will switch to 'warning' mode"
  },
  guardDistanceIndicatorColorNormal =
  {
	key = "guardDistanceIndicatorColorNormal",
	order = 50,
	name = L"Normal color",
	type = "color",
	default = warExtendedSettings.DefaultSettings.guardDistanceIndicatorColorNormal
  },
  guardDistanceIndicatorColorWarning =
  {
	key = "guardDistanceIndicatorColorWarning",
	order = 60,
	name = L"Warning color",
	type = "color",
	default = warExtendedSettings.DefaultSettings.guardDistanceIndicatorColorWarning
  },
  guardDistanceIndicatorAlphaNormal =
  {
	key = "guardDistanceIndicatorAlphaNormal",
	order = 70,
	name = L"Normal opacity",
	type = "float",
	default = warExtendedSettings.DefaultSettings.guardDistanceIndicatorAlphaNormal,
	min = 0,
	max = 1
  },
  guardDistanceIndicatorAlphaWarning =
  {
	key = "guardDistanceIndicatorAlphaWarning",
	order = 80,
	name = L"Warning opacity",
	type = "float",
	default = warExtendedSettings.DefaultSettings.guardDistanceIndicatorAlphaWarning,
	min = 0,
	max = 1
  },
  guardDistanceIndicatorScaleNormal =
  {
	key = "guardDistanceIndicatorScaleNormal",
	order = 84,
	name = L"Normal scaling",
	type = "float",
	default = warExtendedSettings.DefaultSettings.guardDistanceIndicatorScaleNormal,
	min = 0,
	max = 10
  },
  guardDistanceIndicatorScaleWarning =
  {
	key = "guardDistanceIndicatorScaleWarning",
	order = 85,
	name = L"Warning scaling",
	type = "float",
	default = warExtendedSettings.DefaultSettings.guardDistanceIndicatorScaleWarning,
	min = 0,
	max = 10
  },
  guardDistanceIndicatorAnimation =
  {
	key = "guardDistanceIndicatorAnimation",
	order = 90,
	name = L"Enable warning animation (only in combat)",
	type = "bool",
	default = warExtendedSettings.DefaultSettings.guardDistanceIndicatorAnimation
  },

  guardMarkTitle =
  {
	key = "guardMarkTitle",
	order = 100,
	name = L"Guard mark",
	type = "title",
	paddingTop = 30
  },
  guardMarkEnabled =
  {
	key = "guardMarkEnabled",
	order = 110,
	name = L"Enable marking guarder/guarded player",
	type = "bool",
	default = warExtendedSettings.DefaultSettings.guardMarkEnabled
  },
  editGuardTemplate =
  {
	key = "editGuardTemplate",
	order = 120,
	name = L"Edit guard mark template",
	type = "button",
	windowWidth = 300,
	onClick = function ()
	  config_dlg.guardMarkTemplate:Edit ()
	  warExtendedSettings.Guard_OnSettingsChanged (config_dlg)
	end
  }
}]]


function warExtendedSettings.GuardUI_ConfigDialog_OnInitialize (section)

  config_dlg.section = section

  local root = config_dlg.section.windowName.."ContentScrollChild"
  config_dlg.cwn = root.."Config"
  warExtendedSettings.CreateConfigurationWindow (config_dlg.cwn, root, config_dlg.properties, warExtendedSettings.GuardUI_ConfigDialog_TestSettings)

  ScrollWindowUpdateScrollRect (config_dlg.section.windowName.."Content")
end


function warExtendedSettings.GuardUI_ConfigDialog_OnLoad (section)

  config_dlg.isLoading = true

  config_dlg.guardEnabled = warExtendedSettings.Settings.guardEnabled
  config_dlg.guardMarkTemplate = warExtendedSettingsMarkTemplate.New (warExtendedSettings.Settings.guardMarkTemplate)
  config_dlg.guardDistanceIndicator = warExtendedSettings.Settings.guardDistanceIndicator
  config_dlg.guardDistanceIndicatorMovable = warExtendedSettings.Settings.guardDistanceIndicatorMovable
  config_dlg.guardDistanceIndicatorClickThrough = warExtendedSettings.Settings.guardDistanceIndicatorClickThrough
  config_dlg.guardDistanceIndicatorWarningDistance = warExtendedSettings.Settings.guardDistanceIndicatorWarningDistance
  config_dlg.guardDistanceIndicatorColorNormal = warExtendedSettings.clone (warExtendedSettings.Settings.guardDistanceIndicatorColorNormal)
  config_dlg.guardDistanceIndicatorColorWarning = warExtendedSettings.clone (warExtendedSettings.Settings.guardDistanceIndicatorColorWarning)
  config_dlg.guardDistanceIndicatorAlphaNormal = warExtendedSettings.Settings.guardDistanceIndicatorAlphaNormal
  config_dlg.guardDistanceIndicatorAlphaWarning = warExtendedSettings.Settings.guardDistanceIndicatorAlphaWarning
  config_dlg.guardDistanceIndicatorScaleNormal = warExtendedSettings.Settings.guardDistanceIndicatorScaleNormal
  config_dlg.guardDistanceIndicatorScaleWarning = warExtendedSettings.Settings.guardDistanceIndicatorScaleWarning
  config_dlg.guardDistanceIndicatorAnimation = warExtendedSettings.Settings.guardDistanceIndicatorAnimation
  config_dlg.guardMarkEnabled = warExtendedSettings.Settings.guardMarkEnabled

  warExtendedSettings.ConfigurationWindowLoadData (config_dlg.cwn, config_dlg)

  config_dlg.isLoading = false

  warExtendedSettings.GuardUI_ConfigDialog_TestSettings ()
end


function warExtendedSettings.GuardUI_ConfigDialog_OnReset (section)

  for k, v in pairs (warExtendedSettings.Settings)
  do
	if (not k:match("^guard.*")) then continue end
	warExtendedSettings.Settings[k] = nil
  end

  warExtendedSettings.Print ("Guard mark settings has been reset")
  InterfaceCore.ReloadUI ()
end


function warExtendedSettings.GuardUI_ConfigDialog_TestSettings ()

  if (config_dlg.isLoading) then return end

  warExtendedSettings.ConfigurationWindowSaveData (config_dlg.cwn, config_dlg)
  warExtendedSettings.Guard_OnSettingsChanged (config_dlg)
end


function warExtendedSettings.GuardUI_ConfigDialog_OnSave (section)

  warExtendedSettings.GuardUI_ConfigDialog_TestSettings ()
  config_dlg.guardMarkTemplate:ClearMarks ()

  warExtendedSettings.Settings.guardEnabled = config_dlg.guardEnabled
  warExtendedSettings.Settings.guardMarkTemplate = config_dlg.guardMarkTemplate
  warExtendedSettings.Settings.guardDistanceIndicator = config_dlg.guardDistanceIndicator
  warExtendedSettings.Settings.guardDistanceIndicatorWarningDistance = config_dlg.guardDistanceIndicatorWarningDistance
  warExtendedSettings.Settings.guardDistanceIndicatorMovable = config_dlg.guardDistanceIndicatorMovable
  warExtendedSettings.Settings.guardDistanceIndicatorClickThrough = config_dlg.guardDistanceIndicatorClickThrough
  warExtendedSettings.Settings.guardDistanceIndicatorColorNormal = warExtendedSettings.clone (config_dlg.guardDistanceIndicatorColorNormal)
  warExtendedSettings.Settings.guardDistanceIndicatorColorWarning = warExtendedSettings.clone (config_dlg.guardDistanceIndicatorColorWarning)
  warExtendedSettings.Settings.guardDistanceIndicatorAlphaNormal = config_dlg.guardDistanceIndicatorAlphaNormal
  warExtendedSettings.Settings.guardDistanceIndicatorAlphaWarning = config_dlg.guardDistanceIndicatorAlphaWarning
  warExtendedSettings.Settings.guardDistanceIndicatorScaleNormal = config_dlg.guardDistanceIndicatorScaleNormal
  warExtendedSettings.Settings.guardDistanceIndicatorScaleWarning = config_dlg.guardDistanceIndicatorScaleWarning
  warExtendedSettings.Settings.guardDistanceIndicatorAnimation = config_dlg.guardDistanceIndicatorAnimation
  warExtendedSettings.Settings.guardMarkEnabled = config_dlg.guardMarkEnabled

  return true
end



local config_dlg      = {}
config_dlg.section    = {
	name         = "ScenarioInfo",
	title        = L"Scenario info",
	templateName = "warExtendedSettingsScenarioInfoConfiguration",
}

local function testPrinter()
	p("imm here on change")
end

local root            = config_dlg.section.name .. "Config"
config_dlg.cwn        = root .. "W"
config_dlg.properties = {
	guardDistanceIndicatorTitle       = {
		key        = "guardDistanceIndicatorTitle",
		order      = 10,
		name       = L"Guard distance indicator",
		type       = "title",
		paddingTop = -5
	},
	scenarioInfoEnabled               = {
		key   = "scenarioInfoEnabled",
		order = 15,
		name  = L"Enable scenarion info",
		type  = "bool",
	},
	scenarioInfoReplaceStandardWindow = {
		key   = "scenarioInfoReplaceStandardWindow",
		order = 20,
		name  = L"Replace standard scenario ending window",
		type  = "bool",
	},
	testKey                           = {
		key        = "testKey",
		order      = 5,
		name       = L"Tester",
		type       = "bool",
		paddingTop = 5
	},
	asd                               = {
		key        = "asd",
		order      = 25,
		name       = L"Guard distance indicator",
		type       = "title",
		paddingTop = -5
	},
	dad                               = {
		key   = "dad",
		order = 30,
		name  = L"Enable scenarion info",
		type  = "bool",
	},
	asdafsd                           = {
		key   = "asdafsd",
		order = 31,
		name  = L"Replace standard scenario ending window",
		type  = "bool",
	},
	aseasdasda                        = {
		key        = "aseasdasda",
		order      = 32,
		name       = L"Tester",
		type       = "bool",
		paddingTop = 5
	},
	asdasvdas                         = {
		key        = "asdasvdas",
		order      = 33,
		name       = L"Guard distance indicator",
		type       = "title",
		paddingTop = -5
	},
	asecdzcavs                        = {
		key   = "asecdzcavs",
		order = 34,
		name  = L"Enable scenarion info",
		type  = "bool",
	},
	absdasdbzszd                      = {
		key   = "absdasdbzszd",
		order = 35,
		name  = L"Replace standard scenario ending window",
		type  = "bool",
	},
	avseasebb                         = {
		key        = "avseasebb",
		order      = 36,
		name       = L"Tester",
		type       = "bool",
		paddingTop = 5
	},
	asdasveasev                       = {
		key   = "asdasveasev",
		order = 37,
		name  = L"Replace standard scenario ending window",
		type  = "bool",
	},
	groupIconsScale                   = {
		key   = "groupIconsScale",
		order = 38,
		name  = L"Scale",
		type  = "float",
		-- default = warE.DefaultSettings.groupIconsScale,
		min   = 0,
		max   = 5
	},
	groupIconsLayer                   = {
		key    = "groupIconsLayer",
		order  = 39,
		name   = L"Layer",
		type   = "select",
		-- default = Enemy.DefaultSettings.groupIconsLayer,
		values = warExtended._Settings.ConfigurationWindowGetLayersSelectValues
	},
	ghmguhu                           = {
		key        = "ghmguhu",
		order      = 40,
		name       = L"Tester",
		type       = "bool",
		paddingTop = 5
	},
	mghjghj                           = {
		key   = "mghjghj",
		order = 41,
		name  = L"Replace standard scenario ending window",
		type  = "bool",
	},
	fghfghfj                          = {
		key        = "qweqweasbea",
		order      = 42,
		name       = L"Tester",
		type       = "bool",
		paddingTop = 5
	},
	iuouio                            = {
		key   = "iuouio",
		order = 43,
		name  = L"Replace standard scenario ending window",
		type  = "bool",
	},
	tyitit                            = {
		key        = "tyitit",
		order      = 44,
		name       = L"Tester",
		type       = "bool",
		paddingTop = 5
	},
	eqweqwe                           = {
		key        = "eqweqwe",
		order      = 45,
		name       = L"TESTEND",
		type       = "bool",
		paddingTop = 5
	}

}

local WINDOW_NAME = "warExtendedSettings"

function test123()
	warExtended._Settings.AddSettings(L"warExtended Main Menu", config_dlg)
end

function warExtended._Settings.AddSettings(moduleName, settings, entryWindow)
	local windowName = "warExtendedSettingsSections" .. settings.section.name
	p(settings.section.name)

	local frame = GetFrame(windowName)
	if not frame then
		SettingsFrame = Frame:Subclass("warExtendedSettingsTemplate")
		frame = SettingsFrame:CreateFromTemplate(windowName, WINDOW_NAME.."Sections")
		frame:ClearAnchors()
		p(windowName)
		frame:Show(true)
		WindowAddAnchor(windowName, "topleft", "warExtendedSettingsSections", "topleft", 0, 0)
		WindowAddAnchor(windowName, "bottomright", "warExtendedSettingsSections", "bottomright", 0, 0)
	end

	local root = windowName .. "ContentScrollChild"
	local cwn  = root

	warExtended._Settings.AddChildEntry(moduleName, L"Settings", windowName)

	warExtended._Settings.CreateConfigurationWindow(cwn, root, settings.properties)
	warExtended:ExtendTable(warExtended._Settings.Config, settings.DefaultSettings)
	ScrollWindowUpdateScrollRect(windowName .. "Content")
end



-- warExtended:AddEventHandler("InitializeSettings", "CoreInitialized", initializeSettings)
