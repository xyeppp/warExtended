EA_Window_InteractionSpecialtyTraining = {}

function EA_Window_InteractionSpecialtyTraining.Show()
    WindowSetShowing( "warExtendedSpecialtyTraining", true )
    
    warExtendedSpecialtyTraining.Refresh()
    warExtendedSpecialtyTraining.PopulateSpecialty()
end

function EA_Window_InteractionSpecialtyTraining.Hide()
    WindowSetShowing( "warExtendedSpecialtyTraining", false )
end

----------------------------------------------------------------
-- Event Handlers
----------------------------------------------------------------
function EA_Window_InteractionSpecialtyTraining.MouseOverLinkedAbility()

    local pathLevel = WindowGetId(WindowGetParent(WindowGetParent(SystemData.MouseOverWindow.name)))
    local advanceIndex = WindowGetId(SystemData.MouseOverWindow.name)

    if (advanceIndex ~= 0)
    then
        local advanceData = warExtendedSpecialtyTraining.linkedAdvances[pathLevel][advanceIndex]
        local abilityData = advanceData.abilityInfo

        if (abilityData ~= nil)
        then
            -- Move package limit to ability level
            abilityData["minimumRank"] = advanceData.minimumRank
            
            -- DUMP_TABLE(abilityData)
            Tooltips.CreateAbilityTooltip( abilityData, SystemData.ActiveWindow.name )
        else
            -- This isn't an ability so look up the relevent package tooltip.
            Tooltips.CreateTextOnlyTooltip(SystemData.ActiveWindow.name)

            Tooltips.SetTooltipText( 1, 1, advanceData.advanceName )
            Tooltips.SetTooltipColorDef( 1, 1, Tooltips.COLOR_HEADING )
            Tooltips.SetTooltipText( 2, 1, GetStringFromTable( "PackageDescriptions", advanceData.advanceID ) )
            Tooltips.Finalize()

            -- Tooltips.AnchorTooltip( EA_Window_InteractionTraining.PACKAGE_TOOLTIP_ANCHOR )
        end
    end

end

function EA_Window_InteractionSpecialtyTraining.MouseOverSpecializationAbility()
    local advanceData = FrameManager:GetMouseOverWindow():GetAdvanceData()
    local abilityData = advanceData.abilityInfo

    if (abilityData ~= nil)
    then
        -- Move package limit to ability level
        abilityData["minimumRank"] = advanceData.minimumRank
        Tooltips.CreateAbilityTooltip( abilityData, SystemData.ActiveWindow.name )
    end
end

function EA_Window_InteractionSpecialtyTraining.SelectSpecializationAbility()
    
    if ( ButtonGetDisabledFlag( SystemData.ActiveWindow.name ) )
    then
        return
    end

    local selectedFrame = FrameManager:GetMouseOverWindow()

    local pointsTotal     = GameData.Player.GetAdvancePointsAvailable()[GameData.CareerCategory.SPECIALIZATION]
    local pointsSpent     = EA_Window_InteractionSpecialtyTraining.GetSelectedAdvanceCount() + EA_Window_InteractionSpecialtyTraining.GetSelectedSpecLevelCount()
    local pointsRemaining = pointsTotal - pointsSpent

    if (selectedFrame:IsSelected())
    then
        selectedFrame:SetAvailable()
    elseif (pointsRemaining > 0)
    then
        selectedFrame:SetSelected()
    end
    
    warExtendedSpecialtyTraining.RefreshDisplayPanel()
    warExtendedSpecialtyTraining.RefreshInteractivePanel()
end

function EA_Window_InteractionSpecialtyTraining.IncrementSpecialization()
    local path = (WindowGetId(WindowGetParent(SystemData.MouseOverWindow.name)))
    
    if (ButtonGetDisabledFlag("warExtendedSpecialtyTrainingPath"..path.."PathIncrement") == false)
    then
        warExtendedSpecialtyTraining.selectedSpecializationLevels[path]
            = warExtendedSpecialtyTraining.selectedSpecializationLevels[path]  + 1
        
        warExtendedSpecialtyTraining.RefreshInteractivePanel()
        warExtendedSpecialtyTraining.RefreshDisplayPanel()
    end
end

