local warExtended = warExtended
local EA_Window_ContextMenu=EA_Window_ContextMenu
local currentContextMenu = 1
local pairs = pairs

--TODO:clear thisf ile
--[[hook function EA_Window_ContextMenu.OnMouseOverDefaultMenuItem()
--    -- Hide any cascaded ContextMenus if we mouse over a Default Menu Item
--    -- (ie. non-cascading)
--    local winName = WindowGetParent( SystemData.MouseOverWindow.name )
--    if ("EA_Window_ContextMenu3" == winName) then
--        return
--    elseif ("EA_Window_ContextMenu2" == winName) then
--        EA_Window_ContextMenu.Hide(EA_Window_ContextMenu.CONTEXT_MENU_3)
--    elseif ("EA_Window_ContextMenu1" == winName) then
--        EA_Window_ContextMenu.Hide(EA_Window_ContextMenu.CONTEXT_MENU_2)
--        EA_Window_ContextMenu.Hide(EA_Window_ContextMenu.CONTEXT_MENU_3)
--    end
--end

]]

function warExtended:CreateSubContextMenu(entryData, menuTitle)
    local contextMenuId = WindowGetId( WindowGetParent( warExtended:GetMouseOverWindow() ) )

    EA_Window_ContextMenu.CreateContextMenu( "", contextMenuId+1, menuTitle)

    for _, entryData in pairs(entryData) do
        if entryData.text == L"" then
            EA_Window_ContextMenu.AddMenuDivider (contextMenuId+1)
        elseif entryData.type == "cascading" then
            EA_Window_ContextMenu.AddCascadingMenuItem( entryData.text, function () self:CreateSubContextMenu(entryData.entryData) end, entryData.disabled, contextMenuId+1)
        elseif entryData.type == "userDefined" then
            EA_Window_ContextMenu.AddUserDefinedMenuItem(entryData.windowName, contextMenuId+1)
        else
            EA_Window_ContextMenu.AddMenuItem (entryData.text, entryData.callback, entryData.disabled or false, true, contextMenuId+1)
        end
    end

    EA_Window_ContextMenu.Finalize (contextMenuId+1)
end

function warExtended:CreateContextMenu(windowName, contextMenuData, menuTitle, menuAnchor)
    currentContextMenu = 1

    EA_Window_ContextMenu.CreateContextMenu( windowName, currentContextMenu, menuTitle)

    for _, entryData in pairs(contextMenuData) do
        if entryData.text == L"" then
            EA_Window_ContextMenu.AddMenuDivider ()
        elseif entryData.type == "cascading" then
            EA_Window_ContextMenu.AddCascadingMenuItem( entryData.text, function () self:CreateSubContextMenu(entryData.entryData) end, entryData.disabled, 1 )
        elseif entryData.type == "userDefined" then
            EA_Window_ContextMenu.AddUserDefinedMenuItem(entryData.windowName)
        else
            EA_Window_ContextMenu.AddMenuItem (entryData.text, entryData.callback, entryData.disabled or false, true)
        end
    end

    EA_Window_ContextMenu.Finalize ( currentContextMenu, menuAnchor)
end

--[[function DevPadWindow.FileOnLButtonUp ()


    if next(DevPad_Save)==nil or curSave==L"Unsaved" then
        EA_Window_ContextMenu.CreateContextMenu ("DevPadWindowSave", 1, L"Unsaved")
        EA_Window_ContextMenu.AddMenuDivider ()
    else
        EA_Window_ContextMenu.CreateContextMenu ("DevPadWindowSave", 1, curSave)
        EA_Window_ContextMenu.AddMenuDivider ()
    end

    local data = {}
    table.insert (data, {text = L"New", callback = DevPadWindow.ToggleNewFile})
    if next(DevPad_Save)==nil then
        table.insert(data, {text = L"Rename", callback = DevPadWindow.ToggleRename, disabled=true})
    else
        table.insert(data, {text = L"Rename", callback = DevPadWindow.ToggleRename, disabled=false})
    end
    if TextEditBoxGetText(codeWindow)==L"" then
        table.insert(data, {text = L"Clear", callback = DevPadWindow.Clear, disabled=true})
    else
        table.insert(data, {text = L"Clear", callback = DevPadWindow.Clear, disabled=false})
    end
    if next(DevPad_Save)==nil then
        table.insert(data, {text = L"Execute", callback = nil, disabled=true})
    else
        table.insert(data, {text = L"Execute", callback = nil, disabled=false})
    end
    table.insert(data, {text = L"", callback = nil})
    if next(DevPad_Save)==nil then
        table.insert(data, {text = L"Load", callback = DevPadWindow.ToggleLoadProject, disabled=true})
    else
        table.insert(data, {text = L"Load", callback = DevPadWindow.ToggleLoadProject, disabled=false})
    end
    table.insert(data, {text = L"", callback = nil})
    if next(DevPad_Save)==nil or disabledButton==true then
        table.insert(data, {text = L"Save", callback = DevPadWindow.ToggleSave, disabled=true})
    else
        table.insert(data, {text = L"Save", callback = DevPadWindow.ToggleSave, disabled=false})
    end
    table.insert (data, {text = L"Save As", callback = DevPadWindow.ToggleSaveAs})
    table.insert(data, {text = L"", callback = nil})
    if next(DevPad_Save)==nil then
        table.insert(data, {text = L"Delete", callback = DevPadWindow.DeleteProject, disabled=true})
    else
        table.insert(data, {text = L"Delete", callback = DevPadWindow.DeleteProject, disabled=false})
    end

    for _, d in pairs (data)
    do
        if (d.text == L"")
        then
            EA_Window_ContextMenu.AddMenuDivider ()
        elseif (d.text == L"Execute") and next(DevPad_Save)==nil then
            EA_Window_ContextMenu.AddCascadingMenuItem( L"Execute", DevPadWindow.CreateContextMenu, true, 1 )
        elseif (d.text == L"Execute") and next(DevPad_Save)~=nil then
            EA_Window_ContextMenu.AddCascadingMenuItem( L"Execute", DevPadWindow.CreateContextMenu, false, 1 )
        else
            EA_Window_ContextMenu.AddMenuItem (d.text, d.callback, d.disabled or false, true)
        end
    end


end


function DevPadWindow.CreateContextMenu()
    local curSave=LabelGetText(windowName.."ProjectName")
    --local fileName = ButtonGetText( windowName )
    EA_Window_ContextMenu.CreateContextMenu( "DevPadExecuteMenu", 2, L"" )

    for k,v in pairs(DevPad_Save) do
        EA_Window_ContextMenu.AddMenuItem( k, DevPadWindow.OnFileButtonUp, false, false, 2 )
    end
    EA_Window_ContextMenu.Finalize( 2, nil )
end

function DevPadWindow.OnFileButtonUp()
    nobuttontoggle=true;
    local windowName = SystemData.ActiveWindow.name
    local fileName = ButtonGetText( windowName )
    SendChatText(L"/script "..DevPad_Save[fileName].Code, L"")
    DevPad.TestPrint()
end]]