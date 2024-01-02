ScreenFlashWindow = warExtended.Register("warExtended Screen Flash", "Screen Flash")

if not ScreenFlashWindow.Settings then
    ScreenFlashWindow.Settings = {
        IsEnabled = true;
    }
end

local ScreenFlash = ScreenFlashWindow
local WINDOW_NAME = "ScreenFlashWindow"
local WINDOW = Frame:Subclass(WINDOW_NAME)
local unpack = unpack

local frame

local DAMAGE_ALERT_COLOR = { r = 255, g = 0, b = 0 }

-- HP% / Vignette Alpha
local hpThresholds = {
    { 100, 0.1 },
    { 90, 0.15 },
    { 80, 0.2 },
    { 70, 0.25 },
    { 50, 0.3 },
    { 30, 0.35 },
    { 20, 0.4 },
    { 10, 0.5 },
}

local slashCommands = {
    screenFlash = {
        func = function()
            ScreenFlash.Settings.IsEnabled = not ScreenFlash.Settings.IsEnabled
            ScreenFlashWindow.SetEnabled(ScreenFlash.Settings.IsEnabled)
            ScreenFlash:Print(ScreenFlash:PrintToggle(L"Screen flash", ScreenFlash.Settings.IsEnabled))
        end,
        desc = "Toggles the screen flash upon receiving damage."
    }
}

function WINDOW:StartFlash()
    -- Don't show anything if the Flash Window is not enabled.
    if (not self:IsEnabled()) then
        return ;
    end

    -- Only play one flash at a time.
    if (self.m_curFlashTimer > 0) then
        return
    end

    self:Show(true)
    self:StartAlphaAnimation(Window.AnimationType.POP_AND_EASE, self.m_AnimationData.startAlpha, self.m_AnimationData.endAlpha, self.m_AnimationData.duration, 0,0)

    self.m_curFlashTimer = self.m_AnimationData.duration

end

function WINDOW:IsEnabled()
    return self.m_enabledCount > 0
end

function WINDOW:SetThreshold(currentHP)
    local hpPercentage = ScreenFlash:GetPlayerHPPercentage()
    for threshold=1,#hpThresholds do
        local thresholdPercent, thresholdAlpha = unpack(hpThresholds[threshold])
        if hpPercentage <= thresholdPercent then
            self.m_AnimationData.endAlpha = thresholdAlpha
        else
            break
        end
    end
end

-- This window can be enabled by many different windows in the game, so a simple
-- 'is enabled' flag isn't sufficent. Instead, we use a reference count to allow
-- for multiple windows to request this display.
function ScreenFlashWindow.SetEnabled(enabled)
    if (enabled) then
        frame.m_enabledCount = frame.m_enabledCount + 1

        if not frame.m_enabled then
            frame.m_enabled = true
            frame:SetScript("player cur hit points updated", "ScreenFlashWindow.OnPlayerHitPointsUpdated")
          --  frame:SetScript("update processed", "ScreenFlashWindow.OnUpdate")
        end
    else
        frame.m_enabledCount = frame.m_enabledCount - 1

        if (frame.m_enabledCount < 0) then
            frame.m_enabledCount = 0
        end

        if frame.m_enabledCount == 0 and frame.m_enabled then
            frame.m_enabled = false
            frame:SetScript("player cur hit points updated")
            frame:SetScript("update processed")
        end
    end
end

function ScreenFlashWindow.OnInitialize()
    if frame then
        return
    end

    frame = WINDOW:CreateFrameForExistingWindow(WINDOW_NAME)

    if frame then
        frame.m_AnimationData = {
            duration = 1.5,
            delay = 0,
            startAlpha = 0.0,
            endAlpha = 1.0,
        }

        frame.m_enabled = false
        frame.m_enabledCount = 0
        frame.m_curFlashTimer = 0
        frame.m_lastPlayerHitPoints = 0

        frame:SetTint(DAMAGE_ALERT_COLOR)

        ScreenFlash.SetEnabled(ScreenFlash.Settings.IsEnabled)

        warExtended.AddTaskAction(WINDOW_NAME.."SlashRegister",
        function ()
            if LibSlash then
                ScreenFlash:RegisterSlash(slashCommands, "flash")
                return true
            end
        end )
    end

end

function ScreenFlashWindow.OnUpdate( timePassed )
     if( frame.m_curFlashTimer > 0 ) then
         frame.m_curFlashTimer = frame.m_curFlashTimer - timePassed

         if( frame.m_curFlashTimer < 0 ) then
             frame.m_curFlashTimer = 0
             frame:Show(false)
         end
     end
end

function ScreenFlashWindow.OnPlayerHitPointsUpdated(currentHP)
    if not frame:IsEnabled() or not GameData.Player.inCombat then
        return
    end

    if currentHP < frame.m_lastPlayerHitPoints then
        frame:SetThreshold(currentHP)
        frame:StartFlash()
    end

    frame.m_lastPlayerHitPoints = currentHP
end