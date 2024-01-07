-- Mod:		TextureViewer
-- Author:	DarthVon (thedpui02@sneakemail.com)
-- Version:	0.7-beta
-- Date:	09/28/2008
-- ========================
-- Description:
--	Views game textures in the game
--


TextureViewer = {}

------------------------------------
--
--
function TextureViewer.Initialize( )
  
  CreateWindowFromTemplate( "TextureViewerTrackFrame", "TextureViewerTrackFrameTemplate", "TextureViewerWindow" )
  
  TextureViewer.SetTrackingFrameLock( false )
  
  
  TextureViewer.SetNotTracking( )
  TextureViewer.UpdateTrackLabels( )

end



------------------------------------
--


------------------------------------
--
--
function TextureViewer.OnLButtonUpSetTextureButton( )
	TextureViewer.SetTrackingFrameLock( false )
	TextureViewer.SetTrackingLock( false )
	TextureViewer.SetNotTracking( )
	TextureViewer.UpdateTrackFrame( )

end


------------------------------------
--
--
function TextureViewer.Update( timePassed )
  
  if( "TextureViewerWindowTexture" == SystemData.MouseOverWindow.name ) then
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
	local posX, posY = WindowGetScreenPosition( "TextureViewerWindowTexture" )
	
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
	LabelSetText( "TextureViewerWindowTextureWHTrackLabel", L"Dimensions:    " .. towstring(xValue) .. L", " .. towstring(math.ceil(yValue)) )
  else
	xValue = TextureViewer.relativeX
	yValue = TextureViewer.relativeY
	if( type(TextureViewer.relativeX) == "number" ) then
	  xValue = math.ceil(TextureViewer.relativeX)
	  yValue = math.ceil(TextureViewer.relativeY)
	end
	LabelSetText( "TextureViewerWindowTextureXYTrackLabel", L"Coordinates:    " .. towstring(xValue) .. L", " .. towstring(yValue) )
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
  
  LabelSetTextColor( "TextureViewerWindowTextureXYTrackLabel", color.r, color.g, color.b )
  WindowSetShowing( "TextureViewerWindowTextureWHTrackLabel", lock )
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
  
  LabelSetTextColor( "TextureViewerWindowTextureWHTrackLabel", color.r, color.g, color.b )
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
	WindowAddAnchor( "TextureViewerTrackFrame", "topleft", "TextureViewerWindowTexture", relativePoint, (TextureViewer.relativeX - TextureViewer.offsetX) / uiScale, (TextureViewer.relativeY - TextureViewer.offsetY) / uiScale )
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
  WindowAddAnchor( "TextureViewerTrackGuidelineX", "topleft", "TextureViewerWindowTexture", "topleft", 0, y / uiScale )
  WindowAddAnchor( "TextureViewerTrackGuidelineX", "topright", "TextureViewerWindowTexture", "topright", 0, y / uiScale )
  
  WindowClearAnchors( "TextureViewerTrackGuidelineY" )
  WindowAddAnchor( "TextureViewerTrackGuidelineY", "topleft", "TextureViewerWindowTexture", "topleft", x / uiScale, 0 )
  WindowAddAnchor( "TextureViewerTrackGuidelineY", "bottomleft", "TextureViewerWindowTexture", "bottomleft", x / uiScale, 0 )
  
  WindowSetShowing( "TextureViewerTrackGuidelineX", true )
  WindowSetShowing( "TextureViewerTrackGuidelineY", true )
  
  SetHardwareCursor( 15 )

end
