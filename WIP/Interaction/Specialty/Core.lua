warExtendedSpecialtyTraining = warExtended.Register("warExtended Specialty Training")

--TODO: look warbuilder

warExtendedSpecialtyTraining = {
  SPECIALIZATION_PATH_1  = 1,
  SPECIALIZATION_PATH_2  = 2,
  SPECIALIZATION_PATH_3  = 3,

  MAXIMUM_LINKED_ABILITIES = 9,

  advanceData = nil,
  linkedAdvances              = {
    [1] = {},
  [2]= {},
  [3] = {},
  },
  pathAdvances                = {[1]={},[2]={},[3]={}},

  initialSpecializationLevels  = { 0, 0, 0 },

  Paths = {},
  pathFrames       = {},
  abilityFrames    = {[1]={}, [2]={},[3]={}},
  selectedAdvances={[1]={},[2]={},[3]={}}
}

local Specialty = warExtendedSpecialtyTraining


function warExtendedSpecialtyTraining.PopulateAdvances()
  for path=1,3 do
    for index, advanceData in pairs(EA_Window_InteractionSpecialtyTraining.advanceData)
    do
      if InteractionUtils.IsAbility(advanceData)
      then
        -- DEBUG(L" Populating linked abilities, checking spec "..advanceData.abilityInfo.specialization)
        if ( (advanceData.abilityInfo.specialization == path) and
                (InteractionUtils.GetDependencyChainLength(advanceData, EA_Window_InteractionSpecialtyTraining.advanceData) == 0) )
        then
          table.insert(Specialty.linkedAdvances[path], advanceData)
        end
      end

      if (advanceData.category == GameData.CareerCategory.SPECIALIZATION)
      then
        -- Populate the path advances
        if (advanceData.dependencies ~= nil) and
                (advanceData.dependencies[path] ~= nil)
        then
          table.insert(Specialty.pathAdvances[path], advanceData)
        end

      end
    end

  end
end

function warExtendedSpecialtyTraining.PopulatePathAbilities()
  -- DEBUG(L"EA_Window_InteractionSpecialtyTraining.PopulatePathAbilities()")

  for path=1,3 do
    for index, advanceData in pairs(Specialty.pathAdvances[path])
    do
      local requiredPathLevel = advanceData.dependencies[path]
      local newFrame = nil

      if InteractionUtils.IsAction(advanceData)
      then
        newFrame = EA_Window_InteractionSpecialtyActionAbility:Create("warExtendedSpecialtyTrainingPath"..path.."ActionAbility"..index,
                "warExtendedSpecialtyTrainingPath"..path,
                advanceData)
         DEBUG(L"  new frame spawned at level "..requiredPathLevel)
      elseif InteractionUtils.IsMorale(advanceData)
      then
        newFrame = EA_Window_InteractionSpecialtyMoraleAbility:Create("warExtendedSpecialtyTrainingPath"..path.."MoraleAbility"..index,
                "warExtendedSpecialtyTrainingPath"..path,
                advanceData)
      elseif InteractionUtils.IsTactic(advanceData)
      then
        newFrame = EA_Window_InteractionSpecialtyTacticAbility:Create("warExtendedSpecialtyTrainingPath"..path.."TacticAbility"..index,
                "warExtendedSpecialtyTrainingPath"..path,
                advanceData)
      end

      if (newFrame ~= nil)
      then
        table.insert( Specialty.abilityFrames[path], newFrame)

        local anchorPoint = {Point="center", RelativeTo=Specialty.pathFrames[path][requiredPathLevel]:GetName().."Empty", RelativePoint="center", XOffset=0, YOffset=0}
        newFrame:SetAnchor(anchorPoint)

        newFrame:SetIcon()
        newFrame:Show(true)

        -- If the Advance was previously selected, update the state.
        if( Specialty.selectedAdvances[path][ advanceData.packageId ] ~= nil )
        then
          newFrame:SetSelected()
        end
      end
    end
  end

end

