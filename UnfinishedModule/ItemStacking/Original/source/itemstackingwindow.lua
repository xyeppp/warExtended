----------------------------------------------------------------
-- Global Variables
----------------------------------------------------------------

ItemStackingWindow = {}
ItemStackingWindow.CurrentItemSlot = nil
ItemStackingWindow.CurrentSourceLoc = nil
ItemStackingWindow.CurrentItemMaxStackCount = nil
ItemStackingWindow.CurrentInput = nil
ItemStackingWindow.IsBackpackSlot = nil

ItemStackingWindow.MAX_NON_STACKABLE_ITEMS = 400

----------------------------------------------------------------
-- Local Variables
----------------------------------------------------------------

----------------------------------------------------------------
-- CharacterWindow Functions
----------------------------------------------------------------

-- OnInitialize Handler
function ItemStackingWindow.Initialize()

    local windowName = "ItemStackingWindow"

    ButtonSetText( windowName.."Okay", GetString( StringTables.Default.LABEL_OKAY))
    ButtonSetText( windowName.."Cancel", GetString( StringTables.Default.LABEL_CANCEL))
    LabelSetText(windowName.."ItemCostLabel", L"Total Cost:")

end


function ItemStackingWindow.Show(slotLoc, slot, titleText)

    local itemData = ItemStackingWindow.GetItemData(slotLoc, slot)
    if(itemData == nil) then
        return
    end

    local windowName = "ItemStackingWindow"
    local editBoxText = windowName.."TextInput"
    local iconWindow = windowName.."ItemIcon"

    local backpackType = EA_BackpackUtilsMediator.GetCurrentBackpackType()
    local backpackCursor = EA_BackpackUtilsMediator.GetCursorForBackpack( backpackType )
    -- if was a previous lock, release it

    if ItemStackingWindow.CurrentSourceLoc == backpackCursor and ItemStackingWindow.CurrentItemSlot then
        ItemStackingWindow.IsBackpackSlot = false;
        EA_BackpackUtilsMediator.ReleaseLockForSlot(ItemStackingWindow.CurrentItemSlot, backpackType, windowName)
    end

    --Store the item id
    ItemStackingWindow.CurrentItemSlot = slot
    ItemStackingWindow.CurrentSourceLoc = slotLoc
    ItemStackingWindow.CurrentItemMaxStackCount = itemData.stackCount or itemData.capacity
    ItemStackingWindow.CurrentInput = 1

    -- if backpack slot, lock it in place
    if ItemStackingWindow.CurrentSourceLoc == backpackCursor and ItemStackingWindow.CurrentItemSlot then
        ItemStackingWindow.IsBackpackSlot = true;
        EA_BackpackUtilsMediator.RequestLockForSlot(ItemStackingWindow.CurrentItemSlot, backpackType, windowName)
    end

    titleText = titleText or GetString( StringTables.Default.LABEL_STACK_SPLITTING)
    LabelSetText( windowName.."TitleBarText", titleText )


    local texture, x, y = GetIconData(itemData.iconNum)
    DynamicImageSetTexture(iconWindow, texture, x, y)

    TextEditBoxSetText(editBoxText, L"1")

    local itemText = itemData.name

    if itemData.stackCount > 1 then
        itemText = itemText..L" ("..itemData.stackCount..L")"
        TextEditBoxSetText(editBoxText, towstring(math.floor(itemData.stackCount)/2))
    end

    LabelSetText( windowName.."ItemText", itemText)

    if ItemStackingWindow.IsBackpackSlot then
        SliderBarSetCurrentPosition(windowName.."AmountSlider", (ItemStackingWindow.CurrentInput / ItemStackingWindow.CurrentItemMaxStackCount))
        WindowSetShowing(windowName.."ItemCostLabel", false)
        WindowSetShowing(windowName.."ItemCost", false)
    else
        SliderBarSetCurrentPosition(windowName.."AmountSlider", (ItemStackingWindow.CurrentInput / ItemStackingWindow.MAX_NON_STACKABLE_ITEMS))
        WindowSetShowing(windowName.."ItemCostLabel", true)
        WindowSetShowing(windowName.."ItemCost", true)
    end

    --Setting the anchor position to be beneath the mouse cursor
    ItemStackingWindow.HandleAnchor()

    WindowSetShowing( windowName, true)
    WindowAssignFocus( editBoxText, true)
    TextEditBoxSelectAll( editBoxText )
end

