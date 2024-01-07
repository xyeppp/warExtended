local Renown = warExtendedRenownTraining
local warExtended = warExtended

local MAX_ROW = 4

local WINDOW_NAME                 = "warExtendedRenownTraining"
local TAB_TEMPLATE_NAME           = "warExtendedRenownTrainingTabWindow"

local WINDOW                      = Frame:Subclass(WINDOW_NAME)
local TITLEBAR                    = 1
local TAB_GROUP                  = 2
local BASIC_GROUP                    = 3
local ADVANCED_GROUP                   = 4
local ABILITIES_GROUP              = 5
local DEFENSIVE_GROUP              = 6
local RESPEC_BUTTON                 = 7
local TRAIN_BUTTON                  = 8
local CANCEL_BUTTON                  = 9
local PURSE_LABEL                  = 10
local ICON_IMAGE                    = 11
local TITLE_TEXT                    = 13
local DESCRIPTION_TEXT              = 14
local INCREMENT_BUTTON              = 15
local DECREMENT_BUTTON              = 16

local linkedAdvances = {}

local TRAINING_PATH = Frame:Subclass("warExtendedRenownTrainingPanel")

--TODO: separate this as it doesn't process on very first load correctly (or pin with even somewhere else)

function TRAINING_PATH:Create(advanceData, advanceIndex, parentName)
    local frame = self:CreateFromTemplate(parentName..(advanceData.advanceID), parentName)
    local abilityInfo = advanceData.abilityInfo

    if frame then
        frame.m_timesPurchased = 0
        frame.m_maxPurchased = 0
        frame.m_selectedSpecializationLevels = 0
        frame.m_initialSpecializationLevels = 0
        frame.m_advanceIndex = advanceIndex
        frame.m_advanceId = advanceData.advanceID
        frame.m_advanceName = advanceData.advanceName
        frame.m_category = advanceData.category
        frame.m_packageId = advanceData.packageId

        frame.m_linkedAdvances = {
            [1] = {
                advanceId = advanceData.advanceID,
                advanceIndex = advanceIndex
            }
        }

        frame.m_Windows = {
            [ICON_IMAGE] = warExtendedDefaultIconButton:Create(frame:GetName().."Icon", frame:GetName()) ,
            [TITLE_TEXT] = Label:CreateFrameForExistingWindow(frame:GetName().."Title"),
            [DESCRIPTION_TEXT] = Label:CreateFrameForExistingWindow(frame:GetName().."Description"),
            [INCREMENT_BUTTON] = ButtonFrame:CreateFrameForExistingWindow(frame:GetName().."PathIncrement"),
            [DECREMENT_BUTTON] = ButtonFrame:CreateFrameForExistingWindow(frame:GetName().."PathDecrement")
        }

        local win = frame.m_Windows

        win[TITLE_TEXT]:SetText(advanceData.advanceName)

        win[ICON_IMAGE]:SetAnchor({
           Point = "top", RelativePoint = "bottom", RelativeTo = frame:GetName().."Title", XOffset = 0, YOffset = -8
        })

        win[ICON_IMAGE]:Show(true)
        win[ICON_IMAGE]:SetIcon(advanceData.advanceIcon)
        win[ICON_IMAGE]:SetId(advanceIndex)

        win[INCREMENT_BUTTON]:SetText("+")
        win[DECREMENT_BUTTON]:SetText("-")

        frame:GetDependencies()
        frame:CreatePathFrames()
        frame:SetPurchaseButtonStates()

        frame:Show(true)

        win[ICON_IMAGE].OnMouseOver = function(self, ...)
            local priceString = GetStringFormatFromTable("TrainingStrings", StringTables.Training.TEXT_RENOWN_POINT_COST, { L""..Renown.advanceData[self:GetId()].pointCost } )

            if (abilityInfo)
            then
                Tooltips.CreateAbilityTooltip(abilityInfo, SystemData.ActiveWindow.name, EA_Window_InteractionRenownTraining.ANCHOR_CURSOR, priceString )
            else
                warExtended:CreateTextTooltip(self:GetName(), {
                    [1]={{text = Renown.advanceData[self:GetId()].advanceName, color=Tooltips.COLOR_HEADING}},
                    [2]={{text = GetStringFromTable( "PackageDescriptions", Renown.advanceData[self:GetId()].advanceID )}},
                    [3]={{text = priceString}}}, nil, EA_Window_InteractionRenownTraining.ANCHOR_CURSOR)
            end
        end

        return frame
    end
end