function EA_Window_InteractionSpecialtyTraining.DecrementSpecialization()
    local path = (WindowGetId(WindowGetParent(SystemData.MouseOverWindow.name)))
    
    if (ButtonGetDisabledFlag("warExtendedSpecialtyTrainingPath"..path.."PathIncrement") == false)
    then
        warExtendedSpecialtyTraining.selectedSpecializationLevels[path]
                = warExtendedSpecialtyTraining.selectedSpecializationLevels[path]  -1
        
        warExtendedSpecialtyTraining.RefreshInteractivePanel()
        warExtendedSpecialtyTraining.RefreshDisplayPanel()
    end
end

function EA_Window_InteractionSpecialtyTraining.PurchaseAdvances()
    if (ButtonGetDisabledFlag( "warExtendedSpecialtyTrainingPurchaseButton" ))
    then
        return
    end
    
    for path = 1, 3
    do
        local levelsToPurchase = warExtendedSpecialtyTraining.selectedSpecializationLevels[path]
        local levelPurchaseCount = 0
        
        while (levelPurchaseCount < levelsToPurchase)
        do
            BuyCareerPackage( 1, GameData.CareerCategory.SPECIALIZATION, path )
            levelPurchaseCount = levelPurchaseCount + 1
        end
    end
    
    for path = 1,3 do
        for packageId, advanceData in pairs(warExtendedSpecialtyTraining.selectedAdvances[path] )
        do
            BuyCareerPackage( advanceData.tier, advanceData.category, packageId )
        end
    end
    
    ButtonSetDisabledFlag( "warExtendedSpecialtyTrainingPurchaseButton", true )
end

function EA_Window_InteractionSpecialtyTraining.Respecialize()
    local respecCost = GameData.Player.GetSpecialtyRefundCost()
    local pointsSpent = GameData.Player.GetAdvancePointsSpent()[GameData.CareerCategory.SPECIALIZATION]
    
    if (pointsSpent == 0)
    then
        -- There are no points to refund. In this case this button acts as a simple Reset.
        warExtendedSpecialtyTraining.ClearSelection()
        warExtendedSpecialtyTraining.Refresh()
    elseif (respecCost > GameData.Player.money)
    then
        DialogManager.MakeOneButtonDialog( GetStringFormatFromTable("TrainingStrings", StringTables.Training.TEXT_RESPEC_NOT_ENOUGH_MONEY, { MoneyFrame.FormatMoneyString (respecCost) }),
                                           GetString( StringTables.Default.LABEL_OKAY ), nil )
    else
        DialogManager.MakeTwoButtonDialog( GetStringFormatFromTable("TrainingStrings", StringTables.Training.TEXT_RESPEC_CONFIRMATION, { MoneyFrame.FormatMoneyString (respecCost) }),
                                           GetString(StringTables.Default.LABEL_YES), RefundSpecialtyPoints,
                                           GetString(StringTables.Default.LABEL_NO) )
    end
end

----------------------------------------------------------------
-- Utility Functions
----------------------------------------------------------------
function EA_Window_InteractionSpecialtyTraining.GetSelectedAdvanceCount()
    local selectedAdvanceCount = 0
    

    -- Account for the selections aross all tabs
    for _, selectedAdvances in pairs( warExtendedSpecialtyTraining.selectedAdvances )
    do
        for _, _ in pairs( selectedAdvances )
        do
            selectedAdvanceCount = selectedAdvanceCount + 1
        end
    end
    
    return selectedAdvanceCount
end


function EA_Window_InteractionSpecialtyTraining.GetSelectedSpecLevelCount()

    local specLevelCount = 0

    for _, numLevels in pairs(warExtendedSpecialtyTraining.selectedSpecializationLevels)
    do
        specLevelCount = specLevelCount + numLevels
    end
    
    return specLevelCount

end


----------------------------------------------------------------
-- Specialization Mastery Path Level Frame
----------------------------------------------------------------
EA_Window_InteractionSpecialtyTrainingLevel = Frame:Subclass("EA_Templates_SpecializationStep")

function EA_Window_InteractionSpecialtyTrainingLevel:Create(windowName, parentWindow)
    -- Create should do nothing, this frame class only attaches to existing frames
    return nil
end

function EA_Window_InteractionSpecialtyTrainingLevel:Update(elapsedTime)

end

function EA_Window_InteractionSpecialtyTrainingLevel:SetFull()
    WindowSetShowing( self:GetName().."Full", true )
    
    local fullColor = DefaultColor.OWNED_SPECIALIZATION_LEVEL_TEXT
    self:SetTextColor(fullColor.r, fullColor.g, fullColor.b)
end

