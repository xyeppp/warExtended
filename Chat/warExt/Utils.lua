warExtended = {}

local pairs=pairs
local ipairs=ipairs

warExtended.Settings = {}
-- Safe = accept from friends & guild only
-- Scenario = accepts from players in current scenario
warExtended.Settings.Automation = {
    ['AcceptParty'] = {
        ['safe'] = false,
        ['friends'] = false,
        ['guild'] = false,
        ['scenario'] = false,
        ['all'] = false
    },
    ['AcceptRessurect'] = {
        ['safe'] = false,
        ['friends'] = false,
        ['guild'] = false,
        ['scenario'] = false,
        ['all'] = false
    },
    ['AutoRespawn'] = false
}


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

warExtended.CareerToShorthandle = {
    [GameData.CareerLine.IRON_BREAKER] = 'IB',
    [GameData.CareerLine.SWORDMASTER] = 'SM',
    [GameData.CareerLine.CHOSEN] = 'CH',
    [GameData.CareerLine.BLACK_ORC] = 'BO',
    [GameData.CareerLine.KNIGHT] = 'KOTBS',
    [GameData.CareerLine.BLACKGUARD] = 'BG',
    [GameData.CareerLine.WITCH_HUNTER] = 'WH',
    [GameData.CareerLine.WHITE_LION] = 'WL',
    [GameData.CareerLine.MARAUDER] = 'MRD',
    [GameData.CareerLine.WITCH_ELF] = 'WE',
    [GameData.CareerLine.BRIGHT_WIZARD] = 'BW',
    [GameData.CareerLine.MAGUS] = 'MAG',
    [GameData.CareerLine.SORCERER] = 'SRC',
    [GameData.CareerLine.ENGINEER] = 'ENG',
    [GameData.CareerLine.SHADOW_WARRIOR] = 'SW',
    [GameData.CareerLine.SQUIG_HERDER] = 'SH',
    [GameData.CareerLine.CHOPPA] = 'CHP',
    [GameData.CareerLine.SLAYER or GameData.CareerLine.HAMMERER] = 'SLA',
    [GameData.CareerLine.WARRIOR_PRIEST] = 'WP',
    [GameData.CareerLine.DISCIPLE] = 'DOK',
    [GameData.CareerLine.ARCHMAGE] = 'AM',
    [GameData.CareerLine.SHAMAN] = 'SHA',
    [GameData.CareerLine.RUNE_PRIEST] = 'RP',
    [GameData.CareerLine.ZEALOT] = 'ZEL'
}

warExtended.CareerToRole = {
    [GameData.CareerLine.IRON_BREAKER] = 'tanks',
    [GameData.CareerLine.SWORDMASTER] = 'tanks',
    [GameData.CareerLine.CHOSEN] = 'tanks',
    [GameData.CareerLine.BLACK_ORC] = 'tanks',
    [GameData.CareerLine.KNIGHT] = 'tanks',
    [GameData.CareerLine.BLACKGUARD] = 'tanks',
    [GameData.CareerLine.WITCH_HUNTER] = 'mdps',
    [GameData.CareerLine.WHITE_LION] = 'mdps',
    [GameData.CareerLine.MARAUDER] = 'mdps',
    [GameData.CareerLine.WITCH_ELF] = 'mdps',
    [GameData.CareerLine.BRIGHT_WIZARD] = 'rdps',
    [GameData.CareerLine.MAGUS] = 'rdps',
    [GameData.CareerLine.SORCERER] = 'rdps',
    [GameData.CareerLine.ENGINEER] = 'rdps',
    [GameData.CareerLine.SHADOW_WARRIOR] = 'rdps',
    [GameData.CareerLine.SQUIG_HERDER] = 'rdps',
    [GameData.CareerLine.CHOPPA] = 'mdps',
    [GameData.CareerLine.SLAYER or GameData.CareerLine.HAMMERER] = 'mdps',
    [GameData.CareerLine.WARRIOR_PRIEST] = 'healers',
    [GameData.CareerLine.DISCIPLE] = 'healers',
    [GameData.CareerLine.ARCHMAGE] = 'healers',
    [GameData.CareerLine.SHAMAN] = 'healers',
    [GameData.CareerLine.RUNE_PRIEST] = 'healers',
    [GameData.CareerLine.ZEALOT] = 'healers'
}

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

    --Class $functions
    -- The numbers in function correspond to
    ['$ib'] = function()
        return warExtended.GetCareerShorthandle(1)
    end,
    ['$bo'] = function()
        return warExtended.GetCareerShorthandle(5)
    end,
    ['$wh'] = function()
        return warExtended.GetCareerShorthandle(9)
    end,
    ['$eng'] = function()
        return warExtended.GetCareerShorthandle(4)
    end,
    ['$sq'] = function()
        return warExtended.GetCareerShorthandle(8)
    end,
    ['$chp'] = function()
        return warExtended.GetCareerShorthandle(6)
    end,
    ['$sla'] = function()
        return warExtended.GetCareerShorthandle(2)
    end,
    ['$sha'] = function()
        return warExtended.GetCareerShorthandle(7)
    end,
    ['$rp'] = function()
        return warExtended.GetCareerShorthandle(3)
    end,
    ['$kotbs'] = function()
        return warExtended.GetCareerShorthandle(10)
    end,
    ['$sm'] = function()
        return warExtended.GetCareerShorthandle(17)
    end,
    ['$cho'] = function()
        return warExtended.GetCareerShorthandle(13)
    end,
    ['$bg'] = function()
        return warExtended.GetCareerShorthandle(21)
    end,
    ['$wl'] = function()
        return warExtended.GetCareerShorthandle(19)
    end,
    ['$mrd'] = function()
        return warExtended.GetCareerShorthandle(14)
    end,
    ['$we'] = function()
        return warExtended.GetCareerShorthandle(22)
    end,
    ['$bw'] = function()
        return warExtended.GetCareerShorthandle(11)
    end,
    ['$mag'] = function()
        return warExtended.GetCareerShorthandle(16)
    end,
    ['$src'] = function()
        return warExtended.GetCareerShorthandle(24)
    end,
    ['$sw'] = function()
        return warExtended.GetCareerShorthandle(18)
    end,
    ['$wp'] = function()
        return warExtended.GetCareerShorthandle(12)
    end,
    ['$dok'] = function()
        return warExtended.GetCareerShorthandle(23)
    end,
    ['$am'] = function()
        return warExtended.GetCareerShorthandle(20)
    end,
    ['$zel'] = function()
        return warExtended.GetCareerShorthandle(15)
    end,
    --Role message $functions
    ['$tank'] = function()
        return warExtended.GetCareerRole(tank)
    end,
    ['$dps'] = function()
        return warExtended.GetCareerRole(dps)
    end,
    ['$heal'] = function()
        return warExtended.GetCareerRole(heal)
    end
}

function warExtended.GetCurrentTargetNames()
    local HostileTargetName     =   TargetInfo:UnitName('selfhostiletarget')
    local FriendlyTargetName     =   TargetInfo:UnitName('selffriendlytarget')
    return HostileTargetName, FriendlyTargetName
end

function warExtended.IsUserAddonEnabled(addon)
    local mods = ModulesGetData()
    for k, v in ipairs(mods) do
        if v.name == addon then
            if v.isEnabled then
                return true
            else
                return false
            end
            break
        end
    end
end


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
