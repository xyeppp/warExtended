warExtendedLogOut = warExtended.Register("warExtended LogOut")
local LogOut = warExtendedLogOut
local warExtendedTimer = warExtendedTimer
local GetFrame = GetFrame

local WINDOW_NAME = "warExtendedLogOutWindow"
local WINDOW = Frame:Subclass(WINDOW_NAME)
local VIGNETTE = Frame:Subclass("ScreenFlashWindow")
local SYS_LOG = TextLog:Subclass("System")

local LABEL = 1
local TITLEBAR = 2
local VIGNET = 3

local HARDCODED_STRING = "Hardcoded"
local DEFAULT_STRING = "Default"

local LOGGING_OUT_STRING_ID = 456
local NO_LONGER_LOGGING_OUT_STRING_ID = 457

local LOG_OUT_TITLE_STRING_ID = 96
local EXIT_GAME_TITLE_STRING_ID = 97
local LOGOUT_TIMER = 20

function WINDOW:OnShown()
    local win = self.m_Windows

    if not self.m_isLogging then
        return
    end

    self:SetScript(SYS_LOG:GetUpdateEventId(), "warExtendedLogOut.OnTextLogUpdatedEvent")

    win[LABEL]:SetText(GetFormatStringFromTable(HARDCODED_STRING, LOGGING_OUT_STRING_ID, {LOGOUT_TIMER }))
    win[VIGNET]:StartAlphaAnimation( Window.AnimationType.SINGLE_NO_RESET, 0, 1, 20, 0, 0 )

    warExtendedTimer.New (WINDOW_NAME, 1,
            function (self)
                win[LABEL]:SetText(GetFormatStringFromTable(HARDCODED_STRING, LOGGING_OUT_STRING_ID, {LogOut:Round(LOGOUT_TIMER - self.timeout, 0)}))
                return false
            end)
end

function WINDOW:OnHidden()
    local win = self.m_Windows

    if not self.m_isLogging then
        return
    end

    self.m_isLogging = false
    self.m_Timer = LOGOUT_TIMER
    self:SetScript(SYS_LOG:GetUpdateEventId())

    win[VIGNET]:StartAlphaAnimation( Window.AnimationType.SINGLE_NO_RESET_HIDE, win[VIGNET]:GetAlpha(), 0, 0.2, 0, 0 )

    warExtendedTimer:Remove(WINDOW_NAME)
end

function LogOut.OnTextLogUpdatedEvent()
    local _, _, msg = SYS_LOG:GetLastEntry()

    if msg == GetStringFromTable(HARDCODED_STRING, NO_LONGER_LOGGING_OUT_STRING_ID) then
        GetFrame(WINDOW_NAME):Show(false)
    end
end

function LogOut.OnLogOut()
    local frame = GetFrame(WINDOW_NAME)
    frame.m_isLogging = true

    frame.m_Windows[TITLEBAR]:SetText(GetStringFromTable(DEFAULT_STRING, LOG_OUT_TITLE_STRING_ID))
    frame:Show(true)
end

function LogOut.OnExitGame()
    local frame = GetFrame(WINDOW_NAME)
    frame.m_isLogging = true
    frame.m_Windows[TITLEBAR]:SetText(GetStringFromTable(DEFAULT_STRING, EXIT_GAME_TITLE_STRING_ID))
    frame:Show(true)
end

function warExtendedLogOut.OnInitialize()
    local frame = WINDOW:CreateFrameForExistingWindow(WINDOW_NAME)

    frame.m_Timer = LOGOUT_TIMER
    frame.m_isLogging = false

    frame.m_Windows = {
        [LABEL] = Label:CreateFrameForExistingWindow(frame:GetName().."Label"),
        [TITLEBAR] = Label:CreateFrameForExistingWindow(frame:GetName().."TitleBarLabel"),
        [VIGNET] = VIGNETTE:CreateFromTemplate(frame:GetName().."Vignette")
    }

    local win = frame.m_Windows
    win[VIGNET]:SetTint({ r=0, g=0, b=0 })

    frame:RegisterLayoutEditor( GetStringFromTable( DEFAULT_STRING, LOG_OUT_TITLE_STRING_ID ) .. L" Window",
            GetStringFromTable( DEFAULT_STRING, LOG_OUT_TITLE_STRING_ID ) .. L" Window",
            true, false,
            true, nil )

    frame:RegisterLayoutEditorCallback(function(editorCode)
        if( editorCode == LayoutEditor.EDITING_END ) then
            frame:Show(false, Frame.FORCE_OVERRIDE)
        end
    end)

    frame:SetScript("log out", "warExtendedLogOut.OnLogOut")
    frame:SetScript("exit game", "warExtendedLogOut.OnExitGame")

    frame:Show(false)
end