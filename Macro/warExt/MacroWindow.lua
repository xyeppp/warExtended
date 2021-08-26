warExtendedMacro = warExtended.Register("warExtended Macro Window")
local Macro = warExtendedMacro

  --TODO:  getFirstEmptyMacroSlot() Search all macro sets and try to register on another set.
  --       Add an extra clickable macro window somewhere for more slots

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

Macro.Settings={}
Macro.Settings.isMacroSetCreated = false;
Macro.Settings.selectedMacroSet  = 1;
Macro.Settings.Sets = {}

local slashCommands = {

  ["macro"] = {
    ["func"] = function (...) Macro:SetMacroData(...) end,
    ["desc"] = "Create a macro on the fly. Usage: /macro text#slot.\nSlot is optional, first empty slot will be used if nil"
  },
  ["macroset"] = {
    ["func"] = function (...) Macro:LoadMacroSet(...) end,
    ["desc"] = "Load a macro set. Usage: /macroset 1 or 2"
  }

}

local function initializeMacroComboBox()

  ComboBoxAddMenuItem(macroBox, L"Set 1")
  ComboBoxAddMenuItem(macroBox, L"Set 2")
  ComboBoxSetSelectedMenuItem( macroBox, 	warExtendedMacro.Settings.selectedMacroSet)

  warExtendedMacro.OnMacroComboBoxSelect()

  displayMacroSetLoadMessage=true;

end


local function createMacroSets()
  warExtendedMacro.Settings.Sets[1] = DataUtils.GetMacros()
  warExtendedMacro.Settings.Sets[2] = DataUtils.CopyTable(warExtendedMacro.Settings.Sets[1])
  warExtendedMacro.Settings.isMacroSetCreated  = true;
end

local function getCurrentMacroSetNumber()
  local currentMacroNumber = ComboBoxGetSelectedMenuItem(macroBox)
  return currentMacroNumber
end

local function getCurrentMacroSetText()
  local currentMacroText = L"Macro "..ComboBoxGetSelectedText(macroBox)
  return currentMacroText
end

local function getNewMacrosFromSet()
  local macroSet = getCurrentMacroSetNumber()
  local newMacros = warExtendedMacro.Settings.Sets[macroSet]

  for _=1,#newMacros do local macroData=newMacros[_]
    SetMacroData( macroData.name, macroData.text, macroData.iconNum, _)
  end

end


local function setMacroWindowTitlebar()
  local macroSetText = getCurrentMacroSetText()
  LabelSetText(macroWindowTitlebar, macroSetText)
end

local function saveMacroToCurrentSet()
end


function Macro.OnSave()
  p("saving")
  local currentSet = warExtendedMacro.Settings.selectedMacroSet
  local newMacroText = TextEditBoxGetText( "EA_Window_MacroDetailsText" )
  local newMacroName = TextEditBoxGetText( "EA_Window_MacroDetailsName" )

  local newMacroTable = {
    iconNum = EA_Window_Macro.iconNum,
    text = newMacroText,
    name = newMacroName
  }

  local currentMacro = EA_Window_Macro.activeId


 -- SetMacroData( TextEditBoxGetText( "EA_Window_MacroDetailsName" ), macroText, EA_Window_Macro.iconNum, EA_Window_Macro.activeId )

  warExtendedMacro.Settings.Sets[currentSet][currentMacro] = newMacroTable
end

local function loadMacroSet(macroSet)
  macroSet=tonumber(macroSet)
  ComboBoxSetSelectedMenuItem(macroBox, macroSet)

  warExtendedMacro.OnMacroComboBoxSelect()
end


local function getMacroDataFromSlot(macroSlot, dataType)
  local currentMacros = DataUtils.GetMacros()
      if currentMacros[macroSlot][dataType] == (0) or currentMacros[macroSlot][dataType] == L"" then
        return nil
      else
        return currentMacros[macroSlot][dataType]
    end
end


