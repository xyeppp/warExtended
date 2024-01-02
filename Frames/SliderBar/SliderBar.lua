local SLIDER_BAR_WITH_BUTTONS = "warExtendedDefaultSliderBarWithButtons"
SliderBar = Frame:Subclass()

function SliderBar:GetDisabled()
  return SliderBarGetDisabledFlag(self:GetName())
end

function SliderBar:SetDisabled(isDisabled)
  SliderBarSetDisabledFlag(self:GetName(), isDisabled)
end

function SliderBar:GetCurrentPosition()
  return SliderBarGetCurrentPosition(self:GetName())
end

function SliderBar:SetCurrentPosition(curPos)
  SliderBarSetCurrentPosition(self:GetName(), curPos)
end

function SliderBar:OnMouseWheel(x, y, delta, flags)
  if delta > 0 then
    self:SetCurrentPosition(self:GetCurrentPosition()+.02)
    self:OnSlide(self:GetCurrentPosition())
    elseif delta < 0 then
    self:SetCurrentPosition(self:GetCurrentPosition()-.02)
    self:OnSlide(self:GetCurrentPosition())
  end
end



