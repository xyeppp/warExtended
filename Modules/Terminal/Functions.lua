local tostring = tostring
local __DoesWindowExist = DoesWindowExist
local __WindowSetTintColor = WindowSetTintColor
local __DynamicImageSetTexture = DynamicImageSetTexture
local __ButtonSetDisabledFlag = ButtonSetDisabledFlag
local __WindowSetShowing = WindowSetShowing
local __WindowGetShowing = WindowGetShowing
local __WindowRegisterEventHandler = WindowRegisterEventHandler
local __WindowUnregisterEventHandler = WindowUnregisterEventHandler
local __DestroyWindow = DestroyWindow
local __WindowGetAlpha = WindowGetAlpha

DoesWindowExist = function(window)
  if window ~= nil then
	return __DoesWindowExist(window)
  else
	return false
  end
end

local function doesExistWrap(func, window, ...)
  if DoesWindowExist(window) then
	func(window, ...)
	return true
  end
end

WindowSetTintColor = function(window, r, g, b)
  if not doesExistWrap(__WindowSetTintColor, window, r, g, b) then
	d("Failed to set tint color on "..tostring(window))
	return
  end
end

DynamicImageSetTexture = function(window, texture, num1, num2)
  if not doesExistWrap(__DynamicImageSetTexture, window, texture, num1, num2) then
	d("Failed to set texture on "..tostring(window))
  end
end


ButtonSetDisabledFlag = function(button, able)
  if not doesExistWrap(__ButtonSetDisabledFlag, button, able) then
	d("Failed to set disabled on "..button)
  end
end

WindowSetShowing = function(window, able)
  if not doesExistWrap(__WindowSetShowing, window, able) then
	d("Failed to set showing on "..tostring(window))
  end
end

WindowGetShowing = function(window)
  if not doesExistWrap(__WindowGetShowing, window) then
	d("Failed to get showing on "..tostring(window))
	return false
  end
end

WindowRegisterEventHandler = function(window, event, handler)
  if handler == nil and not doesExistWrap(__WindowRegisterEventHandler, window, event, handler) then
	d("Failed to register event handler on "..tostring(window))
  end
end

WindowUnregisterEventHandler = function(window, event)
  if not doesExistWrap(__WindowUnregisterEventHandler, window, event) then
	d("Failed to unregister event handler on "..tostring(window))
  end
end


CarefulCoreFunctions={}
CarefulCoreFunctions.DestroyWindow = DestroyWindow
DestroyWindow = function(window)
  if DoesWindowExist(window) then
	CarefulCoreFunctions.DestroyWindow(window)
  else
	d("Failed to destroy "..tostring(window))
  end
end

CarefulCoreFunctions.WindowGetAlpha = WindowGetAlpha
WindowGetAlpha = function(window)
  if DoesWindowExist(window) then
	return CarefulCoreFunctions.WindowGetAlpha(window)
  else
	d("Failed to get alpha of "..tostring(window))
	return 0
  end
end

CarefulCoreFunctions.WindowSetAlpha = WindowSetAlpha
WindowSetAlpha = function(window, alpha)
  if DoesWindowExist(window) then
	return CarefulCoreFunctions.WindowSetAlpha(window, alpha)
  else
	d("Failed to set alpha of "..tostring(window))
  end
end

CarefulCoreFunctions.WindowGetScale = WindowGetScale
WindowGetScale = function(window)
  if DoesWindowExist(window) then
	return CarefulCoreFunctions.WindowGetScale(window)
  else
	d("Failed to get scale of "..tostring(window))
	return 1
  end
end

CarefulCoreFunctions.WindowSetScale = WindowSetScale
WindowSetScale = function(window, scale)
  if DoesWindowExist(window) then
	return CarefulCoreFunctions.WindowSetScale(window, scale)
  else
	d("Failed to set scale of "..tostring(window))
  end
end

CarefulCoreFunctions.WindowGetDimensions = WindowGetDimensions
WindowGetDimensions = function(window)
  if DoesWindowExist(window) then
	return CarefulCoreFunctions.WindowGetDimensions(window)
  else
	d("Failed to get dimensions of "..tostring(window))
	return 0, 0
  end
end

CarefulCoreFunctions.WindowSetDimensions = WindowSetDimensions
WindowSetDimensions = function(window, x, y)
  if DoesWindowExist(window) then
	return CarefulCoreFunctions.WindowSetDimensions(window, x, y)
  else
	d("Failed to set dimensions of "..tostring(window))
  end
end

CarefulCoreFunctions.WindowGetAnchorCount = WindowGetAnchorCount
WindowGetAnchorCount = function(window)
  if DoesWindowExist(window) then
	local count = CarefulCoreFunctions.WindowGetAnchorCount(window)
	if count ~= nil then
	  return count
	end
	d(window)
	d(DoesWindowExist(window))
	return 0
  else
	d("Failed to get dimensions of "..tostring(window))
	return 0
  end
end

CarefulCoreFunctions.WindowGetOffsetFromParent = WindowGetOffsetFromParent
WindowGetOffsetFromParent = function(window)
  if DoesWindowExist(window) then
	return CarefulCoreFunctions.WindowGetOffsetFromParent(window)
  else
	d("Failed to get offset of parent of "..tostring(window))
	return 0, 0
  end
end

CarefulCoreFunctions.WindowSetOffsetFromParent = WindowSetOffsetFromParent
WindowSetOffsetFromParent = function(window, x, y)
  if DoesWindowExist(window) then
	return CarefulCoreFunctions.WindowSetOffsetFromParent(window, x, y)
  else
	d("Failed to set offset of parent of "..tostring(window))
  end
