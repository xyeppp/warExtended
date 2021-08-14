local warExtended = warExtended
local pairs=pairs

--$et and $ft get automatically translated upon sending the message via ChatMacro function
local EmoteList = {
    ['spit'] = {
        ['hostile'] = L'spits on $et. How disgusting!',
        ["friendly"] = L'spits on $ft. How disgusting!',
        ['notarget'] = L'spits on himself...'
    },
    ['amaze'] = {
        ['hostile'] = L' You are amazed by $et',
        ['friendly'] = L'You are amazed by $ft',
        ['notarget'] = L'You are amazed!'
    },
    ['scared'] = {
        ['hostile'] = L' You are scared of $et',
        ['friendly'] = L'You are scared of $ft',
        ['notarget'] = L'You are amazed!'
    }
}

function warExtended.RegisterSlashEmotes()
    for Emote,_ in pairs(EmoteList) do
        LibSlash.RegisterSlashCmd(Emote,
				   function()
                warExtended.EmoteParser(Emote)
            end
        )
    end
end

function warExtended.EmoteParser(emote)
    local HostileTargetName, FriendlyTargetName = warExtended.getCurrentTargetNames()
    if HostileTargetName ~= L"" then
        ChatMacro(EmoteList[emote].hostile, '/e')
    elseif FriendlyTargetName ~= L"" then
        ChatMacro(EmoteList[emote].friendly, '/e')
    else
        ChatMacro(EmoteList[emote].notarget, '/e')
    end
end
