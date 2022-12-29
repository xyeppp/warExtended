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

local TEXTURE_FRAME     = Frame:Subclass(WINDOW_NAME .. "Textures")
local SET_TEXTURE_BUTTON  = ButtonFrame:Subclass(WINDOW_NAME.."TexturesSetTexture")
local TEXTURE_NAME = TextEditBox:Subclass(WINDOW_NAME.."TexturesTextureEditBox")
local TEXTURE_COMBO = ComboBox:Subclass(WINDOW_NAME.."IconSelectionScrollbar")
local SLICE_NAME = TextEditBox:Subclass(WINDOW_NAME.."IconSelectionScrollbar")
local SLICE_COMBO = ComboBox:Subclass(WINDOW_NAME.."IconSelectionScrollbar")
local X_DIM = TextEditBox:Subclass()
local Y_DIM = X_DIM:Subclass()
local TEXTURE = DynamicImage:Subclass()

------------------------------------
--
--
function TextureViewer.Initialize( )
  
  TextureViewer.lastUpdate = 0
  TextureViewer.texture = L""
  TextureViewer.slice = L""
  TextureViewer.offsetX = 0
  TextureViewer.offsetY = 0
  TextureViewer.trackingLocked = false
  TextureViewer.scrollY = true
  TextureViewer.ShowScrollDirectionIndication( )
  
  LabelSetText( "TerminalTextureViewerTexturesTextureEditLabel", L"Texture Name:" )
  LabelSetText( "TerminalTextureViewerTexturesTextureSliceEditLabel", L"Texture Slice:" )
  LabelSetText( "TerminalTextureViewerTexturesTextureXEditLabel", L"X:" )
  LabelSetText( "TerminalTextureViewerTexturesTextureYEditLabel", L"Y:" )
  TextEditBoxSetText( "TerminalTextureViewerTexturesTextureXEditBox", L"0" )
  TextEditBoxSetText( "TerminalTextureViewerTexturesTextureYEditBox", L"0" )
  ButtonSetText( "TerminalTextureViewerTexturesSetTextureButton", L"Set Texture" )
  
  CreateWindowFromTemplate( "TextureViewerToggleButton", "TextureViewerToggleButtonTemplate", "DebugWindow" )
  ButtonSetText( "TextureViewerToggleButton", L"Texture Viewer" )
  WindowRegisterCoreEventHandler( "TextureViewerToggleButton", "OnLButtonUp", "TextureViewer.ToggleViewer" )
  WindowAddAnchor( "TextureViewerToggleButton", "topright", "DebugWindowReloadUi", "topleft", 60, 0 )
  
  CreateWindowFromTemplate( "TextureViewerTrackFrame", "TextureViewerTrackFrameTemplate", "TerminalTextureViewerTextures" )
  TextureViewer.SetTrackingFrameLock( false )
  
  local uiScale = InterfaceCore.GetScale( )
  CreateWindowFromTemplate( "TextureViewerTrackGuidelineX", "TextureViewerTrackFrameTemplate", "TerminalTextureViewerTextures" )
  WindowSetShowing( "TextureViewerTrackGuidelineX", true )
  WindowSetDimensions( "TextureViewerTrackGuidelineX", 1 / uiScale, 1 / uiScale )
  WindowSetTintColor( "TextureViewerTrackGuidelineX", TEXTURE_VIEWER_GUIDELINE_COLOR.r, TEXTURE_VIEWER_GUIDELINE_COLOR.g, TEXTURE_VIEWER_GUIDELINE_COLOR.b )
  WindowSetAlpha( "TextureViewerTrackGuidelineX", 0.5 )
  
  CreateWindowFromTemplate( "TextureViewerTrackGuidelineY", "TextureViewerTrackFrameTemplate", "TerminalTextureViewerTextures" )
  WindowSetShowing( "TextureViewerTrackGuidelineY", true )
  WindowSetDimensions( "TextureViewerTrackGuidelineY", 1 / uiScale, 1 / uiScale )
  WindowSetTintColor( "TextureViewerTrackGuidelineY", TEXTURE_VIEWER_GUIDELINE_COLOR.r, TEXTURE_VIEWER_GUIDELINE_COLOR.g, TEXTURE_VIEWER_GUIDELINE_COLOR.b )
  WindowSetAlpha( "TextureViewerTrackGuidelineY", 0.5 )
  
  TextureViewer.SetNotTracking( )
  TextureViewer.UpdateTrackLabels( )

end


------------------------------------
--
--
function TextureViewer.Shutdown()

end


------------------------------------
--
--
function TextureViewer.OnResizeBegin( )
  
  WindowUtils.BeginResize( "TerminalTextureViewerTextures", "topleft", 650, 300, TextureViewer.OnResizeEnd )