end

CarefulCoreFunctions.WindowGetScreenPosition = WindowGetScreenPosition
WindowGetScreenPosition = function(window)
  if DoesWindowExist(window) then
	return CarefulCoreFunctions.WindowGetScreenPosition(window)
  else
	d("Failed to get screen position of "..tostring(window))
	return 0,0
  end
end

CarefulCoreFunctions.WindowGetParent = WindowGetParent
WindowGetParent = function(window)
  if DoesWindowExist(window) then
	return CarefulCoreFunctions.WindowGetParent(window)
  else
	d("Failed to get parent of "..tostring(window))
	return "Root"
  end
end

CarefulCoreFunctions.WindowAddAnchor = WindowAddAnchor
WindowAddAnchor = function(window, point, anchor, refpoint, offsetX, offsetY)
  if DoesWindowExist(window) and DoesWindowExist(anchor) then
	if anchor == "Root" then
	  local width, height = WindowGetDimensions("Root");
	  if refpoint == "left" or refpoint == "topleft" or refpoint == "bottomleft" then
		if offsetX < -50 then
		  offsetX = -50
		end
	  end
	  if refpoint == "right" or refpoint == "topright" or refpoint == "bottomright" then
		if offsetX > width + 50 then
		  offsetX = width + 50
		end
	  end
	  if refpoint == "top" or refpoint == "topleft" or refpoint == "topright" then
		if offsetY < -50 then
		  offsetY = -50
		end
	  end
	  if refpoint == "bottom" or refpoint == "bottomleft" or refpoint == "bottomright" then
		if offsetY > height + 50 then
		  offsetY = height + 50
		end
	  end
	end
	return CarefulCoreFunctions.WindowAddAnchor(window, point, anchor, refpoint, offsetX, offsetY)
  elseif DoesWindowExist(window) then
	d("Failed to add anchor "..tostring(anchor).." to "..tostring(window))
	return CarefulCoreFunctions.WindowAddAnchor(window, "left", "Root", "left", 0, 0)
  else
	d("Failed to add anchor "..tostring(anchor).." to "..tostring(window))
  end
end

CarefulCoreFunctions.WindowClearAnchors = WindowClearAnchors
WindowClearAnchors = function(window)
  if DoesWindowExist(window) then
	return CarefulCoreFunctions.WindowClearAnchors(window)
  else
	d("Failed to clear anchor of "..tostring(window))
  end
end

CarefulCoreFunctions.RegisterEventHandler = RegisterEventHandler
RegisterEventHandler = function(event, handler)
  if type(handler) == nil then
	d("Tryed to register no handler for event "..tostring(event))
	return
  end
  local success, errmsg = pcall(CarefulCoreFunctions.RegisterEventHandler, event, handler)
  if not success then
	d("Failed registering event handler")
	d(errmsg)
  end
end

CarefulCoreFunctions.UnregisterEventHandler = UnregisterEventHandler
UnregisterEventHandler = function(event, handler)
  local success, errmsg = pcall(CarefulCoreFunctions.UnregisterEventHandler, event, handler)
  if not success then
	d("Failed unregistering event handler")
	d(errmsg)
  end
end

CarefulCoreFunctions.ListBoxSetRowFilters = ListBoxSetRowFilters
ListBoxSetRowFilters = function(window)
  if DoesWindowExist(window) then
	return CarefulCoreFunctions.ListBoxSetRowFilters(window)
  else
	d("Failed to set row filters of "..tostring(window))
  end
end

CarefulCoreFunctions.DynamicImageSetRotation = DynamicImageSetRotation
DynamicImageSetRotation = function(window, rotation)
  if DoesWindowExist(window) then
	return CarefulCoreFunctions.DynamicImageSetRotation(window, rotation)
  else
	d("Failed to rotate "..tostring(window))
  end
end

CarefulCoreFunctions.ButtonSetPressedFlag = ButtonSetPressedFlag
ButtonSetPressedFlag = function(window, active)
  if DoesWindowExist(window) then
	return CarefulCoreFunctions.ButtonSetPressedFlag(window, active)
  else
	d("Failed to set pressed flag of "..tostring(window))
  end
end

CarefulCoreFunctions.WindowSetId = WindowSetId
WindowSetId = function(window, id)
  if DoesWindowExist(window) then
	return CarefulCoreFunctions.WindowSetId(window, id)
  else
	d("Failed to set id of "..tostring(window))
  end
end

CarefulCoreFunctions.LabelSetText = LabelSetText
LabelSetText = function(window, text)
  if DoesWindowExist(window) then
	return CarefulCoreFunctions.LabelSetText(window, text)
  else
	d("Failed to set text of "..tostring(window))
  end
end

CarefulCoreFunctions.LabelSetTextColor = LabelSetTextColor
LabelSetTextColor = function(window, r, g, b)
  if DoesWindowExist(window) then
	return CarefulCoreFunctions.LabelSetTextColor(window, r, g, b)
  else
	d("Failed to set text of "..tostring(window))
  end
end


CarefulCoreFunctions.DynamicImageSetTextureSlice = DynamicImageSetTextureSlice
DynamicImageSetTextureSlice = function(window, texture)
  if DoesWindowExist(window) then
	CarefulCoreFunctions.DynamicImageSetTextureSlice(window, texture)
  else
	d("Failed to set texture slice on "..tostring(window))
  end
end