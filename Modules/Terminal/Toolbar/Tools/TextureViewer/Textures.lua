TextureViewer = {}

--TODO: add categories for default textures

local warExtended = warExtended
local TerminalTextureViewer = TerminalTextureViewer
local WINDOW_NAME = "TerminalTextureViewer"

local TEXTURE_VIEWER_UPDATE_INTERVAL = 0.01
local TEXTURE_VIEWER_SCROLL_VALUE = 20
local TEXTURE_VIEWER_SCROLL_DIRECTION_NORMAL = { r=255, g=255, b=255 }
local TEXTURE_VIEWER_SCROLL_DIRECTION_HIGHLIGHT = { r=255, g=0, b=0 }
local TEXTURE_VIEWER_GUIDELINE_COLOR = { r=50, g=128, b=255 }

local TEXTURE_NAME_LABEL = 1
local TEXTURE_NAME_EDIT = 2
local TEXTURE_NAME_COMBO_LABEL = 3
local TEXTURE_NAME_COMBO = 4
local SLICE_NAME_LABEL = 5
local SLICE_NAME_EDIT = 6
local SLICE_NAME_COMBO_LABEL = 7
local SLICE_NAME_COMBO = 8
local X_DIM_LABEL = 9
local X_DIM_EDIT = 10
local Y_DIM_LABEL = 11
local Y_DIM_EDIT = 12
local TEXTURE_DISPLAY = 13
local SET_TEXTURE_BTN = 14
local X_TRACKER = 15
local Y_TRACKER = 16
local X_COORDS = 17
local Y_COORDS = 18
local X_DIMS = 19
local Y_DIMS = 20
local TRACK_FRAME = 21


local TRACKER_FRAME = FullResizeImage:Subclass("TextureViewerTrackFrameTemplate")

function TRACKER_FRAME:Create(windowName, parentName)
  local frame = self:CreateFromTemplate(windowName, parentName)
  
  if frame then
	local uiScale = InterfaceCore.GetScale( )
	frame:SetDimensions(1/uiScale, 1/uiScale)
	frame:SetTintColor(warExtended:UnpackRGB(TEXTURE_VIEWER_GUIDELINE_COLOR))
	frame:SetAlpha(0.5)
	frame:Show(true)
 
	return frame
  end
end

TEXTURE_FRAME     = Frame:Subclass(WINDOW_NAME .. "Textures")
local SET_TEXTURE_BUTTON  = ButtonFrame:Subclass(WINDOW_NAME.."TexturesSetTexture")
local TEXTURE_NAME = TextEditBox:Subclass(WINDOW_NAME.."TexturesTextureEditBox")
local TEXTURE_COMBO = ComboBox:Subclass(WINDOW_NAME.."TexturesTextureComboBox")
local SLICE_NAME = TextEditBox:Subclass(WINDOW_NAME.."TextureSliceEditBox")
local SLICE_COMBO = ComboBox:Subclass(WINDOW_NAME.."IconSelectionScrollbar")
local X_DIM = TextEditBox:Subclass()
local Y_DIM = X_DIM:Subclass()
local TEXTURE = DynamicImage:Subclass(WINDOW_NAME.."TexturesTexture")
local TRACKER_X = TRACKER_FRAME:Subclass()
local TRACKER_Y = TRACKER_X:Subclass()

function TEXTURE_COMBO:OnSelChanged(selection)
  local frame = self:GetParent()
  
  if selection >= 1 then
	frame.m_Windows[TEXTURE_NAME_EDIT]:SetText(self:TextAsWideString())
	frame.m_Windows[SLICE_NAME_EDIT]:SetText(L"")
	frame.m_Windows[SLICE_NAME_COMBO]:ClearMenuItems()
	
	if TerminalTextureViewer.GetTextureSlices(self:TextAsWideString())  then
	  frame.m_Windows[SLICE_NAME_COMBO]:SetDisabledFlag(false)
	  frame.m_Windows[SLICE_NAME_COMBO]:AddTable(TerminalTextureViewer.GetTextureSlices(self:TextAsWideString()))
	else
	  frame.m_Windows[SLICE_NAME_COMBO]:SetDisabledFlag(true)
	end
	
	frame.m_Windows[SET_TEXTURE_BTN]:OnLButtonUp()
  end
