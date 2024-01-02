warExtendedRespawnTimer = warExtended.Register("warExtended Respawn Timer")
local RespawnTimer = warExtendedRespawnTimer
local TimeUtils = TimeUtils

local WINDOW_NAME = "warExtendedRespawnTimerWindow"
local WINDOW = Frame:Subclass(WINDOW_NAME)

local RESPAWN_STRING_ID = 102
local RESPAWNING_STRING_ID = 584

local BAR_FRAME = 1
local LABEL = 2

function WINDOW:Create()
    local frame = self:CreateFromTemplate(WINDOW_NAME)

    if frame then
        frame.m_Windows = {
            [BAR_FRAME] = warExtendedDefaultStatusBar:Create(frame:GetName().."Timer"),
            [LABEL] = Label:CreateFrameForExistingWindow(frame:GetName().."Label"),
        }

        local win = frame.m_Windows

        win[LABEL]:SetText(GetStringFromTable("Hardcoded", RESPAWNING_STRING_ID))

        frame:RegisterLayoutEditor( GetStringFromTable( "Hardcoded", RESPAWN_STRING_ID ) .. L" Window",
                GetStringFromTable( "Hardcoded", RESPAWN_STRING_ID ) .. L" Window",
                true, false,
                true, nil )

        frame:RegisterLayoutEditorCallback(function(editorCode)
                if( editorCode == LayoutEditor.EDITING_END ) then
                    frame:Show(false, Frame.FORCE_OVERRIDE)
            end
        end)

        function frame:OnApplicationTwoButtonDialog()
            if SystemData.Dialogs.AppDlg.text:find(GetStringFromTable("Hardcoded", RESPAWNING_STRING_ID)) then
                frame.m_respawnTime = SystemData.Dialogs.AppDlg.timer

                win[BAR_FRAME]:SetMaximumValue(frame.m_respawnTime)
                win[BAR_FRAME]:SetCurrentValue(frame.m_respawnTime)
                win[BAR_FRAME]:StopInterpolating()
                win[BAR_FRAME]:SetText(TimeUtils.FormatClock(frame.m_respawnTime))

                frame:Show(true)
                frame:SetScript("player cur hit points updated", "warExtendedRespawnTimer.OnPlayerCurHitPointsUpdated")

                warExtendedTimer.New (WINDOW_NAME, 0.2,
                        function (self)
                            local newTime = frame.m_respawnTime - self.timeout
                            win[BAR_FRAME]:SetText(TimeUtils.FormatClock(newTime))
                            win[BAR_FRAME]:SetCurrentValue(newTime)

                            if self.timeout > frame.m_respawnTime then
                               -- frame:SetScript("player cur hit points updated")
                                frame:Show(false)
                                return true
                            end
                        end)

                DialogManager.Update(0)
                DialogManager.OnRemoveDialog(SystemData.Dialogs.AppDlg.id)
            end
        end

        frame:Show(false)
        RespawnTimer:Hook(DialogManager.OnApplicationTwoButtonDialog, frame.OnApplicationTwoButtonDialog, true)
    end
end

function warExtendedRespawnTimer.OnPlayerCurHitPointsUpdated(curHitPoints)
    if curHitPoints > 0 then
        local frame = GetFrame(WINDOW_NAME)

        frame:SetScript("player cur hit points updated")
        frame:Show(false)
    end
end

WINDOW:Create()