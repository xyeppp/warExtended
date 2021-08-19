local warExtended = warExtended
local pairs=pairs

--$et and $ft get automatically translated upon sending the message via ChatMacro function
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
    local HostileTargetName, FriendlyTargetName = warExtended.GetCurrentTargetNames()

    if HostileTargetName ~= L""  then
        return ChatMacro(EmoteList[emote].hostile, '/e')
    elseif FriendlyTargetName ~= L"" then
        return ChatMacro(EmoteList[emote].friendly, '/e')
    else
        return ChatMacro(EmoteList[emote].notarget, '/e')
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
