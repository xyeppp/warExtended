ScrollWindow = Frame:Subclass()

function ScrollWindow:SetOffset(offset)
  ScrollWindowSetOffset(self:GetName(), offset)
end

function ScrollWindow:GetOffset()
  return ScrollWindowGetOffset(self:GetName())
end

function ScrollWindow:UpdateScrollRect()
  ScrollWindowUpdateScrollRect(self:GetName())
end