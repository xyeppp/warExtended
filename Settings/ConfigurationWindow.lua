local Enemy = Enemy
local g = {}
local pairs = pairs
local ipairs = ipairs
local tinsert = table.insert
local tsort = table.sort
local mmax = math.max
local mmin = math.min

local config_dlg = nil

--[[
executes on hiding the settings window,
if a section has not been intialized yet(pressed on) it does nothing,
otherwise executes onClose settings function  and triggers the SettingsCHanged event
-- settings changed event is responsible for checking every single setting versus its function and settings things accoridngly
-- implemented into WINDOW:OnHidden()
function Enemy.UI_ConfigDialog_Hide ()

    for _, section in ipairs (config_dlg.sections)
    do
        section.isActive = false

        if (not section.isInitialized
                or not section.isLoaded
                or not section.onClose) then continue end

        section.onClose (section)
    end

    WindowSetShowing ("EnemyConfigDialog", false)
    Enemy.TriggerEvent ("SettingsChanged", Enemy.Settings)
end]]


function Enemy.UI_ConfigDialog_Open (openSection, scroll)
    if (not config_dlg)
    then
        config_dlg =
        {
            sections = {}
        }

        CreateWindow ("EnemyConfigDialog", false)
        LabelSetText ("EnemyConfigDialogTitleBarText", L"Enemy addon configuration")
        ButtonSetText ("EnemyConfigDialogOkButton", L"OK")
        ButtonSetText ("EnemyConfigDialogCancelButton", L"Cancel")
        ButtonSetText ("EnemyConfigDialogResetButton", L"Reset")
        ButtonSetText ("EnemyConfigDialogResetAllButton", L"Reset all")

        LabelSetText ("EnemyConfigDialogSectionLabel", L"Section")
        config_dlg.sections = {}

        Enemy.TriggerEvent ("ConfigDialogInitializeSections", config_dlg.sections)

        for _, section in ipairs (config_dlg.sections)
        do
            section.isInitialized = false
            ComboBoxAddMenuItem ("EnemyConfigDialogSection", section.title)
        end
    end

    local open_section_index = ComboBoxGetSelectedMenuItem ("EnemyConfigDialogSection")
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

    WindowSetShowing ("EnemyConfigDialog", true)

    if (open_section_index == 0) then open_section_index = 1 end
    ComboBoxSetSelectedMenuItem ("EnemyConfigDialogSection", open_section_index)

    Enemy.UI_ConfigDialog_OnSectionSelChanged ()
    if (scroll ~= nil) then ScrollWindowSetOffset (config_dlg.currentSection.windowName.."Content", scroll) end
end



--[[
on selecting combo box different setting window

function Enemy.UI_ConfigDialog_OnSectionSelChanged ()

    local index = ComboBoxGetSelectedMenuItem ("EnemyConfigDialogSection")
    if (index < 1) then return end

    local section = config_dlg.sections[index]

    if (config_dlg.currentSection)
    then
        config_dlg.currentSection.isActive = false
    end

    if (not section.isInitialized)
    then
        section.windowName = "EnemyConfigDialogSections"..section.name
        CreateWindowFromTemplate (section.windowName, section.templateName, "EnemyConfigDialogSections")

        WindowClearAnchors (section.windowName)
        WindowAddAnchor (section.windowName, "topleft", "EnemyConfigDialogSections", "topleft", 0, 0)
        WindowAddAnchor (section.windowName, "bottomright", "EnemyConfigDialogSections", "bottomright", 0, 0)

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

    ButtonSetDisabledFlag ("EnemyConfigDialogResetButton", section.onReset == nil)
end
]]


--[[
on save button, iplemented into frame,
saves settings & executes onSectionSelChanged function
function Enemy.UI_ConfigDialog_Ok ()
    for _, section in ipairs (config_dlg.sections)
    do
        section.isActive = false

        if (not section.isInitialized
                or not section.isLoaded
                or not section.onSave) then continue end

        if (not section.onSave (section))
        then
            ComboBoxSetSelectedMenuItem ("EnemyConfigDialogSection", section.index)
            Enemy.UI_ConfigDialog_OnSectionSelChanged ()
            return
        end
    end

    Enemy.UI_ConfigDialog_Hide ()
    Enemy.FixSettings ()
end
]]

