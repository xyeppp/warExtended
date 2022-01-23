warExtendedWarReport = warExtended.Register("warExtended War Report")
local MiniReport = warExtendedWarReport
local WINDOWNAME = "warExtendedWarReport"

--TODO:ALERT TOGGLE

MiniReport.Settings = {
  isAlertEnabled = false;
}

function MiniReport.ToggleWindow()
  WindowUtils.ToggleShowing(WINDOWNAME)
end

function MiniReport.RefreshEvents()
  CurrentEventsUpdate()
end

function MiniReport.OnClickEvent(flags)
  EA_Window_CurrentEvents.OnClickEvent()

  if MiniReport:IsFlagName("isCtrlPressed", flags) then
    EA_Window_CurrentEvents.OnGoButton(true)
  end
end

function MiniReport.SetEventWindowEnabled(eventWindowName)
  WindowSetAlpha(eventWindowName, 1)
  WindowSetFontAlpha(eventWindowName, 1)
  WindowSetHandleInput(eventWindowName, true)
end

function MiniReport.SetEventWindowDisabled(eventWindowName)
  WindowSetAlpha(eventWindowName, 0.3)
  WindowSetFontAlpha(eventWindowName, 0.3)
  WindowSetHandleInput(eventWindowName, false)
end

function MiniReport.OnShown()
  MiniReport:RegisterUpdate("EA_Window_CurrentEvents.UpdateCooldownTimer")
  CurrentEventsUpdate()
end

function MiniReport.OnHidden()
  MiniReport:UnregisterUpdate("EA_Window_CurrentEvents.UpdateCooldownTimer")
end

function MiniReport.OnMouseOverCurrentEvent()
  local eventData = EA_Window_CurrentEvents.GetCurrentMouseoverEventData()

  if not eventData then
    return
  end

  local tooltipText = EA_Window_CurrentEvents.GetTooltipText(eventData)
  Tooltips.CreateTextOnlyTooltip(MiniReport:GetMouseOverWindow(), tooltipText)
  Tooltips.AnchorTooltip( Tooltips.ANCHOR_WINDOW_BOTTOM)
end


