-- Reuse of warExtendedSettings settings config
--TODO: clean traces on warExtendedSettings, figure out further steps to create first config file
-- UI_ConfigDialog_OnSectionSelChanged check enemy for this and rest of configDialogUI
local warExtended         = warExtended
warExtendedSettings = {}

if not warExtended._Settings then
  warExtended._Settings = {
	  modules = {}
  }
end

local Settings = warExtended._Settings

local WINDOW_NAME = "warExtendedSettings"
local WINDOW_SCROLL_CHILD_NAME = WINDOW_NAME.."MainScrollChild"
local SLASH_WINDOW = WINDOW_NAME.."SlashWindow"
local MOD_DETAILS_WINDOW_NAME = WINDOW_NAME.."ModDetails"
local pairs               = pairs
local ipairs              = ipairs
local tinsert             = table.insert
local tsort               = table.sort
local mmax                = math.max
local mmin                = math.min
local cur_settings            = {}

if not Settings.Config then
  Settings.Config = {}
end

function warExtended._Settings.AddEntry(name)
	local listBox = GetFrame(WINDOW_NAME.."List")
	listBox:AddEntry(name, MOD_DETAILS_WINDOW_NAME)
end

function warExtended._Settings.AddChildEntry(parentName, entryName, entryWindow)
	local listBox = GetFrame(WINDOW_NAME.."List")
	listBox:AddChildEntry(parentName, entryName, entryWindow)
end


local function GetDataFromActiveWindowName ()

  local awn = SystemData.ActiveWindow.name
  if (not awn) then return nil end

  return awn:match("(.-)___(.-)___.*")
end

function warExtended._Settings.ConfigurationWindow_OnChange ()
	local frame = GetFrame(WINDOW_NAME)
  local wn, pkey = GetDataFromActiveWindowName()
  if (not wn or not pkey) then return end
  local handlers = frame.onChangeHandlers[wn]
  if (not handlers) then return end
  local onchange = handlers[pkey]
  if (onchange and type(onchange) == "function")
  then
	onchange(SystemData.ActiveWindow.name)
  end
end




function warExtended._Settings.ConfigurationWindow_OnBoolClick ()
  local wn, pkey = GetDataFromActiveWindowName()
  if (not wn or not pkey) then return end

  local wn = SystemData.ActiveWindow.name
  if (ButtonGetDisabledFlag(wn .. "Value")) then return end

  local v = ButtonGetPressedFlag(wn .. "Value")
  ButtonSetPressedFlag(wn .. "Value", not v)

  warExtended._Settings.ConfigurationWindow_OnChange()
end

function warExtended._Settings.ConfigurationWindow_OnMacroMouseDrag ()
	local frame = GetFrame(WINDOW_NAME)
  if (Cursor.IconOnCursor()) then return end

  local wn, pkey = GetDataFromActiveWindowName()
  if (not wn or not pkey) then return end

  local properties = frame.properties[wn]
  if (not properties) then return end

  local p = properties[pkey]
  if (not p or not p.macroId or not p.macroIconNum) then return end

  Cursor.PickUp(Cursor.SOURCE_MACRO, p.macroId, p.macroId, p.macroIconNum, false)
  EA_Window_Macro.UpdateDetails(p.macroId)
end

function warExtended._Settings.ConfigurationWindow_ShowTooltip ()
	local frame = GetFrame(WINDOW_NAME)
  local wn, pkey = GetDataFromActiveWindowName()
  if (not wn or not pkey) then return end

  local properties = frame.properties[wn]
  if (not properties) then return end

  local p = properties[pkey]
  if (p and p.tooltip)
  then
	Tooltips.CreateTextOnlyTooltip(SystemData.MouseOverWindow.name)

	if (type(p.tooltip) == "function")
	then
	  p.tooltip()

	elseif (type(p.tooltip) == "table")
	then
	  local k = 0

	  for _, v in pairs(p.tooltip)
	  do
		Tooltips.SetTooltipText(k, 1, towstring(v))
		k = k + 1
	  end
	else
	  Tooltips.SetTooltipText(1, 1, towstring(p.tooltip))
	end

	Tooltips.AnchorTooltip(Tooltips.ANCHOR_CURSOR)
	Tooltips.Finalize()
  end
end