function EA_Window_InteractionSpecialtyTrainingLevel:SetEmpty()
    WindowSetShowing( self:GetName().."Full", false )
    
    local emptyColor = DefaultColor.WHITE
    self:SetTextColor(emptyColor.r, emptyColor.g, emptyColor.b)
end

function EA_Window_InteractionSpecialtyTrainingLevel:SetText(labelText)
    LabelSetText( self:GetName().."LevelText", labelText)
end

function EA_Window_InteractionSpecialtyTrainingLevel:SetTextColor(r, g, b)
    LabelSetTextColor(self:GetName().."LevelText", r, g, b)
end

----------------------------------------------------------------
-- Specialization Mastery Path Action Ability Frame
----------------------------------------------------------------
EA_Window_InteractionSpecialtyActionAbility = Frame:Subclass("EA_Templates_SpecializationActionAbility")

function EA_Window_InteractionSpecialtyActionAbility:Create(windowName, parentName, advanceData)
    local abilityFrame = self:CreateFromTemplate(windowName, parentName)

    if (abilityFrame ~= nil)
    then
        abilityFrame.m_AdvanceData = advanceData
        abilityFrame.m_IsSelected  = false
    end
    
    return abilityFrame
end

function EA_Window_InteractionSpecialtyActionAbility:SetIcon()
    local texture, x, y = GetIconData(self.m_AdvanceData.abilityInfo.iconNum)
    DynamicImageSetTexture(self:GetName().."Icon", texture, x, y)
end

function EA_Window_InteractionSpecialtyActionAbility:SetPurchased()
    ButtonSetDisabledFlag( self:GetName(), true )
    ButtonSetCheckButtonFlag( self:GetName(), false )
    ButtonSetStayDownFlag( self:GetName(), true )
    ButtonSetPressedFlag(  self:GetName(), true )

    local color = DefaultColor.RowColors.SELECTED
    WindowSetTintColor( self:GetName().."Icon", color.r, color.g, color.b )
    WindowSetShowing( self:GetName().."BackgroundRule", false)

    self.m_IsSelected = false
    warExtendedSpecialtyTraining.selectedAdvances[WindowGetId(WindowGetParent(self:ParentGetName()))][self.m_AdvanceData.packageId] = nil
end

function EA_Window_InteractionSpecialtyActionAbility:SetAvailable()
    ButtonSetDisabledFlag( self:GetName(), false )
    ButtonSetCheckButtonFlag( self:GetName(), true )
    ButtonSetStayDownFlag( self:GetName(), false )
    ButtonSetPressedFlag( self:GetName(), false )

    local color = DefaultColor.RowColors.AVAILABLE
    WindowSetTintColor( self:GetName().."Icon", color.r, color.g, color.b )
    WindowSetShowing( self:GetName().."BackgroundRule", true)
    DynamicImageSetTextureSlice( self:GetName().."BackgroundRule", "white-bar" )

    self.m_IsSelected = false
    warExtendedSpecialtyTraining.selectedAdvances[WindowGetId(WindowGetParent(self:ParentGetName()))][self.m_AdvanceData.packageId] = nil
end

function EA_Window_InteractionSpecialtyActionAbility:SetSelected()
    ButtonSetDisabledFlag( self:GetName(), false )
    ButtonSetCheckButtonFlag( self:GetName(), true )
    ButtonSetStayDownFlag( self:GetName(), false )
    ButtonSetPressedFlag( self:GetName(), true )

    local color = DefaultColor.RowColors.SELECTED
    WindowSetTintColor( self:GetName().."Icon", color.r, color.g, color.b )
    WindowSetShowing( self:GetName().."BackgroundRule", false)

    self.m_IsSelected = true
    warExtendedSpecialtyTraining.selectedAdvances[WindowGetId(WindowGetParent(self:ParentGetName()))][self.m_AdvanceData.packageId] = self.m_AdvanceData
end

function EA_Window_InteractionSpecialtyActionAbility:SetUnavailable()
    ButtonSetDisabledFlag( self:GetName(), true )
    ButtonSetPressedFlag( self:GetName(), false )
    
    local color = DefaultColor.RowColors.UNAVAILABLE
    WindowSetTintColor( self:GetName().."Icon", color.r, color.g, color.b )
    WindowSetShowing( self:GetName().."BackgroundRule", true)
    DynamicImageSetTextureSlice( self:GetName().."BackgroundRule", "grey-bar" )

    self.m_IsSelected = false
    warExtendedSpecialtyTraining.selectedAdvances[WindowGetId(WindowGetParent(self:ParentGetName()))][self.m_AdvanceData.packageId] = nil
