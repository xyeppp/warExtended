warExtendedMacroPlus = warExtended.Register("warExtended Macros Plus", "MacroPlus")

local Macro = warExtendedMacroPlus
local WINDOW_NAME = "warExtendedMacroPlusWindow"
local EA_MACRO_BUTTON_WINDOW_NAME = "EA_Window_MacroIconSlot"
local GetFrame = GetFrame
local SetMacroData = SetMacroData
local setmetatable = setmetatable

-- Legacy kept for compliance with other addons
EA_Window_Macro = {}
EA_Window_Macro.NUM_MACROS = 48
EA_Window_Macro.NUM_MACRO_ICONS = 30
EA_Window_Macro.MACRO_ICONS_ID_BASE = 1

function EA_Window_Macro.UpdateMacros()
    GetFrame(WINDOW_NAME):UpdateMacros()
end

function EA_Window_Macro.UpdateDetails(macroSlot)
    GetFrame(WINDOW_NAME):UpdateDetails(macroSlot)
end

if not Macro.Settings then
    Macro.Settings = {
        registeredSlash = false
    }
end

local slashCommands = {
    macro = {
        func = function (macroAction, macroName, macroSlot, macroSet)
            macroSet = Macro:toNumber(macroSet) or nil
            macroSlot = Macro:toNumber(macroSlot) or nil

            if macroAction == "" then
                Macro:Warn("Usage: macroAction#macroName#macroSlot#macroSet\nSlot, set & name are optional - first empty slot will be used if not given.")
                return
            end

            RegisterMacro(macroAction, macroName, macroSlot, nil, macroSet)
        end ,
        desc = "Create a macro on the fly. Usage: /macro text#slot.\nSlot is optional, first empty slot will be used if nil"
    },
    macroset = {
        func = function (setIdx)
            local frame = GetFrame(WINDOW_NAME)
            local currentSet, setName = frame:GetSelectedMacroSet()

            setIdx = Macro:toNumber(setIdx) or 0

            if not frame:GetMacroSet(setIdx) then
                Macro:Warn("Invalid macro set -  macro set "..setIdx.." does not exist.")
            elseif frame:GetMacroSet(setIdx) and setIdx ~= currentSet then
                Macro:Print(L"Macro Set "..setIdx..L" loaded.")
                frame:SelectMacroSet(setIdx)
            else
                Macro:Print(L"Macro "..setName..L" is already loaded.")
            end
        end ,
        desc = "Load a macro set. Usage: /macroset 1 or 2"
    }
}

function Macro.OnInitialize()
    Macro:RegisterSlash(slashCommands, "macroplus")

    if not Macro.Settings.registeredSlash then
        Macro:Print("Registering macros.")

        RegisterMacro("/script TellTarget(\"whisper current friendly target with this text\")","warExtended Tell Target");
        RegisterMacro("/script InviteLast()","warExtended Invite Last");
        RegisterMacro("/script ReplyLast(\"reply to last whisper with this text\")", "warExtended Reply Last");
        RegisterMacro("/script ChatMacro(\"send dynamic target info (example: $ehp $elvl $et) to a channel of choice\", \"/s\")","warExtended Chat Macro");

        Macro.Settings.registeredSlash = true
    end
end

function Macro.OnMacroUpdated(macroId)
    local macroPlusFrame = GetFrame(WINDOW_NAME)
    if( macroId == macroPlusFrame.m_activeId ) then
        macroPlusFrame:UpdateDetails( macroPlusFrame.m_activeId )
    end

    local macros = DataUtils.GetMacros()
    local buttonFrame = GetFrame(EA_MACRO_BUTTON_WINDOW_NAME..macroId)
    buttonFrame:SetIcon(macros[macroId].iconNum)
end

function Macro.OnMacrosLoaded()
    GetFrame(WINDOW_NAME):UpdateMacros()
end

local function getFirstEmptyMacroSlotAndSet()
    local macroSets = Macro.Settings.Sets

    for macroSet=1,macroSets:Len() do
        local macros = macroSets:Get(macroSet)
        for macroSlot=1,EA_Window_Macro.NUM_MACROS do
            if macros:Get(macroSlot).text == L"" then
                return macroSlot, macroSet
            end
        end
    end
end

function RegisterMacro(macroAction, macroName, macroSlot, macroIcon, macroSet)
    local frame = GetFrame(WINDOW_NAME)

    if (not macroSlot or not macroSet) then
        macroSlot, macroSet = getFirstEmptyMacroSlotAndSet()
    elseif not macroSet then
        macroSet = frame:GetSelectedMacroSet()
    end

    if not macroSlot then
        Macro:Warn("No empty macro slots - macro not set.")
        return
    end

    macroIcon = macroIcon or Macro:GetMacroData(macroSlot, "iconNum") or Macro:GetRandomNumber(20404,20470)
    macroName = Macro:toWString(macroName or Macro:GetMacroData(macroSlot, "name") or L"Macro "..macroSlot)
    macroAction = Macro:toWString(macroAction)

    if frame:GetSelectedMacroSet() == macroSet then
        SetMacroData( macroName, macroAction, macroIcon, macroSlot )
    end

    frame:SaveMacroToSet({
        iconNum = macroIcon,
        text = macroAction,
        name = macroName
    }, macroSlot, macroSet)

    Macro:PlaySound("button click")
end