end


------------------------------------
--
--
function TextureViewer.OnResizeEnd( )
  
  local w, h = WindowGetDimensions( "TerminalTextureViewerTexturesTexture" )
  DynamicImageSetTextureDimensions( "TerminalTextureViewerTexturesTexture", w, h )

end


------------------------------------
--
--
function TextureViewer.Hide( )
  
  WindowSetShowing( "TerminalTextureViewerTextures", false )

end


------------------------------------
--
--
function TextureViewer.Show( )
  
  WindowSetShowing( "TerminalTextureViewerTextures", true )
  WindowAssignFocus( "TerminalTextureViewerTexturesTextureEditBox", true )

end


------------------------------------
--
--
function TextureViewer.ToggleViewer( )
  
  if( WindowGetShowing( "TerminalTextureViewerTextures" ) ) then
	TextureViewer.Hide( )
  else
	TextureViewer.Show( )
  end

end


------------------------------------
--
--
function TextureViewer.OnLButtonUpSetTextureButton( )
  
  local texture = TextEditBoxGetText( "TerminalTextureViewerTexturesTextureEditBox" )
  local slice = TextEditBoxGetText( "TerminalTextureViewerTexturesTextureSliceEditBox" )
  local x = TextEditBoxGetText( "TerminalTextureViewerTexturesTextureXEditBox" )
  local y = TextEditBoxGetText( "TerminalTextureViewerTexturesTextureYEditBox" )
  local w, h = WindowGetDimensions( "TerminalTextureViewerTexturesTexture" )
  
  if( texture ~= L"" ) then
	local n, _ = wstring.find( texture, L"#" )
	if( n ~= nil ) then
	  texture = wstring.sub( texture, 2, wstring.len(texture) )
	  texture, x, y = GetIconData( tonumber(texture) )
	end
	
	TextureViewer.texture = texture
	TextureViewer.offsetX = math.abs(tonumber(x) or 0)
	TextureViewer.offsetY = math.abs(tonumber(y) or 0)
	
	DynamicImageSetTexture( "TerminalTextureViewerTexturesTexture", tostring(texture), TextureViewer.offsetX, TextureViewer.offsetY )
	DynamicImageSetTextureDimensions( "TerminalTextureViewerTexturesTexture", w, h )
	
	if( slice ~= L"" ) then
	  --commented out because freezes the tracking after
	  --TextureViewer.slice = slice
	  DynamicImageSetTextureSlice( "TerminalTextureViewerTexturesTexture", tostring(slice) )
	end
	
	TextureViewer.SetTrackingFrameLock( false )
	TextureViewer.SetTrackingLock( false )
	TextureViewer.SetNotTracking( )
	TextureViewer.UpdateTrackFrame( )
  end

end

------------------------------------
--
--
function TextureViewer.OnMouseWheel( argX, argY, delta, flags )
  
  if( (TextureViewer.texture ~= L"") and (TextureViewer.slice == L"") ) then
	if( TextureViewer.trackingLocked ) then
	  return
	end
	
	local x = TextureViewer.offsetX
	local y = TextureViewer.offsetY
	
	if( delta < 0 ) then
	  if( TextureViewer.scrollY ) then
		y = y + TEXTURE_VIEWER_SCROLL_VALUE
	  else
		x = x + TEXTURE_VIEWER_SCROLL_VALUE
	  end
	elseif( delta > 0 ) then
	  if( TextureViewer.scrollY ) then
		y = math.max( y - TEXTURE_VIEWER_SCROLL_VALUE, 0 )
	  else
		x = math.max( x - TEXTURE_VIEWER_SCROLL_VALUE, 0 )
	  end
	end
	
	TextEditBoxSetText( "TerminalTextureViewerTexturesTextureXEditBox", towstring(math.abs(x)) )
	TextEditBoxSetText( "TerminalTextureViewerTexturesTextureYEditBox", towstring(math.abs(y)) )
	
	TextureViewer.OnLButtonUpSetTextureButton( )
  end

end


------------------------------------
--
--
function TextureViewer.OnMButtonUp( )
  
  TextureViewer.scrollY = not TextureViewer.scrollY
  TextureViewer.ShowScrollDirectionIndication( )

end


