warExtendedMacro = {}

local warExtended = warExtended
local EA_Window_Macro = EA_Window_Macro
local DataUtils = DataUtils
local ComboBoxGetSelectedMenuItem = ComboBoxGetSelectedMenuItem
local ComboBoxSetSelectedMenuItem = ComboBoxSetSelectedMenuItem
local ComboBoxGetSelectedText     = ComboBoxGetSelectedText
local ComboBoxAddMenuItem = ComboBoxAddMenuItem
local DynamicImageSetTexture  = DynamicImageSetTexture
local SetMacroData  = SetMacroData
local GetIconData = GetIconData
local macroBox = "MacroSetComboBox"
local firstLoad = false;

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
  warExtendedMacro.OnMacroComboBoxSelect()
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

--  local currentMacro=DataUtils.GetMacros()
  for Set,_ in pairs(selectedSet) do
    if macroSet == Set then
      selectedSet[Set] = true;
      warExtendedMacro.Settings.selectedMacroSet = macroSet
    else
      -- split into separate functrion to saveCurrentMacro
      selectedSet[Set] = false;
    --  p("saving old macro to  "..Set)
     -- warExtendedMacro.Settings.Sets[Set] = currentMacro
    end
  end
end

local function getNewMacros(macroSet)
  local setNumber=macroSet
  p("gettingNewMacros  "..setNumber)

  for macroSlot,macroData in pairs(warExtendedMacro.Settings.Sets[setNumber]) do
    SetMacroData( macroData.name, macroData.text, macroData.iconNum, macroSlot)
  end
end


local function saveCurrentMacroSet()
  local macroSet = getCurrentMacroSetNumber()
  local currentSet = DataUtils.GetMacros()
  for Set,_ in pairs (selectedSet) do
    if selectedSet[Set] then
      warExtendedMacro.Settings.Sets[Set] = currentSet
      p("saving current macro to  "..Set)
    end
  end
  local setNumber=macroSet or getCurrentMacroSetNumber()
  --warExtendedMacro.Settings.Sets[setNumber] = currentSet
end

local function loadMacroSet(macroSet)
  local macroSet=tonumber(macroSet)
  ComboBoxSetSelectedMenuItem(macroBox, macroSet)
  p("lkoading macro set "..macroSet)
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

local function getRandomMacroName(macroSlot)
  return towstring("Macro "..macroSlot)
end

local function getRandomMacroIcon()
  return math.random(20404,20470)
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
  firstLoad=true;

  warExtended.ModuleRegister("Macro", slashCommands)

  registerSelfHooks()
  initializeMacroComboBox()

  if warExtendedMacro.Settings.isMacroSetCreated then return end
  createMacroSets()
  registerWarExtendedMacros()

end

--[[TODO:  for k, v in pairs(QuickNameActionsRessurected.NameMap) do
    input = wstring.gsub((input), towstring(k), towstring(v()))
  end]]


function warExtendedMacro.EA_Window_Macro_OnSave(...)
   warExtendedMacro.Original_EA_Window_MacroOnSave(...)
  local currentSet = getCurrentMacroSetNumber()
  saveCurrentMacroSet()
    --[[local macros=DataUtils.GetMacros()
    local tabler1=copyTable(macros,QuickNameActionsRessurected.Settings.MacroSet1)
    local tabler2=copyTable(macros,QuickNameActionsRessurected.Settings.MacroSet2)

    local macroText = TextEditBoxGetText( "EA_Window_MacroDetailsText" )
    for k, v in pairs(QuickNameActionsRessurected.NameMap) do
      macroText = wstring.gsub((macroText), towstring(k), towstring(v()))
    end

    SetMacroData( TextEditBoxGetText( "EA_Window_MacroDetailsName" ), macroText, EA_Window_Macro.iconNum, EA_Window_Macro.activeId )

    local texture, x, y = GetIconData( EA_Window_Macro.iconNum )
    DynamicImageSetTexture( "EA_Window_MacroIconSlot"..EA_Window_Macro.activeId.."IconBase", texture, x, y )

    Sound.Play( Sound.BUTTON_CLICK )

    if set1 then
      local macros=DataUtils.GetMacros()
      copyTable(macros,QuickNameActionsRessurected.Settings.MacroSet1)
    elseif set2 then
      local macros=DataUtils.GetMacros()
      copyTable(macros,QuickNameActionsRessurected.Settings.MacroSet2)
    end

    end]]
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
   macroSet=macroSet or getCurrentMacroSetNumber()
  local macroSetText=getCurrentMacroSetText()
  local currentSet=DataUtils.GetMacros()

  saveCurrentMacroSet()
  setNewMacroSet(macroSet)
  getNewMacros(macroSet)

  --p(warExtendedMacro.Settings.selectedMacroSet)
  --[[local selectedName=ComboBoxGetSelectedMenuItem("SetBox")
  local selectedText=ComboBoxGetSelectedText("SetBox")
  if selectedName==1 then
    if set2 then set2=false end
    set1=true;
    for k,v in pairs(QuickNameActionsRessurected.Settings.MacroSet1) do
      SetMacroData( v.name, v.text, v.iconNum, k)

    end
    EA_ChatWindow.Print(link..L"Macro "..(selectedText)..L" loaded.")
    LabelSetText("EA_Window_MacroTitleBarText", L"Macro Set 1")
    QuickNameActionsRessurected.Settings.SelectedSet=selectedName
  elseif selectedName==2 then
    if set1 then set1=false; end
    set2=true;
    for b,f in pairs(QuickNameActionsRessurected.Settings.MacroSet2) do
      SetMacroData( f.name, f.text, f.iconNum, b)
    end
    EA_ChatWindow.Print(link..L"Macro "..(selectedText)..L" loaded.")
    LabelSetText("EA_Window_MacroTitleBarText", L"Macro Set 2")
      QuickNameActionsRessurected.Settings.SelectedSet=selectedName
  end]]

  if not firstLoad then return end
