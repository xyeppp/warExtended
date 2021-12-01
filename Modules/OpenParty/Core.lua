warExtendedOpenParty = warExtended.Register("warExtended Open Party")
local OpenParty = warExtendedOpenParty

--TODO: add party queue

function OpenParty.OnInitialize()
OpenParty:Hook(EA_Window_OpenPartyWorld.CreateOpenPartyTooltip, warExtendedOpenParty.OnCreateOpenPartyTooltip)
OpenParty:Hook(EA_Window_OpenPartyNearby.CreateOpenPartyTooltip, warExtendedOpenParty.OnCreateOpenPartyTooltip)
end
