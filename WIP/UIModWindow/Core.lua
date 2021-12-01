warExtendedUiMod = warExtended.Register("warExtended Ui Mod")
local UiMod = warExtendedUiMod
--TODO: add profiles

UiMod.Settings = {
  Profiles = {
  }
}

function UiMod.OnInitialize()
  UiMod:Hook(UiModWindow.OnShown, UiMod.OnShownUiModWindow, true)
  UiMod:Hook(UiModWindow.OnHidden, UiMod.OnHiddenUiModWindow, true)
  UiMod.SetSearchLabel()
end