end

function SLICE_COMBO:OnSelChanged(selection)
  
  local frame = self:GetParent()
  if selection >= 1 then
	frame.m_Windows[SLICE_NAME_EDIT]:SetText(self:TextAsWideString())
	frame.m_Windows[SET_TEXTURE_BTN]:OnLButtonUp()
	
  end
end

------------------------------------

function TEXTURE_FRAME:Create()
  local frame = self:CreateFrameForExistingWindow (WINDOW_NAME .. "Textures")

  if (frame) then
	local win =
	{
	  [TEXTURE_NAME_LABEL] = Label:CreateFrameForExistingWindow(frame:GetName() .. "TextureEditLabel"),
	  [TEXTURE_NAME_EDIT] = TEXTURE_NAME:CreateFrameForExistingWindow(frame:GetName() .. "TextureEditBox"),
	--  [TEXTURE_NAME_COMBO_LABEL] = Label:CreateFrameForExistingWindow(frame:GetName() .. "SelectionScrollbar"),
	  [TEXTURE_NAME_COMBO] = TEXTURE_COMBO:CreateFrameForExistingWindow(frame:GetName().."TextureComboBox"),
	  [SLICE_NAME_LABEL] = Label:CreateFrameForExistingWindow(frame:GetName() .. "TextureSliceEditLabel"),
	  [SLICE_NAME_EDIT] = SLICE_NAME:CreateFrameForExistingWindow(frame:GetName() .. "TextureSliceEditBox"),
	 -- [SLICE_NAME_COMBO_LABEL] = Label:CreateFrameForExistingWindow(frame:GetName() .. "SelectionScrollbar"),
	  [SLICE_NAME_COMBO] = SLICE_COMBO:CreateFrameForExistingWindow(frame:GetName().."SliceComboBox"),
	  [X_DIM_LABEL] = Label:CreateFrameForExistingWindow(frame:GetName() .. "TextureXEditLabel"),
	  [X_DIM_EDIT] = X_DIM:CreateFrameForExistingWindow(frame:GetName() .. "TextureXEditBox"),
	  [Y_DIM_LABEL] = Label:CreateFrameForExistingWindow(frame:GetName() .. "TextureYEditLabel"),
	  [Y_DIM_EDIT] = Y_DIM:CreateFrameForExistingWindow(frame:GetName().."TextureYEditBox"),
	  [TEXTURE_DISPLAY] = TEXTURE:CreateFrameForExistingWindow(frame:GetName() .. "Texture"),
	  [SET_TEXTURE_BTN] = SET_TEXTURE_BUTTON:CreateFrameForExistingWindow(frame:GetName().."SetTexture"),
	  [X_TRACKER] = TRACKER_X:Create(frame:GetName().."TrackGuidelineX", frame:GetName()),
	  [Y_TRACKER] = TRACKER_Y:Create(frame:GetName().."TrackGuidelineY", frame:GetName()),
	  [TRACK_FRAME] = TRACKER_FRAME:CreateFromTemplate(frame:GetName().."TrackFrame", frame:GetName()),
	}
	
	frame.m_Windows = win
	
	win[TEXTURE_NAME_LABEL]:SetText(L"Texture Name:")
	win[SLICE_NAME_LABEL]:SetText(L"Texture Slice:")
	win[X_DIM_LABEL]:SetText(L"X:")
	win[X_DIM_EDIT]:SetText(L"0")
	win[Y_DIM_LABEL]:SetText(L"Y:")
	win[Y_DIM_EDIT]:SetText(L"0")
	win[SET_TEXTURE_BTN]:SetText(L"Set Texture")
	win[TEXTURE_DISPLAY]:OnMButtonUp()
	win[TEXTURE_NAME_COMBO]:AddTable(TerminalTextureViewer.GetTextureNames())
	win[SLICE_NAME_COMBO]:AddMenuItem(L"")
	
	frame:SetTrackingFrameLock(false)
	frame:SetNotTracking()
	frame:UpdateTrackLabels()
	frame:Show (true)
  end
  
  return frame
