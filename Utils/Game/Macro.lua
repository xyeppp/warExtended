local warExtended = warExtended
local towstring = towstring
local DataUtils = DataUtils
local SetMacroData= SetMacroData

local macroCache = warExtendedSet:New()

-- Data types: "iconNum", "name", "text"
function warExtended:GetMacroData(macroSlot, dataType)
    local currentMacros = DataUtils.GetMacros()
    if not dataType then
        return currentMacros[macroSlot]
    elseif currentMacros[macroSlot][dataType] == (0) or currentMacros[macroSlot][dataType] == L"" then
        return nil
    else
        return currentMacros[macroSlot][dataType]
    end
end

function warExtended:GetMacroSlot(dataSearch, dataType)
    local currentMacros = DataUtils.GetMacros()
    for macroSlot=1,#currentMacros do
        if self:GetMacroData(macroSlot, dataType) == dataSearch then
            return macroSlot
        end
    end
end

function warExtended:IsMacro(buttonAbilityType)
  local isMacroType = buttonAbilityType == 4
  return isMacroType
end

function warExtended:SetMacro(macroName, macroText, iconNum, macroSlot)
    SetMacroData (macroName, macroText, iconNum, macroSlot)
end

--[[
function warExtended.OnMacroUpdated(macroSlot)
  local macroData = DataUtils.GetMacros()[macroSlot]

  if not macroCache[macroSlot] then
    macroCache[macroSlot] = warExtended:RegisterMacro(macroData, macroSlot, nil)
  end

  macroCache[macroSlot]:updateSelf(macroData)
end]]


--[[
function warExtended:GetRegisteredMacros()
  return macroCache
end]]


--[[
function warExtended.OnAllModulesInitialized()
  macroCache = DataUtils.GetMacros()

  for macroIndex=1,48 do
    local macroState = {
      [1] = macroCache[macroIndex].text,
      [2] = L"testing123"
    }

    macroCache[macroIndex] = warExtended:RegisterMacro(macroCache[macroIndex], macroIndex, macroState)
  end]]

--[[
function warExtended.OnUpdateActionButtons(self, actionType, actionId)
  if warExtended:IsMacroType(actionType) then
    local actionName = self:GetName() .. "Action"
    p(actionName)
    macroCache[actionId]:setActiveActionButton(actionName)
  end
end]]

--[[
local function setActionButtonHooks()
  warExtended:RegisterGameEvent({"macro updated"}, "warExtended.OnMacroUpdated")
  warExtended:Hook(ActionButton.SetActionData, warExtended.OnUpdateActionButtons, true)
end

warExtended:AddEventHandler("setActionButtonHooks", "CoreInitialized", setActionButtonHooks)]]




