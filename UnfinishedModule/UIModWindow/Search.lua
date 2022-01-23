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