function warExtended._Settings.ConfigurationWindow_OnButtonClick ()
	local frame = GetFrame(WINDOW_NAME)
  if (ButtonGetDisabledFlag(SystemData.ActiveWindow.name)) then return end

  local wn, pkey = GetDataFromActiveWindowName()
  if (not wn or not pkey) then return end

  local properties = frame.properties[wn]
  if (not properties) then return end

  local p = properties[pkey]
  if (p.onClick)
  then
	if (p.onClick())
	then
	  warExtended._Settings.ConfigurationWindow_OnChange()
	end
  else
	warExtended._Settings.ConfigurationWindow_OnChange()
  end
end


--
-- "wn" should not contain tripple underline chars "___"
--
function warExtended._Settings.CreateConfigurationWindow(wn, root, properties, onChange)
	--CreateWindowFromTemplate(wn, "warExtendedSettingsTemplate", root)
	local g = GetFrame(WINDOW_NAME)

	local onchange_handlers = {}
	g.onChangeHandlers[wn] = onchange_handlers

	local pp = {}
	g.properties[wn] = pp

	local window_width = 0
	local window_height = 0
	local prev_wnp = nil

	local sorted_properties = {}
	for _, p in pairs(properties) do
		tinsert(sorted_properties, p)
	end

	table.sort(sorted_properties, function(a, b)
		return a.order < b.order
	end)

	local tab_order = 1

	for _, p in ipairs(sorted_properties) do
		local wnp = wn .. "___" .. p.key .. "___"

		if p.onCreate then
			p.onCreate(wnp, p)
		else
			if p.type == "int" or p.type == "float" then
				CreateWindowFromTemplate(wnp, p.template or "warExtendedSettings_PropertyNumberTemplate", wn)
				LabelSetText(wnp .. "Label", p.name)

				WindowSetTabOrder(wnp .. "Value", tab_order)
				tab_order = tab_order + 1
			elseif p.type == "int[]" then
				CreateWindowFromTemplate(
						wnp,
						p.template or "warExtendedSettings_PropertyNumberArray" .. p.size .. "Template",
						wn
				)
				LabelSetText(wnp .. "Label", p.name)

				for k = 1, p.size do
					WindowSetTabOrder(wnp .. "Value" .. k, tab_order)
					tab_order = tab_order + 1
				end
			elseif p.type == "color" then
				CreateWindowFromTemplate(wnp, p.template or "warExtendedSettings_PropertyColorTemplate", wn)
				LabelSetText(wnp .. "Label", p.name)

				for k = 1, 3 do
					WindowSetTabOrder(wnp .. "Value" .. k, tab_order)
					tab_order = tab_order + 1
				end
			elseif p.type == "select" then
				CreateWindowFromTemplate(wnp, p.template or "warExtendedSettings_PropertySelectTemplate", wn)

				local select_values = p.values
				if type(select_values) == "function" then
					select_values = select_values()
				end

				for _, v in ipairs(select_values) do
					ComboBoxAddMenuItem(wnp .. "Value", warExtended:toWStringOrEmpty(v.text))
				end

				LabelSetText(wnp .. "Label", p.name)

				WindowSetTabOrder(wnp .. "Value", tab_order)
				tab_order = tab_order + 1
			elseif p.type == "bool" then
				CreateWindowFromTemplate(wnp, p.template or "warExtendedSettings_PropertyBoolTemplate", wn)
				ButtonSetStayDownFlag(wnp .. "Value", true)
				LabelSetText(wnp .. "Label", p.name)

				WindowSetTabOrder(wnp .. "Value", tab_order)
				tab_order = tab_order + 1
			elseif p.type == "title" then
				CreateWindowFromTemplate(wnp, p.template or "warExtendedSettings_TitleTemplate", wn)
				LabelSetText(wnp .. "Label", p.name)
			elseif p.type == "button" then
				CreateWindowFromTemplate(wnp, p.template or "warExtendedSettings_ButtonTemplate", wn)
				ButtonSetText(wnp .. "Value", p.name)

				WindowSetTabOrder(wnp .. "Value", tab_order)
				tab_order = tab_order + 1
			elseif p.type == "macro" then
				CreateWindowFromTemplate(wnp, p.template or "warExtendedSettings_MacroTemplate", wn)
				LabelSetText(wnp .. "Label", p.name)
			else
				CreateWindowFromTemplate(wnp, p.template or "warExtendedSettings_PropertyStringTemplate", wn)
				LabelSetText(wnp .. "Label", p.name)

				WindowSetTabOrder(wnp .. "Value", tab_order)
				tab_order = tab_order + 1
			end
		end

		local width, height = WindowGetDimensions(wnp)

		if p.windowWidth ~= nil then
			width = p.windowWidth
			-- WindowSetDimensions (wnp, width, height)
		end

		if p.windowHeight ~= nil then
			height = p.windowHeight
			-- WindowSetDimensions (wnp, width, height)
		end

		window_width = math.max(window_width, width)

		if prev_wnp then
			WindowAddAnchor(wnp, "bottomleft", prev_wnp, "topleft", p.paddingLeft or 0, p.paddingTop or 10)
			window_height = window_height + height + (p.paddingTop or 10)
		else
			WindowAddAnchor(wnp, "topleft", wn, "topleft", p.paddingLeft or 0, p.paddingTop or 0)
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

