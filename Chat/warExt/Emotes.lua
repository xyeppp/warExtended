local warExtended = warExtended
local pairs=pairs

local EmoteList = {
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
    local HostileTarget, FriendlyTarget = warExtended:GetTargetNames()
    emote=EmoteList[emote]

    if HostileTarget  then
        return ChatMacro(emote.hostile, '/e')
    elseif FriendlyTarget then
        return ChatMacro(emote.friendly, '/e')
    else
        return ChatMacro(emote.notarget, '/e')
    end

end

function warExtended.RegisterSlashEmotes()
    for Emote,_ in pairs(EmoteList) do
        LibSlash.RegisterSlashCmd(Emote,
				   function()
                emoteParser(Emote)
            end
        )
    end
end
