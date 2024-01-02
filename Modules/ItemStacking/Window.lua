ItemStackingWindow = warExtended.Register("warExtended Item Stacking")

local ItemStackingWindow = ItemStackingWindow
local WINDOW_NAME = "ItemStackingWindow"
local WINDOW = Frame:Subclass(WINDOW_NAME)

local MAX_NON_STACKABLE_ITEMS = 200

local ITEM_ICON = 1
local ITEM_TEXT = 2
local AMOUNT_INPUT = 3
local AMOUNT_SLIDER = 4
local PLUS_BUTTON = 5
local MINUS_BUTTON = 6
local COST_LABEL = 7
local MONEY_FRAME = 8
local ALT_MONEY_FRAME = 9
local OKAY = 10
local CANCEL = 11
local TITLEBAR = 12

function WINDOW:GetItemData(sourceLoc, slot)
    local itemData

    local backpackType = EA_BackpackUtilsMediator.GetCurrentBackpackType()
    local currentBackpackCursor = EA_BackpackUtilsMediator.GetCursorForBackpack(backpackType)
    if (sourceLoc ~= Cursor.SOURCE_QUEST_ITEM and (sourceLoc == currentBackpackCursor or
            sourceLoc == Cursor.SOURCE_BANK))
    then
        itemData = DataUtils.GetItemData(sourceLoc, slot)
    elseif sourceLoc == Cursor.SOURCE_MERCHANT then
        itemData = EA_Window_InteractionStore.GetItem(slot)
    end

    return itemData
end

function WINDOW.FormatAltCurrency(windowName, altCurrencyTable, hideIfNotSet)
    if (windowName ~= WINDOW_NAME .. "ItemAltCost" and windowName ~= WINDOW_NAME .. "ItemCost") then
        return
    end

    local currencyTable =
    {
        { frame = (windowName .. "GoldFrame"), label = (windowName .. "GoldText") },
        { frame = (windowName .. "SilverFrame"), label = (windowName .. "SilverText") },
        { frame = (windowName .. "BrassFrame"), label = (windowName .. "BrassText") },
    }

    for i, altCurrencyData in ipairs(currencyTable) do
        if (altCurrencyTable[i] ~= nil)
        then
            MoneyFrame.SetMoneyValue(altCurrencyData.label, altCurrencyTable[i].quantity * self.m_CurrentInput)
        else
            MoneyFrame.SetMoneyValue(altCurrencyData.label, 0)
            WindowSetShowing(altCurrencyData.frame .. "Image", false)
            WindowSetShowing(altCurrencyData.label, false)
        end
    end
end

function WINDOW:HandleAnchor()
    local mouseX, mouseY = warExtended:GetMousePosition()
    local uiScale = self:GetUIScale()
    local x = mouseX / uiScale - 100
    local y = mouseY / uiScale - 15

    self:SetAnchor({ Point = "topleft", RelativeTo = "Root", RelativePoint = "topleft", XOffset = x, YOffset = y })
end

function WINDOW:OnKeyEscape()
    self:Show(false)
end

function WINDOW:OnShown(slotLoc, slot, titleText)
    local win = self.m_Windows
    local itemData = self:GetItemData(slotLoc, slot)
    if (itemData == nil) then
        return
    end

    local backpackType = EA_BackpackUtilsMediator.GetCurrentBackpackType()
    local backpackCursor = EA_BackpackUtilsMediator.GetCursorForBackpack(backpackType)
    -- if was a previous lock, release it
    if self.m_CurrentSourceLoc == backpackCursor and self.m_CurrentItemSlot then
        EA_BackpackUtilsMediator.ReleaseLockForSlot(self.m_CurrentItemSlot, backpackType, self:GetName())
    end

    --Store the item id
    self.m_CurrentItemSlot = slot
    self.m_CurrentSourceLoc = slotLoc

    -- if backpack slot, lock it in place
    if self.m_CurrentSourceLoc == backpackCursor and self.m_CurrentItemSlot then
        self.m_isBackpackSlot = true
        EA_BackpackUtilsMediator.RequestLockForSlot(self.m_CurrentItemSlot, backpackType, self:GetName())
    else
        self.m_isBackpackSlot = false
    end

    win[TITLEBAR]:SetText(titleText or GetString(StringTables.Default.LABEL_STACK_SPLITTING))

    self:HandleAnchor()

    local itemText = itemData.name

    self.m_CurrentItemMaxStackCount = itemData.stackCount or itemData.capacity

    if itemData.stackCount > 1 then
        itemText = itemText .. L" (" .. itemData.stackCount .. L")"
    end

    win[ITEM_ICON]:SetTexture(GetIconData(itemData.iconNum))
    win[ITEM_TEXT]:SetText(itemText)
    win[ITEM_TEXT]:SetTextColor(DataUtils.GetItemRarityColor(itemData))
    win[AMOUNT_INPUT]:SetText(L"1")
    win[AMOUNT_INPUT]:SetFocus(true)

    win[COST_LABEL]:Show(self.m_isBackpackSlot == false)
    win[ALT_MONEY_FRAME]:Show(itemData.altCurrency ~= nil)
    win[MONEY_FRAME]:Show(itemData.cost ~= nil)

    if self.m_isBackpackSlot then
        self:SetDimensions(310, 280)
        win[AMOUNT_INPUT]:SetText((math.floor(itemData.stackCount) / 2))
        win[AMOUNT_SLIDER]:SetCurrentPosition(self.m_CurrentInput / self.m_CurrentItemMaxStackCount)
    else
        self:SetDimensions(310, 320)
        win[AMOUNT_SLIDER]:SetCurrentPosition(self.m_CurrentInput / MAX_NON_STACKABLE_ITEMS)
    end
