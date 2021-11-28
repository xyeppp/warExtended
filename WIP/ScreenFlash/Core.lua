warExtendedScreenFlash = warExtended.Register("warExtended Screen Flash")
local ScreenFlash = warExtendedScreenFlash

local activeThreshold = nil

ScreenFlash.Settings = {
  IsEnabled = false;
}

local hpThresholds = {
}



function ScreenFlash.PrintThresholds()
  p(thresholds)
end



function ScreenFlash.InitializeScreenFlash()
  ScreenFlash:RegisterUpdate("ScreenFlashWindow.OnUpdate")
  ScreenFlash:RegisterWindowEvent("ScreenFlashWindow", "player cur hit points updated", "warExtendedScreenFlash.OnPlayerHitPointsUpdated")
end

function ScreenFlash.ShutdownScreenFlash()
  ScreenFlash:UnregisterUpdate("ScreenFlashWindow.OnUpdate")
  ScreenFlash:UnregisterWindowEvent("ScreenFlashWindow", "player cur hit points updated", "warExtendedScreenFlash.OnPlayerHitPointsUpdated")
end


local function onScreenFlashSetEnabled()
  if not ScreenFlash.Settings.IsEnabled then

    if not ScreenFlashWindow.IsEnabled() then
      ScreenFlash.ShutdownScreenFlash()
      return
    end

    ScreenFlash.InitializeScreenFlash()
  end
end


function ScreenFlash.OnInitialize()
  ScreenFlash:RegisterEvent("all modules initialized", "warExtendedScreenFlash.InitializeButton")
  ScreenFlash:Hook(ScreenFlashWindow.SetEnabled, onScreenFlashSetEnabled, true)
  thresholds = ScreenFlash.RegisterThresholds()
end