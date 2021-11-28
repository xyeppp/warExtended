warExtendedItemStacking = warExtended.Register("warExtended:Item Stacking" )
local ItemStacking = warExtendedItemStacking
local ITEM_STACKING_WINDOW = "ItemStackingWindow"
local TEXT_BOX = ITEM_STACKING_WINDOW.."TextInput"
local PLUS_BUTTON = ITEM_STACKING_WINDOW.."PlusButton"
local MINUS_BUTTON = ITEM_STACKING_WINDOW.."MinusButton"
local SLIDER_BAR = ITEM_STACKING_WINDOW.."AmountSlider"
local ITEM_COST = ITEM_STACKING_WINDOW.."ItemCost"
local ITEM_ICON = ITEM_STACKING_WINDOW.."ItemIcon"

--TODO:mgremix GATHERBUTTON buttonsetpresssedflag onupdate buttongetpressedflag

local SHIFT_INCREMENT_DECREMENT_VALUE = 15
local INCREMENT_DECREMENT_VALUE = 5
local INCREMENT_DELAY = 0.1

--ItemStackingWindow.MAX_NON_STACKABLE_ITEMS = 400

ItemStacking.history={}

function ItemStacking.GetHistory()
   TextEditBoxSetHistory(TEXT_BOX, ItemStacking.history )
end

function ItemStacking.SetHistory()
   ItemStacking.history = TextEditBoxGetHistory(TEXT_BOX)
end

function ItemStacking.OnInitialize()
   ItemStacking.GetHistory()
end

function ItemStacking.OnMouseOverItemIcon()
   local slotLoc = ItemStackingWindow.CurrentSourceLoc
   local slot = ItemStackingWindow.CurrentItemSlot
   local itemData = ItemStackingWindow.GetItemData(slotLoc, slot)
   Tooltips.CreateItemTooltip(itemData, ITEM_ICON, Tooltips.ANCHOR_WINDOW_RIGHT)
end

local function getTooltipText()
   local tooltipText = L"Decrement by 5."

   if ItemStackingWindow.IsBackpackSlot then
      tooltipText = L"Decrement by 5.\nHold SHIFT to decrement by 20"
      if ItemStacking:IsMouseOverWindow(PLUS_BUTTON) then
         tooltipText = L"Increment by 5.\nHold SHIFT to increment by 20"
      end
      return tooltipText
   end

   if ItemStacking:IsMouseOverWindow(PLUS_BUTTON) then
      tooltipText = L"Increment by 5."
      return tooltipText
   end

      return tooltipText
end

function ItemStacking.OnMouseOverPlusMinusButton()
   local tooltipText = getTooltipText()
   Tooltips.CreateTextOnlyTooltip(ItemStacking:GetMouseOverWindow(), tooltipText)
   Tooltips.AnchorTooltip( Tooltips.ANCHOR_WINDOW_RIGHT )
end

function ItemStacking.OnSlideAmountSlider(sliderAmount)
   if ItemStackingWindow.IsBackpackSlot then
      TextEditBoxSetText(TEXT_BOX, towstring(math.floor(sliderAmount * ItemStackingWindow.CurrentItemMaxStackCount)))
      return
   end

   TextEditBoxSetText(TEXT_BOX, towstring(math.floor(sliderAmount * ItemStackingWindow.MAX_NON_STACKABLE_ITEMS)))
end


local stackCount = {
   isFlagPressed = false;
   incrementDecrementValue = nil,

   setFlag = function(self, isFlagPressed)
      self.isFlagPressed = isFlagPressed
   end,

   setIncrementDecrementValues = function(self)

      if self.isFlagPressed then
         if ItemStackingWindow.IsBackpackSlot then
            self.incrementDecrementValue = SHIFT_INCREMENT_DECREMENT_VALUE
         else
            self.incrementDecrementValue = ItemStackingWindow.CurrentItemMaxStackCount
         end
         return
      end

      self.incrementDecrementValue = INCREMENT_DECREMENT_VALUE
   end,


   increment = function(self)
      if self:isOne() then
         TextEditBoxSetText(TEXT_BOX, towstring(ItemStackingWindow.CurrentInput + self.incrementDecrementValue-1))
         return
      end

      TextEditBoxSetText(TEXT_BOX, towstring(ItemStackingWindow.CurrentInput + self.incrementDecrementValue))
   end,

   decrement = function(self)
      if self:isOne() then
         return
      end

   TextEditBoxSetText(TEXT_BOX, towstring(ItemStackingWindow.CurrentInput - self.incrementDecrementValue))
end,

   isOne = function()
      local isOne = ItemStackingWindow.CurrentInput == 1
      return isOne
   end

}

local timer = 0
function ItemStacking.OnUpdate(...)
   timer = timer + ...
   if timer >= INCREMENT_DELAY then
      if ButtonGetPressedFlag(PLUS_BUTTON) then
         stackCount:increment()
      elseif ButtonGetPressedFlag(MINUS_BUTTON) then
         stackCount:decrement()
      end
      timer = 0
   end
end


function ItemStacking.OnLButtonDownPlusMinusButton(flags)
   stackCount:setFlag(ItemStacking:IsFlagName("isShiftPressed", flags))
   stackCount:setIncrementDecrementValues()
   ItemStacking:RegisterUpdate("warExtendedItemStacking.OnUpdate")
end

function ItemStacking.OnLButtonUpPlusMinusButton(flags)
   ItemStacking:UnregisterUpdate("warExtendedItemStacking.OnUpdate")
end