--Place the window where the mouse cursor currently is
function ItemStackingWindow.HandleAnchor()
    local windowName = "ItemStackingWindow"
    local x = SystemData.MousePosition.x / InterfaceCore.GetScale() -100
    local y = SystemData.MousePosition.y / InterfaceCore.GetScale() -15
    WindowClearAnchors( windowName )
    WindowAddAnchor( windowName, "topleft", "Root", "topleft", x, y )
end

-- OnShutdown Handler
function ItemStackingWindow.Shutdown()

end

-- On Escape key pressed
function ItemStackingWindow.OnKeyEscape()
    ItemStackingWindow.OnClose()
end

--On Enter key pressed
function ItemStackingWindow.OnKeyEnter()
    ItemStackingWindow.OkayButton()
    Cursor.OnLButtonUpProcessed()
end

-- On typing text into the text edit box
function ItemStackingWindow.OnTextChanged(text)
    local slot = ItemStackingWindow.CurrentItemSlot
    local slotLoc = ItemStackingWindow.CurrentSourceLoc
    --Exit out of text amount if the current item id is 0
    if(slot == nil) then
        return
    end

    local itemData = ItemStackingWindow.GetItemData(slotLoc, slot)


    if( itemData == nil ) then
        return
    end

    local windowName = "ItemStackingWindow"
    local editBoxText = windowName.."TextInput"
    local itemCostFrame = windowName.."ItemCost"

    --Hexadecimal of 0 and 9 and Backspace
    ItemStackingWindow.CurrentInput = tonumber(text)
    local amount = itemData.stackCount

    if itemData.stackCount <= 1 then
        -- TODO: we really should have server send us what the stack capacity is for an item so we can use that when an item is stackable
        -- if itemData.capacity > 1 then
        -- amount = itemData.capacity
        amount = ItemStackingWindow.MAX_NON_STACKABLE_ITEMS
    end

    local editInputText = TextEditBoxGetText(editBoxText)
    local outputNum = nil
    if( editInputText ~= nil ) then
        outputNum = tonumber(WStringToString(editInputText))
    end

    if( outputNum ~= nil) then
        if( outputNum > amount ) then
            outputNum = amount
            TextEditBoxSetText(editBoxText, L""..outputNum)
            elseif outputNum == 0 then
            TextEditBoxSetText(editBoxText, L"1")
        end
    end


    if ItemStackingWindow.IsBackpackSlot then
        SliderBarSetCurrentPosition(windowName.."AmountSlider", ItemStackingWindow.CurrentInput / ItemStackingWindow.CurrentItemMaxStackCount)
    else
        local itemCost = itemData.cost
        local altCurrency = itemData.altCurrency
        local totalCost = ItemStackingWindow.CurrentInput * itemCost
        SliderBarSetCurrentPosition(windowName.."AmountSlider", ItemStackingWindow.CurrentInput / ItemStackingWindow.MAX_NON_STACKABLE_ITEMS)
        if itemCost > 0 then
            MoneyFrame.FormatMoney(itemCostFrame, totalCost, 1)
            elseif altCurrency then
            newMoneyFormatAltCurrency(itemCostFrame, altCurrency, 2, ItemStackingWindow.CurrentInput)
        end
    end

end


