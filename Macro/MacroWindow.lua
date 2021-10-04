warExtendedMacro = warExtended.Register("warExtended Macro Window")
local Macro = warExtendedMacro


--[[function Enemy.GetMacroId (text)
--	local macros = DataUtils.GetMacros ()
--
--	for slot = 1, EA_Window_Macro.NUM_MACROS
--	do
--		if macros[slot].text == text
--		then
--			return slot
--		end
--	end
--
--	return nil
--end
--
--
--function Enemy.SetMacro (slot, name, text, iconId)
--	SetMacroData (name, text, iconId, slot)
--	EA_Window_Macro.UpdateDetails (slot)
--end
--
--
--function Enemy.CreateMacro (name, text, iconId)
--
--	local slot = Enemy.GetMacroId (text)
--	if (slot) then return slot end
--
--	local macros = DataUtils.GetMacros ()
--	for slot = 1, EA_Window_Macro.NUM_MACROS
--	do
--		if (macros[slot].text == L"")
--		then
--			Enemy.SetMacro (slot, name, text, iconId)
--			return slot
--		end
--	end
--
--	return nil
--end
--
--
--function Enemy.GetMacro (slot)
--	if (slot == nil) then return nil end
--
--	return DataUtils.GetMacros() [slot]
--end]]
--EA_Window_Macro.UpdateDetails(slot)



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

local MACRO_COMBOBOX = "MacroSetComboBox"
local MACRO_WINDOW_TITLEBAR = "EA_Window_MacroTitleBarText"


Macro.Sets = {}

Macro.Settings = {
  isMacroSetCreated = false,
  selectedMacroSet = 1,
}

local slashCommands = {

  macro = {
    func = function (...) Macro.SetMacroData(...) end,
    desc = "Create a macro on the fly. Usage: /macro text#slot.\nSlot is optional, first empty slot will be used if nil"
  },
  macroset = {
    func = function (...) Macro.LoadMacroSet(...) end,
    desc = "Load a macro set. Usage: /macroset 1 or 2"
  }

}


local function createNewMacroSet()
  local newMacroSet = {}

  for macroNumber=1,48 do
    newMacroSet[macroNumber] =  {
      iconNum = 0,
      text = L"",
      name = L""
    }
  end
  return newMacroSet
end

local function copyExistingMacroSet(macroSet)
  local newMacroSet = {}
  newMacroSet = Macro.Sets[macroSet]
  return newMacroSet
end


local function createInitialMacroSets()
  Macro.Sets[1] = DataUtils.GetMacros()
  Macro.Sets[2] = createNewMacroSet()
  Macro.Settings.isMacroSetCreated  = true;
end

local function getCurrentMacroSetNumber()
  local currentMacroNumber = ComboBoxGetSelectedMenuItem(MACRO_COMBOBOX)
  return currentMacroNumber
end

local function getCurrentMacroSetText()
  local currentMacroText = L"Macro "..ComboBoxGetSelectedText(MACRO_COMBOBOX)
  return currentMacroText
end



local function getNewMacrosFromSet(macroSet)
  local newMacros = Macro.Sets[macroSet]

  for  Slot=1,48 do local macroData=newMacros[Slot]
    SetMacroData( macroData.name, macroData.text, macroData.iconNum, Slot)
  end
end

local function doesMacroSetExist(macroSet)
local isSetCreated = Macro.Sets[macroSet]
if not isSetCreated then
    Macro:Warn("Invalid macro set.")
end
  return isSetCreated
end


local function saveMacroToSet(macroAction, macroName, macroSlot, macroIcon, macroSet)

  macroSet = macroSet or Macro.Settings.selectedMacroSet

 if not doesMacroSetExist(macroSet) then
  return
 end

  macroIcon = macroIcon or EA_Window_Macro.iconNum
  macroAction = macroAction or TextEditBoxGetText( "EA_Window_MacroDetailsText" )
  macroName = macroName or  TextEditBoxGetText( "EA_Window_MacroDetailsName" )
  macroSlot = macroSlot or EA_Window_Macro.activeId

  local newMacroData = {
    iconNum = macroIcon,
    text = macroAction,
    name = macroName
  }

  Macro.Sets[macroSet][macroSlot] = newMacroData

  Macro:Print(L"Macro [Set "..macroSet..L"]["..macroSlot..L"] set to: "..macroAction)
end


local function saveMacroToCurrentSet()
  saveMacroToSet()
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



local function getFirstEmptyMacroSlotAndSet()
  for macroSet=1,#Macro.Sets do local Macros = Macro.Sets[macroSet]
    for macroSlot=1,48 do local macroData = Macros[macroSlot]
      if macroData.text == L"" then
        return macroSlot, macroSet
      end
    end
  end
end

local function isSetLoaded(macroSet)
  local currentSet = getCurrentMacroSetNumber()
  return currentSet == tonumber(macroSet)