end


function warExtendedMacro.Shutdown()
  warExtended.ModuleUnregister("Macro")
end
 --[[if currentMacroSetNumber==1 then
   -- if set2 then set2=false end
   -- set1=true;
   for k,v in pairs(warExtended.Settings.MacroSet1) do
      SetMacroData( v.name, v.text, v.iconNum, k)
    end

    EA_ChatWindow.Print(link..L"Macro "..(currentMacroSetText)..L" loaded.")
    LabelSetText("EA_Window_MacroTitleBarText", L"Macro Set 1")
    warExtended.Settings.SelectedSet=selectedName
  elseif currentMacroSetNumber==2 then
    if set1 then set1=false; end
    set2=true;
    for b,f in pairs(QuickNameActionsRessurected.Settings.MacroSet2) do
      SetMacroData( f.name, f.text, f.iconNum, b)
    end
   -- EA_ChatWindow.Print(link..L"Macro "..(currentMacroSetText)..L" loaded.")
   -- LabelSetText("EA_Window_MacroTitleBarText", L"Macro Set 2")
      --QuickNameActionsRessurected.Settings.SelectedSet=selectedName
  --end
--


function QuickNameActionsRessurected.OnSelSet()
local selectedName=ComboBoxGetSelectedMenuItem("SetBox")
  local selectedText=ComboBoxGetSelectedText("SetBox")
  if selectedName==1 then
    if set2 then set2=false end
    set1=true;
    for k,v in pairs(QuickNameActionsRessurected.Settings.MacroSet1) do
      SetMacroData( v.name, v.text, v.iconNum, k)

    end
    EA_ChatWindow.Print(link..L"Macro "..(selectedText)..L" loaded.")
    LabelSetText("EA_Window_MacroTitleBarText", L"Macro Set 1")
    QuickNameActionsRessurected.Settings.SelectedSet=selectedName
  elseif selectedName==2 then
    if set1 then set1=false; end
    set2=true;
    for b,f in pairs(QuickNameActionsRessurected.Settings.MacroSet2) do
      SetMacroData( f.name, f.text, f.iconNum, b)
    end
    EA_ChatWindow.Print(link..L"Macro "..(selectedText)..L" loaded.")
    LabelSetText("EA_Window_MacroTitleBarText", L"Macro Set 2")
      QuickNameActionsRessurected.Settings.SelectedSet=selectedName
  end
end



function QuickNameActionsRessurected.newEA_Window_MacroOnSave()
--local macros=DataUtils.GetMacros()
local tabler1=copyTable(macros,QuickNameActionsRessurected.Settings.MacroSet1)
local tabler2=copyTable(macros,QuickNameActionsRessurected.Settings.MacroSet2)

local macroText = TextEditBoxGetText( "EA_Window_MacroDetailsText" )
for k, v in pairs(QuickNameActionsRessurected.NameMap) do
  macroText = wstring.gsub((macroText), towstring(k), towstring(v()))
end

SetMacroData( TextEditBoxGetText( "EA_Window_MacroDetailsName" ), macroText, EA_Window_Macro.iconNum, EA_Window_Macro.activeId )

local texture, x, y = GetIconData( EA_Window_Macro.iconNum )
DynamicImageSetTexture( "EA_Window_MacroIconSlot"..EA_Window_Macro.activeId.."IconBase", texture, x, y )

Sound.Play( Sound.BUTTON_CLICK )

if set1 then
  local macros=DataUtils.GetMacros()
  copyTable(macros,QuickNameActionsRessurected.Settings.MacroSet1)
elseif set2 then
  local macros=DataUtils.GetMacros()
  copyTable(macros,QuickNameActionsRessurected.Settings.MacroSet2)
end

end
]]
