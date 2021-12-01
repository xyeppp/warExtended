local ScreenFlash = warExtendedScreenFlash

ScreenFlash.Settings = {
  IsEnabled = false;
  lastPlayerHitPoints = 0
}

local hpThresholds = {
    [1] = ScreenFlash.RegisterThreshold(100, 0.1),
    [2] = ScreenFlash.RegisterThreshold(90, 0.15),
    [3] = ScreenFlash.RegisterThreshold(80, 0.2),
    [4] = ScreenFlash.RegisterThreshold(70, 0.25),
    [5] = ScreenFlash.RegisterThreshold(50, 0.35),
    [6] = ScreenFlash.RegisterThreshold(30, 0.4),
    [7] = ScreenFlash.RegisterThreshold(20, 0.45),
    [8] = ScreenFlash.RegisterThreshold(10, 0.5),

    setNextThresholdHp = function (self)
      for i=1,#self do
        local threshold=self[i]
        threshold:setNextThresholdHp(self[i+1])
      end
    end,

    getActiveThresholdAndFlash = function (self, currentHP)
      for i=1,#self do
        local threshold=self[i]
        local activeThreshold = threshold:getActiveThreshold(currentHP)

        if activeThreshold then
          activeThreshold:flash()
        end

      end
    end
  }

function ScreenFlash.InitializeScreenFlash()
  ScreenFlash:RegisterUpdate("ScreenFlashWindow.OnUpdate")
  ScreenFlash:RegisterWindowEvent("ScreenFlashWindow", "player cur hit points updated", "warExtendedScreenFlash.OnPlayerHitPointsUpdated")
end

function ScreenFlash.ShutdownScreenFlash()
  ScreenFlash:UnregisterUpdate("ScreenFlashWindow.OnUpdate")
  ScreenFlash:UnregisterWindowEvent("ScreenFlashWindow", "player cur hit points updated", "warExtendedScreenFlash.OnPlayerHitPointsUpdated")
end


function ScreenFlash.OnPlayerHitPointsUpdated(currentHP)
  if currentHP < ScreenFlash.Settings.lastPlayerHitPoints then

    if ScreenFlashWindow.IsEnabled() then
      ScreenFlashWindow.StartFlash()
      return
    end

    hpThresholds:getActiveThresholdAndFlash(currentHP)
  end

  ScreenFlash.Settings.lastPlayerHitPoints = currentHP
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

  hpThresholds:setNextThresholdHp()
end