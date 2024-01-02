local WindowUtils = WindowUtils

WindowUtils.resizeMax = { x=0, y=0 }

function WindowUtils.Update( timePassed )

  -- Update the resize frame
  if( WindowUtils.resizing ) then

	local x, y = WindowGetDimensions( "ResizingWindowFrame" )
	local resize = false;

	if( x < WindowUtils.resizeMin.x  ) then
	  x = WindowUtils.resizeMin.x
	  resize = true
	  elseif (x > WindowUtils.resizeMax.x) then
  		x = WindowUtils.resizeMax.x
	  resize = true
	end
	if( y < WindowUtils.resizeMin.y ) then
	  y = WindowUtils.resizeMin.y
	  resize = true
	elseif (y > WindowUtils.resizeMax.y) then
	  y = WindowUtils.resizeMax.y
	  resize = true
	end

	if( resize ) then
	  --DEBUG(L"Resizing: "..x..L", "..y )
	  WindowSetDimensions( "ResizingWindowFrame", x, y )
	end

  end
end

function WindowUtils.BeginResize( windowName, anchorCorner, minX, minY, endCallback, maxX, maxY)

  if ( WindowUtils.resizing ) then
	return
  end
  if ( not WindowGetMovable(windowName) ) then
	return
  end

  -- Anchor the resizing frame to the window
  local width, height = WindowGetDimensions( windowName )
  local scale = WindowGetScale(windowName)
  local x, y = WindowGetDimensions( "Root" )

  WindowSetScale( "ResizingWindowFrame", scale )
  WindowSetDimensions( "ResizingWindowFrame", width, height )

  WindowAddAnchor( "ResizingWindowFrame", anchorCorner, windowName, anchorCorner, 0, 0 )

  WindowSetResizing( "ResizingWindowFrame", true, anchorCorner, false );
  WindowSetShowing( "ResizingWindowFrame", true )

  WindowUtils.resizing = true
  WindowUtils.resizeWindow = windowName
  WindowUtils.resizeAnchor = anchorCorner
  WindowUtils.resizeMin.x = minX
  WindowUtils.resizeMax.x = maxX or x
  WindowUtils.resizeMin.y = minY
  WindowUtils.resizeMax.y = maxY or y
  WindowUtils.resizeEndCallback = endCallback
  --DEBUG(L"BeginResize: "..minX..L", "..minY )

  SetHardwareCursor(SystemData.Cursor.RESIZE2)
end


function WindowUtils.SetRelativeAnchors(windowName, parentName, direction)
    --TODO: finish direction later not needed now
    -- direction == left//right or up//down
    -- positions your additional window based on the first window's position on screen eg. options display on left/right depending on where the window is
    local rootWidth,rootHeight = WindowGetDimensions("Root")
    local half = rootWidth / 2
    local mglX,mglY = WindowGetScreenPosition(parentName)
    local wX, wY = WindowGetDimensions(windowName)
    local anchor = nil

    if mglX*2+wX > half then
        anchor = { Point = "topleft",  RelativeTo = parentName, RelativePoint = "topright",   XOffset = 1, YOffset = 0 }
    else
        anchor = { Point = "topright",  RelativeTo = parentName, RelativePoint = "topleft",   XOffset = -1, YOffset = 0 }
    end

    WindowUtils.SetAnchors (windowName, anchor)
end

function WindowUtils.SetAnchors (windowName, anchor, anchor2)
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