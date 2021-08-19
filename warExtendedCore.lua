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


function warExtended.Initialize()

    warExtended.RegisterHooks()
    warExtended.RegisterSlashCore()
    warExtended.RegisterSlashEmotes()

end



--- Define new global functions
function ChatMacro(text,channel)
    text = towstring(text)
    channel = towstring(channel)

    TargetInfo:UpdateFromClient()
    local enemyTarget = TargetInfo:UnitName("selfhostiletarget"):match(L"([^^]+)^?[^^]*")
    local friendTarget = TargetInfo:UnitName("selffriendlytarget"):match(L"([^^]+)^?[^^]*")
    local mouseTarget = TargetInfo:UnitName("mouseovertarget"):match(L"([^^]+)^?[^^]*")

    SendChatText(text, channel)
end

function TellTarget(input)
  local target = (TargetInfo:UnitName("selffriendlytarget"))
  p(target)
  SendChatText(L"/tell "..target..L" "..towstring(input), L"")
end

function ReplyLastWhisper(input)
  local lastWhisperPlayer = ChatManager.LastTell.name
  SendChatText(L"/tell "..lastWhisperPlayer..L" "..towstring(input), L"")
end

function InviteLastWhisper()
  local lastWhisperPlayer = ChatManager.LastTell.name
  SendChatText(L"/invite "..lastWhisperPlayer, L"")
end
