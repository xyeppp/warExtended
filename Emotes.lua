local warExtended = warExtended
local ChatMacro = ChatMacro
local pairs = pairs

local emotes = warExtendedSet:New()

local function emoteParser(emote)
    local friendlyTarget, hostileTarget = warExtended:GetAllTargets()
    local emote = emotes:Get(emote)

    if warExtended:isNil(hostileTarget) then
        warExtended:Send(emote.hostile, '/e')
    elseif warExtended:isNil(friendlyTarget) and friendlyTarget ~= warExtended:GetPlayerName() then
        warExtended:Send(emote.friendly, '/e')
    else
        warExtended:Send(emote.notarget, '/e')
    end
end

function warExtended:RegisterEmotes(emotesTable)
    for emote, targetState in pairs(emotesTable) do
        if not emotes:Get(emote) then
            emotes:Add(emote, targetState)

            LibSlash.RegisterSlashCmd(emote,
                    function()
                        emoteParser(emote)
                    end
            )
        end
    end
end