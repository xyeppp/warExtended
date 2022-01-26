local function GetDataFromActiveWindowName ()
  
  local awn = SystemData.ActiveWindow.name
  if (not awn) then return nil end
  
  return awn:match ("(.-)___(.-)___.*")
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