local warExtended = warExtended
local math=math

-- URL patterns for automatic link conversion
local URLpattern = "[a-zA-Z@:%._\+~#=%/]+%.[a-zA-Z0-9@:_\+~#=%/%?&]"
local URLpatterns = {
  -- X@X.Y url (---> email)
  "^(www%.[%w_-]+%.%S+[^%p%s])",
  "%s(www%.[%w_-]+%.%S+[^%p%s])",
  -- XXX.YYY.ZZZ.WWW:VVVV/UUUUU url
  "^(%d%d?%d?%.%d%d?%d?%.%d%d?%d?%.%d%d?%d?:%d%d?%d?%d?%d?/%S+[^%p%s])",
  "%s(%d%d?%d?%.%d%d?%d?%.%d%d?%d?%.%d%d?%d?:%d%d?%d?%d?%d?/%S+[^%p%s])",
  -- XXX.YYY.ZZZ.WWW:VVVV url (IP of ts server for example)
  "^(%d%d?%d?%.%d%d?%d?%.%d%d?%d?%.%d%d?%d?:%d%d?%d?%d?%d?)",
  "%s(%d%d?%d?%.%d%d?%d?%.%d%d?%d?%.%d%d?%d?:%d%d?%d?%d?%d?)",
  -- XXX.YYY.ZZZ.WWW/VVVVV url (---> IP)
  "^(%d%d?%d?%.%d%d?%d?%.%d%d?%d?%.%d%d?%d?/%S+[^%p%s])",
  "%s(%d%d?%d?%.%d%d?%d?%.%d%d?%d?%.%d%d?%d?/%S+[^%p%s])",
  -- XXX.YYY.ZZZ.WWW url (---> IP)
  "^(%d%d?%d?%.%d%d?%d?%.%d%d?%d?%.%d%d?%d?)",
  "%s(%d%d?%d?%.%d%d?%d?%.%d%d?%d?%.%d%d?%d?)",
  -- X.Y.Z:WWWW/VVVVV url
  "^([%w_.-]+[%w_-]%.%a%a+:%d%d?%d?%d?%d?/%S+[^%p%s])",
  "%s([%w_.-]+[%w_-]%.%a%a+:%d%d?%d?%d?%d?/%S+[^%p%s])",
  -- X.Y.Z:WWWW url  (ts server for example)
  "^([%w_.-]+[%w_-]%.%a%a+:%d%d?%d?%d?%d?)",
  "%s([%w_.-]+[%w_-]%.%a%a+:%d%d?%d?%d?%d?)",
  -- X.Y.Z/WWWWW url
  "^([%w_.-]+[%w_-]%.%a%a+/%S+[^%p%s])",
  "%s([%w_.-]+[%w_-]%.%a%a+/%S+[^#%p%s])",
  -- X.Y.Z url
  "^([%w_.-]+[%w_-]%.%a%a+)",
  "%s([%w_.-]+[%w_-]%.%a%a+)",
  -- X://Y url
  "(%a+://[%d%w_-%.]+[%.%d%w_%-%/%?%%%#=%;%:%+%&]*)",
};

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
    warExtended.RegisterCoreAndSlashCmd()
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
