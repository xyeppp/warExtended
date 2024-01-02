local Macro = warExtendedMacroPlus
local GetString = GetString
local GetFrame = GetFrame
local GetIconData = GetIconData
local SetMacroData = SetMacroData

local WINDOW_NAME = "warExtendedMacroPlusWindow"
local ICON_SELECT_WINDOW_NAME = "warExtendedMacroPlusWindowIconSelection"
local EA_MACRO_BUTTON_WINDOW_NAME = "EA_Window_MacroIconSlot"
local EA_MACRO_BUTTON_TEMPLATE_NAME = "EA_Window_MacroIconButton"
local EA_MACRO_ICON_SELECT_BUTTON_WINDOW_NAME = "MacroIconSelectionWindowIconSlot"

local WINDOW = Frame:CreateFrameForExistingWindow(WINDOW_NAME)

local MAX_ICONS_ROW = 6
local MAX_ICONS_COLUMN = 5
local MAX_MACRO_ROW = 8
local MAX_MACRO_COLUMN = 6

local TITLEBAR = 1
local MACRO_ICON_BUTTON = 3
local MACRO_ICON_IMAGE = 4
local MACRO_NAME_EDIT = 5
local MACRO_NAME_LABEL = 6
local MACRO_SAVE_BUTTON = 7
local MACRO_CONTENTS_EDIT = 8
local MACRO_CONTENTS_LABEL = 9
local MACRO_SETS_FRAME = 10
local ICON_SELECT_SCROLL = 11

local ICON_SELECT_WINDOW = Frame:CreateFrameForExistingWindow(ICON_SELECT_WINDOW_NAME)

function ICON_SELECT_WINDOW:OnInitialize()
    local frame = self
    if frame then
        frame.m_Windows = {
            [TITLEBAR] = Label:CreateFrameForExistingWindow(frame:GetName().."TitleBarLabel"),
            [ICON_SELECT_SCROLL] = warExtendedDefaultIconScrollWindow:Create(frame:GetName().."Icons", EA_MACRO_ICON_SELECT_BUTTON_WINDOW_NAME, MAX_ICONS_ROW, MAX_ICONS_COLUMN)
        }

        local win = frame.m_Windows
        win[TITLEBAR]:SetText(GetString( StringTables.Default.LABEL_SELECT_ICON))
    end
end

function ICON_SELECT_WINDOW:OnIconSelect(iconNum, texture, x, y)
    local win = WINDOW.m_Windows
    WINDOW.m_iconNum = iconNum
    win[MACRO_ICON_IMAGE]:SetTexture(texture, x, y )
    ICON_SELECT_WINDOW:Show(false)
end

local MACRO_BUTTON = warExtendedDefaultIconButton:Subclass(EA_MACRO_BUTTON_TEMPLATE_NAME)

function MACRO_BUTTON:OnMouseOver()
end

function MACRO_BUTTON:OnRButtonDown()
end

function MACRO_BUTTON:OnLButtonUp()
    local slot = self:GetId()

    if( WINDOW.m_activeId == slot ) then
        local macros = DataUtils.GetMacros()
        Cursor.PickUp( Cursor.SOURCE_MACRO, slot, slot, macros[slot].iconNum, false )
    else
        WINDOW:UpdateDetails( slot )
    end
end

function MACRO_BUTTON:OnMouseDrag()
    if not Cursor.IconOnCursor() then
        local slot = self:GetId()
        local macros = DataUtils.GetMacros()
        Cursor.PickUp( Cursor.SOURCE_MACRO, slot, slot, macros[slot].iconNum, false )
        WINDOW:UpdateDetails( slot )
    end
end

function WINDOW:OnAddSet()
    return self:GetNewMacroSet()
end

function WINDOW:OnSetChanged(setId, setContents)
    if not setContents then
        return
    else
        for Slot=1,48 do
            local macroData = setContents[Slot]
            SetMacroData(macroData.name, macroData.text, macroData.iconNum, Slot)
        end
    end
end

