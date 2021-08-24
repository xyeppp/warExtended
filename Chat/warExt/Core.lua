local warExtended = warExtended
local math=math
local URLpattern = warExtended.Settings.URLpattern
local URLpatterns = warExtended.Settings.URLpatterns

local function getGroupType()
  if (IsWarBandActive()) then
    return 3
  end
  if (GetNumGroupmates() > 0) then
    return 2
  end
  return 1
end


--[[function warExtended.Initialize()

    --warExtended.RegisterHooks()
   -- warExtended.RegisterSlashCore()
   -- warExtended.RegisterSlashEmotes()

end]]



--- Define new global functions
function ChatMacro(text,channel)
  text = towstring(text)
  channel = towstring(channel)


  --TargetInfo:UpdateFromClient()
  local enemyTarget = TargetInfo:UnitName("selfhostiletarget"):match(L"([^^]+)^?[^^]*")
  local friendTarget = TargetInfo:UnitName("selffriendlytarget"):match(L"([^^]+)^?[^^]*")
  local mouseTarget = TargetInfo:UnitName("mouseovertarget"):match(L"([^^]+)^?[^^]*")

  text = text:gsub(L"%$et", enemyTarget or L"<no target>")
  text = text:gsub(L"%$ft", friendTarget or L"<no target>")
  text = text:gsub(L"%$t", mouseTarget or L"<no target>")

  SendChatText(text, channel)
end
