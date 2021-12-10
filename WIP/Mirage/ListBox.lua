local Mirage = warExtendedMirage

local WINDOW_NAME = "warExtendedMirage"
local SORT_BUTTON = WINDOW_NAME.."SortButton"
local LIST_BOX = WINDOW_NAME.."WindowsList"

Mirage.SORT_ORDER_UP	   = 1
Mirage.SORT_ORDER_DOWN	   = 2

Mirage.curSortOrder			= 2


local function UpdateWindowsList()
  ListBoxSetDisplayOrder(LIST_BOX, Mirage.windowsListDataDisplayOrder)
end

function Mirage.UpdateSetSortButton()
  local order = Mirage.curSortOrder
  
  WindowSetShowing( SORT_BUTTON.."SortUpArrow", (order == Mirage.SORT_ORDER_UP) )
  WindowSetShowing( SORT_BUTTON.."SortDownArrow", (order == Mirage.SORT_ORDER_DOWN) )
end

function Mirage.ShowSetData(setId)
  
  if setId then
	Mirage.selectedSet = setId
  end
  
  -- Update the List
  Mirage.windowsListDataDisplayOrder = {}
  
  for index, modData in ipairs( Mirage.windowsListData )
  do
	table.insert( Mirage.windowsListDataDisplayOrder, index )
  end
  
  UpdateWindowsList()
  -- SortModsList()
  --UpdateModsList()
  
  -- Display the 'No Mods' Text if no mods have been found.
  -- WindowSetShowing( "UiModWindowNoModsText", UiModWindow.modsListDataDisplayOrder[1] == nil )
  
  -- UiModWindow.UpdateModSortButtons()
  -- UiModWindow.UpdateEnableDisableAllButtons()
  
  -- Update the Details
  -- UiModWindow.ShowModDetails( UiModWindow.modsListData[ UiModWindow.modsListDataDisplayOrder[1] ] )

end

function Mirage.UpdateWindowRows()
  
  if (warExtendedMirageWindowsList.PopulatorIndices ~= nil)
  then
	for rowIndex, dataIndex in ipairs (warExtendedMirageWindowsList.PopulatorIndices)
	do
	  
	  local windowData = warExtendedMirage.windowsListData[ dataIndex ]
	  Mirage.UpdateWindowRowByIndex( rowIndex, windowData )
	end
  end

end

function Mirage.UpdateWindowRowByIndex(rowIndex, windowData )
  local rowName = LIST_BOX.."Row"..rowIndex
  
  --LabelSetText(LIST_BOX.."Row"..rowIndex.."WindowName", towstring(windowData.name))
  
  -- Set the Background Color
  local isSelected = windowData.name and (Mirage.selectedWindowName == windowData.name )
  DefaultColor.SetListRowTint( rowName.."Background", rowIndex, isSelected )
  
  -- Showing
  ButtonSetCheckButtonFlag( rowName.."Enabled", true )
  ButtonSetPressedFlag( rowName.."Enabled", windowData.isShowing )
end