function Specialty.PopulateLinkedAbilities()
  -- DEBUG(L"EA_Window_InteractionSpecialtyTraining.PopulateLinkedAbilities()")
  -- table.sort(EA_Window_InteractionSpecialtyTraining.linkedAdvances)

  for path=1,3 do
    local relativeIndex = 1
    for _, advanceData in pairs(Specialty.linkedAdvances[path])
    do
      local linkedWindow = "warExtendedSpecialtyTrainingPath"..path.."Ability"..relativeIndex
      local iconWindow   = linkedWindow.."Icon"
      local texture, x, y = GetIconData(advanceData.abilityInfo.iconNum)
      WindowSetShowing(linkedWindow, true)
      DynamicImageSetTexture(iconWindow, texture, x, y)

      if (advanceData.timesPurchased == 0)
      then
        local color = DefaultColor.RowColors.UNAVAILABLE
        WindowSetTintColor( iconWindow, color.r, color.g, color.b )
      else
        local color = DefaultColor.RowColors.SELECTED
        WindowSetTintColor( iconWindow, color.r, color.g, color.b )
      end

      relativeIndex = relativeIndex + 1
    end

    for currentIndex = relativeIndex, EA_Window_InteractionSpecialtyTraining.MAXIMUM_LINKED_ABILITIES
    do
      local emptyWindow = "warExtendedSpecialtyTrainingPath"..path.."Ability"..currentIndex
      WindowSetShowing(emptyWindow, false)
    end
  end
end




function warExtendedSpecialtyTraining.OnShown()
  LabelSetText("warExtendedSpecialtyTrainingPath1Title", GetStringFormat(StringTables.Default.LABEL_SPECIALIZATION_TITLE, { GetSpecializationPathName(GameData.Player.SPECIALIZATION_PATH_1) } ) )
  LabelSetText("warExtendedSpecialtyTrainingPath2Title", GetStringFormat(StringTables.Default.LABEL_SPECIALIZATION_TITLE, { GetSpecializationPathName(GameData.Player.SPECIALIZATION_PATH_2) } ) )
  LabelSetText("warExtendedSpecialtyTrainingPath3Title", GetStringFormat(StringTables.Default.LABEL_SPECIALIZATION_TITLE, { GetSpecializationPathName(GameData.Player.SPECIALIZATION_PATH_3) } ) )
  LabelSetText("warExtendedSpecialtyTrainingTitleBarText", L"Ability Training")

    local pointsTotal     = GameData.Player.GetAdvancePointsAvailable()[GameData.CareerCategory.SPECIALIZATION]
    local pointsSpent     = EA_Window_InteractionSpecialtyTraining.GetSelectedAdvanceCount() + EA_Window_InteractionSpecialtyTraining.GetSelectedSpecLevelCount()
    local pointsRemaining = pointsTotal - pointsSpent
    local pointText       = GetStringFormatFromTable("TrainingStrings", StringTables.Training.LABEL_SPECIALIZATION_POINTS_LEFT, { L""..pointsRemaining } )

    LabelSetText("warExtendedSpecialtyTrainingMasteryPointPurse", pointText)

  DynamicImageSetTexture( "warExtendedSpecialtyTrainingPath1Background", "career_mastery_image1", 0, 0 )
  DynamicImageSetTexture( "warExtendedSpecialtyTrainingPath2Background", "career_mastery_image2", 0, 0 )
  DynamicImageSetTexture( "warExtendedSpecialtyTrainingPath3Background", "career_mastery_image3", 0, 0 )





  for specializationPath=1,3 do
    Specialty.pathFrames[specializationPath] = {}
    for frameNumber = 1, 15
    do
      Specialty.pathFrames[specializationPath][frameNumber] = EA_Window_InteractionSpecialtyTrainingLevel:CreateFrameForExistingWindow("warExtendedSpecialtyTrainingPath"..specializationPath.."SpecializationStep"..frameNumber)
    end

  end


  warExtendedSpecialtyTraining.PopulateAdvances()
  warExtendedSpecialtyTraining.PopulateLinkedAbilities()
  warExtendedSpecialtyTraining.PopulatePathAbilities()


end


function warExtendedSpecialtyTraining.RefreshPathLevel()

  -- Update the pathometer
  for path=1,3 do
    for index, frame in pairs(warExtendedSpecialtyTraining.pathFrames[path])
    do
      local currentPathLevel = EA_Window_InteractionSpecialtyTraining.initialSpecializationLevels[path] +
              EA_Window_InteractionSpecialtyTraining.selectedSpecializationLevels[path]

      if (index <= currentPathLevel)
      then
        frame:SetFull()
      else
        frame:SetEmpty()
      end
    end

  end
end

