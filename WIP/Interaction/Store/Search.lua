local Store = warExtendedStoreInteraction

function Store.OnSearchTextChanged(text)
  text = Store:StringToNoCaseIgnoreSpecial(text)

  local filteredDataIndices = EA_Window_InteractionStore.CreateFilteredList(text)

  EA_Window_InteractionStore.InitDataForSorting( filteredDataIndices )

  EA_Window_InteractionStore.DisplaySortedData()
end