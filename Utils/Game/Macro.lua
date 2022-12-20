local warExtended = warExtended
local towstring = towstring



macroFunc = {
  updateSelf = function(self, macroData)
    self.name = macroData.name
    self.text = macroData.text
    self.iconNum = macroData.iconNum
  end,

  getNextState = function(self)
    if self.activeState == #self.macroStates then
      self.activeState = 1
      return self.macroStates[1]
    else
      self.activeState = self.activeState + 1
      return self.macroStates[self.activeState]
    end
  end,

  setNextState = function(self)
    self.text = self:getNextState()
    self:setMacroData()
  end,

  setMacroData = function(self)
    SetMacroData (self.name, self.text, self.iconNum, self.slot)
    EA_Window_Macro.UpdateDetails (self.slot)
  end,

  setActiveActionButton = function(self, buttonName)
    self.activeActionButtons[buttonName] = self.slot
  end
}

function warExtended:RegisterMacro(macroData, macroSlot, macroStates)
  macroData = setmetatable(macroData, {__index = macroFunc})
  macroData.activeActionButtons = {}
  macroData.slot = macroSlot
  macroData.macroStates = macroStates
  macroData.activeState = 1
  return macroData

end




macroCache = {
}

function warExtended:GetMacroDataFromSlot(slot)
  local macro = macroCache[slot]
  return macro
end

function warExtended:GetMacroTextFromSlot(slot)
  local macroText = tostring(macroCache[slot].text)
  return macroText
end

function warExtended:GetMacroNameFromSlot(slot)
  local macroName = tostring(macroCache[slot].name)
  return macroName
end

function warExtended:GetMacroIconFromSlot(slot)
  return macroCache[slot].iconNum
end

function warExtended:GetMacroSlotFromName(macroName)
  macroName = towstring(macroName)
  for macroSlot=1,#macroCache do
    local isMacroNameMatch = macroCache[macroSlot].name == macroName

    if isMacroNameMatch then
      return macroSlot
    end

  end
end

function warExtended:GetMacroSlotFromText(macroText)
  macroText = towstring(macroText)
  for macroSlot=1,#macroCache do
    local isMacroTextMatch = macroCache[macroSlot].text == macroText

    if isMacroTextMatch then
      return macroSlot
    end

  end
end

function warExtended:IsMacroType(abilityType)
  local isMacroType = abilityType == 4
  return isMacroType
end

function warExtended.OnMacroUpdated(macroSlot)
  local macroData = DataUtils.GetMacros()[macroSlot]

  if not macroCache[macroSlot] then
    macroCache[macroSlot] = warExtended:RegisterMacro(macroData, macroSlot, nil)
  end

  macroCache[macroSlot]:updateSelf(macroData)
end

function warExtended:GetMacros()
  return macroCache
end

function warExtended.OnAllModulesInitialized()
  macroCache = DataUtils.GetMacros()

  for macroIndex=1,48 do
    local macroState = {
      [1] = macroCache[macroIndex].text,
      [2] = L"testing123"
    }

    macroCache[macroIndex] = warExtended:RegisterMacro(macroCache[macroIndex], macroIndex, macroState)
  end

end

function warExtended.OnUpdateActionButtons(self, actionType, actionId)
  if warExtended:IsMacroType(actionType) then
    local actionName = self:GetName() .. "Action"
    p(actionName)
    macroCache[actionId]:setActiveActionButton(actionName)
  end
end


local function setActionButtonHooks()
  warExtended:RegisterGameEvent({"macro updated"}, "warExtended.OnMacroUpdated")
  warExtended:Hook(ActionButton.SetActionData, warExtended.OnUpdateActionButtons, true)
end

warExtended:AddEventHandler("setActionButtonHooks", "CoreInitialized", setActionButtonHooks)




