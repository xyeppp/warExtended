warExtendedMainMenu = warExtended.Register("warExtended Main Menu")
local MainMenu = warExtendedMainMenu

local WAREXT_OPTIONS_WINDOW = "warExtendedSettings"
local UI_MOD_WINDOW = "UiModWindow"

function MainMenu.OnOpenWarExtendedOptions()
  local frame = GetFrame(WAREXT_OPTIONS_WINDOW)
  frame:Show(not frame:IsShowing())
  MainMenuWindow.Hide()
end

function MainMenu.OnOpenUiModsWindow()
  WindowUtils.ToggleShowing( UI_MOD_WINDOW )
  MainMenuWindow.Hide()
end