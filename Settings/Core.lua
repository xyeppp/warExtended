-- Reuse of warExtendedSettings settings config
local warExtended = warExtended
local warExtendedSettings = warExtendedSettings
local pairs = pairs
local ipairs = ipairs
local tinsert = table.insert
local tsort = table.sort
local mmax = math.max
local mmin = math.min
local settings = {}
local g ={}

if not warExtendedSettings.Config then
  warExtendedSettings.Config = {}
end

function warExtendedSettings.Initialize()
  warExtendedSettings.configurationWindow = g
  
  g.onChangeHandlers = {}
  g.properties = {}
  
  --table.sort (Enemy.Fonts)
 -- Enemy.extendTable (Enemy.Settings, Enemy.DefaultSettings)
  --	RegisterEventHandler (SystemData.Events.PLAYER_CAREER_LINE_UPDATED, "Enemy._PlayerCareerLineUpdated")???
  --Enemy.TriggerEvent ("SettingsChanged", Enemy.Settings)
  
  warExtended:TriggerEvent ("SettingsInitialized")
  warExtended:RemoveEventHandler("InitializeSettings", "CoreInitialized")
end

local function GetDataFromActiveWindowName ()
  
  local awn = SystemData.ActiveWindow.name
  if (not awn) then return nil end
  
  return awn:match ("(.-)___(.-)___.*")
end


function warExtendedSettings.ConfigurationWindow_OnChange ()
  local wn, pkey = GetDataFromActiveWindowName ()
  if (not wn or not pkey) then return end
  
  local handlers = g.onChangeHandlers[wn]
  if (not handlers) then return end
  
  local onchange = handlers[pkey]
  if (onchange and type (onchange) == "function")
  then
	onchange (SystemData.ActiveWindow.name)
  end
end

function warExtendedSettings.ConfigurationWindow_OnBoolClick ()
local wn, pkey = GetDataFromActiveWindowName ()
if (not wn or not pkey) then return end

local wn = SystemData.ActiveWindow.name
if (ButtonGetDisabledFlag (wn.."Value")) then return end

local v = ButtonGetPressedFlag (wn.."Value")
ButtonSetPressedFlag (wn.."Value", not v)

warExtendedSettings.ConfigurationWindow_OnChange ()
end


function warExtendedSettings.ConfigurationWindow_OnMacroMouseDrag ()

if (Cursor.IconOnCursor()) then return end

local wn, pkey = GetDataFromActiveWindowName ()
if (not wn or not pkey) then return end

local properties = g.properties[wn]
if (not properties) then return end

local p = properties[pkey]
if (not p or not p.macroId or not p.macroIconNum) then return end

Cursor.PickUp (Cursor.SOURCE_MACRO, p.macroId, p.macroId, p.macroIconNum, false)
EA_Window_Macro.UpdateDetails (p.macroId)
end


function warExtendedSettings.ConfigurationWindow_ShowTooltip ()
local wn, pkey = GetDataFromActiveWindowName ()
if (not wn or not pkey) then return end

local properties = g.properties[wn]
if (not properties) then return end

local p = properties[pkey]
if (p and p.tooltip)
then
Tooltips.CreateTextOnlyTooltip (SystemData.MouseOverWindow.name)

if (type (p.tooltip) == "function")
then
p.tooltip ()

elseif (type (p.tooltip) == "table")
then
local k = 0

for _, v in pairs (p.tooltip)
do
Tooltips.SetTooltipText (k, 1, towstring (v))
k = k + 1
end
else
Tooltips.SetTooltipText (1, 1, towstring (p.tooltip))
end

Tooltips.AnchorTooltip (Tooltips.ANCHOR_CURSOR)
Tooltips.Finalize()
end
end


function warExtendedSettings.ConfigurationWindow_OnButtonClick ()

if (ButtonGetDisabledFlag (SystemData.ActiveWindow.name)) then return end

local wn, pkey = GetDataFromActiveWindowName ()
if (not wn or not pkey) then return end

