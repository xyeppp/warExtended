local ScreenFlash = warExtendedScreenFlash
local GENERAL_SETTINGS_WINDOW = "SWTabGeneralContentsScrollChildSettingsGamePlay"
local SCREEN_FLASH_SETTINGS_BUTTON = "warExtendedScreenFlashSettingsButton"

local TOOLTIP_TEXT = L"Enabling this will flash your screen upon receiving damage. The flashing gets more intense the lower your health is."
local BUTTON_LABEL = L"Flash Screen On Damage"


function ScreenFlash.InitializeButton()
  CreateWindow(SCREEN_FLASH_SETTINGS_BUTTON, true)
  WindowSetParent(SCREEN_FLASH_SETTINGS_BUTTON, GENERAL_SETTINGS_WINDOW)
  LabelSetText(SCREEN_FLASH_SETTINGS_BUTTON.."Label", BUTTON_LABEL)
end

function ScreenFlash.OnInitializeSettingsButton()
  EA_LabelCheckButton.Initialize(ScreenFlash.Settings.IsEnabled)

  if EA_LabelCheckButton.IsChecked() then
    ScreenFlash.InitializeScreenFlash()
  end
end


function ScreenFlash.OnLButtonUpSettingsButton()
  EA_LabelCheckButton.Toggle()
  ScreenFlash.Settings.IsEnabled = EA_LabelCheckButton.IsChecked()

  if EA_LabelCheckButton.IsChecked() then
    ScreenFlash.InitializeScreenFlash()
    return
  end

  ScreenFlash.ShutdownScreenFlash()
end

function ScreenFlash.OnMouseOverSettingsButton()
  Tooltips.CreateTextOnlyTooltip( ScreenFlash:GetActiveWindow(), TOOLTIP_TEXT)
  Tooltips.AnchorTooltip( Tooltips.ANCHOR_WINDOW_TOP)
end

