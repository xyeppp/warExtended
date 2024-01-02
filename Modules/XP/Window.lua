warExtendedExperienceBar = warExtended.Register("warExtended Experience Bar")
local ExperienceBar = warExtendedExperienceBar
local WINDOW_NAME = "warExtendedExperienceBar"

function ExperienceBar.OnPlayerExperienceUpdated()
    local frame = GetFrame(WINDOW_NAME)
    frame:Update()
end

function ExperienceBar.OnInitialize()
    local frame = warExtendedDefaultExperienceBar:Create(WINDOW_NAME)

    frame:RegisterLayoutEditor( GetStringFromTable( "HUDStrings", StringTables.HUD.LABEL_HUD_EDIT_XP_BAR_NAME ),
            GetStringFromTable( "HUDStrings", StringTables.HUD.LABEL_HUD_EDIT_XP_BAR_DESC ),
            true, false,
            true, nil )

    frame:SetScript("player exp updated", "warExtendedExperienceBar.OnPlayerExperienceUpdated")
end




