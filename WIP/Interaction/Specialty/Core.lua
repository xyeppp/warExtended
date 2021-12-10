warExtendedSpecialtyTraining = warExtended.Register("warExtended Specialty Training")

warExtendedSpecialtyTraining = {
  SPECIALIZATION_PATH_1  = 1,
  SPECIALIZATION_PATH_2  = 2,
  SPECIALIZATION_PATH_3  = 3,

  MAXIMUM_LINKED_ABILITIES = 9,

  advanceData = nil,
  linkedAdvances = {
    [1] = {},
    [2] = {},
    [3] = {}
  },
  
  pathAdvances = {
    [1] = {},
    [2] = {},
    [3] = {}
  },

  initialSpecializationLevels  = {0,0,0},
  selectedSpecializationLevels = { 0, 0, 0 },

  Paths = {},
  pathFrames = {},
  abilityFrames    = {
    [1]={},
    [2]={},
    [3]={}
},
  selectedAdvances={
    [1]={},
    [2]={},
    [3]={}
  }
}

local Specialty = warExtendedSpecialtyTraining

function Specialty.RefreshDisplayPanel()
  Specialty.UpdateMasteryPointsAvailable()
end

function Specialty.LoadAdvances()
  Specialty.advanceData = GameData.Player.GetAdvanceData()
  
  -- Populate the current and initial advance levels
  for _, advanceData in pairs(Specialty.advanceData)
  do
    if (advanceData.category == GameData.CareerCategory.SPECIALIZATION)
    then
      
      -- DEBUG(L"Spec "..advanceData.packageId..L" level "..advanceData.timesPurchased..L" found.")
      Specialty.initialSpecializationLevels[advanceData.packageId] = advanceData.timesPurchased
    end
  end
  
  Specialty.selectedSpecializationLevels = { 0, 0, 0 }
end


function warExtendedSpecialtyTraining.PopulateAdvanceTables()
  
  Specialty.linkedAdvances = {
    [1] = {},
    [2] = {},
    [3] = {}
  }
  
  Specialty.pathAdvances   = {
    [1] = {},
    [2] = {},
    [3] = {}
  }
  
  for path=1,3 do
    for _, advanceData in pairs(Specialty.advanceData)
    do
      if InteractionUtils.IsAbility(advanceData)
      then
        -- DEBUG(L" Populating linked abilities, checking spec "..advanceData.abilityInfo.specialization)
        if ( (advanceData.abilityInfo.specialization == path) and
                (InteractionUtils.GetDependencyChainLength(advanceData, Specialty.advanceData) == 0) )
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
        
        if not Specialty.abilityFrames[path] then
          Specialty.abilityFrames[path] = {}
        end
        
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

    for currentIndex = relativeIndex, Specialty.MAXIMUM_LINKED_ABILITIES
    do
      local emptyWindow = "warExtendedSpecialtyTrainingPath"..path.."Ability"..currentIndex
      WindowSetShowing(emptyWindow, false)
    end
  end
end


function warExtendedSpecialtyTraining.RefreshPathLevel()

  -- Update the pathometer
  for path=1,3 do
    for index, frame in pairs(Specialty.pathFrames[path])
    do
      local currentPathLevel = Specialty.initialSpecializationLevels[path] +
              Specialty.selectedSpecializationLevels[path]

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

  local pointsAvailable = GameData.Player.GetAdvancePointsAvailable()[GameData.CareerCategory.SPECIALIZATION]
  for path=1,3 do

    for _, frame in pairs(warExtendedSpecialtyTraining.abilityFrames[path])
    do
      local advanceData = frame:GetAdvanceData()
      local requiredPathLevel = advanceData.dependencies[path]

      local currentPathLevel = Specialty.initialSpecializationLevels[path] +
              Specialty.selectedSpecializationLevels[path]

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


function warExtendedSpecialtyTraining.SetPurchaseButtonStates()
  for path=1,3 do
    local isDecrementLevelValid =  Specialty.selectedSpecializationLevels[path] > 0

    ButtonSetDisabledFlag( "warExtendedSpecialtyTrainingPath"..path.."PathDecrement", not isDecrementLevelValid )

    local pointsSpent = EA_Window_InteractionSpecialtyTraining.GetSelectedAdvanceCount() + EA_Window_InteractionSpecialtyTraining.GetSelectedSpecLevelCount()

    local pathPackageData = nil
    for _, data in ipairs(Specialty.advanceData)
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

    local atSpecializationLimit = ( (Specialty.initialSpecializationLevels[path] +
            Specialty.selectedSpecializationLevels[path])
            >= pathPackageData.maximumPurchaseCount )

    local isIncrementLevelValid = pathPackageData and
            (pointsSpent < GameData.Player.GetAdvancePointsAvailable()[GameData.CareerCategory.SPECIALIZATION]) and
            not atSpecializationLimit

    ButtonSetDisabledFlag("warExtendedSpecialtyTrainingPath"..path.."PathIncrement", not isIncrementLevelValid )

    local isTrainValid = (pointsSpent > 0)
    ButtonSetDisabledFlag( "warExtendedSpecialtyTrainingPurchaseButton", not isTrainValid )
  end

end



