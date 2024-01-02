ColorPicker_ = Frame:Subclass()
local ColorPicker = ColorPicker_
local ColorPickerCreateWithColorTable = ColorPickerCreateWithColorTable
local ColorPickerGetCoordinatesForColor = ColorPickerGetCoordinatesForColor
local ColorPickerGetColorAtPoint = ColorPickerGetColorAtPoint
local ColorPickerGetColorById = ColorPickerGetColorById
local ColorPickerAddColor = ColorPickerAddColor
local ColorPickerAddColorAtPosition = ColorPickerAddColorAtPosition
local ColorPickerClear = ColorPickerClear
local ColorPickerGetColorSpacing = ColorPickerGetColorSpacing
local ColorPickerGetTexDims = ColorPickerGetTexDims
local ColorPickerGetColorSize = ColorPickerGetColorSize


--TODO: change ColorPicker_ into ColorPicker (EA_HerardlyWindow has global object)

local PRIMARY = 1
local SECONDARY = 2
local PRIMARY_SECONDARY = 3

function ColorPicker:Create(windowName, colorTable, colPerRow, xOffset, yOffset, secondaryColor)
  local frame = self:CreateFrameForExistingWindow(windowName)
  frame:CreateWithColorTable(colorTable, colPerRow, xOffset, yOffset)

  frame.m_Windows = {
    [PRIMARY] = DynamicImage:CreateFrameForExistingWindow(frame:GetName().."Primary"),
    [SECONDARY] = DynamicImage:CreateFrameForExistingWindow(frame:GetName().."Secondary"),
    [PRIMARY_SECONDARY] = Frame:CreateFrameForExistingWindow(frame:GetName().."PrimarySecondary")
  }

  local primarySecondaryFrame = frame.m_Windows[PRIMARY_SECONDARY]
  primarySecondaryFrame.m_Windows = {
    [PRIMARY] = DynamicImage:CreateFrameForExistingWindow(primarySecondaryFrame:GetName().."PrimaryHalf"),
    [SECONDARY] = DynamicImage:CreateFrameForExistingWindow(primarySecondaryFrame:GetName().."SecondaryHalf")
  }

  frame.primaryColor = -1

  if secondaryColor then
    frame.secondaryColor = -1
  end

  frame.m_Windows[PRIMARY]:Show(false)
  frame.m_Windows[SECONDARY]:Show(false)
  primarySecondaryFrame:Show(false)

  return frame
end

function ColorPicker:GetPrimary()
  return self.primaryColor
end

function ColorPicker:GetSecondary()
  return self.secondaryColor
end

function ColorPicker:CreateWithColorTable(colorTable, colPerRow, xOffset, yOffset)
  ColorPickerCreateWithColorTable(self:GetName(), colorTable, colPerRow, xOffset, yOffset )
end

function ColorPicker:GetCoordinatesForColor(r,g,b)
  return ColorPickerGetCoordinatesForColor( self:GetName(), r, g, b )
end

function ColorPicker:GetColorAtPoint(x, y)
 return ColorPickerGetColorAtPoint( self:GetName(), x, y )
end

function ColorPicker:ClearSelection()
  self.primaryColor = -1

  if self.secondaryColor then
    self.secondaryColor = -1
  end

  self.m_Windows[PRIMARY]:Show(false)
  self.m_Windows[SECONDARY]:Show(false)
end

function ColorPicker:GetColorById(id)
  local r, g, b, id, x, y = ColorPickerGetColorById(self:GetName(), id)
  local colorTable = {
    r = r,
    g = g,
    b = b,
    id = id,
    x = x,
    y = y,
  }
  return colorTable
end

function ColorPicker:AddColor(r,g,b,id)
  ColorPickerAddColor(self:GetName(), r, g, b, id)
end

function ColorPicker:AddColorAtPosition(r,g,b,id,x,y)
  ColorPickerAddColorAtPosition(self:GetName(), r,g,b,id,x,y )
end

function ColorPicker:Clear()
  ColorPickerClear(self:GetName())
end

function ColorPicker:GetColorSpacing()
return ColorPickerGetColorSpacing(self:GetName())
end

function ColorPicker:GetTexDims()
  return ColorPickerGetTexDims(self:GetName())
end

function ColorPicker:GetColorSize()
  return ColorPickerGetColorSize(self:GetName())
end