end

function TEXTURE_FRAME.OnResizeEnd()
  local texture = GetFrame(WINDOW_NAME .. "Textures").m_Windows[TEXTURE_DISPLAY]
  local x, y = texture:GetDimensions(true)
  texture:SetTextureDimensions(x, y)
end

function SET_TEXTURE_BUTTON:OnLButtonUp()
  local win = self:GetParent().m_Windows
  local settings = TerminalTextureViewer:GetSettings().textures
  local texture = win[TEXTURE_NAME_EDIT]:TextAsString()
  local slice = win[SLICE_NAME_EDIT]:TextAsString()
  local x = win[X_DIM_EDIT]:TextAsNumber()
  local y = win[Y_DIM_EDIT]:TextAsNumber()
  local w, h = win[TEXTURE_DISPLAY]:GetDimensions(true)
  
  if( texture ~= L"" ) then
	settings.texture = texture
	settings.offsetX = math.abs((x) or 0)
	settings.offsetY = math.abs((y) or 0)
	
	win[TEXTURE_DISPLAY]:SetTexture(texture, settings.offsetX, settings.offsetY)
	win[TEXTURE_DISPLAY]:SetTextureDimensions(w, h)
	
	if( slice ~= L"" ) then
	  --commented out because freezes the tracking after
	  --settings.slice = slice
	  win[TEXTURE_DISPLAY]:SetTextureSlice(slice)
	end
	
	local editor = self:GetParent()
	editor:SetTrackingFrameLock(false)
	editor:SetTrackingLock(false)
	editor:SetNotTracking()
	editor:UpdateTrackFrame()
  end
end

function TEXTURE:OnLButtonUp()
  local win = self:GetParent()
  local settings = TerminalTextureViewer:GetSettings().textures
  
  if (settings.texture ~= L"") and (settings.slice == L"") then
	if( settings.trackingLocked ) then
	  win:SetTrackingFrameLock( true )
	  win:ClearGuidelines( )
	else
	  win:SetTrackingLock( true )
	end
  end
end

--
function TEXTURE:OnRButtonUp()
  local win = self:GetParent()
  local settings = TerminalTextureViewer:GetSettings().textures
  if settings.trackingLocked then
	win:SetNotTracking( )
	win:SetTrackingLock( false )
	win:SetTrackingFrameLock( false )
  end

end

function TEXTURE:OnMButtonUp()
  local win = self:GetParent().m_Windows
  local settings = TerminalTextureViewer:GetSettings().textures
  local colorX = TEXTURE_VIEWER_SCROLL_DIRECTION_NORMAL
  local colorY = TEXTURE_VIEWER_SCROLL_DIRECTION_HIGHLIGHT
  settings.scrollY = not settings.scrollY
  
  if( not settings.scrollY ) then
	colorX = TEXTURE_VIEWER_SCROLL_DIRECTION_HIGHLIGHT
	colorY = TEXTURE_VIEWER_SCROLL_DIRECTION_NORMAL
  end
  
  win[X_DIM_EDIT]:SetTintColor(colorX.r, colorX.g, colorX.b)
  win[Y_DIM_EDIT]:SetTintColor(colorY.r, colorY.g, colorY.b)
end

function TEXTURE:OnMouseWheel( argX, argY, delta, flags )
  local win = self:GetParent().m_Windows
  local settings = TerminalTextureViewer:GetSettings().textures
  
  if( (settings.texture ~= L"") and (settings.slice == L"") ) then
	if( settings.trackingLocked ) then
	  return
	end
	
	local x = settings.offsetX
	local y = settings.offsetY
	
	if( delta < 0 ) then
	  if( settings.scrollY ) then
		y = y + TEXTURE_VIEWER_SCROLL_VALUE
	  else
		x = x + TEXTURE_VIEWER_SCROLL_VALUE
	  end
	elseif( delta > 0 ) then
	  if( settings.scrollY ) then
		y = math.max( y - TEXTURE_VIEWER_SCROLL_VALUE, 0 )
	  else
		x = math.max( x - TEXTURE_VIEWER_SCROLL_VALUE, 0 )
	  end
	end
	
	win[X_DIM_EDIT]:SetText(x)
	win[Y_DIM_EDIT]:SetText(y)
	win[SET_TEXTURE_BTN]:OnLButtonUp()
  end
  
