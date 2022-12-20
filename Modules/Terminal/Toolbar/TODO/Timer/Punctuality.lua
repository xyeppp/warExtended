Punctuality = Frame:Subclass ("Punctuality")

local UPDATE_DELAY = .1 -- only update the display every tenth of a second
local updateCounter = UPDATE_DELAY

function Punctuality.Initialize ()
    local stopwatch = Punctuality:CreateFromTemplate ("StopWatch")
    
    Punctuality.m_StopWatch = stopwatch
    Punctuality.Reset ()
    
    ButtonSetText ("StopWatchStop", L"Stop")
    ButtonSetText ("StopWatchStart", L"Start")
    ButtonSetText ("StopWatchReset", L"Reset")
    LabelSetText ("StopWatchTitleBarText", L"Punctuality")
    
    Punctuality.UpdateTimeLabel ()
    
    DevBar:RegisterMod (L"Punctuality", L"A simple stopwatch utility", Punctuality.Toggle, 10950)
end

function Punctuality.Shutdown ()
    Punctuality.m_StopWatch:Destroy ()
end

function Punctuality.Update (timeElapsed)
    if (Punctuality.m_StopWatch.m_IsRunning)
    then
        Punctuality.m_StopWatch.m_Seconds = Punctuality.m_StopWatch.m_Seconds + timeElapsed
        updateCounter = updateCounter - timeElapsed
        
        if (updateCounter <= 0)
        then
            Punctuality.UpdateTimeLabel ()
            updateCounter = UPDATE_DELAY
        end
    end
end

function Punctuality.Toggle ()
    local frame = Punctuality.m_StopWatch
    frame:Show (not frame:IsShowing ())
end

function Punctuality.Stop ()
    Punctuality.m_StopWatch.m_IsRunning = false
end

function Punctuality.Start ()
    Punctuality.m_StopWatch.m_IsRunning = true
end

function Punctuality.Reset ()
    Punctuality.m_StopWatch.m_Seconds       = 0
    Punctuality.m_StopWatch.m_IsRunning     = false
    Punctuality.UpdateTimeLabel ()
end

function Punctuality.UpdateTimeLabel ()
    LabelSetText ("StopWatchCurrentTime", TimeUtils.FormatClock (Punctuality.m_StopWatch.m_Seconds))
end