function WINDOW:OnInitialize()
    local frame = self

    if frame then
        frame.m_Windows = {
            [TITLEBAR] = Label:CreateFrameForExistingWindow(frame:GetName().."TitleBarLabel"),
            [MACRO_ICON_BUTTON] = ButtonFrame:CreateFrameForExistingWindow(frame:GetName().."DetailsIcon"),
            [MACRO_ICON_IMAGE] = DynamicImage:CreateFrameForExistingWindow(frame:GetName().."DetailsIconIconBase"),
            [MACRO_SAVE_BUTTON] = ButtonFrame:CreateFrameForExistingWindow(frame:GetName().."DetailsSave"),
            [MACRO_NAME_LABEL] = Label:CreateFrameForExistingWindow(frame:GetName().."DetailsNameTitle"),
            [MACRO_NAME_EDIT] = TextEditBox:CreateFrameForExistingWindow(frame:GetName().."DetailsName"),
            [MACRO_CONTENTS_EDIT] = TextEditBox:CreateFrameForExistingWindow(frame:GetName().."DetailsText"),
            [MACRO_CONTENTS_LABEL] = Label:CreateFrameForExistingWindow(frame:GetName().."DetailsTextTitle"),
            [MACRO_SETS_FRAME] = warExtendedDefaultSets:Create(frame:GetName().."Sets", Macro.Settings, frame, L"Macro Sets")
        }

        frame.m_activeId = 1
        frame.m_iconNum = 0

        MACRO_BUTTON:CreateSet(EA_MACRO_BUTTON_WINDOW_NAME, frame:GetName().."MacrosScrollChild", MAX_MACRO_ROW, MAX_MACRO_COLUMN)

        local win = frame.m_Windows

        win[TITLEBAR]:SetText(GetString(StringTables.Default.LABEL_MACROS)..L"+")
        win[MACRO_SAVE_BUTTON]:SetText(GetString( StringTables.Default.LABEL_SAVE))
        win[MACRO_NAME_LABEL]:SetText(GetString( StringTables.Default.LABEL_MACROS_NAME))
        win[MACRO_CONTENTS_LABEL]:SetText(GetString( StringTables.Default.LABEL_MACROS_TEXT))


        if not win[MACRO_SETS_FRAME]:GetSet(1) then
            win[MACRO_SETS_FRAME]:AddSet(DataUtils.GetMacros())
            win[MACRO_SETS_FRAME]:AddSet(frame:GetNewMacroSet())
            win[MACRO_SETS_FRAME]:SetSelectedSet(1)
       end

        win[MACRO_ICON_BUTTON].OnLButtonDown = function(self, ...)
            ICON_SELECT_WINDOW:Show(not ICON_SELECT_WINDOW:IsShowing())
        end

        win[MACRO_ICON_BUTTON].OnMouseOver = function(self, ...)
            Macro:CreateTextTooltip(self:GetName(), {
                [1]={{text = GetString( StringTables.Default.TEXT_SELECT_ICON_BUTTON )}},
            }, nil, Tooltips.ANCHOR_WINDOW_TOP)
        end

        win[MACRO_SAVE_BUTTON].OnLButtonUp = function(self, ...)
            local macroText = win[MACRO_CONTENTS_EDIT]:GetText()
            local macroButtonFrame = GetFrame(EA_MACRO_BUTTON_WINDOW_NAME..frame.m_activeId)

            local currentSet = frame:GetSelectedMacroSet()

            frame:SaveMacroToSet({
                iconNum = frame.m_iconNum,
                text = win[MACRO_CONTENTS_EDIT]:GetText(),
                name = win[MACRO_NAME_EDIT]:GetText()
            }, frame.m_activeId, currentSet)

            SetMacroData( win[MACRO_NAME_EDIT]:GetText(), macroText, frame.m_iconNum, frame.m_activeId )

            macroButtonFrame:SetIcon(frame.m_iconNum )
            Macro:PlaySound("button click")
        end

        frame:SetScript("macro updated", "warExtendedMacroPlus.OnMacroUpdated" )
        frame:SetScript("macros loaded", "warExtendedMacroPlus.OnMacrosLoaded")

        frame:UpdateMacros()
        frame:UpdateDetails( 1 )
        frame:HideMacroIconSelectionWindow()

        --TODO: Move into TriggerEvent("Initialize")
        warExtended.AddTaskAction(WINDOW_NAME, function()
            if MainMenuWindow then
                Macro:Hook(MainMenuWindow.OnOpenMacros, function()
                    frame:Show(not frame:IsShowing())
                end)
                return true
            end
        end)
    end
end

function WINDOW:SaveMacroToSet(macro, macroSlot, setId)
    macroSlot = macroSlot or self.m_activeId

    self:GetMacroSet(setId)[macroSlot] = macro
end

function WINDOW:GetMacroSet(setId)
    local win = self.m_Windows
    return win[MACRO_SETS_FRAME]:GetSet(setId)
end

function WINDOW:GetSelectedMacroSet()
    local win = self.m_Windows
    return win[MACRO_SETS_FRAME]:GetSelectedSet()
end

function WINDOW:SelectMacroSet(setId)
    local win = self.m_Windows
    win[MACRO_SETS_FRAME]:SetSelectedSet(setId)
end

function WINDOW:GetNewMacroSet()
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

function WINDOW:UpdateDetails(macroSlot)
    local macros = DataUtils.GetMacros()
    local win = self.m_Windows

    self.m_activeId = macroSlot
    self.m_iconNum = macros[macroSlot].iconNum

    win[MACRO_NAME_EDIT]:SetText(macros[macroSlot].name )
    win[MACRO_CONTENTS_EDIT]:SetText(macros[macroSlot].text )

    local texture, x, y = GetIconData( macros[macroSlot].iconNum )
    win[MACRO_ICON_IMAGE]:SetTexture(texture, x, y )

    -- Update the Buttons
    for index = 1, EA_Window_Macro.NUM_MACROS do
        GetFrame(EA_MACRO_BUTTON_WINDOW_NAME..index):SetPressedFlag(self.m_activeId == index)
    end
end

function WINDOW:UpdateMacros()
    local macros = DataUtils.GetMacros()
    for slot = 1, EA_Window_Macro.NUM_MACROS do
        local buttonFrame = GetFrame(EA_MACRO_BUTTON_WINDOW_NAME..slot)
        buttonFrame:SetIcon(macros[slot].iconNum)
    end
end

function WINDOW:OnShown()
    WindowUtils.OnShown(self.Hide, WindowUtils.Cascade.MODE_AUTOMATIC)
end

function WINDOW:OnHidden()
    WindowUtils.OnHidden()
    self:HideMacroIconSelectionWindow()
end

function WINDOW:HideMacroIconSelectionWindow()
    if ICON_SELECT_WINDOW:IsShowing() then
        ICON_SELECT_WINDOW:Show(false)
    end
end