local ScrollWindow = ScrollWindow
local warExtended = warExtended
warExtendedDefaultIconScrollWindow = ScrollWindow:Subclass("warExtendedDefaultIconScrollWindow")

local IconScrollWindow = warExtendedDefaultIconScrollWindow
local GetFrame = GetFrame
local GetIconData = GetIconData
local ICON_SELECT_BUTTON = warExtendedDefaultIconButton:Subclass()
local mfloor = math.floor

local SCROLLBAR = 1
local SCROLL_CHILD = 2

local PAGE_SIZE = 180
local MAX_SCROLL_MULTIPLIER

local iconList = warExtended:GetIconList()

function ICON_SELECT_BUTTON:OnLButtonDown(...)
    local parentFrame = self:GetParentAbsolute()
    parentFrame:OnIconSelect(self.m_iconNum, self:GetIconData())
end

function IconScrollWindow:Create(windowName, buttonName, maxRow, maxColumn, callback)
    local frame = GetFrame(windowName) or self:CreateFrameForExistingWindow(windowName)

    if frame then
        frame.m_maxColumn = maxColumn
        frame.m_maxRow = maxRow
        frame.m_maxButtons = maxColumn * maxRow
        frame.m_callback = callback
        frame.m_buttonName = buttonName

        MAX_SCROLL_MULTIPLIER = (PAGE_SIZE/frame.m_maxButtons) + 0.05

        local _, frameY = frame:GetDimensions()

        frame.m_Windows = {
            [SCROLLBAR] = VerticalScrollbar:CreateFrameForExistingWindow(frame:GetName().."Scrollbar"),
            [SCROLL_CHILD] = Frame:CreateFrameForExistingWindow(frame:GetName().."ScrollChild")
        }

        local win = frame.m_Windows

        ICON_SELECT_BUTTON:CreateSet(buttonName, win[SCROLL_CHILD]:GetName(), maxRow, maxColumn)

        win[SCROLLBAR]:SetDimensions(20, frameY+4)

        win[SCROLLBAR].OnScrollPosChanged = function(self, scrollPos)
            self:SetMaxScrollPos(#iconList*MAX_SCROLL_MULTIPLIER)
            frame:SetPageIcons(scrollPos/PAGE_SIZE)
        end

        win[SCROLLBAR]:SetMaxScrollPos(#iconList*MAX_SCROLL_MULTIPLIER)

        frame:SetPageIcons(win[SCROLLBAR]:GetScrollPos()/PAGE_SIZE)
    end
end

function IconScrollWindow:SetPageIcons(page)

    local win = self.m_Windows
    local icons = iconList
    page = mfloor(page)

    if page == 0 then
        page = 1
    end

    for icon= 1,self.m_maxButtons do
        local frame = GetFrame(self.m_buttonName..icon)
        local iconId = icon+(page*self.m_maxButtons)-self.m_maxButtons

        if icons[iconId] then
            frame:SetIcon(icons[iconId].m_Id)
            frame:SetId(iconId)

            if not frame:IsShowing() then
                frame:Show(true)
            end
        else
            frame:Show(false)
        end
    end

    if not page == win[SCROLLBAR]:GetMaxScrollPos()/PAGE_SIZE then
        win[SCROLL_CHILD]:UpdateScrollRect()
    end
end

function IconScrollWindow:OnShown()
    local win = self.m_Windows
    for slot = 1, self.m_maxButtons do
        GetFrame(self.m_buttonName..slot):SetPressedFlag(false)
    end

    win[SCROLLBAR]:SetMaxScrollPos(#iconList*MAX_SCROLL_MULTIPLIER)
    self:UpdateScrollRect()
end

function IconScrollWindow:OnHidden()

end

--[[
local ICON_FRAME

function ICON_FRAME:SetMaxIcons()
    local x, y = self.m_Windows[ICON_SCROLL_WINDOW]:GetDimensions(true)
    local scrollbarX, _ = self.m_Windows[ICON_SCROLLBAR]:GetDimensions(true)
    MAX_COLUMN = mfloor((mfloor(x)-scrollbarX-80)/BUTTON_X)
    MAX_ROW = mfloor((mfloor(y)-40)/BUTTON_Y)
    MAX_ICONS_CACHE = MAX_ICONS
    MAX_ICONS = MAX_COLUMN * MAX_ROW
end

function ICON_FRAME:OnShown()
    TerminalTextureViewer:GetSettings().icons.list = TerminalTextureViewer.GetIconsList()
    self:CreateIcons()
    self:SetPageIcons(self.m_Windows[ICON_SCROLLBAR]:GetScrollPos()/90)
    self.m_Windows[ICON_SCROLL_WINDOW]:UpdateScrollRect()
    self:RecreateIcons()
end

function ICON_FRAME:OnHidden()
    TerminalTextureViewer:GetSettings().icons.list = {}
end

function ICON_FRAME:CreateIcons()
    for icon=1,MAX_ICONS do
        if GetFrame(self:GetName().."Slot"..icon) then
            return
        end

        local buttonFrame = ICON_BUTTON:CreateFromTemplate(self:GetName().."Slot"..icon, self:GetName().."SelectionScrollChild" )
        buttonFrame.m_Icon = DynamicImage:CreateFrameForExistingWindow(buttonFrame:GetName().."IconBase")
        buttonFrame:Show(true)

        if icon == 1 then
            buttonFrame:SetAnchor({
                RelativeTo = self:GetName().."SelectionScrollChild", YOffset = 24
            })
        elseif icon%MAX_COLUMN == 1 then
            buttonFrame:SetAnchor({
                Point = "bottomleft", RelativeTo = self:GetName().."Slot"..icon-MAX_COLUMN, YOffset = 4
            })
        else
            buttonFrame:SetAnchor({
                Point = "right", RelativePoint = "left", RelativeTo = self:GetName().."Slot"..icon-1, XOffset = 4,
            })
        end
    end

    self:SetPageIcons(self.m_Windows[ICON_SCROLLBAR]:GetScrollPos()/90)
end

function ICON_FRAME:DestroyIcons()
    for icon=MAX_ICONS,MAX_ICONS_CACHE do
        local frame = GetFrame(self:GetName().."Slot"..icon)
        frame:Show(false)
    end
end

function ICON_FRAME:RecreateIcons()
    local scrollWindow = self.m_Windows[ICON_SCROLL_WINDOW]
    scrollWindow:UpdateScrollRect()
    self:SetMaxIcons()
    self:DestroyIcons()

    for icon=1,MAX_ICONS do
        if not GetFrame(self:GetName().."Slot"..icon) then
            local buttonFrame = ICON_BUTTON:CreateFromTemplate(self:GetName().."Slot"..icon, self:GetName().."SelectionScrollChild" )
            buttonFrame.m_Icon = DynamicImage:CreateFrameForExistingWindow(buttonFrame:GetName().."IconBase")
            buttonFrame:Show(true)
        end
    end

    self:ReanchorIcons()
    self:SetPageIcons(self.m_Windows[ICON_SCROLLBAR]:GetScrollPos()/90)
end

function ICON_FRAME:ReanchorIcons()
    for icon=1,MAX_ICONS do
        local buttonFrame = GetFrame(self:GetName().."Slot"..icon)
        if icon == 1 then
            buttonFrame:SetAnchor({
                RelativeTo = self:GetName().."SelectionScrollChild", YOffset = 24
            })
        elseif icon%MAX_COLUMN == 1 then
            buttonFrame:SetAnchor({
                Point = "bottomleft", RelativeTo = self:GetName().."Slot"..icon-MAX_COLUMN, YOffset = 4
            })
        else
            buttonFrame:SetAnchor({
                Point = "right", RelativePoint = "left", RelativeTo = self:GetName().."Slot"..icon-1, XOffset = 4,
            })
        end
    end
end

function ICON_FRAME:SetPageIcons(page)
    local scrollbar = self.m_Windows[ICON_SCROLLBAR]
    local scrollWindow = self.m_Windows[ICON_SCROLL_WINDOW]
    local icons = TerminalTextureViewer:GetSettings().icons.list
    page = mfloor(page)

    if page == 0 then
        page = 1
    end

    for icon= 1,MAX_ICONS do
        local frame = GetFrame(self:GetName().."Slot"..icon)
        local iconId = icon+(page*40)-40

        if icons[iconId] then
            frame.m_Icon:SetTexture(icons[iconId], 0, 0)
            frame:SetId(iconId)

            if not frame:IsShowing() then
                frame:Show(true)
            end

        else
            frame:Show(false)
        end
    end

    scrollbar:SetMaxScrollPos(#icons*2.29)
    if not page == scrollbar:GetMaxScrollPos()/90 then
        p("not page")
        scrollWindow:UpdateScrollRect()
    end
end

function ICON_FRAME.OnResizeEnd()
    local frame = GetFrame(WINDOW_NAME .. "Icons")
    frame:RecreateIcons()

end

]]