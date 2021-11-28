warExtendedItemStacking = warExtended.Register("warExtended:Item Stacking" )
local ItemStacking = warExtendedItemStacking
local ITEM_STACKING_TEXT_BOX = "ItemStackingWindowTextInput"

ItemStackingWindow.MAX_NON_STACKABLE_ITEMS = 1000

ItemStacking.history={}

function ItemStacking.GetHistory()
   TextEditBoxSetHistory(ITEM_STACKING_TEXT_BOX, ItemStacking.history )
end

function ItemStacking.SetHistory()
   ItemStacking.history = TextEditBoxGetHistory(ITEM_STACKING_TEXT_BOX)
end

local function addToHistory()
   local currentText = TextEditBoxGetText(ITEM_STACKING_TEXT_BOX)
   ItemStacking.history[#ItemStacking.history+1] = currentText
end

function ItemStacking.OnInitialize()
   ItemStacking:Hook(ItemStackingWindow.OnKeyEnter, addToHistory, true)
   ItemStacking:Hook(ItemStackingWindow.OkayButton, addToHistory, true)
end

