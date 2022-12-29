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

function FrameManager.OnInitialize ()
  local frame = FrameManager:GetActiveWindow ()
  
  if (frame)
  then
	frame:OnInitialize ()
  end
end

function FrameManager.OnShutdown ()
  local frame = FrameManager:GetActiveWindow ()
  
  if (frame)
  then
	frame:OnShutdown ()
  end
end

function FrameManager.OnUpdate (elapsedTime)
  local frame = FrameManager:GetActiveWindow ()
  
  if (frame)
  then
	frame:OnUpdate (elapsedTime)
  end
end

function FrameManager.OnSelChanged (idx)
  local frame = FrameManager:GetActiveWindow ()
  
  if (frame)
  then
	frame:OnSelChanged (idx)
  end
end

