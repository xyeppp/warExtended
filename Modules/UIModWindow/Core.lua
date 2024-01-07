warExtendedUiMod = warExtended.Register("warExtended UI Mods/Addons")

local UiMod = warExtendedUiMod

if not UiMod.Settings then
    UiMod.Settings = {

    }
end
--[[
warExtendedUiMod = warExtended.Register("warExtended UI Mods/Addons")
local UiMod = warExtendedUiMod
local SEARCH_BOX="UiModWindowSearchEditBox"
--TODO: add profiles

local filters={}

function UiMod.OnInitialize()
  UiMod:Hook(UiModWindow.OnShown, UiMod.OnShownUiModWindow, true)
  UiMod:Hook(UiModWindow.OnHidden, UiMod.OnHiddenUiModWindow, true)
  --UiMod:RegisterSearchBox("UiModWindowSearchEditBox", UiMod.OnSearchTextChanged, filters)
end

local function toggleAddonsAndReload(...)
  WindowSetShowing( "UiModWindow", false )
  
  for addons = 1, select("#", ...) do
    local addonName = select(addons, ...)
    ModuleSetEnabled(addonName, not warExtended.IsAddonEnabled(addonName))
  end
  
  BroadcastEvent( SystemData.Events.RELOAD_INTERFACE )
end

function warExtended.ToggleAddonsAndReloadUI(...)
  local list = {...}
  local addonString = warExtended:toWString(table.concat(list, "\n"))
  
  DialogManager.MakeTwoButtonDialog (L"This will toggle the following addons and Reload UI:\n"..addonString,
          L"Yes",  function (...) toggleAddonsAndReload(...) end,
          L"No")
end

local UiMod = warExtendedUiMod
local SEARCH_BOX="UiModWindowSearchEditBox"
local TextEditBoxGetText = TextEditBoxGetText
local TextEditBoxSetText = TextEditBoxSetText

function UiMod.OnSearchTextChanged(text, filters)
  text = text or tostring(TextEditBoxGetText(SEARCH_BOX))
  UiModWindow.ShowModCategory( nil , text, filters)
end

function UiMod.OnShownUiModWindow()
  UiMod.OnSearchTextChanged()
end

function UiMod.OnHiddenUiModWindow()
  TextEditBoxSetText(SEARCH_BOX, L"")
end
]]