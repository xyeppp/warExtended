local Healer = warExtendedInteraction
local TOOLTIP_TEXT = L"Enable this setting to automatically heal penalties when interacting with a healer."

function Healer.OnInitializeHealerToggleButton()
    EA_LabelCheckButton.Initialize(Healer.Settings.isEnabled)
end

function Healer.OnLButtonUpHealerToggleButton()
    EA_LabelCheckButton.Toggle()
    Healer.Settings.isEnabled = EA_LabelCheckButton.IsChecked()
end

function Healer.OnMouseOverHealerToggleButton()
    Tooltips.CreateTextOnlyTooltip(Healer:GetActiveWindow(), TOOLTIP_TEXT)
    Tooltips.AnchorTooltip(Tooltips.ANCHOR_WINDOW_BOTTOM)
end