function warExtended._Settings.ConfigurationWindowLoadData (wn, data)
	local g = GetFrame(WINDOW_NAME)
	local properties = g.properties[wn]

	for _, p in pairs(properties)
	do
		local wnp = wn .. "___" .. p.key .. "___"
		local v   = data[p.key]

		if (p.onLoad)
		then
			p.onLoad(wnp, p, data)
		else
			if (p.type == "int" or p.type == "float")
			then
				TextEditBoxSetText(wnp .. "Value", warExtended:toWStringOrEmpty(v))

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
					TextEditBoxSetText(wnp .. "Value" .. k, warExtended:toWStringOrEmpty(v[k]))
				end

			elseif (p.type == "select")
			then
				local select_values = p.values
				if (type(select_values) == "function")
				then
					select_values = select_values()
				end

				local value_set = false

				for k, vv in ipairs(select_values)
				do
					if (vv.value == v)
					then
						ComboBoxSetSelectedMenuItem(wnp .. "Value", k)
						value_set = true

						break
					end
				end

				if (not value_set)
				then
					ComboBoxSetSelectedMenuItem(wnp .. "Value", 1)
				end

			elseif (p.type == "bool")
			then
				ButtonSetPressedFlag(wnp .. "Value", v == true)

			elseif (p.type == "macro")
			then
				local macros = DataUtils.GetMacros()

				p.macroId    = warExtended:GetMacroDataFromSlot(p.macro)
				if (p.macroId)
				then
					p.macroIconNum      = macros[p.macroId].iconNum

					local texture, x, y = GetIconData(p.macroIconNum)
					DynamicImageSetTexture(wnp .. "ButtonIconBase", texture, x, y)
				end

			elseif (p.type ~= "title" and p.type ~= "button")
			then
				TextEditBoxSetText(wnp .. "Value", warExtended:toWStringOrEmpty(v))
			end
		end
	end
end


function warExtended._Settings.ConfigurationWindowSaveData (wn, data)
	local g = GetFrame(WINDOW_NAME)
	local properties = g.properties[wn]

	for _, p in pairs(properties)
	do
		local wnp = wn .. "___" .. p.key .. "___"

		if (p.onSave)
		then
			p.onSave(wnp, p, data)
		else
			if (p.type == "int")
			then
				local v = warExtended:isNil(warExtended:ConvertToInteger(TextEditBoxGetText(wnp .. "Value")), p.default)

				if (v)
				then
					if (p.min) then v = mmax(v, p.min) end
					if (p.max) then v = mmin(v, p.max) end
				end

				data[p.key] = v

			elseif (p.type == "float")
			then
				local v = warExtended:isNil(warExtended:ConvertToFloat(TextEditBoxGetText(wnp .. "Value")), p.default)

				if (v)
				then
					if (p.min) then v = mmax(v, p.min) end
					if (p.max) then v = mmin(v, p.max) end
				end

				data[p.key] = v

			elseif (p.type == "int[]" or p.type == "color")
			then
				local v       = {}
				local default = warExtended:isNil(p.default, {})
				local min     = warExtended:isNil(p.min, {})
				local max     = warExtended:isNil(p.max, {})

				local size
				if (p.type == "color")
				then
					size = 3
					min  = { 0, 0, 0 }
					max  = { 255, 255, 255 }
				else
					size = p.size
				end

				for k = 1, size
				do
					local vv = warExtended:isNil(warExtended:ConvertToInteger(TextEditBoxGetText(wnp .. "Value" .. k)), default[k])

					if (vv)
					then
						if (min[k]) then vv = mmax(vv, min[k]) end
						if (max[k]) then vv = mmin(vv, max[k]) end
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
						WindowSetShowing(wnp .. "Example", false)
					else
						WindowSetShowing(wnp .. "Example", true)
						WindowSetTintColor(wnp .. "Example", v[1], v[2], v[3])
					end
				end

				data[p.key] = v

			elseif (p.type == "select")
			then

				local select_values = p.values
				if (type(select_values) == "function")
				then
					select_values = select_values()
				end

				local v = select_values[ComboBoxGetSelectedMenuItem(wnp .. "Value")]
				if (v)
				then
					v = v.value
				else
					v = p.default
				end

				data[p.key] = v

			elseif (p.type == "bool")
			then
				data[p.key] = ButtonGetPressedFlag(wnp .. "Value")

			elseif (p.type ~= "title" and p.type ~= "button" and p.type ~= "macro")
			then
				local v     = warExtended:isNil(TextEditBoxGetText(wnp .. "Value"), p.default)
				data[p.key] = v
			end
		end
	end
