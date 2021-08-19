warExtendedMacro = {}
  --TODO:  getFirstEmptyMacroSlot() Search all macro sets and try to register on another set.
  --       Allow for creation/deletion of unlimited macro sets.
  --       Add an extra clickable macro window somewhere for more slots

local warExtended = warExtended
local EA_Window_Macro = EA_Window_Macro
local DataUtils = DataUtils
local ComboBoxGetSelectedMenuItem = ComboBoxGetSelectedMenuItem
local ComboBoxSetSelectedMenuItem = ComboBoxSetSelectedMenuItem
local ComboBoxGetSelectedText     = ComboBoxGetSelectedText
local ComboBoxAddMenuItem = ComboBoxAddMenuItem
local DynamicImageSetTexture  = DynamicImageSetTexture
local LabelSetText  = LabelSetText
local SetMacroData  = SetMacroData
local GetIconData = GetIconData
local macroBox = "MacroSetComboBox"
local macroWindowTitlebar = "EA_Window_MacroTitleBarText"
local displayMacroSetLoadMessage = false;

warExtendedMacro.Settings={}
warExtendedMacro.Settings.isMacroSetCreated = false;
warExtendedMacro.Settings.selectedMacroSet  = 1;
warExtendedMacro.Settings.Sets = {}

local selectedSet =  {
    [1]=false,
    [2]=false,
  }

local slashCommands = {

  ["macro"] = {
    ["function"] = function (...) return warExtendedMacro.SetMacroData(...) end,
    ["description"] = "Create a macro on the fly. Usage: /macro text#slot.\nSlot is optional, first empty slot will be used if nil"
  },
  ["macroset"] = {
    ["function"] = function (...) return warExtendedMacro.LoadMacroSet(...) end,
    ["description"] = "Load a macro set. Usage: /macroset 1 or 2"
  }

}

local function initializeMacroComboBox()
  ComboBoxAddMenuItem(macroBox, L"Set 1")
  ComboBoxAddMenuItem(macroBox, L"Set 2")
  ComboBoxSetSelectedMenuItem( macroBox, 	warExtendedMacro.Settings.selectedMacroSet)
  warExtendedMacro.OnMacroComboBoxSelect(warExtendedMacro.Settings.selectedMacroSet)
  displayMacroSetLoadMessage=true;
end


local function createMacroSets()
  warExtendedMacro.Settings.Sets[1] = DataUtils.GetMacros()
  warExtendedMacro.Settings.Sets[2]= DataUtils.CopyTable(warExtendedMacro.Settings.Sets[1])
  warExtendedMacro.Settings.isMacroSetCreated  = true;
end

local function getCurrentMacroSetNumber()
  return ComboBoxGetSelectedMenuItem(macroBox)
end

local function getCurrentMacroSetText()
  return ComboBoxGetSelectedText(macroBox)
end


local function setNewMacroSet(macroSet)

  for Set,_ in pairs(selectedSet) do
    if macroSet == Set then
      selectedSet[Set] = true;
      warExtendedMacro.Settings.selectedMacroSet = macroSet
    else
      selectedSet[Set] = false;
    end
  end

  for macroSlot,macroData in pairs(warExtendedMacro.Settings.Sets[macroSet]) do
    SetMacroData( macroData.name, macroData.text, macroData.iconNum, macroSlot)
  end

  local currentMacroSet = getCurrentMacroSetText()
  LabelSetText(macroWindowTitlebar, L"Macro "..currentMacroSet)

end


local function saveCurrentMacroSet()
  local currentMacros = DataUtils.GetMacros()

  for Set,_ in pairs (selectedSet) do
    if selectedSet[Set] then
      warExtendedMacro.Settings.Sets[Set] = currentMacros
    end
  end

end

local function loadMacroSet(macroSet)
  local macroSet=tonumber(macroSet)
  ComboBoxSetSelectedMenuItem(macroBox, macroSet)
  warExtendedMacro.OnMacroComboBoxSelect(macroSet)
end


local function getMacroData(macroSlot, dataType)
  local currentMacros = DataUtils.GetMacros()
      if currentMacros[macroSlot][dataType] == (0) or currentMacros[macroSlot][dataType] == L"" then
        return nil
      else
        return currentMacros[macroSlot][dataType]
    end
end


local function getRandomMacroIcon()
  return math.random(20404,20470)
end

local function getRandomMacroName(macroSlot)
  return towstring("Macro "..macroSlot)
end

