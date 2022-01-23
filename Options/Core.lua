-- Most of original code from EA WAR Help Window modified for warExt Options
local OPTIONS_WINDOW = "warExtendedOptionsWindow"
local warExtended = warExtended

warExtendedOptions = {}

warExtendedOptions.rowToEntryMap = {}
warExtendedOptions.numTotalRows = 0
warExtendedOptions.lastPressedButtonId = 0
warExtendedOptions.currentOptions = 0
warExtendedOptions.data = {};
warExtendedOptions.lastParentWindow = nil;

warExtendedOptions.ListBoxData = {
}


function warExtendedOptions.OnLButtonUpRow()
  local row = WindowGetId( SystemData.ActiveWindow.name )
  warExtendedOptions.DisplayRow(row)
end

-- displays the entry information for a certain row
function warExtendedOptions.DisplayRow( rowIndex )
  local dataIndex = ListBoxGetDataIndex(OPTIONS_WINDOW.."List", rowIndex)
  local entryData = warExtendedOptions.rowToEntryMap[dataIndex]   -- get the index in ManualWindow.data from the row
  entryData.expanded = not entryData.expanded
  
  warExtendedOptions.ResetPressedButton()
  warExtendedOptions.lastPressedButtonId = entryData.id
  ButtonSetPressedFlag(OPTIONS_WINDOW.."ListRow"..rowIndex.."Name", true ) -- set newly selected entry as pressed
  warExtendedOptions.DisplayManualEntry( entryData ) -- display text for the just selected entry
  
  warExtendedOptions.PrepareData()
end

function warExtendedOptions.ResetPressedButton()
  warExtendedOptions.SetEntrySelectedById( warExtendedOptions.lastPressedButtonId, false )
end

local function getDepthText(entryId)
  local depthText = {}
  
  local function delve(entryId)
    for _,v in pairs(warExtendedOptions.rowToEntryMap) do
      if v.id == entryId then
          table.insert(depthText, tostring(v.name))
         if v.parentEntryId ~= 0 then
          delve(v.parentEntryId)
          end
        end
    end
  end
  
  delve(entryId)
  table.sort(depthText, function(a,b) return a < b end)
  local headerText = towstring(table.concat(depthText, "/"))
  return headerText
end


local function getHeaderText(entryData)
  if entryData.parentEntryId ~= 0 then
    local headerText = getDepthText(entryData.id)
    return headerText
  end

  return entryData.name
end

function warExtendedOptions.DisplayManualEntry( entryData )
  local headerText = getHeaderText(entryData)
  LabelSetText( OPTIONS_WINDOW.."HeaderText", headerText )
  
  if warExtendedOptions.lastParentWindow ~= nil then
    WindowSetShowing(warExtendedOptions.lastParentWindow, false)
  end
  
    warExtendedOptions.DisplayEntryWindow(entryData)
    warExtendedOptions.lastParentWindow = entryData.parentWindow
  
  ScrollWindowSetOffset( OPTIONS_WINDOW.."Main", 0 )        -- reset the scroll bar.
  ScrollWindowUpdateScrollRect(OPTIONS_WINDOW.."Main")      -- reset the scroll bar.

end

function warExtendedOptions.SetEntrySelectedById( id, selected )
  for row = 1, warExtendedOptionsWindowList.numVisibleRows do
    local index = ListBoxGetDataIndex(OPTIONS_WINDOW.."List", row)
    local data = warExtendedOptions.rowToEntryMap[index]
    if( data and data.id == warExtendedOptions.lastPressedButtonId ) then
      ButtonSetPressedFlag(OPTIONS_WINDOW.."ListRow"..row.."Name", selected ) -- set newly selected entry as pressed
    end
  end
end


function warExtendedOptions.SetListRowTints()
  for row = 1, warExtendedOptionsWindowList.numVisibleRows do
    local row_mod = math.mod(row, 2)
    color = DataUtils.GetAlternatingRowColor( row_mod )
    
    local targetRowWindow = OPTIONS_WINDOW.."ListRow"..row
    WindowSetTintColor(targetRowWindow.."RowBackground", color.r, color.g, color.b )
    WindowSetAlpha(targetRowWindow.."RowBackground", color.a )
  end
end



function warExtendedOptions.UpdateOptionsWindowRow()
for row = 1, warExtendedOptionsWindowList.numVisibleRows do
  local rowWindow = OPTIONS_WINDOW.."ListRow"..row
  local index = ListBoxGetDataIndex(OPTIONS_WINDOW.."List", row)
  local data = warExtendedOptions.rowToEntryMap[index]
  
  if (data ~= nil)
  then
    if (warExtendedOptions.lastPressedButtonId == data.id )
    then
      ButtonSetPressedFlag(rowWindow.."Name", true ) -- set newly selected entry as pressed
    else
      ButtonSetPressedFlag(rowWindow.."Name", false )
    end
    
    local hasChildEntries = #data.childEntries > 0
    WindowSetShowing(rowWindow.."PlusButton",  hasChildEntries and not data.expanded)
    WindowSetShowing(rowWindow.."MinusButton", hasChildEntries and data.expanded)
    
    local depth = warExtendedOptions.ListBoxData[index].depth
    WindowClearAnchors(rowWindow.."Name")
    WindowAddAnchor(rowWindow.."Name", "left", rowWindow, "left", 30 + (15 * depth), 6)
  end
end
end

function warExtendedOptions.PrepareData()
  -- reset tables and counters that are going to be used later on
  warExtendedOptions.orderTable = {}
  warExtendedOptions.ListBoxData = {}
  warExtendedOptions.numTotalRows = 1                -- more of an index than row counter
  warExtendedOptions.rowToEntryMap = {}
  
  if( not warExtendedOptions.data ) then
    return -- quit if we have no data to work on.
  end
  
  table.sort( warExtendedOptions.data, DataUtils.AlphabetizeByNames )
  
  local function AddEntryAsRow(entryIndex, entryData, depth)
    local entryTable = {name = entryData.name, depth = depth}
    table.insert( warExtendedOptions.ListBoxData, warExtendedOptions.numTotalRows, entryTable )
    table.insert( warExtendedOptions.orderTable, warExtendedOptions.numTotalRows)
    table.insert( warExtendedOptions.rowToEntryMap, warExtendedOptions.numTotalRows, entryData )
  
    warExtendedOptions.numTotalRows = warExtendedOptions.numTotalRows + 1
    
    if entryData.expanded
    then
      -- entry is expanded so add children as rows, recursively
      for childEntryIndex, childEntryData in ipairs( entryData.childEntries ) do
        AddEntryAsRow(childEntryIndex, childEntryData, depth+1)
      end
    end
  end
  
  for entryIndex, entryData in ipairs( warExtendedOptions.data ) do
    AddEntryAsRow(entryIndex, entryData, 0)
  end
  
  ListBoxSetDisplayOrder(OPTIONS_WINDOW.."List", warExtendedOptions.orderTable )
  warExtendedOptions.SetListRowTints()
end

function warExtendedOptions.GetOptionsOrder()
  return warExtendedOptions.orderTable
end