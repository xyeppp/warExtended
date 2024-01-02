warExtendedDefaultExperienceBar = Frame:Subclass("warExtendedDefaultExperienceBar")

local XP_FRAME = warExtendedDefaultExperienceBar

local NUM_DIVISIONS = 10
local NUM_TICKS = NUM_DIVISIONS - 1

local LABEL = 1
local BAR = 2
local REST_BAR = 3

function XP_FRAME:GetCurrentLevel()
    return GameData.Player.battleLevel
end

function XP_FRAME:GetEarnedAndNeededExperience()
        return GameData.Player.Experience.curXpEarned, GameData.Player.Experience.curXpNeeded
end

function XP_FRAME:GetRestedExperience()
        return GameData.Player.Experience.restXp
end

function XP_FRAME:GetRestedExperiencePercent()
        local expEarned, expNeeded = self:GetEarnedAndNeededExperience()
        local restedExperience = self:GetRestedExperience()
        local restPercent = ((expEarned + restedExperience) / expNeeded)*100
        return restPercent
end

function XP_FRAME:UpdateRestLimit()
    local xOffset = self.m_barWidth * self:GetRestedExperiencePercent()

    WindowClearAnchors( self:GetName().."ContentsRestXpLimitMarker" )
    WindowAddAnchor( self:GetName().."ContentsRestXpLimitMarker", "left", self:GetName().."ContentsProgressBar", "center", xOffset, 0 )
end

function XP_FRAME:SetLabel(expEarned, expNeeded)
    local win = self.m_Windows
    win[LABEL]:SetText(GetStringFormat(StringTables.Default.TEXT_EXP_BAR, { expEarned, expNeeded }))
end

function XP_FRAME:SetStatusBarValues(expEarned, expNeeded)
    local win = self.m_Windows
  --  local earnedPoints, neededPoints = self:GetEarnedAndNeededExperience()

    win[BAR]:SetMaximumValue(expNeeded)
    win[BAR]:SetCurrentValue(expEarned)
end

function XP_FRAME:SetTicks()
    -- Dynamically Create the desired number of tick marks.
    for tickIndex = 1, NUM_TICKS do
        local windowName = self:GetName().."ContentsTick"..tickIndex
        CreateWindowFromTemplate( windowName, "EA_DynamicImage_HUDStatusBar_NarrowTickMark", self:GetName().."Contents" )
        CreateWindowFromTemplate( windowName.."Rest", "EA_DynamicImage_HUDStatusBar_NarrowTickMarkBright", self:GetName().."Contents" )
    end

    self:OnSizeUpdated( self:GetDimensions() )
end

function XP_FRAME:UpdateRestBar()
    local restedExperience = self:GetRestedExperience()
    -- Update the RestXP Bar
    local hasRest     = restedExperience > 0
    local win = self.m_Windows

    -- If the Rest Xp is on/off, update the bar art.
    if( self.m_hasRest == nil or self.m_hasRest ~= hasRest ) then

        self.m_hasRest = hasRest

        -- Background
        win[REST_BAR]:Show(hasRest)

        -- Limit Marker
        WindowSetShowing( self:GetName().."ContentsRestXpLimitMarker", hasRest )

        -- Ticks
        for tickIndex = 1, NUM_TICKS do
            WindowSetShowing( self:GetName().."ContentsTick"..tickIndex, not hasRest )
            WindowSetShowing( self:GetName().."ContentsTick"..tickIndex.."Rest", hasRest )
        end

        -- End Pieces
        WindowSetShowing( self:GetName().."ContentsLeftEndCap", not hasRest )
        WindowSetShowing( self:GetName().."ContentsRightEndCap", not hasRest )
        WindowSetShowing( self:GetName().."ContentsLeftEndCapRest", hasRest )
        WindowSetShowing( self:GetName().."ContentsRightEndCapRest", hasRest )
    end

    -- If the player has rest, update the ticks
    if( hasRest ) then

        -- The Rest XP value is the percentage of this level the player

        local restPercent = self:GetRestedExperiencePercent()
        win[REST_BAR]:SetCurrentValue(restPercent )

        -- Only show the rest and end caps if they are below the end of the bar.
        WindowSetShowing( self:GetName().."ContentsRestXpLimitMarker", restPercent < 100 )
        WindowSetShowing( self:GetName().."ContentsRightEndCap", restPercent >= 100  )

        self:UpdateRestLimit()

        -- Ticks - Show only those up to the end of the rest amount
        for tickIndex = 1, NUM_TICKS do

            local showRestTick = tickIndex/NUM_DIVISIONS <= restPercent

            WindowSetShowing( self:GetName().."ContentsTick"..tickIndex, not showRestTick )
            WindowSetShowing( self:GetName().."ContentsTick"..tickIndex.."Rest", showRestTick )
        end
    end
end

