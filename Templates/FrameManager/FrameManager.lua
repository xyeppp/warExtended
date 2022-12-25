local FrameManager = FrameManager

function FrameManager.OnScrollPosChanged (scrollPos)
  local frame = FrameManager:GetActiveWindow ()
  
  if (frame)
  then
	frame:OnScrollPosChanged (scrollPos)
  end
end

function FrameManager.OnShown ()
  local frame = FrameManager:GetActiveWindow ()
  
  if (frame)
  then
	frame:OnShown ()
  end
end

function FrameManager.OnHidden ()
  local frame = FrameManager:GetActiveWindow ()
  
  if (frame)
  then
	frame:OnHidden ()
  end
end

function FrameManager.OnMouseDrag ()
  local frame = FrameManager:GetActiveWindow ()
  
  if (frame)
  then
	frame:OnMouseDrag ()
  end
end

--[[function FrameManager.OnMouseOverEnd (flags, mouseX, mouseY)
  local frame = FrameManager:GetActiveWindow ()
  
  if (frame)
  then
	frame:OnMouseOverEnd (flags, mouseX, mouseY)
  end
end

function FrameManager.OnMouseOverEnd (flags, mouseX, mouseY)
  local frame = FrameManager:GetActiveWindow ()
  
  if (frame)
  then
	frame:OnMouseOverEnd (flags, mouseX, mouseY)
  end
end]]