warExtendedMirage = warExtended.Register("warExtended Mirage")
local Mirage = warExtendedMirage

Mirage.windowsListData = {}
Mirage.windowsListDataDisplayOrder = {}

local function getMirageSlot(mirageSlot)
  local mirageWindows = Mirage.Settings.MirageSlots[mirageSlot]
  return mirageWindows
end

local function isAddedToMirage(mirageSlot, window)
  local mirageSlot = getMirageSlot(mirageSlot)

  for addedWindows = 1, #mirageSlot do
    local isAdded = window == mirageSlot[addedWindows]
    if isAdded then
      return isAdded
    end
  end

end



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

local function getAnchorPoints()
  local x,y=WindowGetOffsetFromParent("CursorWindow")
  local interfaceScale=InterfaceCore.GetScale()
  local xResolution,yResolution=SystemData.screenResolution.x/4,SystemData.screenResolution.y/4
  local relativePoint1=(x*interfaceScale)>(xResolution*3) and "right" or "left"
  local relativePoint2=(y*interfaceScale)>(yResolution*3) and "top" or "bottom"

  local anchorTable = {
    ["RelativeTo"] = "Root",
    ["Point"] = "topleft",
    ["RelativePoint"] = relativePoint1 .. relativePoint2,
    ["XOffset"] = x,
    ["YOffset"] = y
  }

  return anchorTable
end

local PARENT_WINDOW

local function addToMirage()
  local mirageSlot = getMirageSlot(1)
  mirageSlot[#mirageSlot+1] = PARENT_WINDOW
end

local function setWindowData(activeWindowName)
  LAST_SELECTED_WINDOW = activeWindowName
  local window=activeWindowName
  PARENT_WINDOW= getParentLevels(window)

  EA_Window_ContextMenu.CreateContextMenu()
  if not isAddedToMirage(1, PARENT_WINDOW) then
    EA_Window_ContextMenu.AddMenuItem(towstring(PARENT_WINDOW),addToMirage,false,true)
  else
    EA_Window_ContextMenu.AddMenuItem(towstring(PARENT_WINDOW),addToMirage,true,true)
  end
  EA_Window_ContextMenu.Finalize(nil,getAnchorPoints())
  IS_CONTEXT_MENU_SHOWING=true;
end

local function addToMirage(mirageSlot, parentWindow)
  local mirageSlot = getMirageSlot(mirageSlot)
  mirageSlot[#mirageSlot+1] = parentWindow
end


function Mirage.OnUpdate(timeElapsed)
 -- local activeWindowName = SystemData.MouseOverWindow.name
  local window=SystemData.MouseOverWindow.name

  if window == "Root" then
    if IS_CONTEXT_MENU_SHOWING then
      IS_CONTEXT_MENU_SHOWING = false;
      EA_Window_ContextMenu.HideAll()
    end
    return
  end

  if window:match("EA_Window_ContextMenu") or window == LAST_SELECTED_WINDOW then
    return
  end

  setWindowData(window)

end



local function onMirage()
  for windows = 1, #Mirage.Settings.MirageSlots[1] do
    local windowName = Mirage.Settings.MirageSlots[1][windows]
    local isShowing = not WindowGetShowing(windowName)
    WindowSetShowing(windowName, isShowing)
  end
end


local slashCommands = {
  mirage = {
    func = onMirage,
    desc = "yes"
  }
}

function Mirage.OnInitialize()
  Mirage.RegisterSlashCommand()
end