function warExtendedSpecialtyTraining.RefreshPathAbilities()
  -- DEBUG(L"EA_Window_InteractionSpecialtyTraining.RefreshPathAbilities()")

  local pointsAvailable = GameData.Player.GetAdvancePointsAvailable()[GameData.CareerCategory.SPECIALIZATION]
  for path=1,3 do

    for _, frame in pairs(warExtendedSpecialtyTraining.abilityFrames[path])
    do
      local advanceData = frame:GetAdvanceData()
      local requiredPathLevel = advanceData.dependencies[path]

      local currentPathLevel = EA_Window_InteractionSpecialtyTraining.initialSpecializationLevels[path] +
              EA_Window_InteractionSpecialtyTraining.selectedSpecializationLevels[path]

      -- DEBUG(L"  "..advanceData.advanceName..L" requires "..requiredPathLevel..L" <= ("..EA_Window_InteractionSpecialtyTraining.initialSpecializationLevels[EA_Window_InteractionSpecialtyTraining.currentTab]..L" + "..EA_Window_InteractionSpecialtyTraining.selectedSpecializationLevels[EA_Window_InteractionSpecialtyTraining.currentTab]..L")")
      if ( requiredPathLevel and (requiredPathLevel <= currentPathLevel) )
      then
        local pointsSpent     = EA_Window_InteractionSpecialtyTraining.GetSelectedAdvanceCount() + EA_Window_InteractionSpecialtyTraining.GetSelectedSpecLevelCount()

        if (advanceData.timesPurchased > 0)
        then
          frame:SetPurchased()
        elseif (frame:IsSelected() )
        then
          frame:SetSelected()
        elseif ( pointsSpent >= pointsAvailable )
        then
          frame:SetUnavailable()
        else
          frame:SetAvailable()
        end
      else
        frame:SetUnavailable()
      end
    end

  end

end

function warExtendedSpecialtyTraining.RefreshInteractivePane()
  warExtendedSpecialtyTraining.RefreshPathLevel()
  warExtendedSpecialtyTraining.RefreshPathAbilities()
  warExtendedSpecialtyTraining.SetPurchaseButtonStates()
end

function warExtendedSpecialtyTraining.SetPurchaseButtonStates()
  for path=1,3 do
    local isDecrementLevelValid =  EA_Window_InteractionSpecialtyTraining.selectedSpecializationLevels[path] > 0

    ButtonSetDisabledFlag( "warExtendedSpecialtyTrainingPath"..path.."PathDecrement", not isDecrementLevelValid )

    local pointsSpent = EA_Window_InteractionSpecialtyTraining.GetSelectedAdvanceCount() + EA_Window_InteractionSpecialtyTraining.GetSelectedSpecLevelCount()

    local pathPackageData = nil
    for _, data in ipairs(EA_Window_InteractionSpecialtyTraining.advanceData)
    do
      -- if this is the package(s) we are looking for
      if ( (GameData.CareerCategory.SPECIALIZATION == data.category) and
              (1 == data.tier) and
              (path == data.packageId) )
      then
        pathPackageData = data
        break
      end
    end

    local atSpecializationLimit = ( (EA_Window_InteractionSpecialtyTraining.initialSpecializationLevels[path] +
            EA_Window_InteractionSpecialtyTraining.selectedSpecializationLevels[path])
            >= pathPackageData.maximumPurchaseCount )

    local isIncrementLevelValid = pathPackageData and
            (pointsSpent < GameData.Player.GetAdvancePointsAvailable()[GameData.CareerCategory.SPECIALIZATION]) and
            not atSpecializationLimit

    ButtonSetDisabledFlag("warExtendedSpecialtyTrainingPath"..path.."PathIncrement", not isIncrementLevelValid )

    local isTrainValid = (pointsSpent > 0)
    ButtonSetDisabledFlag( "warExtendedSpecialtyTrainingPurchaseButton", not isTrainValid )
  end

end




WindowRegisterEventHandler("warExtendedSpecialtyTraining", SystemData.Events.PLAYER_CAREER_CATEGORY_UPDATED,  "EA_Window_InteractionSpecialtyTraining.Refresh")
WindowRegisterEventHandler("warExtendedSpecialtyTraining", SystemData.Events.PLAYER_MONEY_UPDATED,            "EA_Window_InteractionSpecialtyTraining.UpdatePlayerResources" )
WindowRegisterEventHandler("warExtendedSpecialtyTraining", SystemData.Events.PLAYER_ABILITIES_LIST_UPDATED,   "EA_Window_InteractionSpecialtyTraining.Refresh" )
WindowRegisterEventHandler("warExtendedSpecialtyTraining", SystemData.Events.PLAYER_SINGLE_ABILITY_UPDATED,   "EA_Window_InteractionSpecialtyTraining.Refresh" )
WindowRegisterEventHandler("warExtendedSpecialtyTraining", SystemData.Events.PLAYER_CAREER_LINE_UPDATED,      "EA_Window_InteractionSpecialtyTraining.OnCareerLineUpdated" )