--[[
-- resets current selected settings to default values
function Enemy.UI_ConfigDialog_ResetCurrentSection ()
    config_dlg.currentSection.onReset (config_dlg.currentSection)
end
]]

-- on reset button, implemented - resets current section to default values
--[[
function Enemy.UI_ConfigDialog_Reset ()

    if (ButtonGetDisabledFlag ("EnemyConfigDialogResetButton") or not config_dlg.currentSection) then return end

    DialogManager.MakeTwoButtonDialog (L"Enemy addon\n\nThis will reset "..config_dlg.currentSection.title:lower ()..L" section settings.\n\nContinue?\n\n(you may have to wait for game interface to reload)",
            L"Yes", Enemy.UI_ConfigDialog_ResetCurrentSection,
            L"No")
end]]

--on reset all button, implemented into frame - resets all settings to it's default values
--[[
function Enemy.UI_ConfigDialog_ResetAll ()

    if (ButtonGetDisabledFlag ("EnemyConfigDialogResetAllButton")) then return end

    DialogManager.MakeTwoButtonDialog (L"Enemy addon\n\nAre you sure you want to reset all settings to their default values?\n\n(you will have to wait for game interface to reload)",
            L"Yes", Enemy.ResetSettings,
            L"No")
end]]



--initializes window with onChangeHandlers and properties needed to be used later on during changing settings and window creation
-- added for now as WINDOW:Create()
-- event is not needed as does not seem to be registered anywhere in enemy
--[[function Enemy.ConfigurationWindowInitialize ()

	Enemy.configurationWindow = g

	g.onChangeHandlers = {}
	g.properties = {}

	Enemy.TriggerEvent ("EnemyConfigurationWindowInitialized")
end]]




--used to get the activewindow and properties
-- already have it, will be changed into flrames later on
--[[local function GetDataFromActiveWindowName ()

	local awn = SystemData.ActiveWindow.name
	if (not awn) then return nil end

	return awn:match ("(.-)___(.-)___.*")
end]]

--used to call main onChange function from the window resposinble for every change made in settings,
-- wwill be remade into individual frames later on
-- added already
--[[function Enemy.ConfigurationWindow_OnChange ()
	local wn, pkey = GetDataFromActiveWindowName ()
	if (not wn or not pkey) then return end

	local handlers = g.onChangeHandlers[wn]
	if (not handlers) then return end

	local onchange = handlers[pkey]
	if (onchange and type (onchange) == "function")
	then
		onchange (SystemData.ActiveWindow.name)
	end
end]]


-- used on the bool template to call onChange handlers
-- will be changed to frame and called individualy with function defined in settings and a set frame
-- implemented
--[[function Enemy.ConfigurationWindow_OnBoolClick ()
	local wn, pkey = GetDataFromActiveWindowName ()
	if (not wn or not pkey) then return end

	local wn = SystemData.ActiveWindow.name
	if (ButtonGetDisabledFlag (wn.."Value")) then return end

	local v = ButtonGetPressedFlag (wn.."Value")
	ButtonSetPressedFlag (wn.."Value", not v)

	Enemy.ConfigurationWindow_OnChange ()
end]]


-- used on macro mouse drag,
-- will be changed into frame if possible
-- implemented
--[[
function Enemy.ConfigurationWindow_OnMacroMouseDrag ()

	if (Cursor.IconOnCursor()) then return end

	local wn, pkey = GetDataFromActiveWindowName ()
	if (not wn or not pkey) then return end

	local properties = g.properties[wn]
	if (not properties) then return end

	local p = properties[pkey]
	if (not p or not p.macroId or not p.macroIconNum) then return end

	Cursor.PickUp (Cursor.SOURCE_MACRO, p.macroId, p.macroId, p.macroIconNum, false)
	EA_Window_Macro.UpdateDetails (p.macroId)
end]]

-- show tooltip
-- will be changed into default frame capability if tooltip is defined
-- implemented for now
-- needs to be changed into using tooltips from warExtended table
--[[function Enemy.ConfigurationWindow_ShowTooltip ()
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
end]]

