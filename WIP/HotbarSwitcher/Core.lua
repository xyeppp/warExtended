warExtendedHotbarSwitcher = warExtended.Register("warExtended Hotbar Switcher")
local Switcher = warExtendedHotbarSwitcher
local ActionBars = ActionBars
local HOTBAR_SWITCHER = "HotbarSwitch"


Switcher.Switchers = {
}

local function isActionButtonAMacro(actionType)
  local isMacro = actionType == 4
  return isMacro
end

local function removeHotbarSwitcherActionButton(actionSlot)
  for switcherButton, switcherData in pairs(Switcher.Settings.SwitcherButtons) do
    if switcherData.slot == actionSlot then
      Switcher.Settings.SwitcherButtons[switcherButton] = nil
    end
  end
end

local function getHotbarSwitch(actionId)
  local macros = DataUtils.GetMacros()
  local macroText = tostring(macros[actionId].text)
  local currentHotbar, destinationHotbar = macroText:match(HOTBAR_SWITCHER.."%((%d+),(%d+)%)")
  return currentHotbar, destinationHotbar
end

local function isMacroSwitcherMacro(actionId)
local macros = DataUtils.GetMacros()
local macroText = tostring(macros[actionId].text)
local isSwitcherMacro = macroText:match(HOTBAR_SWITCHER)
return isSwitcherMacro
end

local function setHotbarSwitcherActionButton(actionId, slot, actionSlot)
  local actionButtonName = getActionBarButtonName(slot)
  local isButton = Switcher.Settings.SwitcherButtons[actionId]
  local currentHotbar, destinationHotbar = getHotbarSwitch(actionId)
  if not isButton then
    Switcher.Settings.SwitcherButtons[actionId] = {
      name = actionButtonName,
      slot = actionSlot,
      isPressed = false;
      curHotbar = tonumber(currentHotbar),
      destHotbar = tonumber(destinationHotbar)
    }
  end
end

local function getSwitcherState(slot)
  for _, switcherData in pairs(warExtendedHotbarSwitcher.Settings.SwitcherButtons) do
    local isSwitcherSlot = switcherData.slot == slot
    if isSwitcherSlot then
      local isSwitcherPressed = switcherData.isPressed
      return isSwitcherPressed
    end
  end
end

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


local function processSwitch(switcherData)
  local switcherName = switcherData.name
  local switcherCur = switcherData.curHotbar
  local switcherDest = switcherData.destHotbar
  local switcherIsPressed = switcherData.isPressed

  if ButtonGetPressedFlag(switcherName) and not switcherIsPressed then
    switcherData.isPressed = true;
    SetHotbarPage(switcherCur, switcherDest)
  elseif not ButtonGetPressedFlag(switcherName) and switcherIsPressed then
    switcherData.isPressed=false;
    SetHotbarPage(switcherCur, switcherCur)
  end
end



function HotbarSwitch(timeElapsed)
  local isSwitcherBound = next(Switcher.Settings.SwitcherButtons) ~= nil
  if isSwitcherBound then
    for _, switcherData in pairs(Switcher.Settings.SwitcherButtons) do
      processSwitch(switcherData)
    end
  end
end


function Switcher.OnInitialize()
--  Switcher:Hook(ActionBars.UpdateProxy, HotbarSwitch, true)
  Switcher:Hook(ActionBars.UpdateActionButtons, onUpdateActionButtons, true)
end