end

function TEXTURE_FRAME:OnShown()
  self:SetScript("OnUpdate", "FrameManager.OnUpdate")
end

function TEXTURE_FRAME:OnHidden()
  self:SetScript("OnUpdate")
end
------------------------------------
--
--
function TEXTURE_FRAME:OnUpdate( timePassed )
  local settings = TerminalTextureViewer:GetSettings().textures
  local mouseoverWindow = FrameManager:GetMouseOverWindow ()
  local texture = self.m_Windows[TEXTURE_DISPLAY]
  local mouseX, mouseY = warExtended:GetMousePosition()
  
  if mouseoverWindow and mouseoverWindow:GetName() == texture:GetName() then
	if( settings.lastUpdate < TEXTURE_VIEWER_UPDATE_INTERVAL ) then
	  settings.lastUpdate = settings.lastUpdate + timePassed
	  return
	else
	  settings.lastUpdate = 0
	end
	if( (settings.texture == L"") or (settings.slice ~= L"") ) then
	  self:SetNotTracking( )
	  return
	end
	
	settings.lastMouseX = mouseX
	settings.lastMouseY = mouseY
	local posX, posY = texture:GetScaledScreenPosition()
	
	if( settings.trackingLocked ) then
	  if( not settings.trackingFrameLocked ) then
		settings.dimensionX = settings.lastMouseX - posX + settings.offsetX - settings.relativeX
		settings.dimensionY = settings.lastMouseY - posY + settings.offsetY - settings.relativeY
		self:SetGuidelines( settings.relativeX + settings.dimensionX - settings.offsetX, settings.relativeY + settings.dimensionY - settings.offsetY )
	  end
	else
	  settings.relativeX = settings.lastMouseX - posX + settings.offsetX
	  settings.relativeY = settings.lastMouseY - posY + settings.offsetY
	  self:SetGuidelines( settings.relativeX - settings.offsetX, settings.relativeY - settings.offsetY)
	end
  else
	if( self:GuidelinesVisible( ) ) then
	  self:ClearGuidelines( )
	end
	
	if( settings.lastMouseX == "~" ) then
	  return
	end
	
	if( not settings.trackingFrameLocked ) then
	  self:SetNotTracking( )
	end
 
	settings.lastUpdate = 0
  end
  
  self:UpdateTrackLabels( )
  self:UpdateTrackFrame( )

end


------------------------------------
--
--
function TEXTURE_FRAME:SetNotTracking( )
  local settings = TerminalTextureViewer:GetSettings().textures
  settings.lastMouseX = "~"
  settings.lastMouseY = "~"
  if( not settings.trackingLocked ) then
	settings.dimensionX = settings.relativeX
	settings.dimensionY = settings.relativeY
	settings.relativeX = "~"
	settings.relativeY = "~"
  end

end


------------------------------------
--
--
function TEXTURE_FRAME:UpdateTrackLabels( )
  local settings = TerminalTextureViewer:GetSettings().textures
  local xValue
  local yValue
  if( settings.trackingLocked ) then
	xValue = settings.dimensionX
	yValue = settings.dimensionY
	if warExtended:IsType(settings.dimensionX, "number") then
	  xValue = math.ceil(settings.dimensionX)
	  yValue = math.ceil(settings.dimensionY)
	end
	--LabelSetText( "TerminalTextureViewerTexturesTextureWHTrackLabel", L"Dimensions:    " .. towstring(xValue) .. L", " .. towstring(math.ceil(yValue)) )
  else
	xValue = settings.relativeX
	yValue = settings.relativeY
	if warExtended:IsType(settings.relativeX, "number") then
	  xValue = math.ceil(settings.relativeX)
	  yValue = math.ceil(settings.relativeY)
	end
	--LabelSetText( "TerminalTextureViewerTexturesTextureXYTrackLabel", L"Coordinates:    " .. towstring(xValue) .. L", " .. towstring(yValue) )
  end
end




