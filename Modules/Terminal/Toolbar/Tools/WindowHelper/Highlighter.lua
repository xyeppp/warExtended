local warExtendedTerminal = warExtendedTerminal
local WindowSetShowing = WindowSetShowing
local WindowClearAnchors = WindowClearAnchors
local WindowAddAnchor = WindowAddAnchor
local DestroyWindow = DestroyWindow
local WINDOW_NAME = "Highlight"
local ANCHOR_NAME = "AnchorHighlight"
local FRAME_NAME = "TerminalWindowHelperHighlight"

local AnchorHighlight = Frame:Subclass(FRAME_NAME)


local WindowHighlight = Frame:Subclass(FRAME_NAME)

function WindowHighlight:Create(parentName)
  local frame = self:CreateFromTemplate(WINDOW_NAME..parentName, parentName)
  frame:ClearAnchors()
  frame:SetAnchor(
		  { Point = "topleft", RelativePoint = "topleft", RelativeTo = parentName, XOffset = -2, YOffset = -2 },
		  { Point = "bottomright", RelativePoint = "bottomright", RelativeTo = parentName, XOffset = 2, YOffset = 2 }
  )

  frame:Show(true)
  frame:StartAlphaAnimation(Window.AnimationType.LOOP, 1, 0, 0.5, 0, 0)
  return frame
end

function WindowHighlight:CreateAnchorHighlight(parentName)
    local frame = self:CreateFromTemplate(ANCHOR_NAME..parentName, parentName)
    frame:ClearAnchors()
    frame:SetAnchor(
            { Point = "topleft", RelativePoint = "topleft", RelativeTo = parentName, XOffset = -2, YOffset = -2 },
            { Point = "topleft", RelativePoint = "topleft", RelativeTo = parentName, XOffset = 6, YOffset = 6 }
    )

    frame:Show(true)
    frame:SetTintColor(0, 255, 0)
    frame:StartAlphaAnimation(Window.AnimationType.LOOP, 1, 0, 0.5, 0, 0)
    return frame
end

function WindowHighlight:IsHighlighted(parentName)
  return GetFrame(WINDOW_NAME..parentName) or GetFrame(ANCHOR_NAME..parentName)
end

function WindowHighlight:DestroyWindow(frame)
    frame:Destroy()
end





local windowHighlighter = {
  isHighlighted = function(self, windowName)
	if warExtendedTerminal.Settings.highlightedWindows[windowName] then
	  return true
	end
  end,

  highlightWindow = function(self, windowName)
	warExtendedTerminal.Settings.highlightedWindows[windowName] = highlightWindow:registerNewHighlightWindow(windowName)
	warExtendedTerminal.Settings.highlightedWindows[windowName]:show()
  end,

  unhighlightWindow = function(self, windowName)
	warExtendedTerminal.Settings.highlightedWindows[windowName]:hide()
	warExtendedTerminal.Settings.highlightedWindows[windowName]:unregisterHighlightWindow(windowName)
  end,
}

function windowHighlighter:onInterfaceReload()
  if next(warExtendedTerminal.Settings.highlightedWindows) ~= nil then
	for parentName, _ in pairs(warExtendedTerminal.Settings.highlightedWindows) do
	  windowHighlighter:highlightWindow(parentName)
	end
  end
end

function warExtendedTerminal.HighlightWindow(windowName)
    local frame = WindowHighlight:IsHighlighted(windowName)
    if frame then
        WindowHighlight:DestroyWindow(frame)
	return
  end

  WindowHighlight:Create(windowName)
end


function warExtendedTerminal.HighlightAnchor(windowName)
    local frame = WindowHighlight:IsHighlighted(windowName)
    if frame then
        WindowHighlight:DestroyWindow(frame)
        return
    end

    WindowHighlight:CreateAnchorHighlight(windowName)
end

--warExtended:AddEventHandler("HighlightWindows", "CoreInitialized", windowHighlighter.onInterfaceReload)


