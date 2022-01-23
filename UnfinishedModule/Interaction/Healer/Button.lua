local Healer = warExtendedHealer
local TOOLTIP_TEXT = L"Enable this setting to automatically heal penalties when interacting with a healer."

function Healer.OnInitializeToggleButton()
  EA_LabelCheckButton.Initialize(Healer.Settings.isEnabled)
end

function Healer.OnLButtonUpToggleButton()
  EA_LabelCheckButton.Toggle()
  Healer.Settings.isEnabled = EA_LabelCheckButton.IsChecked()
end

function Healer.OnMouseOverToggleButton()
  Tooltips.CreateTextOnlyTooltip( Healer:GetActiveWindow(), TOOLTIP_TEXT)
  Tooltips.AnchorTooltip( Tooltips.ANCHOR_WINDOW_BOTTOM)
end