local properties = g.properties[wn]
if (not properties) then return end

local p = properties[pkey]
if (p.onClick)
then
if (p.onClick ())
then
warExtendedSettings.ConfigurationWindow_OnChange ()
end
else
warExtendedSettings.ConfigurationWindow_OnChange ()
end
end

function warExtendedSettings.ConfigurationWindowGetSelectValuesHelper (data, textPropertyName, valuePropertyName, sort, emptyItem)

local res = {}

for k, v in pairs (data)
do
local obj = {}

if (textPropertyName == "$value")
then
obj.text = v
elseif (textPropertyName == "$key")
then
obj.text = k
else
obj.text = v[textPropertyName]
end

if (valuePropertyName == "$value")
then
obj.value = v
elseif (valuePropertyName == "$key")
then
obj.value = k
else
obj.value = v[valuePropertyName]
end

tinsert (res, obj)
end

if (sort)
then
tsort (res, function (a, b)
return a.text < b.text
end)
end

if (emptyItem)
then
tinsert (res, 1, { text = emptyItem, value = nil })
end

return res

end


function warExtendedSettings.ConfigurationWindowGetLayersSelectValues (emptyItem)
return warExtendedSettings.ConfigurationWindowGetSelectValuesHelper (Window.Layers, "$key", "$value", true, emptyItem)
end


function warExtendedSettings.ConfigurationWindowGetAnchorsSelectValues (emptyItem)
return warExtendedSettings.ConfigurationWindowGetSelectValuesHelper (warExtendedSettings.Anchors, "$value", "$value", false, emptyItem)
end


function warExtendedSettings.ConfigurationWindowGetFontsSelectValues (emptyItem)
return warExtendedSettings.ConfigurationWindowGetSelectValuesHelper (warExtendedSettings.Fonts, "$value", "$value", true, emptyItem)
end


function warExtendedSettings.ConfigurationWindowGetTextAlignsSelectValues (emptyItem)
return warExtendedSettings.ConfigurationWindowGetSelectValuesHelper (warExtendedSettings.TextAligns, "$value", "$value", true, emptyItem)
end


function warExtendedSettings.ConfigurationWindowGetSoundsSelectValues (emptyItem)
return warExtendedSettings.ConfigurationWindowGetSelectValuesHelper (GameData.Sound, "$key", "$value", true, emptyItem)
end


local config_dlg = {}
config_dlg.section =  {
  name = "ScenarioInfo",
  title = L"Scenario info",
  templateName = "warExtendedSettingsScenarioInfoConfiguration",
}

