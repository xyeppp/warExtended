local keymap = {}
--Register your keymap with the following table format and object:RegisterKeymap
--
--local keymapTable = {
--  [text] = function,
--  [text2] = function,
--}
--
--Everything else will get handled automatically for you.


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