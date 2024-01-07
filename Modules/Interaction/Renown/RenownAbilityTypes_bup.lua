local Renown = warExtendedRenownTraining

renownAbilityTypes = {
    Basic = {
        [9] = { 1, 6, 11, 16 },
        [10] = { 1, 6, 11, 16 }
    },
    Advanced = {
        [11] = { 1, 5, 9, 13 },
        [13] = { 1, 4 }
    },
    Abilities = {
        [13] = { 7, 10, },
        [15] = { 1, 4, 7, 9 }
    },
    Defensive = {
        [12] = { 1, 5, },
        [14] = { 1, 5, 9, 14 }
    },
}

function Renown.GetRenownAdvanceType(advanceData)
    for advanceType, advanceCategory in pairs(renownAbilityTypes) do
        for _, advance in pairs(advanceCategory) do
            for _, advanceId in pairs(advance) do
                p(advance)
                if advanceData.packageId == advanceId and advanceCategory == advanceData.category then
                    p(advanceType, advanceData.advanceName)
                end
            end
        end
    end
end


--[[for k,v in pairs(warExtendedRenownTraining.advanceData) do
--     warExtendedRenownTraining.GetRenownAdvanceType(v)
--end]]
