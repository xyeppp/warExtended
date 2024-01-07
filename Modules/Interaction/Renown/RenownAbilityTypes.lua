local Renown = warExtendedRenownTraining

local ADVANCE_CATEGORY_9 = 9
local ADVANCE_CATEGORY_10 = 10
local ADVANCE_CATEGORY_11 = 11
local ADVANCE_CATEGORY_12 = 12
local ADVANCE_CATEGORY_13 = 13
local ADVANCE_CATEGORY_14 = 14
local ADVANCE_CATEGORY_15 = 15

local BASIC_TYPE = "Basic"
local ADVANCED_TYPE = "Advanced"
local ABILITIES_TYPE = "Abilities"
local DEFENSIVE_TYPE = "Defensive"

local renownAdvanceTypes = {
    [ADVANCE_CATEGORY_9] = {
        [1] = BASIC_TYPE,
        [6] = BASIC_TYPE,
        [11] = BASIC_TYPE,
        [16] = BASIC_TYPE
    },
    [ADVANCE_CATEGORY_10] = {
        [1] = BASIC_TYPE,
        [6] = BASIC_TYPE,
        [11] = BASIC_TYPE,
        [16] = BASIC_TYPE
    },
    [ADVANCE_CATEGORY_11] = {
        [1] = ADVANCED_TYPE,
        [5] = ADVANCED_TYPE,
        [9] = ADVANCED_TYPE,
        [13] = ADVANCED_TYPE
    },
    [ADVANCE_CATEGORY_12] = {
        [1] = DEFENSIVE_TYPE,
        [5] = DEFENSIVE_TYPE,
    },
    [ADVANCE_CATEGORY_13] = {
        [1] = ADVANCED_TYPE,
        [4] = ADVANCED_TYPE,
        [7] = ABILITIES_TYPE,
        [10] = ABILITIES_TYPE,
    },
    [ADVANCE_CATEGORY_14] = {
        [1] = DEFENSIVE_TYPE,
        [5] = DEFENSIVE_TYPE,
        [9] = DEFENSIVE_TYPE,
        [14] = DEFENSIVE_TYPE
    },
    [ADVANCE_CATEGORY_15] = {
        [1] = ABILITIES_TYPE,
        [4] = ABILITIES_TYPE,
        [7] = ABILITIES_TYPE,
        [9] = ABILITIES_TYPE
    }
}

function Renown.GetBaseRenownAdvanceType(advanceData)
    return renownAdvanceTypes[advanceData.category][advanceData.packageId], advanceData.advanceCategory
end