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

warExtendedMacro.Settings={}
warExtendedMacro.Settings.isMacroSetCreated = false;
warExtendedMacro.Settings.selectedMacroSet  = 1;

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

local selectedMacroSet1 = false;
local selectedMacroSet2 = false;

local function initializeMacroComboBox()
  ComboBoxAddMenuItem(macroBox, L"Set 1")
  ComboBoxAddMenuItem(macroBox, L"Set 2")
  ComboBoxSetSelectedMenuItem( macroBox, 	warExtendedMacro.Settings.selectedMacroSet)
  warExtendedMacro.OnMacroComboBoxSelect()
end


local function createMacroSets()
  warExtendedMacro.Settings.Set1  = DataUtils.GetMacros()
  warExtendedMacro.Settings.Set2  = DataUtils.CopyTable(warExtendedMacro.Set1)
  warExtendedMacro.Settings.isMacroSetCreated  = true;
end

local function getCurrentMacroSetNumber()
  return ComboBoxGetSelectedMenuItem(macroBox)
end

local function getCurrentMacroSetText()
  return ComboBoxGetSelectedText(macroBox)
end

local function setCurrentMacroSet(macroSet)
  ComboBoxSetSelectedMenuItem(macroBox, tonumber(macroSet))
  warExtendedMacro.OnMacroComboBoxSelect()
end

local function saveCurrentMacroSet()
  local currentMacroSet = getCurrentMacroSetNumber()
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

local function RegisterMacro(macroAction, macroName, macroSlot, macroIcon)
  macroSlot = macroSlot or getFirstEmptyMacroSlot()

  if macroSlot == nil then
    return warExtended.ModuleChatPrint("Macro","No empty macro slots in the current set - macro not set.")
  end

  macroIcon = macroIcon or getMacroIcon(macroSlot) or getRandomMacroIcon()
  macroName = macroName or getMacroName(macroSlot) or getRandomMacroName(macroSlot)

  local texture, x, y = GetIconData( macroIcon )
  DynamicImageSetTexture( "MacroIconSelectionWindowIconSlot"..macroSlot.."IconBase", texture, x, y )
  SetMacroData( macroName, towstring(macroAction), macroIcon, macroSlot )
  DynamicImageSetTexture( "EA_Window_MacroIconSlot"..macroSlot.."IconBase", texture, x, y )

  Sound.Play( Sound.BUTTON_CLICK )

  warExtended.ModuleChatPrint("Macro", towstring("Macro ["..macroSlot.."] set to: "..macroAction))

end


local function registerWarExtendedMacros()

  warExtended.ModuleChatPrint("Macro", L"Setting up warExtended Macros.")

  RegisterMacro(L"/script TellTarget(\"whisper current friendly target with this text\")",L"warExtended Tell Target", nil, 22250);
  RegisterMacro(L"/script InviteLast()",L"warExtended Invite Last", nil, 22251);
  RegisterMacro(L"/script ReplyLast(\"reply to last whisper with this text\")", L"warExtended Reply Last", nil, 22252);
  RegisterMacro(L"/script ChatMacro(\"send dynamic target info (example: $ehp $elvl $et) to a channel of choice\", \"/s\")",L"warExtended Chat Macro", nil, 22253);

  local currentMacros = DataUtils.GetMacros()
  warExtendedMacro.Settings.Set1 = DataUtils.CopyTable(currentMacros)

end


local function registerSelfHooks()
  --Original_EA_Window_MacroOnSave = EA_Window_Macro.OnSave
  --EA_Window_Macro.OnSave         = warExtendedMacro.EA_Window_Macro_OnSave
end

function warExtendedMacro.Initialize()

  warExtended.ModuleRegister("Macro", slashCommands)

  registerSelfHooks()
  initializeMacroComboBox()

  if warExtendedMacro.Settings.isMacroSetCreated then return end
  createMacroSets()
  registerWarExtendedMacros()

end

function warExtendedMacro.EA_Window_Macro_OnSave()
  p("hooked")
end

function warExtendedMacro.SetMacroData(macroAction, macroSlot)
  p(macroAction)
  p("----")
  p(macroSlot)
  --local argSplit = StringSplit(tostring(macroAction), "#")
--  p(argSplit)
  macroSlot = macroSlot or nil
end