end


function RegisterMacro(macroAction, macroName, macroSlot, macroIcon, macroSet)
  if (not macroSlot and not macroSet) then
    macroSlot, macroSet = getFirstEmptyMacroSlotAndSet()
  elseif not macroSet then
    macroSet = getCurrentMacroSetNumber()
  end

  if macroSlot == nil then
     Macro:Warn("No empty macro slots - macro not set.")
    return
  end

  macroIcon = macroIcon or getMacroIcon(macroSlot) or getRandomMacroIcon()
  macroName = towstring(macroName or getMacroName(macroSlot) or getGenericMacroName(macroSlot))
  macroAction = towstring(macroAction)

  if isSetLoaded(macroSet) then
    local texture, x, y = GetIconData( macroIcon )
    DynamicImageSetTexture( "MacroIconSelectionWindowIconSlot"..macroSlot.."IconBase", texture, x, y )
    SetMacroData( macroName, macroAction, macroIcon, macroSlot )
    DynamicImageSetTexture( "EA_Window_MacroIconSlot"..macroSlot.."IconBase", texture, x, y )
  end

  saveMacroToSet(macroAction, macroName, macroSlot, macroIcon, macroSet)

  Sound.Play( Sound.BUTTON_CLICK )
end

local function registerWarExtendedMacros()

  Macro:Print("Setting up warExtended Macros.")

  RegisterMacro("/script TellTarget(\"whisper current friendly target with this text\")","warExtended Tell Target", nil, 22250,2);
  RegisterMacro("/script InviteLast()","warExtended Invite Last", nil, 22251,2);
  RegisterMacro("/script ReplyLast(\"reply to last whisper with this text\")", "warExtended Reply Last", nil, 22252,2);
  RegisterMacro("/script ChatMacro(\"send dynamic target info (example: $ehp $elvl $et) to a channel of choice\", \"/s\")","warExtended Chat Macro", nil, 22253,2);

end

local function initializeMacroComboBox()

  for macroSetNumber,_ in pairs(Macro.Sets) do
    local macroSetText = towstring("Set "..macroSetNumber)
    ComboBoxAddMenuItem(MACRO_COMBOBOX, macroSetText)
  end

  ComboBoxSetSelectedMenuItem( MACRO_COMBOBOX, Macro.Settings.selectedMacroSet)
  Macro.OnMacroComboBoxSelect()
end


function Macro.Initialize()

  if not Macro.Settings.isMacroSetCreated then
    createInitialMacroSets()
    registerWarExtendedMacros()
  end

  initializeMacroComboBox()

  Macro:RegisterSlash(slashCommands, "warextmacro")
  Macro:Hook(EA_Window_Macro.OnSave, saveMacroToCurrentSet, true)
end


function Macro.SetMacroData(macroAction, macroSlot, macroSet)
  macroSet = tonumber(macroSet) or nil
  macroSlot = tonumber(macroSlot) or nil

    if macroAction == "" then
      Macro:Print("Usage: yourMacro#macroSlot\nMacro slot is optional - first empty slot will be used if not given.")
      return
    end

    RegisterMacro(macroAction, nil, macroSlot, nil, macroSet)
  end





local function loadMacroSet(macroSet)
  macroSet=tonumber(macroSet)
  ComboBoxSetSelectedMenuItem(MACRO_COMBOBOX, macroSet)
  Macro.OnMacroComboBoxSelect()
end


function Macro.LoadMacroSet(macroSet)
  local currentSetText = tostring(getCurrentMacroSetText())

  if not doesMacroSetExist(tonumber(macroSet)) then
    return
  end

  if not isSetLoaded(macroSet) then
    loadMacroSet(macroSet)
    return
  else
    Macro:Print(currentSetText.." is already loaded.")
    return
  end

end



local function setMacroWindowTitlebar()
  local macroSetText = getCurrentMacroSetText()
  LabelSetText(MACRO_WINDOW_TITLEBAR, macroSetText)
end



function Macro.OnMacroComboBoxSelect()
  local selectedMacroSet = getCurrentMacroSetNumber()
  Macro.Settings.selectedMacroSet = selectedMacroSet

  getNewMacrosFromSet(selectedMacroSet)
  setMacroWindowTitlebar()

end


function Macro.Shutdown()
  --warExtended.ModuleUnregister("Macro")
end
------------------------------------- test function

local testtext = {}

function SendMacro(text, ...)
  local test = DataUtils.GetMacros()
  testtext[#testtext+1] = (text)
  local macroNumbers = {...}
  for k,v in pairs(macroNumbers) do
    testtext[#testtext+1] = tostring(test[v].text)
    p(v)
  end
  p(testtext)
  local finalText = table.concat(testtext, " ")
  SendChatText(towstring(finalText), L"")
  p(testtext)
  testtext={}



end