function newMoneyFormatAltCurrency (windowName, altCurrencyTable, hideIfNotSet, totalBuying)
    p(totalBuying)
    hideIfNotSet = hideIfNotSet

    local currencyTable =
    {
        { frame = (windowName.."GoldFrame"),     label = (windowName.."GoldText")   },
        { frame = (windowName.."SilverFrame"),   label = (windowName.."SilverText") },
        { frame = (windowName.."BrassFrame"),    label = (windowName.."BrassText")  },
    }

    local currentAnchor = windowName

    for i, altCurrencyData in ipairs (currencyTable) do

        if (altCurrencyTable[i] ~= nil)
        then
            if (altCurrencyTable[i].icon ~= 0)
            then
                local texture, x, y = GetIconData(altCurrencyTable[i].icon )
                local ImageWindow = altCurrencyData.frame.."Image"
                DynamicImageSetTexture(ImageWindow, texture, x, y)
                DynamicImageSetTextureScale(ImageWindow, MoneyFrame.ALT_CURRENCY_ICON_SCALE )

                --
                if altCurrencyTable[i].name ~= nil
                then
                    MoneyFrame.altCurrencyTooltips[ImageWindow] = altCurrencyTable[i].name
                end
                if (altCurrencyTable[i].tint ~= nil)
                then
                    local TintColor = altCurrencyTable[i].tint
                    WindowSetTintColor(ImageWindow, TintColor.r, TintColor.g, TintColor.b)
                end
            end

            MoneyFrame.SetMoneyValue (altCurrencyData.label, altCurrencyTable[i].quantity*totalBuying)

            if (altCurrencyTable[i].quantity == 0 and hideIfNotSet)
            then
                altCurrencyData.showing = false
            else
                altCurrencyData.showing = true
            end

            WindowSetShowing (altCurrencyData.frame.."Image", altCurrencyData.showing)
            WindowSetShowing (altCurrencyData.label, altCurrencyData.showing)

            WindowClearAnchors (altCurrencyData.label)
            if (currentAnchor == windowName)
            then
                WindowAddAnchor (altCurrencyData.label, "topleft", currentAnchor, "topleft", 5, 0)
            else
                WindowAddAnchor (altCurrencyData.label, "topright", currentAnchor, "topleft", 5, 0)
            end

            if (altCurrencyData.showing) then
                currentAnchor = altCurrencyData.frame
            end
        else
            MoneyFrame.SetMoneyValue(altCurrencyData.label, 0)
            WindowSetShowing (altCurrencyData.frame.."Image", false)
            WindowSetShowing (altCurrencyData.label, false)
        end
    end

    return currentAnchor
end

--On Okay Button LButtonUp pressed
function ItemStackingWindow.OkayButton()
    local itemData = ItemStackingWindow.GetItemData(ItemStackingWindow.CurrentSourceLoc, ItemStackingWindow.CurrentItemSlot)
    if(itemData == nil) then
        return
    end

    local windowName = "ItemStackingWindow"
    local editBoxText = windowName.."TextInput"

    local editInputText = TextEditBoxGetText(editBoxText)
    local outputNum = nil
    if( editInputText ~= nil ) then
        outputNum = tonumber(WStringToString(editInputText))
    end

    if(outputNum ~= nil and outputNum > 0) then
        Cursor.PickUp( ItemStackingWindow.CurrentSourceLoc, ItemStackingWindow.CurrentItemSlot, itemData.uniqueID, itemData.iconNum, true, outputNum )
    end

    ItemStackingWindow.OnClose()
end

--On Cancel Button LButtonUp pressed
function ItemStackingWindow.CancelButton()
    ItemStackingWindow.OnClose()
end

function ItemStackingWindow.OnClose()
    local windowName = "ItemStackingWindow"
    local backpackType = EA_BackpackUtilsMediator.GetCurrentBackpackType()
    local backpackCursor = EA_BackpackUtilsMediator.GetCursorForBackpack( backpackType )

    if ItemStackingWindow.CurrentSourceLoc == backpackCursor and ItemStackingWindow.CurrentItemSlot then
        EA_BackpackUtilsMediator.ReleaseLockForSlot(ItemStackingWindow.CurrentItemSlot, backpackType, windowName)
    end

    ItemStackingWindow.CurrentItemSlot = nil
    ItemStackingWindow.CurrentSourceLoc = nil
    ItemStackingWindow.CurrentItemMaxStackCount = nil
    ItemStackingWindow.CurrentInput = nil
    ItemStackingWindow.IsBackpackSlot = nil

    WindowSetShowing( windowName, false)
end

function ItemStackingWindow.GetItemData(sourceLoc, slot)

    local itemData

    -- NOTE: I removed sourceLoc == Cursor.SOURCE_EQUIPMENT and sourceLoc == Cursor.SOURCE_QUEST_ITEM (1/12/09)
    --	 as valid choices, since I can't think of any reason we would have a stackable item in the CharacterWindow,
    --   and we shouldn't be able to split a stacked item in Quest Backpack

    local backpackType = EA_BackpackUtilsMediator.GetCurrentBackpackType()
    local curretBackpackCursor = EA_BackpackUtilsMediator.GetCursorForBackpack( backpackType )
    if( sourceLoc ~= Cursor.SOURCE_QUEST_ITEM and ( sourceLoc == curretBackpackCursor or
        sourceLoc == Cursor.SOURCE_BANK ) )
    then
        itemData = DataUtils.GetItemData(sourceLoc, slot)

    elseif sourceLoc == Cursor.SOURCE_MERCHANT then
        itemData = EA_Window_InteractionStore.GetItem(slot)
    end

    return itemData
end
