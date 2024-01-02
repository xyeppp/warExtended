HorizontalScrollWindow = Frame:Subclass()

function HorizontalScrollWindow:SetOffset(offset)
  HorizontalScrollWindowSetOffset(self:GetName(), offset)
end

function HorizontalScrollWindow:GetOffset()
  return HorizontalScrollWindowGetOffset(self:GetName())
end

function HorizontalScrollWindow:UpdateScrollRect()
  HorizontalScrollWindowUpdateScrollRect(self:GetName())
end