end

function EA_Window_InteractionSpecialtyActionAbility:GetAdvanceData()
    return self.m_AdvanceData
end

function EA_Window_InteractionSpecialtyActionAbility:IsSelected()
    return self.m_IsSelected
end

----------------------------------------------------------------
-- Specialization Mastery Path Morale Ability Frame
----------------------------------------------------------------
EA_Window_InteractionSpecialtyMoraleAbility = Frame:Subclass("EA_Templates_SpecializationMoraleAbility")

function EA_Window_InteractionSpecialtyMoraleAbility:Create(windowName, parentName, advanceData)
    local abilityFrame = self:CreateFromTemplate(windowName, parentName)

    if (abilityFrame ~= nil)
    then
        abilityFrame.m_AdvanceData = advanceData
        abilityFrame.m_IsSelected  = false
    end
    
    return abilityFrame
end

function EA_Window_InteractionSpecialtyMoraleAbility:SetIcon()
    local texture, x, y = GetIconData(self.m_AdvanceData.abilityInfo.iconNum)
    CircleImageSetTexture(self:GetName().."Icon", texture, 32, 32)
end

function EA_Window_InteractionSpecialtyMoraleAbility:SetPurchased()
    ButtonSetDisabledFlag( self:GetName(), true )
    ButtonSetCheckButtonFlag( self:GetName(), false )
    ButtonSetStayDownFlag( self:GetName(), true )
    ButtonSetPressedFlag(  self:GetName(), true )
    
    local color = DefaultColor.RowColors.SELECTED
    WindowSetTintColor( self:GetName().."Icon", color.r, color.g, color.b )
    WindowSetShowing( self:GetName().."BackgroundRule", false)

    self.m_IsSelected = false
    warExtendedSpecialtyTraining.selectedAdvances[WindowGetId(WindowGetParent(self:ParentGetName()))][self.m_AdvanceData.packageId] = nil
end

function EA_Window_InteractionSpecialtyMoraleAbility:SetSelected()
    ButtonSetDisabledFlag( self:GetName(), false )
    ButtonSetCheckButtonFlag( self:GetName(), true )
    ButtonSetStayDownFlag( self:GetName(), false )
    ButtonSetPressedFlag( self:GetName(), true )

    local color = DefaultColor.RowColors.SELECTED
    WindowSetTintColor( self:GetName().."Icon", color.r, color.g, color.b )
    WindowSetShowing( self:GetName().."BackgroundRule", false)

    self.m_IsSelected = true
    warExtendedSpecialtyTraining.selectedAdvances[WindowGetId(WindowGetParent(self:ParentGetName()))][self.m_AdvanceData.packageId] = self.m_AdvanceData
end

function EA_Window_InteractionSpecialtyMoraleAbility:SetAvailable()
    ButtonSetDisabledFlag( self:GetName(), false )
    ButtonSetCheckButtonFlag( self:GetName(), true )
    ButtonSetStayDownFlag( self:GetName(), false )
    ButtonSetPressedFlag( self:GetName(), false )

    local color = DefaultColor.RowColors.AVAILABLE
    WindowSetTintColor( self:GetName().."Icon", color.r, color.g, color.b )
    WindowSetShowing( self:GetName().."BackgroundRule", true)
    DynamicImageSetTextureSlice( self:GetName().."BackgroundRule", "white-bar" )

    self.m_IsSelected = false
    warExtendedSpecialtyTraining.selectedAdvances[WindowGetId(WindowGetParent(self:ParentGetName()))][self.m_AdvanceData.packageId] = nil
end

function EA_Window_InteractionSpecialtyMoraleAbility:SetUnavailable()
    ButtonSetDisabledFlag( self:GetName(), true )
    ButtonSetPressedFlag( self:GetName(), false )

    local color = DefaultColor.RowColors.UNAVAILABLE
    WindowSetTintColor( self:GetName().."Icon", color.r, color.g, color.b )
    WindowSetShowing( self:GetName().."BackgroundRule", true)
    DynamicImageSetTextureSlice( self:GetName().."BackgroundRule", "grey-bar" )
    
    self.m_IsSelected = false
    warExtendedSpecialtyTraining.selectedAdvances[WindowGetId(WindowGetParent(self:ParentGetName()))][self.m_AdvanceData.packageId] = nil
end

function EA_Window_InteractionSpecialtyMoraleAbility:GetAdvanceData()
    return self.m_AdvanceData
