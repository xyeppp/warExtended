local MiniReport = warExtendedWarReport
local WINDOWNAME = "warExtendedWarReport"

local tooltipText = {
  [1] = L"Enabling this option will display the War Report window upon login.",
  [2] = L"Enabling this option will display an alert when the War Report cooldown is up."
}

function MiniReport.OnInitializeShowOnLoginButton()
  LabelSetText(WINDOWNAME.."ShowOnLoginLabel", L"Show on login")
  EA_LabelCheckButton.Initialize(EA_Window_CurrentEvents.GetShowOnLogin())
end

function MiniReport.OnInitializeCooldownAlertButton()
  LabelSetText(WINDOWNAME.."ToggleAlertLabel", L"Cooldown alert")
  EA_LabelCheckButton.Initialize(MiniReport.Settings.isAlertEnabled)
end

function MiniReport.OnLButtonUpCooldownAlertButton()
  EA_LabelCheckButton.Toggle()
  MiniReport.Settings.isAlertEnabled = EA_LabelCheckButton.IsChecked()
end

function MiniReport.OnMouseOverSettingsButton()
  local tooltipText = tooltipText[MiniReport:GetMouseOverWindowId()]
  
  Tooltips.CreateTextOnlyTooltip(MiniReport:GetMouseOverWindow(), tooltipText)
  Tooltips.AnchorTooltip( Tooltips.ANCHOR_WINDOW_BOTTOM)
end