local function getRandomMacroIcon()
  local randomIconNumber = math.random(20404,20470)
  return randomIconNumber
end

local function getGenericMacroName(macroSlot)
  local randomName = towstring("Macro "..macroSlot)
  return randomName
end

local function getMacroName(macroSlot)
  local macroName = getMacroDataFromSlot(macroSlot, "name")
  return macroName
end

local function getMacroIcon(macroSlot)
  local macroIcon = getMacroDataFromSlot(macroSlot, "iconNum")
  return macroIcon
end

local function getMacroText(macroSlot)
  local macroText = getMacroDataFromSlot(macroSlot, "text")
  return macroText
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
     Macro:Print("No empty macro slots in the current set - macro not set.")
    return
  end

  macroIcon = macroIcon or getMacroIcon(macroSlot) or getRandomMacroIcon()
  macroName = macroName or getMacroName(macroSlot) or getGenericMacroName(macroSlot)

  local texture, x, y = GetIconData( macroIcon )
  DynamicImageSetTexture( "MacroIconSelectionWindowIconSlot"..macroSlot.."IconBase", texture, x, y )
  SetMacroData( towstring(macroName), towstring(macroAction), macroIcon, macroSlot )
  DynamicImageSetTexture( "EA_Window_MacroIconSlot"..macroSlot.."IconBase", texture, x, y )

  Sound.Play( Sound.BUTTON_CLICK )


  Macro:Print(towstring("Macro ["..macroSlot.."] set to: "..macroAction))

end

local function registerWarExtendedMacros()

  Macro:Print("Setting up warExtended Macros.")

  RegisterMacro("/script TellTarget(\"whisper current friendly target with this text\")","warExtended Tell Target", nil, 22250);
  RegisterMacro("/script InviteLast()","warExtended Invite Last", nil, 22251);
  RegisterMacro("/script ReplyLast(\"reply to last whisper with this text\")", "warExtended Reply Last", nil, 22252);
  RegisterMacro("/script ChatMacro(\"send dynamic target info (example: $ehp $elvl $et) to a channel of choice\", \"/s\")","warExtended Chat Macro", nil, 22253);

end

local function registerSelfHook()
     Macro:Hook(EA_Window_Macro.OnSave, Macro.OnSave)
end


function warExtendedMacro.Initialize()

 if not warExtendedMacro.Settings.isMacroSetCreated then
    createMacroSets()
    registerWarExtendedMacros()
  end

  Macro:RegisterSlash(slashCommands, "warextmacro")

  initializeMacroComboBox()
  registerSelfHook()

end


function Macro:SetMacroData(macroAction, macroSlot)

  if macroAction == "" then
     Macro:Print("Usage: yourMacro#macroSlot\nMacro slot is optional - first empty slot will be used if not given.")
    return
  end
  macroSlot = tonumber(macroSlot) or nil
  RegisterMacro(macroAction, nil, macroSlot, nil)
end

function warExtendedMacro:LoadMacroSet(macroSet)
  local currentSet = getCurrentMacroSetNumber()
  local currentSetText = tostring(getCurrentMacroSetText())

  if (macroSet=="1" or macroSet=="2") and (currentSet ~= tonumber(macroSet)) then
     loadMacroSet(macroSet)
    return
  elseif currentSet == tonumber(macroSet) then
    Macro:Print(currentSetText.." is already loaded.")
    return
  end

  Macro:Print("Usage: /macroset 1 or 2")
end


function warExtendedMacro.OnMacroComboBoxSelect()

  warExtendedMacro.Settings.selectedMacroSet = getCurrentMacroSetNumber()

  getNewMacrosFromSet()
  setMacroWindowTitlebar()

  if not displayMacroSetLoadMessage then return end

  local macroSetText=getCurrentMacroSetText()
  --warExtended.ModuleChatPrint("Macro", L"Macro "..macroSetText..L" loaded.")

end


function warExtendedMacro.Shutdown()
  --warExtended.ModuleUnregister("Macro")
end