local root = config_dlg.section.name.."Config"
config_dlg.cwn = root.."W"
config_dlg.properties =
  {
    guardDistanceIndicatorTitle =
    {
      key = "guardDistanceIndicatorTitle",
      order = 10,
      name = L"Guard distance indicator",
      type = "title",
      paddingTop = -5
    },
    scenarioInfoEnabled =
    {
      key = "scenarioInfoEnabled",
      order = 15,
      name = L"Enable scenarion info",
      type = "bool",
    },
    scenarioInfoReplaceStandardWindow =
    {
      key = "scenarioInfoReplaceStandardWindow",
      order = 20,
      name = L"Replace standard scenario ending window",
      type = "bool",
    },
    testKey =
    {
      key = "testKey",
      order = 5,
      name = L"Tester",
      type = "bool",
      paddingTop = 5
    },
    asd =
    {
      key = "asd",
      order = 25,
      name = L"Guard distance indicator",
      type = "title",
      paddingTop = -5
    },
    dad =
    {
      key = "dad",
      order = 30,
      name = L"Enable scenarion info",
      type = "bool",
    },
    asdafsd =
    {
      key = "asdafsd",
      order = 31,
      name = L"Replace standard scenario ending window",
      type = "bool",
    },
    aseasdasda =
    {
      key = "aseasdasda",
      order = 32,
      name = L"Tester",
      type = "bool",
      paddingTop = 5
    },
    asdasvdas =
    {
      key = "asdasvdas",
      order = 33,
      name = L"Guard distance indicator",
      type = "title",
      paddingTop = -5
    },
    asecdzcavs =
    {
      key = "asecdzcavs",
      order = 34,
      name = L"Enable scenarion info",
      type = "bool",
    },
    absdasdbzszd =
    {
      key = "absdasdbzszd",
      order = 35,
      name = L"Replace standard scenario ending window",
      type = "bool",
    },
    avseasebb =
    {
      key = "avseasebb",
      order = 36,
      name = L"Tester",
      type = "bool",
      paddingTop = 5
    },
    asdasveasev =
    {
      key = "asdasveasev",
      order = 37,
      name = L"Replace standard scenario ending window",
      type = "bool",
    },
    groupIconsScale =
    {
      key = "groupIconsScale",
      order = 38,
      name = L"Scale",
      type = "float",
     -- default = warE.DefaultSettings.groupIconsScale,
      min = 0,
      max = 5
    },
    groupIconsLayer =
    {
      key = "groupIconsLayer",
      order = 39,
      name = L"Layer",
      type = "select",
     -- default = Enemy.DefaultSettings.groupIconsLayer,
      values = warExtendedSettings.ConfigurationWindowGetLayersSelectValues
    },
    ghmguhu =
    {
      key = "ghmguhu",
      order = 40,
      name = L"Tester",
      type = "bool",
      paddingTop = 5
    },
    mghjghj =
    {
      key = "mghjghj",
      order = 41,
      name = L"Replace standard scenario ending window",
      type = "bool",
    },
    fghfghfj =
    {
      key = "qweqweasbea",
      order = 42,
      name = L"Tester",
      type = "bool",
      paddingTop = 5
    },
    iuouio =
    {
      key = "iuouio",
      order = 43,
      name = L"Replace standard scenario ending window",
      type = "bool",
    },
    tyitit =
    {
      key = "tyitit",
      order = 44,
      name = L"Tester",
      type = "bool",
      paddingTop = 5
    },
    eqweqwe =
    {
      key = "eqweqwe",
      order = 45,
      name = L"TESTEND",
      type = "bool",
      paddingTop = 5
    }
    
  }

function wext123()
  local windowName = "warExtendedSettingsSections"..config_dlg.section.name
  
  if not DoesWindowExist("warExtendedSettingsSections"..config_dlg.section.name) then
    local windowName = "warExtendedSettingsSections"..config_dlg.section.name
    CreateWindowFromTemplate (windowName, "warExtendedSettingsTemplate", "warExtendedSettingsSections")
  
    WindowClearAnchors (windowName)
    WindowAddAnchor (windowName, "topleft", "warExtendedSettingsSections", "topleft", 0, 0)
    WindowAddAnchor (windowName, "bottomright", "warExtendedSettingsSections", "bottomright", 0, 0)
    --warExtendedSettings.CreateConfigurationWindow (cwn, root, config_dlg.properties, nil)
  end
  
  local root = windowName.."ContentScrollChild"
  local cwn = root
  
  warExtendedSettings.CreateConfigurationWindow (cwn, root, config_dlg.properties, nil)
  warExtended:ExtendTable (warExtendedSettings.Config, config_dlg.DefaultSettings)
  ScrollWindowUpdateScrollRect (windowName.."Content")
end