--[[
--- on button onClick
-- used onclick of button in settings, will be made into frame later
-- implemented for now
function Enemy.ConfigurationWindow_OnButtonClick ()

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
			Enemy.ConfigurationWindow_OnChange ()
		end
	else
		Enemy.ConfigurationWindow_OnChange ()
	end
]]


--[[
-- main creation window, needs to be fully remade into making individual frames from template later on
-- implemneted for now as is
--
-- "wn" should not contain tripple underline chars "___"
--
function Enemy.CreateConfigurationWindow (wn, root, properties, onChange)

	CreateWindowFromTemplate (wn, "EA_Window_Default", root)

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
				CreateWindowFromTemplate (wnp, p.template or "EnemyConfigurationWindow_PropertyNumberTemplate", wn)
				LabelSetText (wnp.."Label", p.name)

				WindowSetTabOrder (wnp.."Value", tab_order)
				tab_order = tab_order + 1

			elseif (p.type == "int[]")
			then
				CreateWindowFromTemplate (wnp, p.template or "EnemyConfigurationWindow_PropertyNumberArray"..p.size.."Template", wn)
				LabelSetText (wnp.."Label", p.name)

				for k = 1, p.size
				do
					WindowSetTabOrder (wnp.."Value"..k, tab_order)
					tab_order = tab_order + 1
				end

			elseif (p.type == "color")
			then
				CreateWindowFromTemplate (wnp, p.template or "EnemyConfigurationWindow_PropertyColorTemplate", wn)
				LabelSetText (wnp.."Label", p.name)

				for k = 1, 3
				do
					WindowSetTabOrder (wnp.."Value"..k, tab_order)
					tab_order = tab_order + 1
				end

			elseif (p.type == "select")
			then
				CreateWindowFromTemplate (wnp, p.template or "EnemyConfigurationWindow_PropertySelectTemplate", wn)

				local select_values = p.values
				if (type (select_values) == "function")
				then
					select_values = select_values ()
				end

				for _, v in ipairs (select_values)
				do
					ComboBoxAddMenuItem (wnp.."Value", Enemy.toWStringOrEmpty (v.text))
				end

				LabelSetText (wnp.."Label", p.name)

				WindowSetTabOrder (wnp.."Value", tab_order)
				tab_order = tab_order + 1

			elseif (p.type == "bool")
			then
				CreateWindowFromTemplate (wnp, p.template or "EnemyConfigurationWindow_PropertyBoolTemplate", wn)
				ButtonSetStayDownFlag (wnp.."Value", true)
				LabelSetText (wnp.."Label", p.name)

				WindowSetTabOrder (wnp.."Value", tab_order)
				tab_order = tab_order + 1

			elseif (p.type == "title")
			then
				CreateWindowFromTemplate (wnp, p.template or "EnemyConfigurationWindow_TitleTemplate", wn)
				LabelSetText (wnp.."Label", p.name)

			elseif (p.type == "button")
			then
				CreateWindowFromTemplate (wnp, p.template or "EnemyConfigurationWindow_ButtonTemplate", wn)
				ButtonSetText (wnp.."Value", p.name)

				WindowSetTabOrder (wnp.."Value", tab_order)
				tab_order = tab_order + 1

			elseif (p.type == "macro")
			then
				CreateWindowFromTemplate (wnp, p.template or "EnemyConfigurationWindow_MacroTemplate", wn)
				LabelSetText (wnp.."Label", p.name)

			else
				CreateWindowFromTemplate (wnp, p.template or "EnemyConfigurationWindow_PropertyStringTemplate", wn)
				LabelSetText (wnp.."Label", p.name)

				WindowSetTabOrder (wnp.."Value", tab_order)
				tab_order = tab_order + 1
			end
		end

		local width, height = WindowGetDimensions (wnp)

		if (p.windowWidth ~= nil)
		then
			width = p.windowWidth
			WindowSetDimensions (wnp, width, height)
		end

		if (p.windowHeight ~= nil)
		then
			height = p.windowHeight
			WindowSetDimensions (wnp, width, height)
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
	WindowSetDimensions (wn, window_width, window_height)

	return window_width, window_height
end]]

