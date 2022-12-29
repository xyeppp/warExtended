VerticalScrollbar = Frame:Subclass()

function VerticalScrollbar:SetScrollPos(scrollPos)
  VerticalScrollbarSetScrollPosition(self:GetName(), scrollPos)
end

function VerticalScrollbar:GetScrollPos()
  return VerticalScrollbarGetScrollPosition(self:GetName())
end

function VerticalScrollbar:SetMaxScrollPos(scrollPos)
  VerticalScrollbarSetMaxScrollPosition(self:GetName(), scrollPos)
end

function VerticalScrollbar:GetMaxScrollPos()
  return VerticalScrollbarGetMaxScrollPosition(self:GetName())
end

function VerticalScrollbar:SetPageSize(pageSize)
  VerticalScrollbarSetPageSize(self:GetName(), pageSize)
end

function VerticalScrollbar:GetPageSize()
  return VerticalScrollbarGetPageSize(self:GetName())
end

function VerticalScrollbar:SetLineSize(lineSize)
  VerticalScrollbarSetLineSize(self:GetName(), lineSize)
end

function VerticalScrollbar:GetLineSize()
  return VerticalScrollbarGetLineSize(self:GetName())
end
