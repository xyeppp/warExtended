warExtendedDefaultRenownBar = warExtendedDefaultExperienceBar:Subclass("warExtendedDefaultRenownBar")

local RP_FRAME = warExtendedDefaultRenownBar

local NUM_DIVISIONS = 8
local NUM_TICKS = NUM_DIVISIONS - 1

local LABEL = 1
local BAR = 2

function RP_FRAME:GetCurrentLevel()
    return GameData.Player.Renown.curRank
end

function RP_FRAME:GetEarnedAndNeededExperience()
        return GameData.Player.Renown.curRenownEarned, GameData.Player.Renown.curRenownNeeded
end

function RP_FRAME:SetLabel()
    local win = self.m_Windows
    win[LABEL]:SetText(GetStringFormat(StringTables.Default.TEXT_RENOWN_BAR, { self:GetEarnedAndNeededExperience() }))
end

function RP_FRAME:SetStatusBarValues()
    local win = self.m_Windows
    local earnedPoints, neededPoints = self:GetEarnedAndNeededExperience()

    win[BAR]:SetMaximumValue(neededPoints)
    win[BAR]:SetCurrentValue(earnedPoints)
end

function RP_FRAME:Update()
    --Used for the tutorial.
    EA_AdvancedWindowManager.UpdateWindowShowing( self:GetName().."Contents", EA_AdvancedWindowManager.WINDOW_TYPE_RP )

    self:SetLabel()
    self:SetStatusBarValues()
end

function RP_FRAME:SetTooltipText()
    local barFrame = FrameManager:GetMouseOverWindow()
    local TOOLTIP_ANCHOR = { Point = "bottom",  RelativeTo = barFrame.m_Name, RelativePoint = "top",  XOffset = 0, YOffset = 10 }
    local curPoints, maRpoints = barFrame:GetEarnedAndNeededExperience()

    local percent = L"0"

    if(maRpoints > 0)
    then
        percent = wstring.format(L"%d", curPoints/maRpoints*100)
    end

    local title = GameData.Player.Renown.curTitle
    if( title == L"" ) then
        title = GetString( StringTables.Default.LABEL_NONE)
    end

    local line1 = GetString( StringTables.Default.LABEL_RENOWN_POINTS )
    local line2 = GetString( StringTables.Default.TEXT_RENOWN_BAR_DESC )
    local line3 = GetString( StringTables.Default.LABEL_RENOWN_RANK )..L": "
    local line4 = GetString( StringTables.Default.LABEL_CUR_TITLE )..L": "
    local line5 = GetStringFormat( StringTables.Default.TEXT_CUR_RENOWN, {curPoints, maRpoints, percent } )
    local line6 = curPoints..L"/"..maRpoints..L" ("..percent..L"%)"

    Tooltips.SetTooltipText( 1, 1, line1)
    Tooltips.SetTooltipColorDef( 1, 1, Tooltips.COLOR_HEADING )
    Tooltips.SetTooltipText( 2, 1, line2)
    Tooltips.SetTooltipText( 3, 1, line3)
    Tooltips.SetTooltipText( 3, 3, towstring(GameData.Player.Renown.curRank))
    Tooltips.SetTooltipColorDef( 3, 1, Tooltips.COLOR_HEADING )
    Tooltips.SetTooltipText( 4, 1, line4)
    Tooltips.SetTooltipText( 4, 3, title)
    Tooltips.SetTooltipColorDef( 4, 1, Tooltips.COLOR_HEADING )
    Tooltips.SetTooltipText( 5, 1, L"Current Renown: ")
    Tooltips.SetTooltipText( 5, 3, line6)
    Tooltips.SetTooltipColorDef( 5, 1, Tooltips.COLOR_HEADING )
    Tooltips.Finalize();
    Tooltips.AnchorTooltip( TOOLTIP_ANCHOR )
end

function RP_FRAME:OnMouseOver()
    Tooltips.CreateTextOnlyTooltip( self:GetName() )
    Tooltips.SetUpdateCallback( self.SetTooltipText )

    local win = self.m_Windows
    win[LABEL]:Show(true)
end

function RP_FRAME:OnMouseOverEnd()
    local win = self.m_Windows
    win[LABEL]:Show(false)
end

function RP_FRAME:SetTicks()
    for tickIndex = 1, NUM_TICKS do
        local windowName = self:GetName().."ContentsTick"..tickIndex

        -- Alternate the tick marks
        if( math.mod( tickIndex, 2 ) == 1 ) then
            CreateWindowFromTemplate( windowName, "EA_DynamicImage_HUDStatusBar_WideTickMarkMini", self:GetName().."Contents")
        else
            CreateWindowFromTemplate( windowName, "EA_DynamicImage_HUDStatusBar_WideTickMark", self:GetName().."Contents" )
        end
    end

    self:OnSizeUpdated( self:GetDimensions() )
end

function RP_FRAME:OnSizeUpdated(w, h)
    -- Update the Tick Marks to be spaced evenly across the bar
    local divisionWidth = w / NUM_DIVISIONS

    local x, y = WindowGetDimensions( self:GetName().."ContentsTick1" )
    local tickOffsetX = divisionWidth - x/2

    for tickIndex = 1, NUM_TICKS do

        local windowName = self:GetName().."ContentsTick"..tickIndex

        WindowClearAnchors( windowName )
        WindowAddAnchor( windowName, "topleft", self:GetName().."Contents", "top", tickOffsetX, 1 )

        tickOffsetX = tickOffsetX + divisionWidth
    end
end

function RP_FRAME:Create(windowName)
    local frame = self:CreateFrameForExistingWindow(windowName)

    if frame then
        frame.m_Windows = {
            [LABEL] = Label:CreateFrameForExistingWindow(frame:GetName() .. "ContentsLabel"),
            [BAR] = StatusBar:CreateFrameForExistingWindow(frame:GetName() .. "ContentsProgressBar"),
        }

        local win = frame.m_Windows

        win[BAR]:SetBackgroundTint(DefaultColor.LIGHT_GRAY)
        win[LABEL]:Show(false)

        frame:Update()
        frame:SetTicks()

        return frame
    end
end