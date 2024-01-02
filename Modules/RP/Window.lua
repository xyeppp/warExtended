warExtendedRenownBar = warExtended.Register("warExtended Renown Bar")
local RenownBar = warExtendedRenownBar
local WINDOW_NAME = "warExtendedRenownBar"
local RP_FRAME = warExtendedDefaultRenownBar:Subclass(WINDOW_NAME)

function RenownBar.OnPlayerRenownUpdated()
    local frame = GetFrame(WINDOW_NAME)
    frame:Update()
end

function RenownBar.OnPlayerRenownRankUpdated()
    warExtended:PlaySound("renown rank up")
end

function RenownBar.OnInitialize()
    local frame = RP_FRAME:Create(WINDOW_NAME)

    frame:RegisterLayoutEditor( GetStringFromTable( "HUDStrings", StringTables.HUD.LABEL_HUD_EDIT_RP_BAR_NAME ),
            GetStringFromTable( "HUDStrings", StringTables.HUD.LABEL_HUD_EDIT_RP_BAR_DESC ),
            true, false,
            true, nil )

    frame:SetScript("player renown updated", "warExtendedRenownBar.OnPlayerRenownUpdated")
    frame:SetScript("player renown rank updated", "warExtendedRenownBar.OnPlayerRenownRankUpdated")
end




