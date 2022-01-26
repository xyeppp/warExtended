warExtendedMainMenu = warExtended.Register("warExtended Main Menu")
local MainMenu = warExtendedMainMenu

local WAREXT_OPTIONS_WINDOW = "warExtendedSettings"
local UI_MOD_WINDOW = "UiModWindow"

function MainMenu.OnOpenWarExtendedOptions()
  WindowUtils.ToggleShowing( WAREXT_OPTIONS_WINDOW )
  MainMenuWindow.Hide()
end

function MainMenu.OnOpenUiModsWindow()
  WindowUtils.ToggleShowing( UI_MOD_WINDOW )
  MainMenuWindow.Hide()
end