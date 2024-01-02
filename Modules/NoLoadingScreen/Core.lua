warExtendedNoLoadScreen = warExtended.Register("warExtended NoLoadingScreen", "NoLoadScreen")
local NoLoadScreen = warExtendedNoLoadScreen
local ScenarioSummaryWindow = ScenarioSummaryWindow
local SC_SUMMARY_WINDOW_NAME = "ScenarioSummaryWindow"

local FADE_OUT_TIME = 0.01
local FADE_IN_TIME = 0.01

local slashCommands = {
    noload = {
        func = function()
            NoLoadScreen.Settings.enabled = not NoLoadScreen.Settings.enabled
            NoLoadScreen:Print(NoLoadScreen:PrintToggle(L"No loading screen", NoLoadScreen.Settings.enabled))
        end,
        desc = "Toggles the loading screen."
    },
}

if not NoLoadScreen.Settings then
    NoLoadScreen.Settings = {
        enabled = true;
    }
end

local function onInitScenarioExitLoadScreen()
    ScenarioSummaryWindow.SetDisplayMode( ScenarioSummaryWindow.MODE_IN_PROGRESS )
end

NoLoadScreen:Hook(EA_Window_LoadingScreen.Initialize, function ()
    EA_Window_LoadingScreen.FADE_OUT_TIME = FADE_OUT_TIME
    EA_Window_LoadingScreen.FADE_IN_TIME = FADE_IN_TIME

    NoLoadScreen:RegisterSlash(slashCommands, "loadscreen")
end, true)

NoLoadScreen:Hook(EA_Window_LoadingScreen.InitScenarioExitLoadScreen, onInitScenarioExitLoadScreen, true)
NoLoadScreen:Hook(EA_Window_LoadingScreen.BeginScenarioExitLoadScreen, onInitScenarioExitLoadScreen, true)

NoLoadScreen:Hook(ScenarioSummaryWindow.SetDisplayMode, function()
    local shouldShow = GameData.ScenarioData.mode == GameData.ScenarioMode.POST_MODE and ScenarioSummaryWindow.currentMode == ScenarioSummaryWindow.MODE_POST_MODE
    if shouldShow then
        WindowSetShowing( SC_SUMMARY_WINDOW_NAME.."Close", shouldShow )
    end
end, true)

NoLoadScreen:Hook(ScenarioSummaryWindow.ToggleShowing, function(...)
    if ( GameData.Player.isInScenario or WindowGetShowing(SC_SUMMARY_WINDOW_NAME) ) then
        local shouldShow = GameData.ScenarioData.mode == GameData.ScenarioMode.POST_MODE and ScenarioSummaryWindow.currentMode == ScenarioSummaryWindow.MODE_POST_MODE
        if shouldShow then
            WindowUtils.ToggleShowing( SC_SUMMARY_WINDOW_NAME )
        end
    end
end, true)

NoLoadScreen:Hook(EA_Window_LoadingScreen.OnLoadBegin, function()
    if NoLoadScreen.Settings.enabled then
        EA_Window_LoadingScreen.SetHideTimer( 0 )
        EA_Window_LoadingScreen.Stop()
        return
    elseif ( GameData.ScenarioData.id ~= 0) then
        local loadingData = LoadingScreenGetCurrentData()
        if GameData.Player.zone == loadingData.zoneId then
            EA_Window_LoadingScreen.SetHideTimer( 0 )
            EA_Window_LoadingScreen.Stop()
        end
    end

end, true)