warExtendedItemStacking = warExtended.Register("warExtended Item Stacking" )

local ItemStacking = warExtendedItemStacking
local textBox = "ItemStackingWindowTextInput"

local slashCommands = {

   ["dasdasd"] = {
      ["func"] = function (...) return Macro:SetMacroData(...) end,
      ["desc"] = "Create a macro on the fly. Usage: /macro text#slot.\nSlot is optional, first empty slot will be used if nil"
   },
   ["testestes"] = {
      ["func"] = function (...) return Macro:LoadMacroSet(...) end,
      ["desc"] = "Load a macro set. Usage: /macroset 1 or 2"
   }

}

function ItemStacking:TestFunction()
   ItemStacking:RegisterSlash(slashCommands, "warextmacro")
end

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
