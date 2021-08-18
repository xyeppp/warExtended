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
        ['notarget'] = L'is amazed!'
    },
    ['scared'] = {
        ['hostile'] = L' You are scared of $et',
        ['friendly'] = L'You are scared of $ft',
        ['notarget'] = L'is scared.'
    }
}

local function emoteParser(emote)
    local HostileTargetName, FriendlyTargetName = warExtended.GetCurrentTargetNames()
    if HostileTargetName ~= L"" then
        ChatMacro(EmoteList[emote].hostile, '/e')
    elseif FriendlyTargetName ~= L"" then
        ChatMacro(EmoteList[emote].friendly, '/e')
    else
        ChatMacro(EmoteList[emote].notarget, '/e')
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
