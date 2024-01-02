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

function FrameManager.OnSlide(curPos)
  local frame = FrameManager:GetActiveWindow ()

  if (frame)
  then
	frame:OnSlide (curPos)
  end
end

function FrameManager.OnMButtonUp (flags, x, y)
  local frame = FrameManager:GetActiveWindow ()

  if (frame)
  then
	frame:OnMButtonUp (flags, x, y)
  end
end

function FrameManager.OnKeyTab(...)
    local frame = FrameManager:GetActiveWindow()

    if (frame) then
        frame:OnKeyTab(...)
    end
end

function FrameManager.OnKeyEnter(...)
  local frame = FrameManager:GetActiveWindow()

  if (frame) then
    frame:OnKeyEnter(...)
  end
end

function FrameManager.OnKeyEscape(...)
    local frame = FrameManager:GetActiveWindow()

    if (frame) then
        frame:OnKeyEscape(...)
    end
end

function FrameManager.OnDefaultRButtonUp (flags, x, y)
  local frame = FrameManager:GetActiveWindow ()

  if (frame)
  then

	EA_Window_ContextMenu.CreateDefaultContextMenu(frame:GetName())
  end
end

function FrameManager.OnResizeBegin( flags, x, y )
  local frame = FrameManager:GetActiveWindow ()

  if (frame)
  then
	frame:OnResizeBegin( flags, x, y )
  end
end

function FrameManager.OnPointMouseOver()
  local frame = FrameManager:GetActiveWindow ()

  if (frame)
  then
	frame:OnPointMouseOver ()
  end
end

function FrameManager.OnSizeUpdated(width, height )
  local frame = FrameManager:GetActiveWindow ()

  if (frame)
  then
    frame:OnSizeUpdated (width, height )
  end
end