------------------------------------
--
--
function TextureViewer.Update( timePassed )
  
  if( "TerminalTextureViewerTexturesTexture" == SystemData.MouseOverWindow.name ) then
	if( TextureViewer.lastUpdate < TEXTURE_VIEWER_UPDATE_INTERVAL ) then
	  TextureViewer.lastUpdate = TextureViewer.lastUpdate + timePassed
	  return
	else
	  TextureViewer.lastUpdate = 0
	end
	if( (TextureViewer.texture == L"") or (TextureViewer.slice ~= L"") ) then
	  TextureViewer.SetNotTracking( )
	  return
	end
	
	TextureViewer.lastMouseX = SystemData.MousePosition.x
	TextureViewer.lastMouseY = SystemData.MousePosition.y
	local posX, posY = WindowGetScreenPosition( "TerminalTextureViewerTexturesTexture" )
	
	if( TextureViewer.trackingLocked ) then
	  if( not TextureViewer.trackingFrameLocked ) then
		TextureViewer.dimensionX = TextureViewer.lastMouseX - posX + TextureViewer.offsetX - TextureViewer.relativeX
		TextureViewer.dimensionY = TextureViewer.lastMouseY - posY + TextureViewer.offsetY - TextureViewer.relativeY
		TextureViewer.SetGuidelines( TextureViewer.relativeX + TextureViewer.dimensionX - TextureViewer.offsetX, TextureViewer.relativeY + TextureViewer.dimensionY - TextureViewer.offsetY )
	  end
	else
	  TextureViewer.relativeX = TextureViewer.lastMouseX - posX + TextureViewer.offsetX
	  TextureViewer.relativeY = TextureViewer.lastMouseY - posY + TextureViewer.offsetY
	  TextureViewer.SetGuidelines( TextureViewer.relativeX - TextureViewer.offsetX, TextureViewer.relativeY - TextureViewer.offsetY)
	end
  else
	if( TextureViewer.GuidelinesVisible( ) ) then
	  TextureViewer.ClearGuidelines( )
	end
	
	if( TextureViewer.lastMouseX == "~" ) then
	  return
	end
	
	if( not TextureViewer.trackingFrameLocked ) then
	  TextureViewer.SetNotTracking( )
	end
	
	TextureViewer.lastUpdate = 0
  end
  
  TextureViewer.UpdateTrackLabels( )
  TextureViewer.UpdateTrackFrame( )

end


------------------------------------
--
--
function TextureViewer.SetNotTracking( )
  
  TextureViewer.lastMouseX = "~"
  TextureViewer.lastMouseY = "~"
  if( not TextureViewer.trackingLocked ) then
	TextureViewer.dimensionX = TextureViewer.relativeX
	TextureViewer.dimensionY = TextureViewer.relativeY
	TextureViewer.relativeX = "~"
	TextureViewer.relativeY = "~"
  end

end


------------------------------------
--
--
function TextureViewer.UpdateTrackLabels( )
  
  local xValue
  local yValue
  if( TextureViewer.trackingLocked ) then
	xValue = TextureViewer.dimensionX
	yValue = TextureViewer.dimensionY
	if( type(TextureViewer.dimensionX) == "number" ) then
	  xValue = math.ceil(TextureViewer.dimensionX)
	  yValue = math.ceil(TextureViewer.dimensionY)
	end
	LabelSetText( "TerminalTextureViewerTexturesTextureWHTrackLabel", L"Dimensions:    " .. towstring(xValue) .. L", " .. towstring(math.ceil(yValue)) )
  else
	xValue = TextureViewer.relativeX
	yValue = TextureViewer.relativeY
	if( type(TextureViewer.relativeX) == "number" ) then
	  xValue = math.ceil(TextureViewer.relativeX)
	  yValue = math.ceil(TextureViewer.relativeY)
	end
	LabelSetText( "TerminalTextureViewerTexturesTextureXYTrackLabel", L"Coordinates:    " .. towstring(xValue) .. L", " .. towstring(yValue) )
  end

end


------------------------------------
--
--
function TextureViewer.ShowScrollDirectionIndication( )
  
  local colorX = TEXTURE_VIEWER_SCROLL_DIRECTION_NORMAL
  local colorY = TEXTURE_VIEWER_SCROLL_DIRECTION_HIGHLIGHT
  if( not TextureViewer.scrollY ) then
	colorX = TEXTURE_VIEWER_SCROLL_DIRECTION_HIGHLIGHT
	colorY = TEXTURE_VIEWER_SCROLL_DIRECTION_NORMAL
  end
  
  WindowSetTintColor( "TerminalTextureViewerTexturesTextureXEditBox", colorX.r, colorX.g, colorX.b )
  WindowSetTintColor( "TerminalTextureViewerTexturesTextureYEditBox", colorY.r, colorY.g, colorY.b )

end


