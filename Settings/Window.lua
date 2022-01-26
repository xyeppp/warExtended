local warExtendedSettings         = warExtendedSettings
local OPTIONS_WINDOW              = "warExtendedSettings"
local OPTIONS_WINDOW_SCROLL_CHILD = OPTIONS_WINDOW .. "MainScrollChild"
local SLASH_WINDOW                = "warExtendedSettingsSlashCommands"
local TITLE_BAR_TEXT              = L"warExtended Settings"
local DEFAULT_TOPIC               = L"Settings"
local DESCRIPTION_TEXT			  = L"Description"
local DEFAULT_TEXT                = L"Select an addon from the list on the left to open it's settings."
local EMPTY_TEXT                  = L"No warExtended modules registered."
local CLOSE_TEXT                  = L"Close"
local RESET_TEXT				  = L"Reset"
local RESET_ALL					  = L"Reset All"
local OK					  	   = L"Ok"

function warExtendedSettings.WindowOnInitialize()
  LabelSetText(OPTIONS_WINDOW .. "TitleBarText", TITLE_BAR_TEXT)
  ButtonSetText(OPTIONS_WINDOW .. "ExitButton", CLOSE_TEXT)
  LabelSetText(OPTIONS_WINDOW .. "HeaderText", DEFAULT_TOPIC)
  ButtonSetText(OPTIONS_WINDOW .. "ResetButton", RESET_TEXT)
  ButtonSetText(OPTIONS_WINDOW .. "ResetAllButton", RESET_ALL)
  ButtonSetText(OPTIONS_WINDOW .. "OkButton", OK)
end

function warExtendedSettings.WindowHide()
  
  --for _, section in ipairs (config_dlg.sections)
 -- do
	--section.isActive = false
	
	--if (not section.isInitialized
	--		or not section.isLoaded
	--		or not section.onClose) then continue end
	
	--section.onClose (section)
  --end
  
  WindowSetShowing ("warExtendedSettings", false)
  warExtended:TriggerEvent ("SettingsChanged", warExtendedSettings.Settings)
end

function warExtendedSettings.WindowOnShutdown()

end

function warExtendedSettings.OnVertScrollLButtonUp()
end

function warExtendedSettings.WindowOnShown()
  if #warExtendedSettings.data == 0 then
	LabelSetText(OPTIONS_WINDOW .. "MainScrollChildLabel", DEFAULT_TOPIC)
	LabelSetText(OPTIONS_WINDOW .. "MainScrollChildText", EMPTY_TEXT)
  else
	LabelSetText(OPTIONS_WINDOW .. "MainScrollChildLabel", DEFAULT_TOPIC)
	LabelSetText(OPTIONS_WINDOW .. "MainScrollChildText", DEFAULT_TEXT)
  end
  
  WindowUtils.OnShown()
  warExtendedSettings.PrepareData()
  warExtendedSettings.UpdateOptionsWindowRow()
  warExtendedSettings.SetListRowTints()
end

local index       = 0
local cmdTemplate = "warExtendedSettingsSlashCommandTemplate"

local function displaySlashWindow(entryData)
  local optionParent  = warExtendedSettings.GetOptionParent(entryData.parentEntryId)
  local slashCommands = warExtended.GetModuleSlashCommands(optionParent.addonName)
  if index > 0 then
	for i = 1, index do
	  DestroyWindow(cmdTemplate .. i)
	end
	index = 0
  end
  
  for k, v in pairs(slashCommands) do
	index = index + 1
	CreateWindowFromTemplate(cmdTemplate .. index, "warExtendedSettingsSlashCommandTemplate", SLASH_WINDOW .. "ScrollChild")
	LabelSetText(cmdTemplate .. index .. "Label", towstring("/" .. k))
	LabelSetText(cmdTemplate .. index .. "Text", towstring(v))
	if index == 1 then
	  WindowAddAnchor(cmdTemplate .. index, "topleft", SLASH_WINDOW .. "ScrollChild", "topleft", 5, 5)
	else
	  WindowAddAnchor(cmdTemplate .. index, "center", cmdTemplate .. index - 1, "center", 0, 40)
	end
  end
end

local function displayDescriptionWindow(entryData)
  LabelSetText(OPTIONS_WINDOW_SCROLL_CHILD.."Label", DESCRIPTION_TEXT)
  LabelSetText(OPTIONS_WINDOW_SCROLL_CHILD .. "Text", warExtended.GetAddonDescription(entryData.addonName))
end

function warExtendedSettings.DisplayEntryWindow(entryData)
  if not DoesWindowExist(entryData.parentWindow) then
	CreateWindow(entryData.parentWindow, true)
  end
  
  if entryData.parentWindow == OPTIONS_WINDOW .. "Main" then
	displayDescriptionWindow(entryData)
  elseif entryData.parentWindow == SLASH_WINDOW then
	displaySlashWindow(entryData)
  end
  
  WindowSetShowing(entryData.parentWindow, true)
  WindowSetParent(entryData.parentWindow, OPTIONS_WINDOW)
end

function warExtendedSettings.SetWindowText(entryData)

end

function warExtendedSettings.OnLButtonUpExitButton()
  WindowSetShowing(OPTIONS_WINDOW, false)
end