end

function EA_Window_InteractionSpecialtyMoraleAbility:IsSelected()
    return self.m_IsSelected
end

----------------------------------------------------------------
-- Specialization Mastery Path Tactic Ability Frame
----------------------------------------------------------------
EA_Window_InteractionSpecialtyTacticAbility = Frame:Subclass("EA_Templates_SpecializationTacticAbility")

function EA_Window_InteractionSpecialtyTacticAbility:Create(windowName, parentName, advanceData)
    local abilityFrame = self:CreateFromTemplate(windowName, parentName)

    if (abilityFrame ~= nil)
    then
        abilityFrame.m_AdvanceData = advanceData
        abilityFrame.m_IsSelected  = false
    end
    
    return abilityFrame
end

function EA_Window_InteractionSpecialtyTacticAbility:SetPurchased()
    ButtonSetDisabledFlag( self:GetName(), true )
    ButtonSetCheckButtonFlag( self:GetName(), false )
    ButtonSetStayDownFlag( self:GetName(), true )
    ButtonSetPressedFlag(  self:GetName(), true )

    local color = DefaultColor.RowColors.SELECTED
    WindowSetTintColor( self:GetName().."Icon", color.r, color.g, color.b )
    WindowSetShowing( self:GetName().."BackgroundRule", false)
    
    self.m_IsSelected = false
    warExtendedSpecialtyTraining.selectedAdvances[WindowGetId(WindowGetParent(self:ParentGetName()))][self.m_AdvanceData.packageId] = nil
end

function EA_Window_InteractionSpecialtyTacticAbility:SetAvailable()
    ButtonSetDisabledFlag( self:GetName(), false )
    ButtonSetCheckButtonFlag( self:GetName(), true )
    ButtonSetStayDownFlag( self:GetName(), false )
    ButtonSetPressedFlag( self:GetName(), false )

    local color = DefaultColor.RowColors.AVAILABLE
    WindowSetTintColor( self:GetName().."Icon", color.r, color.g, color.b )
    WindowSetShowing( self:GetName().."BackgroundRule", true)
    DynamicImageSetTextureSlice( self:GetName().."BackgroundRule", "white-bar" )

    self.m_IsSelected = false
    warExtendedSpecialtyTraining.selectedAdvances[WindowGetId(WindowGetParent(self:ParentGetName()))][self.m_AdvanceData.packageId] = nil
end

function EA_Window_InteractionSpecialtyTacticAbility:SetSelected()
    ButtonSetDisabledFlag( self:GetName(), false )
    ButtonSetCheckButtonFlag( self:GetName(), true )
    ButtonSetStayDownFlag( self:GetName(), false )
    ButtonSetPressedFlag( self:GetName(), true )

    local color = DefaultColor.RowColors.SELECTED
    WindowSetTintColor( self:GetName().."Icon", color.r, color.g, color.b )
    WindowSetShowing( self:GetName().."BackgroundRule", false)
    
    self.m_IsSelected = true
    warExtendedSpecialtyTraining.selectedAdvances[WindowGetId(WindowGetParent(self:ParentGetName()))][self.m_AdvanceData.packageId] = self.m_AdvanceData
  end

function EA_Window_InteractionSpecialtyTacticAbility:SetUnavailable()
    ButtonSetDisabledFlag( self:GetName(), true )
    ButtonSetPressedFlag( self:GetName(), false )
    
    local color = DefaultColor.RowColors.UNAVAILABLE
    WindowSetTintColor( self:GetName().."Icon", color.r, color.g, color.b )
    WindowSetShowing( self:GetName().."BackgroundRule", true)
    DynamicImageSetTextureSlice( self:GetName().."BackgroundRule", "grey-bar" )
    
    self.m_IsSelected = false
    warExtendedSpecialtyTraining.selectedAdvances[WindowGetId(WindowGetParent(self:ParentGetName()))][self.m_AdvanceData.packageId] = nil
end

function EA_Window_InteractionSpecialtyTacticAbility:SetIcon()
    local texture, x, y = GetIconData(self.m_AdvanceData.abilityInfo.iconNum)
    DynamicImageSetTexture(self:GetName().."Icon", texture, x, y)
end

function EA_Window_InteractionSpecialtyTacticAbility:GetAdvanceData()
    return self.m_AdvanceData
end

function EA_Window_InteractionSpecialtyTacticAbility:IsSelected()
    return self.m_IsSelected
end
