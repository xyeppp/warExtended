local warExtended = warExtended
local pairs=pairs

local emotes = {
    ['spit'] = {
        ['hostile'] = 'spits on $et. How disgusting!',
        ["friendly"] = 'spits on $ft. How disgusting!',
        ['notarget'] = 'spits on himself...'
    },
    ['amaze'] = {
        ['hostile'] = ' You are amazed by $et',
        ['friendly'] = 'You are amazed by $ft',
        ['notarget'] = 'is amazed!'
    },
    ['scared'] = {
        ['hostile'] = ' You are scared of $et',
        ['friendly'] = 'You are scared of $ft',
        ['notarget'] = 'is scared.'
    }
}

local function emoteParser(emote)
    local friendlyTarget, hostileTarget = warExtended:GetAllTargets()
    local emote=emotes[emote]

    if hostileTarget then
        ChatMacro(emote.hostile, '/e')
        return
    elseif friendlyTarget and friendlyTarget ~= warExtended:GetPlayerName() then
        ChatMacro(emote.friendly, '/e')
        return
    else
        ChatMacro(emote.notarget, '/e')
        return
    end
end

function warExtended.RegisterEmotes()
    for emote,_ in pairs(emotes) do
        LibSlash.RegisterSlashCmd(emote,
                function()
                    emoteParser(emote)
                end
        )
    end
end
