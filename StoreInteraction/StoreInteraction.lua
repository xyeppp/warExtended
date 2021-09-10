warExtendedStore = warExtended.Register("warExtended Store Interaction")
local Store = warExtendedStore
local isAtStore = false


function Store.IsAtStoreCheck()
  local storeInteraction = EA_Window_InteractionStore.InteractingWithStore() or EA_Window_InteractionLibrarianStore.InteractingWithLibrarianStore()

  if storeInteraction ~= isAtStore then
	isAtStore = storeInteraction
	EA_Window_Backpack.UpdateBackpackSlots()
  end

end


local function tintUnsellable( buttonGroupName, buttonIndex, itemData, isLocked, highLightColor )
  local isNotEmptySlotAndNotCurrency = itemData.id ~= 0 and itemData.type ~= GameData.ItemTypes.CURRENCY

  if isNotEmptySlotAndNotCurrency then
	local isUnsellable = itemData.flags[GameData.Item.EITEMFLAG_NO_SELL] or itemData.sellPrice <= 0
	if isUnsellable and isAtStore then
	  ActionButtonGroupSetTintColor( buttonGroupName, buttonIndex, 125, 0, 0)
	elseif not isAtStore then
	  ActionButtonGroupSetTintColor( buttonGroupName, buttonIndex, 255, 255, 255)
	end
  end

end


function Store.Initialize()
  Store:Hook(EA_Window_Backpack.SetActionButton, tintUnsellable, true)
  Store:RegisterEvent("INTERACT_DONE", "warExtendedStore.IsAtStoreCheck")
  Store:RegisterEvent("INTERACT_SHOW_STORE","warExtendedStore.IsAtStoreCheck")
end