function TRAINING_PATH:Update()
    win = self.m_Windows

    win[ICON_IMAGE]:SetIcon(Renown.advanceData[self.m_linkedAdvances[self.m_timesPurchased].advanceIndex].advanceIcon)
    win[ICON_IMAGE]:SetId(self.m_linkedAdvances[self.m_timesPurchased].advanceIndex)

    win[TITLE_TEXT]:SetText(Renown.advanceData[self.m_linkedAdvances[self.m_timesPurchased].advanceIndex].advanceName)
end

function TRAINING_PATH:CreatePathFrames()
    self.m_pathFrames =  {}

    for index=1,#self.m_linkedAdvances do
        local advance = Renown.advanceData[self.m_linkedAdvances[index].advanceIndex]
        self.m_pathFrames[index] = EA_Window_InteractionSpecialtyTrainingLevel:CreateFrameForExistingWindow(self:GetName().."SpecializationStep"..index)

        if advance.timesPurchased > 0 then
            self.m_timesPurchased = self.m_timesPurchased + 1
            self:Update()
            self.m_pathFrames[index]:SetFull()
        else
            self.m_pathFrames[index]:SetEmpty()
        end
    end

    for i=#self.m_linkedAdvances +1,5 do
        DestroyWindow(self:GetName().."SpecializationStep"..i)
    end

end

local Specialty = warExtendedSpecialtyTraining

function TRAINING_PATH:SetPurchaseButtonStates()
    for path=1,#self.m_linkedAdvances do
        local isDecrementLevelValid =  self.m_selectedSpecializationLevels > 0

        ButtonSetDisabledFlag( self:GetName().."PathDecrement", not isDecrementLevelValid )

        local pointsSpent = EA_Window_InteractionSpecialtyTraining.GetSelectedAdvanceCount() + EA_Window_InteractionSpecialtyTraining.GetSelectedSpecLevelCount()

        local pathPackageData = nil
        for _, data in pairs(Renown.advanceData)
        do
            -- if this is the package(s) we are looking for
            if ( (GameData.CareerCategory.RENOWN_STATS == data.category) and
                    (path == data.packageId) )
            then
                pathPackageData = data
                break
            end
        end

        if pathPackageData then
            local atSpecializationLimit = ((self.m_initialSpecializationLevels +
                    self.m_selectedSpecializationLevels)
                    >= pathPackageData.maximumPurchaseCount )
        end

        local isIncrementLevelValid = pathPackageData and
                (pointsSpent < GameData.Player.GetAdvancePointsAvailable()[GameData.CareerCategory.RENOWN_STATS_A]) and
                not atSpecializationLimit

        ButtonSetDisabledFlag(self:GetName().."PathIncrement", not isIncrementLevelValid )

        local isTrainValid = (pointsSpent > 0)
        ButtonSetDisabledFlag( "warExtendedSpecialtyTrainingPurchaseButton", not isTrainValid )
    end
end


function TRAINING_PATH:GetDependencies()
    for index, advanceData in pairs(Renown.advanceData) do
        if self.m_category == advanceData.category then
            for packageId, _ in pairs(advanceData.dependencies) do
                local dependentData = InteractionUtils.GetDependentPackage( advanceData, packageId, Renown.advanceData )

                for _, advance in pairs(self.m_linkedAdvances) do
                    if advance.advanceId == dependentData.advanceID then

                        self.m_linkedAdvances[#self.m_linkedAdvances+1]  = {
                            advanceId = advanceData.advanceID,
                            advanceIndex = index
                        }

                    end
                end
            end
        end
    end
end

--TODO:Change position in table to advanceIndex for easier adding of dependency chains
--TODO: Add mouseover with Levels and their descriptions onto icon

local TAB_GROUP_WINDOW = Frame:Subclass(TAB_TEMPLATE_NAME)

function TAB_GROUP_WINDOW:OnInitialize(...)
    local currentAdvance = 0

    if warExtended:IsTableEmpty(Renown.advanceData) then
        self:GetParent():LoadAdvances()
    end

    self.m_Windows = {}

    for advanceIndex, advanceData in pairs(Renown.advanceData) do
        local advanceType, _ = Renown.GetBaseRenownAdvanceType(advanceData)

        if advanceType and self:GetName():match(advanceType) then
            currentAdvance = currentAdvance + 1
            self.m_Windows[currentAdvance] = TRAINING_PATH:Create(advanceData, advanceIndex, self:GetName())

            if currentAdvance%MAX_ROW == 1 then
                self.m_Windows[currentAdvance]:SetAnchor({
                    Point = "bottom", RelativePoint = "bottom", RelativeTo = self.m_Windows[1]:GetName(), XOffset = 0, YOffset = 375
                })
            elseif currentAdvance > 1 then
                self.m_Windows[currentAdvance]:SetAnchor({
                    Point = "right", RelativePoint = "right", RelativeTo = self.m_Windows[currentAdvance-1]:GetName(), XOffset = 192, YOffset = 0
                })
            end
        end
    end
