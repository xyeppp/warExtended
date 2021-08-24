warExtendedItemStacking = warExtended.Register("warExtended Item Stacking", "das", "yellow")

local ItemStacking = warExtendedItemStacking
local textBox = "ItemStackingWindowTextInput"

ItemStackingWindow.MAX_NON_STACKABLE_ITEMS = 1000

if not ItemStacking.history then
   ItemStacking.history={}
end

function ItemStacking.GetHistory()
   TextEditBoxSetHistory(textBox, ItemStacking.history )
end

function ItemStacking.SetHistory()
   DebugWindow.history = TextEditBoxGetHistory(textBox)
end

--function ItemStacking.AddToHistory()
  -- local text = TextEditBoxGetText(textBox)
   --ItemStacking.history[#ItemStacking.history+1]=text
--end

ItemStacking:Hook(ItemStackingWindow.Initialize, ItemStacking.GetHistory)
ItemStacking:Hook(ItemStackingWindow.Shutdown, ItemStacking.SetHistory)
--ItemStacking:Hook(ItemStackingWindow.OnKeyEnter, ItemStacking.AddToHistory)
--ItemStacking:Hook(ItemStackingWindow.OkayButton, ItemStacking.AddToHistory)
