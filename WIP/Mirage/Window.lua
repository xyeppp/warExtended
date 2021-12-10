local Mirage = warExtendedMirage
local WINDOW_NAME = "warExtendedMirage"
local SORT_BUTTON = WINDOW_NAME.."SortButton1"
local LIST_BOX = WINDOW_NAME.."WindowsList"

local testTable = {
  [1] = {
	wideStrName = L"dasdas",
	index = nil,
	isShowing = L"true",
	showing = true;
  },
  [2] = {
	wideStrName = L"asebvaseasev",
	index = nil,
	isShowing = L"true",
	showing = true;
  },
  [3] = {
	wideStrName = L"dasdaseasda",
	index = nil,
	isShowing = L"true",
	showing = true;
  },
}

local function UpdateWindowsData()
  
  warExtendedMirage.windowsListData = testTable
  
  -- Build a list of all the mod sets
  local setNames = {}
  for windowIndex=1,#warExtendedMirage.windowsListData do
	p(windowIndex)
	warExtendedMirage.windowsListData[windowIndex].index = windowIndex
  end

end


function Mirage.OnShown()
 -- Mirage:RegisterUpdate("warExtendedMirage.OnUpdate")
end

function Mirage.OnHidden()
 -- Mirage:UnregisterUpdate("warExtendedMirage.OnUpdate")
end

function Mirage.OnRawDeviceInputToggleWindows(deviceId, keyId, isPressed)
  p(deviceId, keyId, isPressed)
  local isMouse = deviceId == 2
  isPressed = isPressed == 1
  
  if isMouse then
	return
  end
  
  if isPressed then
	p(keyId)
  end
  
  -- Mirage:UnregisterUpdate("warExtendedMirage.OnUpdate")
end

local function setWindowLabels()
  LabelSetText(WINDOW_NAME.."TitleBarText", L"Mirage")
  ButtonSetText(WINDOW_NAME.."AddButton", L"Add Window")
  ButtonSetText(WINDOW_NAME.."RemoveButton", L"Remove Window")
  ButtonSetText(WINDOW_NAME.."RenameButton", L"Rename Window")
  ButtonSetText(WINDOW_NAME.."SortButton1", L"Window Name")
  end

function Mirage.OnInitializeWindow()
  setWindowLabels()
  UpdateWindowsData()
  
  Mirage.ShowSetData( 1)
  Mirage.UpdateSetSortButton()
end

function Mirage.OnShutdownWindow()
  p("im here")
end

function Mirage.ToggleWindow()
  WindowUtils.ToggleShowing(WINDOW_NAME)
end
