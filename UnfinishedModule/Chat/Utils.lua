warExtended.Settings.URLpattern = "[a-zA-Z@:%._\+~#=%/]+%.[a-zA-Z0-9@:_\+~#=%/%?&]"
warExtended.Settings.URLpatterns = {
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

--Define chat $functions
warExtended.ChatFunctionNames = {
    --General $functions
    ['$level'] = function()
        return warExtended.GetPlayerLevel()
    end,
    ['$guild'] = function()
        return warExtended.GetHyperlink(guild, nil)
    end,
    ['$mastery'] = function()
        return warExtended.GetPlayerMastery()
    end,
    ['$warband'] = function()
        return warExtended.GetHyperlink(warband, playerName)
    end,

    ['$discord'] = function()
        return warExtended.GetHyperlink(discord, nil)
    end,
    ['$join'] = function()
        return warExtended.GetHyperlink(join, playerName)
    end,
    ['$invite'] = function()
        return warExtended.GetHyperlink(invite, playerName)
    end,
    ['$tell'] = function()
        return warExtended.GetHyperlink(tell, playerName)
    end,
    ['$inspect'] = function()
        return warExtended.GetHyperlink(inspect, playerName)
    end,
}

--[[warExtended.Settings.Tester = {}
warExtended.Settings.discord =  ""
warExtended.Settings.tellMessage1 =  "x"
warExtended.Settings.tellMessage2 =  "xx"
warExtended.Settings.chatMessage1 = "LFG BS"
warExtended.Settings.chatMessage1Channel =  "/5"
warExtended.Settings.chatMessage2 =  "LFG BB/BE"
warExtended.Settings.chatMessage2Channel =  "/5"
warExtended.Settings.smartChannel1 = false;
warExtended.Settings.smartChannel2 = false;
warExtended.Settings.GuildLink =  "Guildless"
warExtended.Settings.oldQNAmessage =  ""
warExtended.Settings.oldQNAmasteryMessage =  ""
warExtended.Settings.discord =  ""
warExtended.Settings.MacroCopy = false;
warExtended.Settings.Career = nil;
warExtended.Settings.AlertToggle = false;
warExtended.Settings.AlertText =  ""

warExtended.Settings.AutoJoin = false

warExtended.Settings.MacroSet1 = {}
warExtended.Settings.macroSet2 = {}
warExtended.Settings.RegisteredMacros = false;
warExtended.Settings.SelectedSet = 1
warExtended.Settings.PingMessage =  ""
warExtended.Settings.PingChannel =  ""
warExtended.Settings.MarkToggle = 1
warExtended.Settings.AutoRespawn = false;
warExtended.Settings.PartyJoinerStart = false;
]]