function warExtendedSettings.ConfigurationWindowLoadData (wn, data)
  
  local properties = g.properties[wn]
  
  for _, p in pairs (properties)
  do
    local wnp = wn.."___"..p.key.."___"
    local v = data[p.key]
    
    if (p.onLoad)
    then
      p.onLoad (wnp, p, data)
    else
      if (p.type == "int" or p.type == "float")
      then
        TextEditBoxSetText (wnp.."Value", warExtended:toWStringOrEmpty (v))
      
      elseif (p.type == "int[]" or p.type == "color")
      then
        if (not v) then v = {} end
        
        local size
        if (p.type == "color")
        then
          size = 3
        else
          size = p.size
        end
        
        for k = 1, size
        do
          TextEditBoxSetText (wnp.."Value"..k, warExtended:toWStringOrEmpty (v[k]))
        end
      
      elseif (p.type == "select")
      then
        local select_values = p.values
        if (type (select_values) == "function")
        then
          select_values = select_values ()
        end
        
        local value_set = false
        
        for k, vv in ipairs (select_values)
        do
          if (vv.value == v)
          then
            ComboBoxSetSelectedMenuItem (wnp.."Value", k)
            value_set = true
            
            break
          end
        end
        
        if (not value_set)
        then
          ComboBoxSetSelectedMenuItem (wnp.."Value", 1)
        end
      
      elseif (p.type == "bool")
      then
        ButtonSetPressedFlag (wnp.."Value", v == true)
      
      elseif (p.type == "macro")
      then
        local macros = DataUtils.GetMacros()
        
        p.macroId = warExtended:GetMacroDataFromSlot(p.macro)
        if (p.macroId)
        then
          p.macroIconNum = macros[p.macroId].iconNum
          
          local texture, x, y = GetIconData (p.macroIconNum)
          DynamicImageSetTexture (wnp.."ButtonIconBase", texture, x, y)
        end
      
      elseif (p.type ~= "title" and p.type ~= "button")
      then
        TextEditBoxSetText (wnp.."Value", warExtended:toWStringOrEmpty (v))
      end
    end
  end
end


function warExtendedSettings.ConfigurationWindowSaveData (wn, data)
  
  local properties = g.properties[wn]
  
  for _, p in pairs (properties)
  do
    local wnp = wn.."___"..p.key.."___"
    
    if (p.onSave)
    then
      p.onSave (wnp, p, data)
    else
      if (p.type == "int")
      then
        local v = warExtended:isNil (warExtended:ConvertToInteger (TextEditBoxGetText (wnp.."Value")), p.default)
        
        if (v)
        then
          if (p.min) then v = mmax (v, p.min) end
          if (p.max) then v = mmin (v, p.max) end
        end
        
        data[p.key] = v
      
      elseif (p.type == "float")
      then
        local v = warExtended:isNil (warExtended:ConvertToFloat (TextEditBoxGetText (wnp.."Value")), p.default)
        
        if (v)
        then
          if (p.min) then v = mmax (v, p.min) end
          if (p.max) then v = mmin (v, p.max) end
        end
        
        data[p.key] = v
      
      elseif (p.type == "int[]" or p.type == "color")
      then
        local v = {}
        local default = warExtended:isNil (p.default, {})
        local min = warExtended:isNil (p.min, {})
        local max = warExtended:isNil (p.max, {})
        
        local size
        if (p.type == "color")
        then
          size = 3
          min = { 0, 0, 0 }
          max = { 255, 255, 255 }
        else
          size = p.size
        end
        
        for k = 1, size
        do
          local vv = warExtended:isNil (warExtended:ConvertToInteger (TextEditBoxGetText (wnp.."Value"..k)), default[k])
          
          if (vv)
          then
            if (min[k]) then vv = mmax (vv, min[k]) end
            if (max[k]) then vv = mmin (vv, max[k]) end
          end
          
          v[k] = vv
        end
        
        if (p.type == "color")
        then
          if (not v or not v[1] or not v[2] or not v[3])
          then
            v = nil
          end
          
          if (not v)
          then
            WindowSetShowing (wnp.."Example", false)
          else
            WindowSetShowing (wnp.."Example", true)
            WindowSetTintColor (wnp.."Example", v[1], v[2], v[3])
          end
        end
        
        data[p.key] = v
      
      elseif (p.type == "select")
      then
        
        local select_values = p.values
        if (type (select_values) == "function")
        then
          select_values = select_values ()
        end
        
        local v = select_values[ComboBoxGetSelectedMenuItem (wnp.."Value")]
        if (v)
        then
          v = v.value
        else
          v = p.default
        end
        
        data[p.key] = v
      
      elseif (p.type == "bool")
      then
        data[p.key] = ButtonGetPressedFlag (wnp.."Value")
      
      elseif (p.type ~= "title" and p.type ~= "button" and p.type ~= "macro")
      then
        local v = warExtended:isNil (TextEditBoxGetText (wnp.."Value"), p.default)
        data[p.key] = v
      end
    end
  end