function TEXTURE_FRAME:SetTrackingLock( lock )
  local settings = TerminalTextureViewer:GetSettings().textures
  settings.trackingLocked = lock
  
  local color = TEXTURE_VIEWER_SCROLL_DIRECTION_NORMAL
  if( lock ) then
	color = TEXTURE_VIEWER_SCROLL_DIRECTION_HIGHLIGHT
  else
	settings.dimensionX = 0
	settings.dimensionX = 0
  end
  
 -- LabelSetTextColor( "TerminalTextureViewerTexturesTextureXYTrackLabel", color.r, color.g, color.b )
 -- WindowSetShowing( "TerminalTextureViewerTexturesTextureWHTrackLabel", lock )
end


------------------------------------
--
--
function TEXTURE_FRAME:SetTrackingFrameLock( frameLock )
  local settings = TerminalTextureViewer:GetSettings().textures
  settings.trackingFrameLocked = frameLock
  
  local color = TEXTURE_VIEWER_SCROLL_DIRECTION_NORMAL
  if( frameLock ) then
	color = TEXTURE_VIEWER_SCROLL_DIRECTION_HIGHLIGHT
  end
  
 -- LabelSetTextColor( "TerminalTextureViewerTexturesTextureWHTrackLabel", color.r, color.g, color.b )
end


------------------------------------
--
--
function TEXTURE_FRAME:UpdateTrackFrame( )
  local settings = TerminalTextureViewer:GetSettings().textures
  local trackFrame = self.m_Windows[TRACK_FRAME]
  trackFrame:ClearAnchors()
  
  if( settings.trackingLocked ) then
	if( (settings.dimensionX == 0) or (settings.dimensionY == 0) ) then
	  return
	end
	local relativePoint
	if( settings.dimensionX < 0 ) then
	  if( settings.dimensionY < 0 ) then
		relativePoint = "bottomright"
	  else
		relativePoint = "topright"
	  end
	else
	  if( settings.dimensionY < 0 ) then
		relativePoint = "bottomleft"
	  else
		relativePoint = "topleft"
	  end
	end
	
	local uiScale = InterfaceCore.GetScale( )
	trackFrame:SetAnchor (
			{Point = "topleft", RelativePoint = relativePoint, RelativeTo=self:GetName().."Texture", XOffset = (settings.relativeX - settings.offsetX) / uiScale, YOffset = (settings.relativeY - settings.offsetY) / uiScale}
	)
	trackFrame:SetDimensions(math.abs(settings.dimensionX/uiScale), math.abs(settings.dimensionY/uiScale))
  end
  trackFrame:Show(settings.trackingLocked)
end


function TEXTURE_FRAME:GuidelinesVisible( )
  local isVisible = self.m_Windows[X_TRACKER]:IsShowing()
  return isVisible
end


function TEXTURE_FRAME:ClearGuidelines( )
  local guideX, guideY = self.m_Windows[X_TRACKER], self.m_Windows[Y_TRACKER]
  guideX:Show(false)
  guideY:Show(false)
  warExtended:SetCursor()
end


function TEXTURE_FRAME:SetGuidelines( x, y )
  local uiScale = InterfaceCore.GetScale( )
  local guideX, guideY = self.m_Windows[X_TRACKER], self.m_Windows[Y_TRACKER]
  
  guideX:ClearAnchors()
  guideX:SetAnchor (
  {Point = "topleft", RelativePoint = "topleft", RelativeTo=self:GetName().."Texture", XOffset = 0, YOffset = y/uiScale},
  {Point = "topright", RelativePoint = "topright", RelativeTo=self:GetName().."Texture", XOffset = 0, YOffset = y/uiScale}
  )

  guideY:ClearAnchors()
  guideY:SetAnchor (
  {Point = "topleft", RelativePoint = "topleft", RelativeTo=self:GetName().."Texture", XOffset = x/uiScale, YOffset = 0},
  {Point = "bottomleft", RelativePoint = "bottomleft", RelativeTo=self:GetName().."Texture", XOffset = x/uiScale, YOffset = 0}
  )
  
  guideX:Show(true)
  guideY:Show(true)

  warExtended:SetCursor(15)
end
