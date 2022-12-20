local warExtended               = warExtended
local WindowGetScreenPosition   = WindowGetScreenPosition
local WindowGetId               = WindowGetId
local SystemData                = SystemData
local WindowSetOffsetFromParent = WindowSetOffsetFromParent
local WindowGetParent = WindowGetParent
local WindowGetShowing = WindowGetShowing
local WindowSetShowing = WindowSetShowing
local WindowSetId = WindowSetId
local WindowGetId = WindowGetId
local DoesWindowExist = DoesWindowExist
local CreateWindowFromTemplate  = CreateWindowFromTemplate
local WindowGetDimensions = WindowGetDimensions

function warExtended:GetMouseOverWindow()
  local mouseoverWindow = SystemData.MouseOverWindow.name
  return mouseoverWindow
end

--[[ function warExtended:IsMouseOverWindow(...)
 local windows = {...}
--  local matches = {}
--
--  for windowName=1,#windows do
--    local isMatch = warExtended:GetMouseOverWindow():match(windows[windowName])
--    if isMatch ~= nil then
--      matches[#matches+1] = isMatch
--    end
--  end
--  return unpack(matches)
end
]]

function warExtended:IsMouseOverWindow(...)
  local windows = {...}
  local matches = {}
  
  for windowName=1,#windows do
     local isMatch = warExtended:GetMouseOverWindow():match(windows[windowName])
     if isMatch ~= nil then
       matches[#matches+1] = isMatch
     end
   end
  
   return unpack(matches)
end

function warExtended:GetActiveWindow()
  local activeWindow = SystemData.ActiveWindow.name
  return activeWindow
end

function warExtended:WindowShowOnParent(windowName)
  local isParentShowing=WindowGetShowing(WindowGetParent(windowName))
    if isParentShowing then
    WindowSetShowing(windowName, true)
  end
end


function warExtended:IsActiveWindow(windowName)
  local isActiveWindow = { warExtended:GetActiveWindow():match(windowName) }
  return unpack(isActiveWindow)
end

function warExtended:GetWindowPosition(windowName)
  local x,y = WindowGetScreenPosition(windowName)
  return x,y
end

function warExtended:OnCloseButton()
  local parentWindow = warExtended:IsMouseOverWindow("(.*)TitleBarClose")
  
  if not parentWindow then
    return
  end
  
  WindowSetShowing(parentWindow, false)
end


function warExtended:OnResizeWindow(minX, minY, endCallback)
  local parentWindow = warExtended:IsMouseOverWindow("(.*)ResizeButton")
  
  if not parentWindow then
    return
  end
  
  WindowUtils.BeginResize( parentWindow, "topleft", minX, minY, endCallback)
end

function warExtended:GetActiveWindowId()
  local activeWindowId = WindowGetId(warExtended:GetActiveWindow())
  return activeWindowId
end
function warExtended:WindowDoesExist(windowName)
  local doesExist = DoesWindowExist(windowName)
  return doesExist
end

function warExtended:GetMouseOverWindowId()
  local mouseOverWindowId = WindowGetId(warExtended:GetActiveWindow())
  return mouseOverWindowId
end

function warExtended:GetWindowId(windowName)
  local windowId = WindowGetId(windowName)
  return windowId
end

function warExtended:SetWindowId(windowName, id)
  WindowSetId(windowName, id)
end

function warExtended:WindowGetDimensions(windowName)
  local winX, winY = WindowGetDimensions(windowName)
  return winX, winY
end

function warExtended:CreateWindowTemplate(windowName, templateName, parentWindow)
  CreateWindowFromTemplate(windowName, templateName, parentWindow)
end

function warExtended:SetWindowOffset(windowName, x, y)
  WindowSetOffsetFromParent(windowName, x, y)
end

function warExtended:WindowSetRelativeAnchor(windowName, parentName, direction)
  -- direction == left//right or up//down
  -- positions your additional window based on the first window's position on screen eg. options display on left/right depending on where the window is
  local rootWidth,rootHeight = WindowGetDimensions("Root")
  local half = rootWidth / 2
  local mglX,mglY = WindowGetScreenPosition(parentName)
  local wX, wY = WindowGetDimensions(windowName)
  local anchor = nil

  if mglX*2+wX > half then
    anchor = { Point = "topleft",  RelativeTo = parentName, RelativePoint = "topright",   XOffset = 7, YOffset = 0 }
  else
    anchor = { Point = "topright",  RelativeTo = parentName, RelativePoint = "topleft",   XOffset = -7, YOffset = 0 }
  end
  
  warExtendedTerminal:WindowSetAnchor (windowName, anchor)
end

function warExtended:WindowSetAnchor (windowName, anchor, anchor2)
  if (anchor)
  then
    WindowClearAnchors (windowName)
    
    local relativeTo    = anchor.RelativeTo or "Root"
    local point         = anchor.Point or "topleft"
    local relativePoint = anchor.RelativePoint or "topleft"
    local x             = anchor.XOffset or 0
    local y             = anchor.YOffset or 0
    
    WindowAddAnchor (windowName, point, relativeTo, relativePoint, x, y)
    
    -- Only set anchor2 if anchor was valid.
    if (anchor2)
    then
      relativeTo    = anchor2.RelativeTo or "Root"
      point         = anchor2.Point or "topleft"
      relativePoint = anchor2.RelativePoint or "topleft"
      x             = anchor2.XOffset or 0
      y             = anchor2.YOffset or 0
      
      WindowAddAnchor (windowName, point, relativeTo, relativePoint, x, y)
    end
  end
end