end


function warExtendedSettings.ConfigurationWindowReset (wn, data)
  
  local properties = g.properties[wn]
  
  for _, p in pairs (properties)
  do
    local wnp = wn.."___"..p.key.."___"
    
    if (p.onReset)
    then
      p.onReset (wnp, p, data)
    else
      if (p.type == "int[]" or p.type == "color")
      then
        local size
        if (p.type == "color")
        then
          size = 3
        else
          size = p.size
        end
        
        local default = p.default or {}
        
        for k = 1, size
        do
          TextEditBoxSetText (wnp.."Value"..k, warExtended:toWStringOrEmpty (default[k]))
        end
      
      elseif (p.type == "select")
      then
        local select_values = p.values
        if (type (select_values) == "function")
        then
          select_values = select_values ()
        end
        
        local value_set = false
        
        for k, vv in ipairs (select_values)
        do
          if (vv.value == p.default)
          then
            ComboBoxSetSelectedMenuItem (wnp.."Value", k)
            value_set = true
            
            break
          end
        end
        
        if (not value_set)
        then
          ComboBoxSetSelectedMenuItem (wnp.."Value", 1)
        end
      
      elseif (p.type == "bool")
      then
        ButtonSetPressedFlag (wnp.."Value", p.default == true)
      
      elseif (p.type ~= "title" and p.type ~= "button" and p.type ~= "macro")
      then
        TextEditBoxSetText (wnp.."Value", warExtended:toWStringOrEmpty (p.default))
      end
    end
  end
end


-------------------------------------------------------------- UI: Config dialog
local config_dlg = nil

function warExtendedSettings.HideSettings()
  
  for _, section in ipairs (config_dlg.sections)
  do
    section.isActive = false
    
    if (not section.isInitialized
            or not section.isLoaded
            or not section.onClose) then continue end
    
    section.onClose (section)
  end
  
  WindowSetShowing ("warExtendedSettings", false)
  warExtended:TriggerEvent ("SettingsChanged", warExtendedSettings.Settings)
end

function warExtendedSettings.UI_ConfigDialog_Open (openSection, scroll)
  
  if (not config_dlg)
  then
    config_dlg =
    {
      sections = {}
    }
    
    CreateWindow ("warExtendedSettingsConfigDialog", false)
    LabelSetText ("warExtendedSettingsConfigDialogTitleBarText", L"warExtendedSettings addon configuration")
    ButtonSetText ("warExtendedSettingsConfigDialogOkButton", L"OK")
    ButtonSetText ("warExtendedSettingsConfigDialogCancelButton", L"Cancel")
    ButtonSetText ("warExtendedSettingsConfigDialogResetButton", L"Reset")
    ButtonSetText ("warExtendedSettingsConfigDialogResetAllButton", L"Reset all")
    
    LabelSetText ("warExtendedSettingsConfigDialogSectionLabel", L"Section")
    config_dlg.sections = {}
    
    warExtendedSettings.TriggerEvent ("ConfigDialogInitializeSections", config_dlg.sections)
    
    for _, section in ipairs (config_dlg.sections)
    do
      section.isInitialized = false
      ComboBoxAddMenuItem ("warExtendedSettingsConfigDialogSection", section.title)
    end
  end
  
  local open_section_index = ComboBoxGetSelectedMenuItem ("warExtendedSettingsConfigDialogSection")
  for section_index, section in ipairs (config_dlg.sections)
  do
    section.isActive = false
    
    if (section.name == openSection)
    then
      open_section_index = section_index
    end
    
    section.index = section_index
    section.isLoaded = false
  end
  
  WindowSetShowing ("warExtendedSettingsConfigDialog", true)
  
  if (open_section_index == 0) then open_section_index = 1 end
  ComboBoxSetSelectedMenuItem ("warExtendedSettingsConfigDialogSection", open_section_index)
  
  warExtendedSettings.UI_ConfigDialog_OnSectionSelChanged ()
  if (scroll ~= nil) then ScrollWindowSetOffset (config_dlg.currentSection.windowName.."Content", scroll) end
