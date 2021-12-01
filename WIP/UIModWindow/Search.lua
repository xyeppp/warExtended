local UiMod = warExtendedUiMod
local SEARCH_BOX="UiModWindowSearchEditBox"
local TextEditBoxGetText = TextEditBoxGetText
local TextEditBoxSetText = TextEditBoxSetText

function UiMod.OnSearchTextChanged(text)
  text = text or TextEditBoxGetText(SEARCH_BOX)
  text = UiMod:StringToNoCaseIgnoreSpecial(text)

  UiModWindow.ShowModCategory( nil , text)
end

function UiMod.SetSearchLabel()
  LabelSetText("UiModWindowSearchEditBoxTitleLabel", L"Search:")
end

function UiMod.OnShownUiModWindow()
  UiMod.OnSearchTextChanged()
end

function UiMod.OnHiddenUiModWindow()
  TextEditBoxSetText(SEARCH_BOX, L"")
end