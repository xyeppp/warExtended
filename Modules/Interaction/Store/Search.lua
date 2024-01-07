local Store = warExtendedInteraction

function Store.OnStoreSearchTextChanged(text)
    local filteredDataIndices = EA_Window_InteractionStore.CreateFilteredList(text)

    EA_Window_InteractionStore.InitDataForSorting(filteredDataIndices)

    EA_Window_InteractionStore.DisplaySortedData()
end
