local keymap = {}

function ChatMacro(text,channel)
  text = towstring(text)
  channel = towstring(channel)
  local enemyTarget, friendTarget, mouseTarget = warExtended:GetTargetNames()
  --textFilter(text)

  text = text:gsub(L"%$et", enemyTarget or L"<no target>")
  text = text:gsub(L"%$ft", friendTarget or L"<no target>")
  text = text:gsub(L"%$mt", mouseTarget or L"<no target>")

  SendChatText(text, channel)
end