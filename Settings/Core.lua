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

local function initializeSettings ()
  warExtendedSettings.configurationWindow = g
  
  g.onChangeHandlers = {}
  g.properties = {}
  
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
    bmnbjb =
    {
      key = "bmnbjb",
      order = 38,
      name = L"Tester",
      type = "bool",
      paddingTop = 5
    },
    ghumghuhb =
    {
      key = "ghumghuhb",
      order = 39,
      name = L"Replace standard scenario ending window",
      type = "bool",
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
  ScrollWindowUpdateScrollRect (windowName.."Content")
end


function warExtendedSettings.CreateConfigurationWindow (wn, root, properties, onChange)
  
  CreateWindowFromTemplate (wn, "warExtendedSettingsTemplate", root)
  
  local onchange_handlers = {}
  g.onChangeHandlers[wn] = onchange_handlers
  
  local pp = {}
  g.properties[wn] = pp
  
  local window_width = 0
  local window_height = 0
  local prev_wnp = nil
  
  local sorted_properties = {}
  for _, p in pairs (properties)
  do
    tinsert (sorted_properties, p)
  end
  
  table.sort (sorted_properties, function (a, b)
    return a.order < b.order
  end)
  
  local tab_order = 1
  
  for _, p in ipairs (sorted_properties)
  do
    local wnp = wn.."___"..p.key.."___"
    
    if (p.onCreate)
    then
      p.onCreate (wnp, p)
    else
      if (p.type == "int" or p.type == "float")
      then
        CreateWindowFromTemplate (wnp, p.template or "warExtendedSettings_PropertyNumberTemplate", wn)
        LabelSetText (wnp.."Label", p.name)
        
        WindowSetTabOrder (wnp.."Value", tab_order)
        tab_order = tab_order + 1
      
      elseif (p.type == "int[]")
      then
        CreateWindowFromTemplate (wnp, p.template or "warExtendedSettings_PropertyNumberArray"..p.size.."Template", wn)
        LabelSetText (wnp.."Label", p.name)
        
        for k = 1, p.size
        do
          WindowSetTabOrder (wnp.."Value"..k, tab_order)
          tab_order = tab_order + 1
        end
      
      elseif (p.type == "color")
      then
        CreateWindowFromTemplate (wnp, p.template or "warExtendedSettings_PropertyColorTemplate", wn)
        LabelSetText (wnp.."Label", p.name)
        
        for k = 1, 3
        do
          WindowSetTabOrder (wnp.."Value"..k, tab_order)
          tab_order = tab_order + 1
        end
      
      elseif (p.type == "select")
      then
        CreateWindowFromTemplate (wnp, p.template or "warExtendedSettings_PropertySelectTemplate", wn)
        
        local select_values = p.values
        if (type (select_values) == "function")
        then
          select_values = select_values ()
        end
        
        for _, v in ipairs (select_values)
        do
          ComboBoxAddMenuItem (wnp.."Value", warExtended:toWStringOrEmpty (v.text))
        end
        
        LabelSetText (wnp.."Label", p.name)
        
        WindowSetTabOrder (wnp.."Value", tab_order)
        tab_order = tab_order + 1
      
      elseif (p.type == "bool")
      then
        CreateWindowFromTemplate (wnp, p.template or "warExtendedSettings_PropertyBoolTemplate", wn)
        ButtonSetStayDownFlag (wnp.."Value", true)
        LabelSetText (wnp.."Label", p.name)
        
        WindowSetTabOrder (wnp.."Value", tab_order)
        tab_order = tab_order + 1
      
      elseif (p.type == "title")
      then
        CreateWindowFromTemplate (wnp, p.template or "warExtendedSettings_TitleTemplate", wn)
        LabelSetText (wnp.."Label", p.name)
      
      elseif (p.type == "button")
      then
        CreateWindowFromTemplate (wnp, p.template or "warExtendedSettings_ButtonTemplate", wn)
        ButtonSetText (wnp.."Value", p.name)
        
        WindowSetTabOrder (wnp.."Value", tab_order)
        tab_order = tab_order + 1
      
      elseif (p.type == "macro")
      then
        CreateWindowFromTemplate (wnp, p.template or "warExtendedSettings_MacroTemplate", wn)
        LabelSetText (wnp.."Label", p.name)
      
      else
        CreateWindowFromTemplate (wnp, p.template or "warExtendedSettings_PropertyStringTemplate", wn)
        LabelSetText (wnp.."Label", p.name)
        
        WindowSetTabOrder (wnp.."Value", tab_order)
        tab_order = tab_order + 1
      end
    end
    
    local width, height = WindowGetDimensions (wnp)
    
    if (p.windowWidth ~= nil)
    then
      width = p.windowWidth
     -- WindowSetDimensions (wnp, width, height)
    end
    
    if (p.windowHeight ~= nil)
    then
      height = p.windowHeight
     -- WindowSetDimensions (wnp, width, height)
    end
    
    window_width = math.max (window_width, width)
    
    if (prev_wnp)
    then
      WindowAddAnchor (wnp, "bottomleft", prev_wnp, "topleft", p.paddingLeft or 0, p.paddingTop or 10)
      window_height = window_height + height + (p.paddingTop or 10)
    else
      WindowAddAnchor (wnp, "topleft", wn, "topleft", p.paddingLeft or 0, p.paddingTop or 0)
      window_height = window_height + height + (p.paddingTop or 0)
    end
    
    prev_wnp = wnp
    
    onchange_handlers[p.key] = p.onChange or onChange
    pp[p.key] = p
  end
  
  window_height = window_height + 30
 -- WindowSetDimensions (wn, window_width, window_height)
  
  return window_width, window_height
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


warExtended:AddEventHandler("InitializeSettings", "CoreInitialized", initializeSettings)