local warExtended = warExtended
local buttons = {}

function warExtended:IsActionButtonType(actionButtonData, actionType)
    return actionButtonData.m_ActionType == actionType
end

function warExtended:RegisterActionButton(actionButtonData)

end


--[[Switcher:Hook(ActionBars.UpdateActionButtons, onUpdateActionButtons, true)


local function onUpdateActionButtons(slot, actionType, actionId)
  local isSwitcherMacro = isActionButtonAMacro(actionType) and isMacroSwitcherMacro(actionId)
  local isSwitcherSaved = isHotbarSwitcherSaved(slot)

  if isSwitcherSaved then
	local isSwitcherPressed = getSwitcherState(slot)
	if not isSwitcherPressed and not isSwitcherMacro then
	  removeHotbarSwitcherActionButton(slot)
	  return
	end
  end

  if isSwitcherMacro then
	setHotbarSwitcherActionButton(actionId, slot, slot)
  end
end

local abuttons = {
  add = function(self, buttonNumber, text)
    self.active[buttonNumber] = text
  end,

  getActive = function(self)
    return self.active
  end,

  clear = function(self)
    if next(self.active) == 0 then
      return
    end
  end,

  active = {}
}

switchedMacros = {}

local function testFFFF(macroData)
  if not switchedMacros[macroData.m_ActionId] then
    return
  end

  SetMacroData(switchedMacros[macroData.m_ActionId].name, switchedMacros[macroData.m_ActionId].text, switchedMacros[macroData.m_ActionId].iconNum, macroData.m_ActionId)
  EA_Window_Macro.UpdateDetails (macroData.m_ActionId)
  switchedMacros[macroData.m_ActionId] = nil
end


local function testFFF(actionButtonData)
  p(actionButtonData)
  if actionButtonData.m_ActionType == 4 then
    local macros = GetMacrosData()
    local macro = macros[actionButtonData.m_ActionId]
    if warExtended:IsKeymapText(tostring(macro.text)) then
      p('is keymap')
      switchedMacros[actionButtonData.m_ActionId] = macro
      SetMacroData (macro.name, substituteChatText(tostring(macro.text)), macro.iconNum, actionButtonData.m_ActionId)
      EA_Window_Macro.UpdateDetails (actionButtonData.m_ActionId)
    end
  end
end

function testMacro()
    warExtended:Hook(ActionButton.OnLButtonDown,testFFF, true)
    warExtended:Ho
   ok(ActionButton.OnLButtonUp,testFFFF, true)
end]]