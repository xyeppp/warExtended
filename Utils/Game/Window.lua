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

  local frame = GetFrame(parentWindow)
  if frame then
    frame:Show(not frame:IsShowing())
  else
    WindowSetShowing(parentWindow, false)
  end
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




