warExtendedUiMod = warExtended.Register("warExtended UI Mods/Addons")
local UiMod = warExtendedUiMod
local SEARCH_BOX="UiModWindowSearchEditBox"
--TODO: add profiles

local filters={}

function UiMod.OnInitialize()
  UiMod:Hook(UiModWindow.OnShown, UiMod.OnShownUiModWindow, true)
  UiMod:Hook(UiModWindow.OnHidden, UiMod.OnHiddenUiModWindow, true)
  UiMod:RegisterSearchBox("UiModWindowSearchEditBox", UiMod.OnSearchTextChanged, filters)
end