end

function warExtended._Settings.ConfigurationWindowReset (wn, data)
	local g = GetFrame(WINDOW_NAME)
	local properties = g.properties[wn]

	for _, p in pairs(properties)
	do
		local wnp = wn .. "___" .. p.key .. "___"

		if (p.onReset)
		then
			p.onReset(wnp, p, data)
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
					TextEditBoxSetText(wnp .. "Value" .. k, warExtended:toWStringOrEmpty(default[k]))
				end

			elseif (p.type == "select")
			then
				local select_values = p.values
				if (type(select_values) == "function")
				then
					select_values = select_values()
				end

				local value_set = false

				for k, vv in ipairs(select_values)
				do
					if (vv.value == p.default)
					then
						ComboBoxSetSelectedMenuItem(wnp .. "Value", k)
						value_set = true

						break
					end
				end

				if (not value_set)
				then
					ComboBoxSetSelectedMenuItem(wnp .. "Value", 1)
				end

			elseif (p.type == "bool")
			then
				ButtonSetPressedFlag(wnp .. "Value", p.default == true)

			elseif (p.type ~= "title" and p.type ~= "button" and p.type ~= "macro")
			then
				TextEditBoxSetText(wnp .. "Value", warExtended:toWStringOrEmpty(p.default))
			end
		end
	end
end



function warExtended._Settings.ConfigurationWindowGetSelectValuesHelper (data, textPropertyName, valuePropertyName, sort, emptyItem)

  local res = {}

  for k, v in pairs(data)
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

	tinsert(res, obj)
  end

  if (sort)
  then
	tsort(res, function(a, b)
	  return a.text < b.text
	end)
  end

  if (emptyItem)
  then
	tinsert(res, 1, { text = emptyItem, value = nil })
  end

  return res

end

function warExtended._Settings.ConfigurationWindowGetLayersSelectValues (emptyItem)
  return warExtended._Settings.ConfigurationWindowGetSelectValuesHelper(Window.Layers, "$key", "$value", true, emptyItem)
end

function warExtended._Settings.ConfigurationWindowGetAnchorsSelectValues (emptyItem)
  return warExtended._Settings.ConfigurationWindowGetSelectValuesHelper(warExtended:GetConstants("windowAnchors"), "$value", "$value", false, emptyItem)
end

function warExtended._Settings.ConfigurationWindowGetFontsSelectValues (emptyItem)
  return warExtended._Settings.ConfigurationWindowGetSelectValuesHelper(warExtended:GetConstants("fonts"), "$value", "$value", true, emptyItem)
end

function warExtended._Settings.ConfigurationWindowGetTextAlignsSelectValues (emptyItem)
  return warExtended._Settings.ConfigurationWindowGetSelectValuesHelper(warExtended:GetConstants("textAligns"), "$value", "$value", true, emptyItem)
end

function warExtended._Settings.ConfigurationWindowGetSoundsSelectValues (emptyItem)
  return warExtended._Settings.ConfigurationWindowGetSelectValuesHelper(GameData.Sound, "$key", "$value", true, emptyItem)
end

-- used on ResetAll:LButtonUp()
-- needs to be remade to get all default settings fromm each individual addon
function warExtended._Settings.ResetSettings ()
	warExtendedSettings.Config = nil
	warExtended:Print ("All settings has been reset")
	InterfaceCore.ReloadUI ()
end