end

function warExtendedSettings.UI_ConfigDialog_OnSectionSelChanged ()
  
  local section = config_dlg.sections[index]
  
  if (config_dlg.currentSection)
  then
    config_dlg.currentSection.isActive = false
  end
  
  if (not section.isInitialized)
  then
    section.windowName = "warExtendedSettingsConfigDialogSections"..section.name
    CreateWindowFromTemplate (section.windowName, section.templateName, "warExtendedSettingsConfigDialogSections")
    
    WindowClearAnchors (section.windowName)
    WindowAddAnchor (section.windowName, "topleft", "warExtendedSettingsConfigDialogSections", "topleft", 0, 0)
    WindowAddAnchor (section.windowName, "bottomright", "warExtendedSettingsConfigDialogSections", "bottomright", 0, 0)
    
    if (section.onInitialize) then section.onInitialize (section) end
    section.isInitialized = true
  end
  
  if (not section.isLoaded and section.onLoad)
  then
    section.onLoad (section)
  end
  
  for section_index, section in ipairs (config_dlg.sections)
  do
    if (not section.isInitialized) then continue end
    WindowSetShowing (section.windowName, section_index == index)
  end
  
  section.isActive = true
  section.isLoaded = true
  config_dlg.currentSection = section
  
  ButtonSetDisabledFlag ("warExtendedSettingsConfigDialogResetButton", section.onReset == nil)
end

function warExtendedSettings.OnLButtonUpOkButton()
  
  for _, section in ipairs (config_dlg.sections)
  do
    section.isActive = false
    
    if (not section.isInitialized
            or not section.isLoaded
            or not section.onSave) then continue end
    
    if (not section.onSave (section))
    then
      ComboBoxSetSelectedMenuItem ("warExtendedSettingsConfigDialogSection", section.index)
      warExtendedSettings.UI_ConfigDialog_OnSectionSelChanged ()
      return
    end
  end
  
  warExtendedSettings.UI_ConfigDialog_Hide ()
  warExtendedSettings.FixSettings ()
end


function warExtendedSettings.UI_ConfigDialog_ResetCurrentSection ()
  config_dlg.currentSection.onReset (config_dlg.currentSection)
end


function warExtendedSettings.UI_ConfigDialog_Reset ()
  
  if (ButtonGetDisabledFlag ("warExtendedSettingsConfigDialogResetButton") or not config_dlg.currentSection) then return end
  
  DialogManager.MakeTwoButtonDialog (L"warExtendedSettings addon\n\nThis will reset "..config_dlg.currentSection.title:lower ()..L" section settings.\n\nContinue?\n\n(you may have to wait for game interface to reload)",
          L"Yes", warExtendedSettings.UI_ConfigDialog_ResetCurrentSection,
          L"No")
end


function warExtendedSettings.UI_ConfigDialog_ResetAll ()
  
  if (ButtonGetDisabledFlag ("warExtendedSettingsConfigDialogResetAllButton")) then return end
  
  DialogManager.MakeTwoButtonDialog (L"warExtendedSettings addon\n\nAre you sure you want to reset all settings to their default values?\n\n(you will have to wait for game interface to reload)",
          L"Yes", warExtendedSettings.ResetSettings,
          L"No")
end