end

function TAB_GROUP_WINDOW:OnShown(...)
end

function WINDOW:Create()
    self:CreateFromTemplate(WINDOW_NAME)

    self.m_Windows            = {
        [TITLEBAR] = Label:CreateFrameForExistingWindow(WINDOW_NAME .. "TitleBarLabel"),
        [TAB_GROUP] = TabGroup:Create(WINDOW_NAME .. "Tab", Renown.Settings),
        [BASIC_GROUP] = TAB_GROUP_WINDOW:CreateFromTemplate(WINDOW_NAME.."Basic", WINDOW_NAME),
        [ADVANCED_GROUP] = TAB_GROUP_WINDOW:CreateFromTemplate(WINDOW_NAME.."Advanced", WINDOW_NAME),
        [ABILITIES_GROUP] = TAB_GROUP_WINDOW:CreateFromTemplate(WINDOW_NAME.."Abilities", WINDOW_NAME),
        [DEFENSIVE_GROUP] = TAB_GROUP_WINDOW:CreateFromTemplate(WINDOW_NAME.."Defensive", WINDOW_NAME),
        [RESPEC_BUTTON] = ButtonFrame:CreateFrameForExistingWindow(WINDOW_NAME.."RespecializeButton"),
        [TRAIN_BUTTON] = ButtonFrame:CreateFrameForExistingWindow(WINDOW_NAME.."TrainButton"),
        [CANCEL_BUTTON] = ButtonFrame:CreateFrameForExistingWindow(WINDOW_NAME.."CancelButton"),
        [PURSE_LABEL] = Label:CreateFrameForExistingWindow(WINDOW_NAME.."PurseLabel"),
    }

    local win = self.m_Windows

    win[TAB_GROUP]:AddExistingTab(WINDOW_NAME .. "TabBasic", win[BASIC_GROUP]:GetName(), L"Basic")
    win[TAB_GROUP]:AddExistingTab(WINDOW_NAME .. "TabAdvanced", win[ADVANCED_GROUP]:GetName(), L"Advanced")
    win[TAB_GROUP]:AddExistingTab(WINDOW_NAME .. "TabAbilities", win[ABILITIES_GROUP]:GetName(), L"Abilities")
    win[TAB_GROUP]:AddExistingTab(WINDOW_NAME .. "TabDefensive", win[DEFENSIVE_GROUP]:GetName(), L"Defensive")

    win[TITLEBAR]:SetText(GetStringFromTable( "TrainingStrings", StringTables.Training.LABEL_RENOWN_TRAINING_TITLE ))

    win[RESPEC_BUTTON]:SetText(GetString( StringTables.Default.LABEL_PURCHASE_RESPECIALIZATION ))
    win[TRAIN_BUTTON]:SetText(GetStringFromTable("TrainingStrings", StringTables.Training.LABEL_PURCHASE_TRAINING ))
    win[CANCEL_BUTTON]:SetText(GetStringFromTable("TrainingStrings", StringTables.Training.LABEL_CANCEL_TRAINING ))

    win[CANCEL_BUTTON].OnLButtonUp = function(self, ...)
        EA_Window_InteractionRenownTraining.Hide()
    end
end

function WINDOW:LoadAdvances()
    for _, data in pairs(GameData.Player.GetAdvanceData()) do
        if InteractionUtils.IsRenownAdvance(data) then
            Renown.advanceData[#Renown.advanceData+1] = data
        end
    end
end

function WINDOW:UpdatePlayerResources()
    local pointsRemaining = EA_Window_InteractionRenownTraining.GetPointsAvailable()
    local pointsSpent     = EA_Window_InteractionRenownTraining.GetPointsSpent()
    local pointText       = GetStringFormatFromTable("TrainingStrings", StringTables.Training.LABEL_RENOWN_PURSE, { L""..pointsRemaining, L""..pointsSpent } )

    local win = self.m_Windows
    win[PURSE_LABEL]:SetText(pointText)
end

function WINDOW:OnShown(...)
    self:LoadAdvances()
    self:UpdatePlayerResources()
end

function WINDOW:OnHidden(...)
end

WINDOW:Create()