function warExtendedMacro.LoadMacroSet(macroSet)
  if macroSet=="1" or macroSet=="2" then
    return setCurrentMacroSet(macroSet)
  else
    return warExtended.ModuleChatPrint("Macro", "Usage: /macroset 1 or 2")
  end
  end

  --[[local regex = wstring.match(towstring(input), L"\^\%s")
  local qnaSplit = StringSplit(tostring(input), "#")
  local qnaSplitter = wstring.match(towstring(input), L"#")
  local input = towstring(qnaSplit[1])
  local macroNumber = towstring(qnaSplit[2])
  local macros = DataUtils.GetMacros ()

  if not input or input == L"" then EA_ChatWindow.Print(link..L"Usage: /qnamacro text#macroNumber)") return end
  if not qnaSplit[2] or qnaSplit[2] == L"" or qnaSplit[2] == nil then EA_ChatWindow.Print(link..L"Usage: /qnamacro text#macroNumber)") return end
  if qnaSplitter and (qnaSplit[2] == nil or qnaSplit[2] == L"") then EA_ChatWindow.Print(link..L"Usage: /qnamacro text#macroNumber)") return end
  if qnaSplit and (qnaSplit[2] == nil or qnaSplit[2] == L"") then EA_ChatWindow.Print(link..L"Usage: /qnamacro text#macroNumber)") return end


  for k, v in pairs(macros) do
    if wstring.match(towstring(k), macroNumber) then
    end
  end

  for k, v in pairs(QuickNameActionsRessurected.NameMap) do
    input = wstring.gsub((input), towstring(k), towstring(v()))
  end

  SetMacroData( TextEditBoxGetText( "EA_Window_MacroDetailsName" ), input, macros[tonumber(macroNumber)].iconNum, tonumber(macroNumber))

  local texture, x, y = GetIconData( macros[tonumber(macroNumber)].iconNum )
  DynamicImageSetTexture( "EA_Window_MacroIconSlot"..tonumber(macroNumber).."IconBase", texture, x, y )

  Sound.Play( Sound.BUTTON_CLICK )

  EA_ChatWindow.Print(link..L"Macro ["..macroNumber..L"] set to: "..input)
end]]







function warExtendedMacro.Shutdown()
  warExtended.ModuleUnregister("Macro")
end




--[[function QuickNameActionsRessurected.LoadSet(input)
if input=="1" then
  ComboBoxSetSelectedMenuItem("SetBox", 1)
  QuickNameActionsRessurected.OnSelSet()
  return
elseif input=="2" then
  ComboBoxSetSelectedMenuItem("SetBox", 2)
  QuickNameActionsRessurected.OnSelSet()
  return
else
  EA_ChatWindow.Print(towstring(link)..L"Usage: /qnaload 1 or /qnaload 2")
end
end]]

--[[function QuickNameActionsRessurected.OnSelSet()
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

function QuickNameActionsRessurected.MacroSetter(input, macroNumber)
  local regex = wstring.match(towstring(input), L"\^\%s")
  local qnaSplit = StringSplit(tostring(input), "#")
  local qnaSplitter = wstring.match(towstring(input), L"#")
  local input = towstring(qnaSplit[1])
  local macroNumber = towstring(qnaSplit[2])
  local macros = DataUtils.GetMacros ()

  if not input or input == L"" then EA_ChatWindow.Print(link..L"Usage: /qnamacro text#macroNumber)") return end
  if not qnaSplit[2] or qnaSplit[2] == L"" or qnaSplit[2] == nil then EA_ChatWindow.Print(link..L"Usage: /qnamacro text#macroNumber)") return end
  if qnaSplitter and (qnaSplit[2] == nil or qnaSplit[2] == L"") then EA_ChatWindow.Print(link..L"Usage: /qnamacro text#macroNumber)") return end
  if qnaSplit and (qnaSplit[2] == nil or qnaSplit[2] == L"") then EA_ChatWindow.Print(link..L"Usage: /qnamacro text#macroNumber)") return end


  for k, v in pairs(macros) do
    if wstring.match(towstring(k), macroNumber) then
    end
  end

  for k, v in pairs(QuickNameActionsRessurected.NameMap) do
    input = wstring.gsub((input), towstring(k), towstring(v()))
  end

  SetMacroData( TextEditBoxGetText( "EA_Window_MacroDetailsName" ), input, macros[tonumber(macroNumber)].iconNum, tonumber(macroNumber))

  local texture, x, y = GetIconData( macros[tonumber(macroNumber)].iconNum )
  DynamicImageSetTexture( "EA_Window_MacroIconSlot"..tonumber(macroNumber).."IconBase", texture, x, y )

  Sound.Play( Sound.BUTTON_CLICK )

  EA_ChatWindow.Print(link..L"Macro ["..macroNumber..L"] set to: "..input)
end]]

function warExtendedMacro.OnMacroComboBoxSelect()
  p(getCurrentMacroSetNumber())
  p(getCurrentMacroSetText())
 end

 -- if currentMacroSetNumber==1 then
   -- if set2 then set2=false end
   -- set1=true;
   --[[ for k,v in pairs(warExtended.Settings.MacroSet1) do
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
    end]]
   -- EA_ChatWindow.Print(link..L"Macro "..(currentMacroSetText)..L" loaded.")
   -- LabelSetText("EA_Window_MacroTitleBarText", L"Macro Set 2")
      --QuickNameActionsRessurected.Settings.SelectedSet=selectedName
  --end
--end