function XP_FRAME:Update()
    local expEarned, expNeeded = self:GetEarnedAndNeededExperience()

    if expNeeded == nil then
        return
    end

    --Tutorial feature
    EA_AdvancedWindowManager.UpdateWindowShowing( self:GetName().."Contents", EA_AdvancedWindowManager.WINDOW_TYPE_XP )

    self:SetLabel(expEarned, expNeeded)
    self:SetStatusBarValues(expEarned, expNeeded)
    self:UpdateRestBar()
end

function XP_FRAME:OnSizeUpdated(w, h)
    self.m_barWidth = w

    -- Update the Tick Marks to be spaced evenly across the bar
    local divWidth = w / NUM_DIVISIONS
    local x, y = WindowGetDimensions(self:GetName().."ContentsTick1" )
    local tickOffsetX = divWidth - x/2

    for tickIndex = 1, NUM_TICKS do
        local windowName = self:GetName().."ContentsTick"..tickIndex

                -- Regular Tick Mark
                WindowClearAnchors( windowName )
                WindowAddAnchor( windowName, "topleft", self:GetName().."Contents", "top", tickOffsetX, -2 )

                -- Rest Tick Mark
                WindowClearAnchors( windowName.."Rest" )
                WindowAddAnchor( windowName.."Rest", "topleft", self:GetName().."Contents", "top", tickOffsetX, -2 )

                tickOffsetX = tickOffsetX + divWidth
    end

    self:UpdateRestLimit()
end

function XP_FRAME:Create(windowName)
    local frame = GetFrame(windowName) or self:CreateFrameForExistingWindow(windowName)

    if frame then
        frame.m_Windows = {
            [LABEL] = Label:CreateFrameForExistingWindow(frame:GetName() .. "ContentsLabel"),
            [BAR] = StatusBar:CreateFrameForExistingWindow(frame:GetName() .. "ContentsProgressBar"),
            [REST_BAR] = StatusBar:CreateFrameForExistingWindow(frame:GetName() .. "ContentsRestBarBackground"),
        }

        local win = frame.m_Windows

        win[BAR]:SetBackgroundTint(DefaultColor.LIGHT_GRAY)
        win[LABEL]:Show(false)
        win[REST_BAR]:SetMaximumValue(100)

        frame:SetTicks()
        frame:Update()

        win[BAR]:StopInterpolating()

        return frame
    end
end


function XP_FRAME:SetTooltipText()
    local barFrame = FrameManager:GetMouseOverWindow()
    local TOOLTIP_ANCHOR = { Point = "bottom",  RelativeTo = barFrame.m_Name, RelativePoint = "top",  XOffset = 0, YOffset = 10 }
    local curPoints, maxPoints = barFrame:GetEarnedAndNeededExperience()
    local restPoints = barFrame:GetRestedExperience()

    local line1 = GetString( StringTables.Default.LABEL_EXP_POINTS )
    Tooltips.SetTooltipText( 1, 1, line1 )
    Tooltips.SetTooltipColorDef( 1, 1, Tooltips.COLOR_HEADING )

    local line2 = GetString( StringTables.Default.TEXT_EXP_BAR_DESC )
    Tooltips.SetTooltipText( 2, 1, line2 )

    local line3 = L""
    local line4 = L""

    if ( maxPoints == 0 ) then
        -- We're the maximum level.
        line3 = GetString( StringTables.Default.TEXT_CUR_EXP_MAXIMUM )
    else
        local percent = wstring.format(L"%d", curPoints / maxPoints * 100)
        line3 = L"Current Exp: "
        line4 = curPoints..L"/"..maxPoints..L" ("..percent..L"%)"
    end
    Tooltips.SetTooltipText( 3, 1, line3 )
    Tooltips.SetTooltipText( 3, 3, line4 )
    Tooltips.SetTooltipColorDef( 3, 1, Tooltips.COLOR_HEADING )

    if (restPoints > 0) then
        local line5 = GetString( StringTables.Default.LABEL_EXP_RESTED )..L" Exp:"
        local restPercent = wstring.format(L"%d", barFrame:GetRestedExperiencePercent())
        Tooltips.SetTooltipText( 4, 1, line5 )
        Tooltips.SetTooltipText( 4, 3, L""..restPoints..L" ("..restPercent..L"%)" )
        Tooltips.SetTooltipColorDef( 4, 1, DefaultColor.XP_COLOR_RESTED )
    end

    Tooltips.Finalize()
    Tooltips.AnchorTooltip( TOOLTIP_ANCHOR )
end

function XP_FRAME:OnMouseOver()
    Tooltips.CreateTextOnlyTooltip( self:GetName() )
    Tooltips.SetUpdateCallback( self.SetTooltipText )

    local win = self.m_Windows
    win[LABEL]:Show(true)
end

-- OnMouseOverEnd Handler for xp bar
function XP_FRAME:OnMouseOverEnd()
    local win = self.m_Windows
    win[LABEL]:Show(false)
end