end

function WINDOW:OnHidden()
    local backpackType = EA_BackpackUtilsMediator.GetCurrentBackpackType()
    local backpackCursor = EA_BackpackUtilsMediator.GetCursorForBackpack(backpackType)
    if self.m_CurrentSourceLoc == backpackCursor and self.m_CurrentItemSlot then
        EA_BackpackUtilsMediator.ReleaseLockForSlot(self.m_CurrentItemSlot, backpackType, self:GetName())
    end

    self.m_CurrentItemSlot = nil
    self.m_CurrentSourceLoc = nil
end

function ItemStackingWindow.OnInitialize()
    if not ItemStackingWindow.history then
        ItemStackingWindow.history = {}
    end

    local frame = WINDOW:CreateFrameForExistingWindow(WINDOW_NAME)
    if frame then
        frame.m_Windows = {
            [TITLEBAR] = Label:CreateFrameForExistingWindow(frame:GetName() .. "TitleBarLabel"),
            [ITEM_TEXT] = Label:CreateFrameForExistingWindow(frame:GetName() .. "ItemText"),
            [AMOUNT_INPUT] = TextEditBox:CreateFrameForExistingWindow(frame:GetName() .. "TextInput"),
            [OKAY] = ButtonFrame:CreateFrameForExistingWindow(frame:GetName() .. "Okay"),
            [CANCEL] = ButtonFrame:CreateFrameForExistingWindow(frame:GetName() .. "Cancel"),
            [ITEM_ICON] = DynamicImage:CreateFrameForExistingWindow(WINDOW_NAME .. "ItemIcon"),
            [COST_LABEL] = Label:CreateFrameForExistingWindow(WINDOW_NAME .. "ItemCostLabel"),
            [MONEY_FRAME] = Frame:CreateFrameForExistingWindow(WINDOW_NAME .. "ItemCost"),
            [ALT_MONEY_FRAME] = Frame:CreateFrameForExistingWindow(WINDOW_NAME .. "ItemAltCost"),
            [AMOUNT_SLIDER] = SliderBar:CreateFrameForExistingWindow(WINDOW_NAME .. "AmountSlider"),
            [MINUS_BUTTON] = ButtonFrame:CreateFrameForExistingWindow(WINDOW_NAME .. "MinusButton"),
            [PLUS_BUTTON] = ButtonFrame:CreateFrameForExistingWindow(WINDOW_NAME .. "PlusButton")
        }

        local win = frame.m_Windows
        win[OKAY]:SetText(GetString(StringTables.Default.LABEL_OKAY))
        win[CANCEL]:SetText(GetString(StringTables.Default.LABEL_CANCEL))
        win[COST_LABEL]:SetText(L"Cost")

        win[AMOUNT_INPUT]:SetHistory(ItemStackingWindow.history)

        win[CANCEL].OnLButtonUp = function(self)
            self:GetParent():Show(false)
        end

        win[AMOUNT_INPUT].OnTextChanged = function(self, editInputText)
            local slot = frame.m_CurrentItemSlot
            local slotLoc = frame.m_CurrentSourceLoc

            --Exit out of text amount if the current item id is 0
            if (slot == nil) then
                return
            end

            local itemData = frame:GetItemData(slotLoc, slot)

            if (itemData == nil) then
                return
            end

            --Hexadecimal of 0 and 9 and Backspace

            local amount = itemData.stackCount
            if itemData.stackCount <= 1 then
                -- TODO: we really should have server send us what the stack capacity is for an item so we can use that when an item is stackable
                -- if itemData.capacity > 1 then
                -- amount = itemData.capacity
                amount = MAX_NON_STACKABLE_ITEMS
            end

            local outputNum = nil
            if (editInputText ~= nil) then
                outputNum = tonumber(WStringToString(editInputText))
                frame.m_CurrentInput = outputNum
            end

            if (outputNum ~= nil) then
                if (outputNum > amount) then
                    outputNum = amount
                    win[AMOUNT_INPUT]:SetText(outputNum)
                elseif outputNum == 0 then
                    win[AMOUNT_INPUT]:SetText(L"1")
                end
            end

            if not frame.m_CurrentInput then
                return
            end

            local itemCost = itemData.cost
            local altCurrency = itemData.altCurrency

            if frame.m_isBackpackSlot then
                win[AMOUNT_SLIDER]:SetCurrentPosition(frame.m_CurrentInput / frame.m_CurrentItemMaxStackCount)
            elseif itemCost or altCurrency then
                win[AMOUNT_SLIDER]:SetCurrentPosition(frame.m_CurrentInput / MAX_NON_STACKABLE_ITEMS)

                if itemCost > 0 then
                    local totalCost = frame.m_CurrentInput * itemCost or frame.m_CurrentInput * altCurrency
                    MoneyFrame.FormatMoney(win[MONEY_FRAME]:GetName(), totalCost, 0)
                elseif altCurrency then
                    MoneyFrame.FormatAltCurrency(win[ALT_MONEY_FRAME]:GetName(), altCurrency, 1);
                end
            end
        end

        win[AMOUNT_INPUT].OnKeyEscape = function(self)
            frame:OnKeyEscape()
        end

        win[AMOUNT_INPUT].OnKeyEnter = function(self)
            win[OKAY]:OnLButtonUp()
            Cursor.OnLButtonUpProcessed()
        end

        win[AMOUNT_SLIDER].OnSlide = function(self, amount)
            if frame.m_isBackpackSlot then
                win[AMOUNT_INPUT]:SetText(math.floor(amount * frame.m_CurrentItemMaxStackCount))
            else
                win[AMOUNT_INPUT]:SetText(math.floor(amount * MAX_NON_STACKABLE_ITEMS))
            end
        end

        win[PLUS_BUTTON].OnLButtonDown = function(self, flags, x, y)
            warExtendedTimer.New(self:GetName(), .05, function()
                if self:IsPressed() then
                    win[AMOUNT_INPUT]:SetText(win[AMOUNT_INPUT]:TextAsNumber() + 1)
                    return false
                else
                    return true
                end
            end)
        end

        win[MINUS_BUTTON].OnLButtonDown = function(self, flags, x, y)
            warExtendedTimer.New(self:GetName(), .05, function()
                if self:IsPressed() then
                    win[AMOUNT_INPUT]:SetText(win[AMOUNT_INPUT]:TextAsNumber() - 1)
                    return false
                else
                    return true
                end
            end)
        end

        win[OKAY].OnLButtonUp = function(self)
            local itemData = frame:GetItemData(frame.m_CurrentSourceLoc, frame.m_CurrentItemSlot)
            if (itemData == nil) then
                return
            end

            local editInputText = win[AMOUNT_INPUT]:GetText()

            local outputNum = nil
            if (editInputText ~= nil) then
                outputNum = tonumber(WStringToString(editInputText))
            end

            if (outputNum ~= nil and outputNum > 0) then
                Cursor.PickUp(frame.m_CurrentSourceLoc, frame.m_CurrentItemSlot, itemData.uniqueID, itemData.iconNum,
                    true, outputNum)
            end

            frame:Show(false)
        end

        win[ITEM_ICON].OnMouseOver = function(self)
            local itemData = frame:GetItemData(frame.m_CurrentSourceLoc, frame.m_CurrentItemSlot)
            Tooltips.CreateItemTooltip(itemData, self:GetName(), Tooltips.ANCHOR_WINDOW_VARIABLE)
        end
    end

    ItemStackingWindow:Hook(MoneyFrame.FormatAltCurrency, WINDOW.FormatAltCurrency, true)
end

function ItemStackingWindow.Show(slotLoc, slot, titleText)
    local frame = GetFrame(WINDOW_NAME)
    frame:Show(true)
    frame:OnShown(slotLoc, slot, titleText)
end
