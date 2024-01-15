local warExtended                      = warExtended
local Frame                            = Frame
local GetFrame						 	= GetFrame
local WindowRegisterCoreEventHandler   = WindowRegisterCoreEventHandler
local WindowUnregisterCoreEventHandler = WindowUnregisterCoreEventHandler
local WindowRegisterEventHandler       = WindowRegisterEventHandler
local WindowUnregisterEventHandler     = WindowUnregisterEventHandler
local TextLogGetUpdateEventId		   = TextLogGetUpdateEventId
local WindowSetId = WindowSetId
local DoesWindowExist = DoesWindowExist
local type = type

function Frame:SetTextLogScript(textLog, func)
  self:SetScript(TextLogGetUpdateEventId(textLog), func)
end

function Frame:SetTextLogScripts(textLogs, ...)
  local args = {...}
  for event=1,#textLogs do
	for func = 1, #args do
	  self:SetTextLogScript(textLogs[event], args[func])
	end
  end
end

function Frame:SetScript(event, func)
  local GameEvent = warExtended:GetGameEvent(event)
	p(GameEvent)
  if func ~= nil then
	if GameEvent then
	  WindowRegisterEventHandler(self:GetName(), GameEvent, func)
	else
	  WindowRegisterCoreEventHandler(self:GetName(), event, func)
	end
	return
  end

  if GameEvent then
	WindowUnregisterEventHandler(self:GetName(), GameEvent)
  else
	WindowUnregisterCoreEventHandler(self:GetName(), event)
  end
end

function Frame:SetScripts(events, ...)
 -- local arg=select(1,...)
  for event=1,#events do
	local arg=select(1,...)
	  self:SetScript(events[event], arg)
	end
end

function Frame:SetId(id)
  self.m_Id = id
end

function Frame:SetHandleInput(doesHandleInput)
  WindowSetHandleInput(self:GetName(), doesHandleInput)
end

function Frame:GetScaledScreenPosition ()
  self.m_ScaledScreenX, self.m_ScaledScreenY = WindowGetScreenPosition (self:GetName ())
  return self.m_ScaledScreenX, self.m_ScaledScreenY
end

function Frame:GetAnchors()
	local anchorCount = WindowGetAnchorCount (self:GetName())
	local anchorId = 1
	local anchors = {}

	while (anchorId <= anchorCount)
	do
	  local point, relativePoint, relativeTo, xoffs, yoffs = WindowGetAnchor (self:GetName(), anchorId)
	  anchors[anchorId] = {
		Point = point,
		RelativePoint = relativePoint,
		RelativeTo = relativeTo,
		XOffset = xoffs,
		YOffset = yoffs,
	  }

	  anchorId = anchorId + 1
	end

return anchors
end

function Frame:GetAlpha()
	return WindowGetAlpha(self:GetName())
end

function Frame:GetDimensions(override)
  if override then
	self:SetDimensions(WindowGetDimensions (self:GetName ()))
	return self:GetDimensions()
  elseif (self.m_Width == nil)	then
	  self.m_Width, self.m_Height = WindowGetDimensions (self:GetName ())
	end

	return self.m_Width, self.m_Height
end

function Frame:GetDimensionsScaled()
	local width, height = self:GetDimensions()
	local scale = self:GetUIScale()

	return self.m_Width*scale, self.m_Height*scale
end

function Frame:GetUIScale()
	return InterfaceCore.GetScale()
end

function Frame:GetParentAbsolute()
	local function getParentLevels(windowName)
		local windowLevels = {}
		local currentWindow = windowName

		while currentWindow and currentWindow ~= "Root" do
			windowLevels[#windowLevels+1] = currentWindow
			currentWindow = WindowGetParent(currentWindow)
		end

		local windowParent = windowLevels[#windowLevels]
		return windowParent
	end

	return GetFrame(getParentLevels(self:GetName()))
end

function Frame:BeginResize(anchorCorner, minX, minY, endCallback, maxX, maxY)
  WindowUtils.BeginResize(self:GetName(), anchorCorner, minX, minY, endCallback, maxX, maxY)
end

function Frame:GetOffsetFromParent()
  return WindowGetOffsetFromParent(self:GetName())
end

function Frame:SetOffsetFromParent(x, y)
  WindowSetOffsetFromParent(self:GetName(), x, y)
end

function Frame:SetFocus(focus)
	WindowAssignFocus(self:GetName(), focus)
end

function Frame:HideUntilMouseover(state)
	if state then
		self:Show(false)

		warExtended.AddTaskAction(self:GetName().."HideUntilMouseOver", function()
			local mouseX, mouseY = warExtended:GetMousePosition()
			local framePositionX, framePositionY = self:GetScaledScreenPosition()
			local frameDimX, frameDimY = self:GetDimensions()


			if mouseX > framePositionX then
				if mouseX < (framePositionX + (frameDimX * self:GetScale())) then
					if mouseY > framePositionY then
						self:Show(true)
					end
				end
			else
				self:Show(false)
			end
		end)

	elseif not state then
		if warExtended.GetTask (self:GetName().."HideUntilMouseOver") then
			warExtended.RemoveTask(self:GetName().."HideUntilMouseOver")
			self:Show(true)
		end
	end
end

function Frame:RegisterLayoutEditor(windowDesc, allowSizeWidth, allowSizeHeight, allowHiding, setHiddenCallback, allowableAnchorList, neverLockAspect, minSize, resizeEndCallback, moveEndCallback)
	if (self.m_isLayoutEditorRegistered) then return end
	LayoutEditor.RegisterWindow(self:GetName(), windowDesc, allowSizeWidth, allowSizeHeight, allowHiding, setHiddenCallback, allowableAnchorList, neverLockAspect, minSize, resizeEndCallback, moveEndCallback);
	self.m_isLayoutEditorRegistered = true;
end

function Frame:UnregisterLayoutEditor()
	if (not self.m_isLayoutEditorRegistered) then return end
		LayoutEditor.UnregisterWindow(self:GetName());
		self.m_isLayoutEditorRegistered = false;
end

function Frame:RegisterLayoutEditorCallback(func)
	LayoutEditor.RegisterEditCallback(func)
end


function Frame:CreateFrameForExistingWindow (windowName)
	local newFrame = setmetatable ({}, self)

	newFrame.m_Name             = windowName
	newFrame.m_Id               = EA_IdGenerator:GetNewId ()

	if DoesWindowExist(newFrame.m_Name) then
		WindowSetId (newFrame.m_Name, newFrame.m_Id)
	end

	if newFrame.OnInitialize then
		newFrame:OnInitialize()
	end

	FrameManager:Add (newFrame.m_Name, newFrame)

	return newFrame
end

function Frame:OnScrollPosChanged (scrollPos)            end
function Frame:OnShown ()            end
function Frame:OnHidden ()            end
function Frame:OnMouseDrag ()            end
function Frame:OnInitialize ()            end
function Frame:OnShutdown ()            end
function Frame:OnUpdate (elapsedTime)            end
function Frame:OnSelChanged (idx)            end
function Frame:OnMButtonUp(flags, x, y) end
function Frame:OnDefaultRButtonUp(flags, x, y) end
function Frame:OnResizeBegin( flags, x, y ) end
function Frame:OnPointMouseOver() end
function Frame:OnSlide(curPos) end
function Frame:OnKeyEscape() end
function Frame:OnKeyTab() end
function Frame:OnKeyEnter() end
function Frame:OnSizeUpdated(width, height ) end