function ColorPicker:SelectPrimary(flags, x, y, id)
  local color

  if id then
    color = self:GetColorById(id)
  else
    color = self:GetColorAtPoint(x, y)
  end

  if (color and self:GetPrimary() == color.id) or not color then
    return
  end

  local secondaryFrame = self.m_Windows[SECONDARY]
  local oldPrimary = self.primaryColor

  if color then
    local newColorIndex = color.id
    if newColorIndex == self.primaryColor then
      newColorIndex = -1
    end

    self.primaryColor = newColorIndex
  else
    self.primaryColor = -1
  end

  if( self.primaryColor ~= -1 )
  then
    local selectedColorName = self.m_Windows[PRIMARY]
    local unselectedColorName = self.m_Windows[PRIMARY_SECONDARY]
    if( self.primaryColor == self.secondaryColor )
    then
      selectedColorName = self.m_Windows[PRIMARY_SECONDARY]
      unselectedColorName = self.m_Windows[PRIMARY]
      secondaryFrame:Show(false)
    elseif( self.secondaryColor ~= -1 and self.secondaryColor )
    then
      secondaryFrame:Show(true)
    end

    selectedColorName:SetOffsetFromParent(color.x + - 7, color.y - 7)
    unselectedColorName:SetOffsetFromParent(color.x + - 7, color.y - 7)

    selectedColorName:Show(true)
    unselectedColorName:Show(false)
  else
    local selectedColorName = self.m_Windows[PRIMARY]
    if( oldPrimary ~= -1 and oldPrimary == self.secondaryColor and self.secondaryColor)
    then
      selectedColorName = self.m_Windows[PRIMARY_SECONDARY]
      secondaryFrame:Show(self.secondaryColor ~= -1)
    end

    selectedColorName:Show(false)
  end

  return color
end

function ColorPicker:OnRButtonUp(flags, x, y)
  if not self.secondaryColor then
    return
  end

end

--[[function ColorPicker:SelectPrimary(flags, x, y)
  local color = ColorPickerGetColorAtPoint( "DyeMerchantColorPicker", x, y )
  local oldPrimary = CharacterWindow.primaryColor
  if( color )
  then
    local newColorIndex = CharacterWindow.dyeColors[ GetIndexIntoDyeColors( color.id ) ].paletteIndex
    if( newColorIndex == CharacterWindow.primaryColor )
    then
      newColorIndex = -1
    end

    CharacterWindow.primaryColor = newColorIndex
  else
    CharacterWindow.primaryColor = -1
  end

  if( CharacterWindow.primaryColor ~= -1 )
  then
    local selectedColorName = "DyeMerchantPrimary"
    local unselectedColorName = "DyeMerchantPrimarySecondary"
    if( CharacterWindow.primaryColor == CharacterWindow.secondaryColor )
    then
      selectedColorName = "DyeMerchantPrimarySecondary"
      unselectedColorName = "DyeMerchantPrimary"
      WindowSetShowing("DyeMerchantSecondary", false)
    elseif( CharacterWindow.secondaryColor ~= -1 )
    then
      WindowSetShowing("DyeMerchantSecondary", true)
    end

    local x, y = WindowGetOffsetFromParent( "DyeMerchantColorPicker" )
    WindowSetOffsetFromParent(selectedColorName, color.x + x - 7, color.y + y - 7)
    WindowSetOffsetFromParent(unselectedColorName, color.x + x - 7, color.y + y - 7)

    WindowSetShowing(selectedColorName, true)
    WindowSetShowing(unselectedColorName, false)
  else
    local selectedColorName = "DyeMerchantPrimary"
    if( oldPrimary ~= -1 and oldPrimary == CharacterWindow.secondaryColor )
    then
      selectedColorName = "DyeMerchantPrimarySecondary"
      WindowSetShowing("DyeMerchantSecondary", CharacterWindow.secondaryColor ~= -1)
    end

    WindowSetShowing(selectedColorName, false)
  end
end

function ColorPicker:SelectSecondary(flags, x, y)
  local color = ColorPickerGetColorAtPoint( "DyeMerchantColorPicker", x, y )
  local oldSecondary = CharacterWindow.secondaryColor
  if( color )
  then
    local newColorIndex = CharacterWindow.dyeColors[ GetIndexIntoDyeColors( color.id ) ].paletteIndex
    if( newColorIndex == CharacterWindow.secondaryColor )
    then
      newColorIndex = -1
    end

    CharacterWindow.secondaryColor = newColorIndex
  else
    CharacterWindow.secondaryColor = -1
  end

  if( CharacterWindow.secondaryColor ~= -1 )
  then
    local selectedColorName = "DyeMerchantSecondary"
    local unselectedColorName = "DyeMerchantPrimarySecondary"
    if( CharacterWindow.primaryColor == CharacterWindow.secondaryColor )
    then
      selectedColorName = "DyeMerchantPrimarySecondary"
      unselectedColorName = "DyeMerchantSecondary"
      WindowSetShowing("DyeMerchantPrimary", false)
    elseif( CharacterWindow.primaryColor ~= -1 )
    then
      WindowSetShowing("DyeMerchantPrimary", true)
    end

    local x, y = WindowGetOffsetFromParent( "DyeMerchantColorPicker" )
    WindowSetOffsetFromParent(selectedColorName, color.x + x - 7, color.y + y - 7)
    WindowSetOffsetFromParent(unselectedColorName, color.x + x - 7, color.y + y - 7)

    WindowSetShowing(selectedColorName, true)
    WindowSetShowing(unselectedColorName, false)
  else
    local selectedColorName = "DyeMerchantSecondary"
    if( oldSecondary ~= -1 and oldSecondary == CharacterWindow.primaryColor )
    then
      selectedColorName = "DyeMerchantPrimarySecondary"
      WindowSetShowing("DyeMerchantPrimary", CharacterWindow.primaryColor ~= -1)
    end

    WindowSetShowing(selectedColorName, false)
  end
end

function ColorPicker:SelectPrimarySecondary(flags, x, y)

end]]
