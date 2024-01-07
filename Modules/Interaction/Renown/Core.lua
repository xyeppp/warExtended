----------------------------------------------------------------
-- Local variables
----------------------------------------------------------------
warExtendedRenownTraining =
{
    advanceData      = {},
    selectedAdvances = {},
    selectedCosts    = 0,

    SORT_ASCENDING   = true,
    SORT_DESCENDING  = false,
    currentSort      = 2,
    sortButtonData   = {},
    pointsSpent      = 0,

    ANCHOR_CURSOR    = { Point = "topleft", RelativeTo = "CursorWindow", RelativePoint = "bottomleft", XOffset = 30, YOffset = -20 },


    Settings =
    {
        availabilityFilter = true,
    }
}

local Renown = warExtendedRenownTraining
local Interaction = warExtendedInteraction
