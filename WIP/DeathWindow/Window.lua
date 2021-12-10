local DeathRecap = warExtendedDeathWindow
local DEATH_RECAP_WINDOW = "warExtendedDeathRecap"
local TITLE_BAR_TEXT = "TitleBarText"

function DeathRecap.SetWindowLabel()
  LabelSetText(DEATH_RECAP_WINDOW..TITLE_BAR_TEXT, L"Death Recap")
  ButtonSetText("DeathWindowRecapButton", L"RECAP")
end

function DeathRecap.Hide()
  WindowSetShowing(DEATH_RECAP_WINDOW, false)
end

function DeathRecap.ToggleDeathRecapWindow()
  WindowUtils.ToggleShowing(DEATH_RECAP_WINDOW)
end

function DeathRecap.OnLButtonUpRecapButton()
  DeathRecap.ToggleDeathRecapWindow()
end

function DeathRecap.OnMouseOverRecapAbility()
  local recapEntry = DeathRecap.GetMouseOverTemplateData(DeathRecap:GetMouseOverWindowId())
  local timeBeforeDeath = towstring(recapEntry:getAbilityHitTimeBeforeDeath().." before death.")
  local abilityData = recapEntry:getAbilityData()

  Tooltips.CreateAbilityTooltip(abilityData, DeathRecap:GetMouseOverWindow(), Tooltips.ANCHOR_WINDOW_RIGHT, timeBeforeDeath)

end