warExtended = {}

local pairs=pairs
local ipairs=ipairs

local HyperlinkData = L"v1.0"
local HyperlinkText = L"[warExt] "
local HyperlinkColor = DefaultColor.GREEN
--Return self hyperlink
warExtended.getSelfHyperlink=CreateHyperLink( HyperlinkData, HyperlinkText, {HyperlinkColor.r, HyperlinkColor.g, HyperlinkColor.b}, {} )

-- Settings
warExtended.Settings = {}
--Automation Settings
-- Safe = accept from friends & guild only
-- Scenario = accepts from players in current scenario
warExtended.Settings.Automation = {
    ['PartyAccept'] = {
        ['safe'] = false,
        ['friends'] = false,
        ['guild'] = false,
        ['scenario'] = false,
        ['all'] = false
    },
    ['RessurectAccept'] = {
        ['safe'] = false,
        ['friends'] = false,
        ['guild'] = false,
        ['scenario'] = false,
        ['all'] = false
    },
    ['AutomaticRespawn'] = false
}

warExtended.CareerShorthandle = {
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

warExtended.CareerRole = {
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
        return warExtended.ReturnPlayerLevel()
    end,
    ['$guild'] = function()
        return warExtended.HyperlinkCreator(guild)
    end,
    ['$mastery'] = function()
        return warExtended.ReturnPlayerMastery()
    end,
    ['$warband'] = function()
        return warExtended.HyperlinkCreator(warband, playerName)
    end,
    ['$discord'] = function()
        return warExtended.HyperlinkCreator(discord)
    end,
    ['$join'] = function()
        return warExtended.HyperlinkCreator(join, playerName)
    end,
    ['$invite'] = function()
        return warExtended.HyperlinkCreator(invite, playerName)
    end,
    ['$tell'] = function()
        return warExtended.HyperlinkCreator(tell, playerName)
    end,
    ['$inspect'] = function()
        return warExtended.HyperlinkCreator(inspect, playerName)
    end,

    --Class $functions
    -- The numbers in function correspond to
    ['$ib'] = function()
        return warExtended.ReturnPlayerClassFromName(1)
    end,
    ['$bo'] = function()
        return warExtended.ReturnPlayerClassFromName(5)
    end,
    ['$wh'] = function()
        return warExtended.ReturnPlayerClassFromName(9)
    end,
    ['$eng'] = function()
        return warExtended.ReturnPlayerClassFromName(4)
    end,
    ['$sq'] = function()
        return warExtended.ReturnPlayerClassFromName(8)
    end,
    ['$chp'] = function()
        return warExtended.ReturnPlayerClassFromName(6)
    end,
    ['$sla'] = function()
        return warExtended.ReturnPlayerClassFromName(2)
    end,
    ['$sha'] = function()
        return warExtended.ReturnPlayerClassFromName(7)
    end,
    ['$rp'] = function()
        return warExtended.ReturnPlayerClassFromName(3)
    end,
    ['$kotbs'] = function()
        return warExtended.ReturnPlayerClassFromName(10)
    end,
    ['$sm'] = function()
        return warExtended.ReturnPlayerClassFromName(17)
    end,
    ['$cho'] = function()
        return warExtended.ReturnPlayerClassFromName(13)
    end,
    ['$bg'] = function()
        return warExtended.ReturnPlayerClassFromName(21)
    end,
    ['$wl'] = function()
        return warExtended.ReturnPlayerClassFromName(19)
    end,
    ['$mrd'] = function()
        return warExtended.ReturnPlayerClassFromName(14)
    end,
    ['$we'] = function()
        return warExtended.ReturnPlayerClassFromName(22)
    end,
    ['$bw'] = function()
        return warExtended.ReturnPlayerClassFromName(11)
    end,
    ['$mag'] = function()
        return warExtended.ReturnPlayerClassFromName(16)
    end,
    ['$src'] = function()
        return warExtended.ReturnPlayerClassFromName(24)
    end,
    ['$sw'] = function()
        return warExtended.ReturnPlayerClassFromName(18)
    end,
    ['$wp'] = function()
        return warExtended.ReturnPlayerClassFromName(12)
    end,
    ['$dok'] = function()
        return warExtended.ReturnPlayerClassFromName(23)
    end,
    ['$am'] = function()
        return warExtended.ReturnPlayerClassFromName(20)
    end,
    ['$zel'] = function()
        return warExtended.ReturnPlayerClassFromName(15)
    end,
    --Role message $functions
    ['$tank'] = function()
        return warExtended.ReturnPlayerRoleFromName(tank)
    end,
    ['$dps'] = function()
        return warExtended.ReturnPlayerRoleFromName(dps)
    end,
    ['$heal'] = function()
        return warExtended.ReturnPlayerRoleFromName(heal)
    end
}

function warExtended.getCurrentTargetNames()
    local HostileTargetName     =   TargetInfo:UnitName('selfhostiletarget')
    local FriendlyTargetName     =   TargetInfo:UnitName('selffriendlytarget')
    return HostileTargetName, FriendlyTargetName
end

--Checks if user has addon enabled
function warExtended.isUserAddonEnabled(addon)
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
