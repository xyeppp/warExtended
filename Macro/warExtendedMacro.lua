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

warExtended.Macro={}
warExtended.Macro.isMacroSetCreated = false;
warExtended.Macro.selectedMacroSet  = 1;
local slashCommands = {

  ["macro"] = {
    ["function"] = function() p("Making new macro.") end,
    ["description"] = L"Create a macro on the fly. Usage: /macro text#slot.\nSlot is optional, first empty slot will be used if nil"
  },
  ["macroset"] = {
    ["function"] = function() p("Setting macro set.") end,
    ["description"] = L"Load a macro set. Usage: /macroset 1 or 2"
  }

}

local selectedMacroSet1 = false;
local selectedMacroSet2 = false;

local function initializeMacroComboBox()
  ComboBoxAddMenuItem("MacroSetComboBox", L"Set 1")
  ComboBoxAddMenuItem("MacroSetComboBox", L"Set 2")
  ComboBoxSetSelectedMenuItem( "MacroSetComboBox", 	warExtended.Macro.selectedMacroSet)
  warExtended.OnMacroComboBoxSelect()
end

local function createMacroSets()
  warExtended.Macro.Set1  = DataUtils.GetMacros()
  warExtended.Macro.Set2  = DataUtils.CopyTable(warExtended.Macro.Set1)
  warExtended.Macro.isMacroSetCreated  = true;
end

local function getCurrentMacroSetNumber()
  return ComboBoxGetSelectedMenuItem("MacroSetComboBox")
end

local function getCurrentMacroSetText()
  return ComboBoxGetSelectedText("MacroSetComboBox")
end

local function getFirstEmptyMacroSlot()
    local currentMacros = DataUtils.GetMacros()
    for macroSlot,macroData in pairs(currentMacros) do
      if macroData.text == L"" then
        return macroSlot or nil
      end
    end
end

local function registerSelfHooks()
  Original_EA_Window_MacroOnSave = EA_Window_Macro.OnSave
  EA_Window_Macro.OnSave         = warExtended.EA_Window_Macro_OnSave
end

function RegisterMacro(macroAction, macroName, macroSlot, macroIcon)
  local selfHyperlink = warExtended.Modules["Macro"]["hyperlink"]

    macroSlot = macroSlot or getFirstEmptyMacroSlot()
    macroIcon = macroIcon or math.random(20404,20470)
    macroName = macroName or L"Macro "..macroSlot

    if macroSlot == nil then
      return EA_ChatWindow.Print(selfHyperlink..L"No empty macro slots in the current set - macro not set.")
    end

  	local texture, x, y = GetIconData( macroIcon )
    DynamicImageSetTexture( "MacroIconSelectionWindowIconSlot"..macroSlot.."IconBase", texture, x, y )
    SetMacroData( macroName, macroAction, macroIcon, macroSlot )
    DynamicImageSetTexture( "EA_Window_MacroIconSlot"..macroSlot.."IconBase", texture, x, y )
end

local function saveCurrentMacroSet()
  local currentMacroSet = getCurrentMacroSetNumber()
end

local function registerWarExtendedMacros()

  RegisterMacro(L"/script TellTarget(\"whisper current friendly target with this text\")",L"warExtended Tell Target", nil, 22250);
  RegisterMacro(L"/script InviteLast()",L"warExtended Invite Last", nil, 22251);
  RegisterMacro(L"/script ReplyLast(\"reply to last whisper with this text\")", L"warExtended Reply Last", nil, 22252);
  RegisterMacro(L"/script ChatMacro(\"send dynamic target info (example: $ehp $elvl $et) to a channel of choice\", \"/s\")",L"warExtended Chat Macro", nil, 22253);

  local currentMacros = DataUtils.GetMacros()
  warExtended.Macro.Set1 = DataUtils.CopyTable(currentMacros)

end

function warExtended.EA_Window_Macro_OnSave()
  p("hooked")
end

function warExtended.InitializeModuleMacro()

  warExtended.RegisterModule("Macro", slashCommands)

  registerSelfHooks()
  initializeMacroComboBox()

  if warExtended.Macro.isMacroSetCreated then return end
  createMacroSets()
  registerWarExtendedMacros()

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


function warExtended.OnMacroComboBoxSelect()
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
