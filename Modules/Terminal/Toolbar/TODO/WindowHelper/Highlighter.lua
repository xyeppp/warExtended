local warExtendedTerminal = warExtendedTerminal
local WindowSetShowing = WindowSetShowing
local WindowClearAnchors = WindowClearAnchors
local WindowAddAnchor = WindowAddAnchor
local DestroyWindow = DestroyWindow
local FOCUS_WINDOW = "WindowHighlightFocus"

local highlightWindow = {
  createSelfTemplate= function(self, parentName)
	CreateWindowFromTemplate(self.name, FOCUS_WINDOW, "Root")
  end,
  
  addAnchor = function(self, parentName)
	WindowClearAnchors(self.name)
	WindowAddAnchor(self.name, "topleft", parentName, "topleft", -2, -2 )
	WindowAddAnchor(self.name, "bottomright", parentName, "bottomright", 2, 2 )
  end,
  
  show = function (self)
	WindowSetShowing( self.name, true )
	WindowStartAlphaAnimation(self.name, Window.AnimationType.LOOP, 1, 0, 0.5, false, 0, 0)
  end,
  
  hide = function(self)
	WindowSetShowing( self.name, false )
  end,
  
  registerNewHighlightWindow = function(self, windowName)
	local newHighlight = setmetatable({ }, { __index = self })
	newHighlight.name = windowName..FOCUS_WINDOW
	newHighlight:createSelfTemplate(windowName)
	newHighlight:addAnchor(windowName)
	return newHighlight
  end,
  
  unregisterHighlightWindow = function(self, windowName)
	DestroyWindow(self.name)
	warExtendedTerminal.Settings.highlightedWindows[windowName] = nil
  end
}


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
  if not warExtendedTerminal:WindowDoesExist(windowName) then
	warExtendedTerminal.ConsoleLog(windowName.." window does not exist.")
	return
  end
  
  if windowHighlighter:isHighlighted(windowName) then
	windowHighlighter:unhighlightWindow(windowName)
	return
  end
  
  windowHighlighter:highlightWindow(windowName)
end

warExtended:AddEventHandler("HighlightWindows", "CoreInitialized", windowHighlighter.onInterfaceReload)


