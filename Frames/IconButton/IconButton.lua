warExtendedDefaultIconButton = ButtonFrame:Subclass("warExtendedDefaultIconButton")
local IconButton = warExtendedDefaultIconButton
local GetFrame = GetFrame
local GetIconData = GetIconData

function IconButton:Create(windowName, parentName)
    local frame = GetFrame(windowName) or self:CreateFromTemplate(windowName, parentName)

    if frame then
        frame.m_Icon = DynamicImage:CreateFrameForExistingWindow(frame:GetName().."IconBase")
        return frame
    end
end

function IconButton:CreateSet(windowName, parentName, maxRow, maxColumn)
    local maxSlot = maxRow * maxColumn

    for iconButton = 1, maxSlot do
        local frame = self:Create(windowName..iconButton, parentName)

        if frame then
            if iconButton%maxRow == 1 and iconButton ~= 1 then
                frame:SetAnchor({
                    Point = "bottomleft", RelativeTo = windowName..iconButton-maxRow, YOffset = 4
                })
            elseif iconButton > 1 then
                frame:SetAnchor({
                    Point = "right", RelativePoint = "left", RelativeTo = windowName..iconButton-1, XOffset = 4,
                })
            end

            frame:SetId(iconButton)
            frame:SetCheckButtonFlag(true)
            frame:Show(true)
        end
    end
end

function IconButton:SetIcon(iconNum)
    if warExtended:IsType(iconNum, "string") then

    end
    local texture, x, y = GetIconData(iconNum)
    self.m_iconNum = iconNum
    self.m_Icon:SetTexture(texture, x, y)
end

function IconButton:GetIconData()
    return GetIconData(self.m_iconNum)
end