--[[
loads data from configWindow, impelemented as is, needs to be remade into frame
function Enemy.ConfigurationWindowLoadData (wn, data)

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
				TextEditBoxSetText (wnp.."Value", Enemy.toWStringOrEmpty (v))

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
					TextEditBoxSetText (wnp.."Value"..k, Enemy.toWStringOrEmpty (v[k]))
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

				p.macroId = Enemy.GetMacroId (p.macro)
				if (p.macroId)
				then
					p.macroIconNum = macros[p.macroId].iconNum

					local texture, x, y = GetIconData (p.macroIconNum)
			    	DynamicImageSetTexture (wnp.."ButtonIconBase", texture, x, y)
				end

			elseif (p.type ~= "title" and p.type ~= "button")
			then
				TextEditBoxSetText (wnp.."Value", Enemy.toWStringOrEmpty (v))
			end
		end
	end
end]]

--[[
saves data into settings, needs to be remade into warExtended saving into SavedSettings with a specified table
function Enemy.ConfigurationWindowSaveData (wn, data)

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
				local v = Enemy.isNil (Enemy.ConvertToInteger (TextEditBoxGetText (wnp.."Value")), p.default)

				if (v)
				then
					if (p.min) then v = mmax (v, p.min) end
					if (p.max) then v = mmin (v, p.max) end
				end

				data[p.key] = v

			elseif (p.type == "float")
			then
				local v = Enemy.isNil (Enemy.ConvertToFloat (TextEditBoxGetText (wnp.."Value")), p.default)

				if (v)
				then
					if (p.min) then v = mmax (v, p.min) end
					if (p.max) then v = mmin (v, p.max) end
				end

				data[p.key] = v

			elseif (p.type == "int[]" or p.type == "color")
			then
				local v = {}
				local default = Enemy.isNil (p.default, {})
				local min = Enemy.isNil (p.min, {})
				local max = Enemy.isNil (p.max, {})

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
					local vv = Enemy.isNil (Enemy.ConvertToInteger (TextEditBoxGetText (wnp.."Value"..k)), default[k])

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
				local v = Enemy.isNil (TextEditBoxGetText (wnp.."Value"), p.default)
				data[p.key] = v
			end
		end
	end
end]]

--[[resets window to default values, needs to be made acordingly to warExt settings,
implemented for now
function Enemy.ConfigurationWindowReset (wn, data)

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
					TextEditBoxSetText (wnp.."Value"..k, Enemy.toWStringOrEmpty (default[k]))
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
				TextEditBoxSetText (wnp.."Value", Enemy.toWStringOrEmpty (p.default))
			end
		end
	end
end]]

--[[gets constants from specified path, implemented as is
function Enemy.ConfigurationWindowGetSelectValuesHelper (data, textPropertyName, valuePropertyName, sort, emptyItem)

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


function Enemy.ConfigurationWindowGetLayersSelectValues (emptyItem)
	return Enemy.ConfigurationWindowGetSelectValuesHelper (Window.Layers, "$key", "$value", true, emptyItem)
end


function Enemy.ConfigurationWindowGetAnchorsSelectValues (emptyItem)
	return Enemy.ConfigurationWindowGetSelectValuesHelper (Enemy.Anchors, "$value", "$value", false, emptyItem)
end


function Enemy.ConfigurationWindowGetFontsSelectValues (emptyItem)
	return Enemy.ConfigurationWindowGetSelectValuesHelper (Enemy.Fonts, "$value", "$value", true, emptyItem)
end


function Enemy.ConfigurationWindowGetTextAlignsSelectValues (emptyItem)
	return Enemy.ConfigurationWindowGetSelectValuesHelper (Enemy.TextAligns, "$value", "$value", true, emptyItem)
end


function Enemy.ConfigurationWindowGetSoundsSelectValues (emptyItem)
	return Enemy.ConfigurationWindowGetSelectValuesHelper (GameData.Sound, "$key", "$value", true, emptyItem)
end]]