local function getMacroName(macroSlot)
  return getMacroData(macroSlot, "name")
end

local function getMacroIcon(macroSlot)
  return getMacroData(macroSlot, "iconNum")
end

local function getMacroText(macroSlot)
  return getMacroData(macroSlot, "text")
end

local function getFirstEmptyMacroSlot()
  local currentMacros = DataUtils.GetMacros()
  --TODO: Search all macro sets and try to register on another set.
  local currentMacroSet = getCurrentMacroSetNumber()

  for macroSlot=1,#currentMacros do
    if getMacroText(macroSlot) == nil then
       return macroSlot
    end
  end
end

function RegisterMacro(macroAction, macroName, macroSlot, macroIcon)
  macroSlot = macroSlot or getFirstEmptyMacroSlot()

  if macroSlot == nil then
    return warExtended.ModuleChatPrint("Macro","No empty macro slots in the current set - macro not set.")
  end

  macroIcon = macroIcon or getMacroIcon(macroSlot) or getRandomMacroIcon()
  macroName = macroName or getMacroName(macroSlot) or getRandomMacroName(macroSlot)

  local texture, x, y = GetIconData( macroIcon )
  DynamicImageSetTexture( "MacroIconSelectionWindowIconSlot"..macroSlot.."IconBase", texture, x, y )
  SetMacroData( towstring(macroName), towstring(macroAction), macroIcon, macroSlot )
  DynamicImageSetTexture( "EA_Window_MacroIconSlot"..macroSlot.."IconBase", texture, x, y )

  Sound.Play( Sound.BUTTON_CLICK )

  warExtended.ModuleChatPrint("Macro", towstring("Macro ["..macroSlot.."] set to: "..macroAction))

end

local function registerWarExtendedMacros()

  warExtended.ModuleChatPrint("Macro", L"Setting up warExtended Macros.")

  RegisterMacro("/script TellTarget(\"whisper current friendly target with this text\")","warExtended Tell Target", nil, 22250);
  RegisterMacro("/script InviteLast()","warExtended Invite Last", nil, 22251);
  RegisterMacro("/script ReplyLast(\"reply to last whisper with this text\")", "warExtended Reply Last", nil, 22252);
  RegisterMacro("/script ChatMacro(\"send dynamic target info (example: $ehp $elvl $et) to a channel of choice\", \"/s\")","warExtended Chat Macro", nil, 22253);

  local currentMacros = DataUtils.GetMacros()
  warExtendedMacro.Settings.Set1 = DataUtils.CopyTable(currentMacros)

end

local function registerSelfHooks()
  warExtendedMacro.Original_EA_Window_MacroOnSave = EA_Window_Macro.OnSave
  EA_Window_Macro.OnSave         = warExtendedMacro.EA_Window_Macro_OnSave
end


function warExtendedMacro.Initialize()
  warExtended.ModuleRegister("Macro", slashCommands)

  if not warExtendedMacro.Settings.isMacroSetCreated then
    createMacroSets()
    registerWarExtendedMacros()
  end

  initializeMacroComboBox()
  registerSelfHooks()


end


function warExtendedMacro.SetMacroData(macroAction, macroSlot)

  if macroAction == "" then
    return warExtended.ModuleChatPrint("Macro", "Usage: yourMacro#macroSlot\nMacro slot is optional - first empty slot will be used if not given.")
  end
  macroSlot = tonumber(macroSlot) or nil
  RegisterMacro(macroAction, nil, macroSlot, nil)
end

function warExtendedMacro.LoadMacroSet(macroSet)

  if macroSet=="1" or macroSet=="2" then
    return loadMacroSet(macroSet)
  else
    return warExtended.ModuleChatPrint("Macro", "Usage: /macroset 1 or 2")
  end

end

function warExtendedMacro.OnMacroComboBoxSelect(macroSet)

  setNewMacroSet(macroSet)

  if not displayMacroSetLoadMessage then return end

  local macroSetText=getCurrentMacroSetText()
  warExtended.ModuleChatPrint("Macro", L"Macro "..macroSetText..L" loaded.")

end

function warExtendedMacro.EA_Window_Macro_OnSave(...)
  --[[TODO: GSUB all macro text with textFilter function to process all old QNA namemap Functions]]
    warExtendedMacro.Original_EA_Window_MacroOnSave(...)
    saveCurrentMacroSet()
end

function warExtendedMacro.Shutdown()
  warExtended.ModuleUnregister("Macro")
end
