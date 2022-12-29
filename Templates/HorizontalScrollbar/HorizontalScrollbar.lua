HorizontalScrollbar = Frame:Subclass()

function HorizontalScrollbar:SetScrollPos(scrollPos)
  HorizontalScrollbarSetScrollPosition(self:GetName(), scrollPos)
end

function HorizontalScrollbar:GetScrollPos()
  return HorizontalScrollbarGetScrollPosition(self:GetName())
end

function HorizontalScrollbar:SetMaxScrollPos(scrollPos)
  HorizontalScrollbarSetMaxScrollPosition(self:GetName(), scrollPos)
end

function HorizontalScrollbar:GetMaxScrollPos()
  return HorizontalScrollbarGetMaxScrollPosition(self:GetName())
end

function HorizontalScrollbar:SetPageSize(pageSize)
  HorizontalScrollbarSetPageSize(self:GetName(), pageSize)
end

function HorizontalScrollbar:GetPageSize()
  return HorizontalScrollbarGetPageSize(self:GetName())
end

function HorizontalScrollbar:SetLineSize(lineSize)
  HorizontalScrollbarSetLineSize(self:GetName(), lineSize)
end

function HorizontalScrollbar:GetLineSize()
  return HorizontalScrollbarGetLineSize(self:GetName())
end
