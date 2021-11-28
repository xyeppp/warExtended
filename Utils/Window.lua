local warExtended = warExtended
local WindowGetScreenPosition = WindowGetScreenPosition
local WindowGetId = WindowGetId
local SystemData = SystemData

function warExtended:GetMouseOverWindow()
  local mouseoverWindow = SystemData.MouseOverWindow.name
  return mouseoverWindow
end

function warExtended:IsMouseOverWindow(windowName)
  local isMouseOverWindow = { SystemData.MouseOverWindow.name:match(windowName) }
  return unpack(isMouseOverWindow)
end

function warExtended:GetActiveWindow()
  local activeWindow = SystemData.ActiveWindow.name
  return activeWindow
end

function warExtended:IsActiveWindow(windowName)
  local isActiveWindow = { SystemData.ActiveWindow.name:match(windowName) }
  return unpack(isActiveWindow)
end

function warExtended:GetWindowPosition(windowName)
  local windowPosition = WindowGetScreenPosition(windowName)
  return windowPosition
end

function warExtended:GetActiveWindowId()
  local activeWindowId = WindowGetId(SystemData.ActiveWindow.name)
  return activeWindowId
end

function warExtended:GetMouseOverWindowId()
  local mouseOverWindowId = WindowGetId(SystemData.MouseOverWindow.name)
  return mouseOverWindowId
end