------------------------------------
--
--
function TextureViewer.OnLButtonUp( )
  
  if( (TextureViewer.texture ~= L"") and (TextureViewer.slice == L"") ) then
	if( TextureViewer.trackingLocked ) then
	  TextureViewer.SetTrackingFrameLock( true )
	  TextureViewer.ClearGuidelines( )
	else
	  TextureViewer.SetTrackingLock( true )
	end
  end

end


------------------------------------
--
--
function TextureViewer.OnRButtonUp( )
  
  if( TextureViewer.trackingLocked ) then
	TextureViewer.SetNotTracking( )
	TextureViewer.SetTrackingLock( false )
	TextureViewer.SetTrackingFrameLock( false )
  end

end


------------------------------------
--
--
function TextureViewer.SetTrackingLock( lock )
  
  TextureViewer.trackingLocked = lock
  
  local color = TEXTURE_VIEWER_SCROLL_DIRECTION_NORMAL
  if( lock ) then
	color = TEXTURE_VIEWER_SCROLL_DIRECTION_HIGHLIGHT
  else
	TextureViewer.dimensionX = 0
	TextureViewer.dimensionX = 0
  end
  
  LabelSetTextColor( "TerminalTextureViewerTexturesTextureXYTrackLabel", color.r, color.g, color.b )
  WindowSetShowing( "TerminalTextureViewerTexturesTextureWHTrackLabel", lock )
end


------------------------------------
--
--
function TextureViewer.SetTrackingFrameLock( frameLock )
  
  TextureViewer.trackingFrameLocked = frameLock
  
  local color = TEXTURE_VIEWER_SCROLL_DIRECTION_NORMAL
  if( frameLock ) then
	color = TEXTURE_VIEWER_SCROLL_DIRECTION_HIGHLIGHT
  end
  
  LabelSetTextColor( "TerminalTextureViewerTexturesTextureWHTrackLabel", color.r, color.g, color.b )
end


------------------------------------
--
--
function TextureViewer.UpdateTrackFrame( )
  
  WindowClearAnchors( "TextureViewerTrackFrame" )
  if( TextureViewer.trackingLocked ) then
	if( (TextureViewer.dimensionX == 0) or (TextureViewer.dimensionY == 0) ) then
	  return
	end
	local relativePoint
	if( TextureViewer.dimensionX < 0 ) then
	  if( TextureViewer.dimensionY < 0 ) then
		relativePoint = "bottomright"
	  else
		relativePoint = "topright"
	  end
	else
	  if( TextureViewer.dimensionY < 0 ) then
		relativePoint = "bottomleft"
	  else
		relativePoint = "topleft"
	  end
	end
	
	local uiScale = InterfaceCore.GetScale( )
	WindowAddAnchor( "TextureViewerTrackFrame", "topleft", "TerminalTextureViewerTexturesTexture", relativePoint, (TextureViewer.relativeX - TextureViewer.offsetX) / uiScale, (TextureViewer.relativeY - TextureViewer.offsetY) / uiScale )
	WindowSetDimensions( "TextureViewerTrackFrame", math.abs(TextureViewer.dimensionX / uiScale), math.abs(TextureViewer.dimensionY / uiScale) )
  end
  WindowSetShowing( "TextureViewerTrackFrame", TextureViewer.trackingLocked )

end


function TextureViewer.GuidelinesVisible( )
  
  return WindowGetShowing( "TextureViewerTrackGuidelineX" )

end


function TextureViewer.ClearGuidelines( )
  
  WindowSetShowing( "TextureViewerTrackGuidelineX", false )
  WindowSetShowing( "TextureViewerTrackGuidelineY", false )
  
  ClearCursor( )

end


function TextureViewer.SetGuidelines( x, y )
  local uiScale = InterfaceCore.GetScale( )
  
  WindowClearAnchors( "TextureViewerTrackGuidelineX" )
  WindowAddAnchor( "TextureViewerTrackGuidelineX", "topleft", "TerminalTextureViewerTextures", "topleft", 0, y / uiScale )
  WindowAddAnchor( "TextureViewerTrackGuidelineX", "topright", "TerminalTextureViewerTextures", "topright", 0, y / uiScale )
  
  WindowClearAnchors( "TextureViewerTrackGuidelineY" )
  WindowAddAnchor( "TextureViewerTrackGuidelineY", "topleft", "TerminalTextureViewerTextures", "topleft", x / uiScale, 0 )
  WindowAddAnchor( "TextureViewerTrackGuidelineY", "bottomleft", "TerminalTextureViewerTextures", "bottomleft", x / uiScale, 0 )
  
  WindowSetShowing( "TextureViewerTrackGuidelineX", true )
  WindowSetShowing( "TextureViewerTrackGuidelineY", true )
  
  SetHardwareCursor( 15 )

end
