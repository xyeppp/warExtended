------------------------------------------------------------------------------
---------------------------------LOCALS---------------------------------------


local windowName = "DevPadWindow"
local codeWindow = "DevPadWindowDevPadCode"
local codeScroll="DevPadWindowDevPadCodeDevPadCodeScrollBar"
local saveWindow="DevPadSaveWindow"
local deleteWindow="DevPadDeleteWindow"
local saveWindowText="DevPadSaveWindowTextBox"
local comboBoxer="DevPadProjectLoadFileSelect"
local loadWindow="DevPadConfirmLoad"
local newWindow="DevPadNewWindow"
local newWindowText="DevPadNewWindowTextBox"
local projectWindow="DevPadProjectLoad"
local renameWindow="DevPadRenameWindow"
local renameWindowText="DevPadRenameWindowTextBox"
local exist=false;
local executed=false;
local nobuttontoggle=false;


------------------------------------------------------------------------------
---------------------------------MAIN WINDOW----------------------------------
DevPad = {}
function DevPad.Initialize()

	if not DevPad_FileCount then
	   DevPad_FileCount = 0;
	end

if not DevPad_Save then
	DevPad_Save = {}
end

	if not DevPad_Settings then
		DevPad_Settings = { Code = L"", show = false }
	end


	----------------------------------------------------------------------------
	---------------------------------LABELS-------------------------------------
CreateWindow( saveWindow, false)
CreateWindow( deleteWindow, false)
CreateWindow(loadWindow, false)
CreateWindow(projectWindow,false)
CreateWindow(renameWindow, false)
CreateWindow(newWindow, false)
WindowSetShowing(codeScroll, false)

----MAIN WINDOW
ButtonSetText( windowName .. "File", L"File" )
ButtonSetText( windowName .. "Save", L"Save" )
ButtonSetText( windowName .. "Execute", L"Execute" )
ButtonSetText( windowName .. "Close", L"Close")
ButtonSetText( windowName .. "Undo", L"Undo")
LabelSetTextColor( windowName .. "Lines", 255, 255, 0)
LabelSetText( windowName .. "LineCount", L"Line Count: ")
LabelSetTextColor(windowName .. "ProjectName", 255, 255, 0)
LabelSetText (windowName .. "Project", L"File: ")


--------SAVE WINDOW
ButtonSetText( saveWindow .. "Cancel", L"Cancel" )
ButtonSetText( saveWindow .. "SaveFile", L"Save" )
LabelSetText( saveWindow .. "FileName", L"Project Name: ")
LabelSetText( saveWindow .. "SaveName", L"Save As")

-------DELETE WINDOW
ButtonSetText( deleteWindow .. "Cancel", L"Cancel" )
ButtonSetText( deleteWindow .. "DeleteFile", L"Confirm" )
LabelSetText( deleteWindow .. "DeleteName", L"Delete Project")


------LOAD WINDOW
ButtonSetText( loadWindow .. "Cancel", L"Cancel")
ButtonSetText( loadWindow .. "Load", L"Confirm" )
ButtonSetText( loadWindow .. "SaveLoad", L"Save & Confirm" )
LabelSetText( loadWindow .. "LoadName", L"Warning!")

------NEW FILE
ButtonSetText( newWindow .. "Cancel", L"Cancel")
ButtonSetText( newWindow .. "NewFile", L"Confirm" )
LabelSetText( newWindow .. "NewName", L"New Project")
LabelSetText( newWindow .. "FileName", L"Project Name: ")

------RENAME FILE
ButtonSetText( renameWindow .. "Cancel", L"Cancel")
ButtonSetText( renameWindow .. "RenameFile", L"Confirm" )
LabelSetText( renameWindow .. "RenameName", L"Rename Project")
LabelSetText( renameWindow .. "FileName", L"New Name: ")

------LOAD PROJECTS FILE
ButtonSetText( projectWindow .. "Cancel", L"Cancel")
ButtonSetText( projectWindow .. "LoadFile", L"Load" )
LabelSetText( projectWindow .. "Name", L"Load File")
LabelSetText( projectWindow .. "Choose", L"Choose File: ")



TextEditBoxSetText( codeWindow, DevPad_Settings.Code )


----INIT FUNCTIONS
DevPadWindow.InitCombBox()
	if DevPad_Settings.show then
		DevPadWindow.Show()
	end
	DevPadWindow.GetProjectName()
	DevPadWindow.LineCount()
	DevPadWindow.Undo()
	DevPadWindow.SaveCheck()
end




-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
-----------------------------WINDOW FUNCTIONS--------------------------------
DevPadWindow = {}




----------------------------------------------------------------------------
----------------------------TOGGLE WINDOW-----------------------------------
function DevPadWindow.Toggle()
	if WindowGetShowing( windowName ) then
		DevPadWindow.Hide()
		DebugWindow.OnShowFocus()
	else
		DevPadWindow.Show()
		DevPadWindow.OnShown()
	end
end

----------------------------------------------------------------------------
-----------------------------SHOW THE WINDOW---------------------------------

function DevPadWindow.Show()
	DevPad_Settings.show = true
	WindowSetShowing( windowName, true )
end

----------------------------------------------------------------------------
----------------------------HIDE THE WINDOW--------------------------------

function DevPadWindow.Hide()
	DevPad_Settings.show = false
	WindowSetShowing(windowName, false)
		if WindowGetShowing("DebugWindow") then
			WindowAssignFocus("DebugWindowTextBox", true)
		end
end


-----------------------------------------------------------------------------
---------------------------FOCUS ON SHOW-------------------------------------
function DevPadWindow.OnShown()
	local visible = WindowGetShowing(windowName)==true
		if visible == true then
			WindowAssignFocus( codeWindow, true )
 		end
end

----------------------------------------------------------------------------
-----------------------------LINE COUNT-------------------------------------
function DevPadWindow.LineCount()
	local base=tostring(TextEditBoxGetText(codeWindow))
	local pattern="\r"
  local linecount=select(2, string.gsub(base, pattern, ""))+1
	LabelSetText( windowName .. "Lines", towstring(linecount))
end

----------------------------------------------------------------------------
-----------------------------TAB KEY BEHAVIOR------------------------------
function DevPadWindow.OnKeyTab()
	 TextEditBoxInsertText(codeWindow,towstring"     ")
 end


 ----------------------------------------------------------------------------
 ------------------------RESIZE WINDOW-------------------------------------
function DevPad.OnResizeBegin()
  WindowUtils.BeginResize( windowName, "topleft", 300, 200, nil)
end


----------------------------------------------------------------------------
---------------------------DISPLAY PROJECT NAME-----------------------------
function DevPadWindow.GetProjectName()
	if DevPad_Settings.SelectedText~=nil then
		LabelSetText(windowName .. "ProjectName", DevPad_Settings.SelectedText)
else

		LabelSetText(windowName.."ProjectName",	L"Unsaved")
		DevPadWindow.SaveCheck()
	end
end


----------------------------------------------------------------------------
------------------------ESCAPE KEY BEHAVIOUR---------------------------------
function DevPadWindow.OnKeyEscape()
  local visible=WindowGetShowing("DebugWindow")==true
	local text = TextEditBoxGetText(SystemData.ActiveWindow.name)
		if visible==true then
				WindowAssignFocus("DebugWindowTextBox", true)
		elseif visible==false and text==L"" then
				WindowSetShowing(windowName, false)
		end
end


----------------------------------------------------------------------------
----------------------------INIT COMBO BOX-------------------------------
function DevPadWindow.InitCombBox()
	ComboBoxClearMenuItems(comboBoxer)
	  for k,v in pairs( DevPad_Save ) do
						if k==L"" then
								DevPad_Save[k]=nil
						end
						ComboBoxAddMenuItem( comboBoxer, k)
				end
	if DevPad_Settings.Selected ~= nil then
					ComboBoxSetSelectedMenuItem( comboBoxer, 	DevPad_Settings.Selected )
				end
end

-----------------------------------------------------------------------------
-----------------------FILE MENU-------------------------------------------

function DevPadWindow.FileOnLButtonUp ()

		local curSave=LabelGetText(windowName.."ProjectName")


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

	EA_Window_ContextMenu.Finalize ( 1,
		{
			["XOffset"] = -30,
			["YOffset"] = 285,
			["Point"] = "bottomright",
			["RelativePoint"] = "bottomleft",
			["RelativeTo"] = "DevPadWindowFile",
		} )
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
end

-----------------------------------------------------------------------------
---------------------------CREATE NEW PROJECT--------------------------------
-----------------------------------------------------------------------------
---------------------------SHOW MENU-----------------------------------------
function DevPadWindow.ToggleNewFile()
	if WindowGetShowing(projectWindow, true) or WindowGetShowing(renameWindow, true) or WindowGetShowing(saveWindow, true) or WindowGetShowing(deleteWindow, true) then
		WindowSetShowing(renameWindow, false)
		WindowSetShowing(projectWindow, false)
		WindowSetShowing(saveWindow, false)
		WindowSetShowing(deleteWindow, false)
	 end
   	WindowSetShowing(newWindow, true)
		WindowAssignFocus(newWindowText, true)
end

------------------------------------------------------------------------------
---------------------------------HIDE WINDOW----------------------------------
function DevPadWindow.HideNewWindow()
	local visible=WindowGetShowing(windowName)==true
		local visible2=WindowGetShowing("DebugWindow")==true
		TextEditBoxSetText(newWindowText, L"")
		WindowSetShowing(newWindow, false)
		if visible==true then
			WindowAssignFocus(codeWindow, true)
		elseif visible==false and visible2==true then
			WindowAssignFocus("DebugWindowTextBox", true)
	end
end

-----------------------------------------------------------------------------
----------------------------CREATE NEWPROJECT--------------------------------
function DevPadWindow.CreateNewFile()
	local fileName = TextEditBoxGetText(newWindowText)
	if fileName == L"" then pp("File name cannot be empty.")
		WindowAssignFocus(newWindowText, true) return
	else
		for key, value in pairs(DevPad_Save) do
			if key==fileName then
					exist=true;
			else
					exist=false;
				end
		end
	end
	if exist then
	 pp ("A file with this name already exists.")
	elseif not exist then
		DevPad_Save[fileName] = {}
		DevPad_Save[fileName].Code = TextEditBoxGetText(codeWindow)
		ComboBoxAddMenuItem(comboBoxer, 	fileName)
		WindowSetShowing(newWindow, false)
		TextEditBoxSetText(newWindowText, L"")
	DevPad_FileCount = DevPad_FileCount+1
	ComboBoxSetSelectedMenuItem( comboBoxer, DevPad_FileCount	 )
	DevPadWindow.GoToNew()
end
end


-----------------------------------------------------------------------------
-----------------------------GO TO NEW---------------------------------------
function DevPadWindow.GoToNew()
		local selectedName=ComboBoxGetSelectedMenuItem(comboBoxer)
		local selectedText=ComboBoxGetSelectedText(comboBoxer)
		TextEditBoxSetText( codeWindow, L"")
		DevPad_Settings.Selected = selectedName
		DevPad_Settings.SelectedText = selectedText
		DevPadWindow.LineCount()
		DevPadWindow.GetProjectName()
		DevPadWindow.SaveCheck()
end

-----------------------------------------------------------------------------
--------------------------RENAME PROJECT--------------------------------------
function DevPadWindow.ToggleRename()
	if WindowGetShowing(projectWindow, true) or WindowGetShowing(newWindow, true) or WindowGetShowing(saveWindow, true) or WindowGetShowing(deleteWindow, true) then
		 WindowSetShowing(newWindow, false)
		WindowSetShowing(projectWindow, false)
		WindowSetShowing(saveWindow, false)
		WindowSetShowing(deleteWindow, false)
	end
	WindowSetShowing(renameWindow, true)
	WindowAssignFocus(renameWindowText, true)
end

-----------------------------------------------------------------------------
--------------------------CANCEL RENAME--------------------------------------
function DevPadWindow.CancelRename()
	local visible=WindowGetShowing(windowName)==true
		local visible2=WindowGetShowing("DebugWindow")==true
		TextEditBoxSetText(renameWindowText, L"")
		WindowSetShowing(renameWindow, false)
		if visible==true then
			WindowAssignFocus(codeWindow, true)
		elseif visible==false and visible2==true then
			WindowAssignFocus("DebugWindowTextBox", true)
	end
end

-----------------------------------------------------------------------------
--------------------------CONFIRM RENAME------------------------------------
function DevPadWindow.ConfirmRename()
	local fileName = TextEditBoxGetText(renameWindowText)
	local selectedText=ComboBoxGetSelectedText(comboBoxer)
	local selectedName=ComboBoxGetSelectedMenuItem(comboBoxer)
	DevPad_Settings.SelectedText = fileName
	local SaveData = DevPad_Save
	if fileName==L"" then pp("File name cannot be empty.") return
	else
		for key, value in pairs(DevPad_Save) do
			if key==fileName then
					exist=true;
			else
					exist=false;
				end
		end
	end
	if exist then
	 pp ("A file with this name already exists.")
	elseif not exist then
	for key, value in pairs (SaveData) do
		local newKey = fileName
		if key==selectedText then
				if (newKey  ~= nil) then
				SaveData[newKey] = SaveData[key]
				SaveData[key] = nil
		end
	end
end
pp("File "..tostring(selectedText).." renamed to "..tostring(fileName)..".")
------either selectedName or 1 you decide
DevPad_Settings.Selected = selectedName
DevPadWindow.InitCombBox()
DevPadWindow.GetProjectName()
DevPadWindow.CancelRename()
end
end

	-----------------------------------------------------------------------------
	---------------------------LOAD PROJECTT--------------------------------







----SHOW WINDOW
	function DevPadWindow.ToggleLoadProject()
		if WindowGetShowing(renameWindow, true) or WindowGetShowing(newWindow, true) or WindowGetShowing(saveWindow, true) or WindowGetShowing(deleteWindow, true) then
			WindowSetShowing(newWindow, false)
			WindowSetShowing(renameWindow, false)
			WindowSetShowing(saveWindow, false)
			WindowSetShowing(deleteWindow, false)
		 end
		WindowSetShowing(projectWindow, true)
		DevPadWindow.LoadCheck()
	end

-------HIDE WINDOW-
	function DevPadWindow.HideLoadProject()
		local visible=WindowGetShowing(projectWindow)==true
		local visible2=WindowGetShowing("DebugWindow")==true
		WindowSetShowing(projectWindow, false)
		if visible==true then
			WindowAssignFocus(codeWindow, true)
		elseif visible==false and visible2==true then
			WindowAssignFocus("DebugWindowTextBox", true)
		end
	end


	----------MAIN LOAD FUNCTION
	function DevPadWindow.LoadFile()
		local selectedName=ComboBoxGetSelectedMenuItem(comboBoxer)
		local selectedText=ComboBoxGetSelectedText(comboBoxer)
		local fileCode = DevPad_Save[selectedText].Code
			TextEditBoxSetText( codeWindow, fileCode )
			DevPad_Settings.Selected = selectedName
			DevPad_Settings.SelectedText = selectedText
			DevPadWindow.GetProjectName()
			DevPadWindow.HideLoadProject()
	  	DevPadWindow.Undo()
			DevPadWindow.SaveCheck()


	end




-----check before loading for unsaved changes

	function DevPadWindow.LoadCheck()
		local curSave=LabelGetText(windowName.."ProjectName")
			if DevPad_Settings.Code ~= DevPad_Save[curSave].Code then
				DevPadWindow.ConfirmLoadFile()
		end
	end


-------show confirm load
function DevPadWindow.ConfirmLoadFile()
		local curSave=LabelGetText(windowName.."ProjectName")
			WindowSetShowing(projectWindow, false)
			LabelSetText( loadWindow .. "LoadConfirm", L"You have unsaved changes in "..curSave..L".\nDo you want to continue?")
			WindowSetShowing(loadWindow, true)
	end



------hide confirm load


	function DevPadWindow.HideConfirmLoadWindow()
		local visible=WindowGetShowing(windowName)==true
		local visible2=WindowGetShowing("DebugWindow")==true
		WindowSetShowing(loadWindow, false)
		if visible==true then
			WindowAssignFocus(codeWindow, true)
		elseif visible==false and visible2==true then
			WindowAssignFocus("DebugWindowTextBox", true)
		end
	end

----LOAD PROJECT show
	function DevPadWindow.LoadProjectShow()
		WindowSetShowing( loadWindow, false )
		WindowSetShowing( projectWindow, true )
		DevPadWindow.SaveCheck()
	end

---save&confirm
	function DevPadWindow.SaveLoadFile()
		local curSave=LabelGetText(windowName.."ProjectName")
		DevPad_Save[curSave].Code=DevPad_Settings.Code
		WindowSetShowing( loadWindow, false )
		WindowSetShowing( projectWindow, true )
		DevPadWindow.SaveCheck()
		DevPadWindow.Undo()
	end


	------------------------------------------------------------------------------
	-------------------------------SAVE FUNCTIONS-----------------------------

	---------------------------SAVE AS WINDOW TOGGLE
	function DevPadWindow.ToggleSaveAs()
			if WindowGetShowing(newWindow) or WindowGetShowing(projectWindow) or WindowGetShowing(renameWindow) or WindowGetShowing(deleteWindow, true) then
			 WindowSetShowing(newWindow, false)
			 WindowSetShowing(projectWindow, false)
			 WindowSetShowing(renameWindow, false)
			 WindowSetShowing(deleteWindow, false)
		 end
			WindowSetShowing(saveWindow, true)
			WindowAssignFocus(saveWindow.."TextBox", true)
	end


	------------------HIDE SAVE WINDOW
	function DevPadWindow.HideSaveWindow()
		local visible=WindowGetShowing(windowName)==true
			local visible2=WindowGetShowing("DebugWindow")==true
			TextEditBoxSetText(saveWindowText, L"")
			WindowSetShowing(saveWindow, false)
			if visible==true then
				WindowAssignFocus(codeWindow, true)
			elseif visible==false and visible2==true then
				WindowAssignFocus("DebugWindowTextBox", true)
			end
			end

-------------SAVE FILE
	function DevPadWindow.ToggleSave()

		if disabledButton==true then return end
		if WindowGetShowing(loadWindow, true) then
			WindowSetShowing(loadWindow, false) end
		local curSelect=LabelGetText(windowName.."ProjectName")
		if curSelect==L"Unsaved" then
			DevPadWindow.ToggleSaveAs()
		else
			DevPad_Save[curSelect].Code = TextEditBoxGetText(codeWindow)
			pp("File "..tostring(curSelect).." saved.")
			DevPadWindow.SaveCheck()
			DevPadWindow.Undo()
		end
	end


	---------------MAIN  SAVE FUNCTION--------


		function DevPadWindow.SaveFile()
			local fileName = TextEditBoxGetText(saveWindowText)
			local curSave=LabelGetText(windowName.."ProjectName")
			DevPad_Save[fileName] = {}
			DevPad_Save[fileName].Code = TextEditBoxGetText(codeWindow)
			if fileName == L"" then
				pp("File name cannot be empty!")
				WindowAssignFocus(saveWindowText, true)
			elseif DevPad_Save[curSave] == DevPad_Save[fileName] then
						pp ("File name cannot be the same!")
						WindowAssignFocus(saveWindowText, true)
					else
						ComboBoxAddMenuItem(comboBoxer, 	fileName)
						WindowSetShowing(saveWindow, false)
						pp("File "..tostring(fileName).." saved to DevPad.")
						TextEditBoxSetText(saveWindowText, L"")
						DevPad_FileCount = DevPad_FileCount+1
						ComboBoxSetSelectedMenuItem( comboBoxer, DevPad_FileCount	 )
						DevPadWindow.LoadFile()
				end
			end






	------------------------------------------------------------------------------
	---------------------SAVE CHECK BUTTON FLAG----------------------------------
				function DevPadWindow.SaveCheck()
				local curSave=LabelGetText(windowName.."ProjectName")
				if curSave==L"Unsaved" then
					disabledButton=false;
					ButtonSetDisabledFlag(windowName.."Save", false)
				else
				if DevPad_Save[curSave]~=nil then
						if DevPad_Settings.Code == DevPad_Save[curSave].Code then
						disabledButton=true;
						ButtonSetDisabledFlag(windowName.."Save", true)
						else
						disabledButton=false;
						ButtonSetDisabledFlag(windowName.."Save", false)
				end
			end
			end
end

	------------------------------------------------------------------------------
	-------------------------------TOOLTIP PREVIEW------------------------------

function DevPadWindow.OnMouseOverCode()
	local selectedText=ComboBoxGetSelectedText(comboBoxer)
    local windowName	= comboBoxer
		local stringLength = string.sub(tostring(L"\n\n"..DevPad_Save[selectedText].Code), 1, 340)
		if DevPad_Save[selectedText].Code==L"" then
			stringLength=string.sub(tostring(L"\n\nempty"), 1, 340)
		end
    Tooltips.CreateTextOnlyTooltip (windowName)
    Tooltips.SetTooltipText (1, 1, L"File: "..towstring(selectedText)..towstring(stringLength))
    Tooltips.SetTooltipColorDef (1, 1, Tooltips.COLOR_ITEM_HIGHLIGHT)
    Tooltips.Finalize ()

    local anchor = { Point="right", RelativeTo=comboBoxer, RelativePoint="left", XOffset=-0, YOffset=20 }
    Tooltips.AnchorTooltip (anchor)
    Tooltips.SetTooltipAlpha (0.85)
end






--------------------------------UNDO--------------------------------
------------------------------------------------------------------------------
------------------------UNDO TO LAST SAVED STATE-------------------------------

function DevPadWindow.Undo()
	local curSave=LabelGetText(windowName.."ProjectName")
	if  curSave==L"Unsaved" then
		--disabledButton=true;
		ButtonSetDisabledFlag(windowName.."Undo", true)
	else
		if DevPad_Save[curSave]~=nil then
			if DevPad_Settings.Code == DevPad_Save[curSave].Code then
				disabledButton=true;
				ButtonSetDisabledFlag(windowName.."Undo", true)
			else
				disabledButton=false;
				ButtonSetDisabledFlag(windowName.."Undo", false)
			end
		end
	end
end

------------------------------------------------------------------------------
--------------------------------UNDO CLICK----------------------------------

function DevPadWindow.UndoClick()
	local curSave=LabelGetText(windowName.."ProjectName")
	if disabledButton==true or curSave==L"Unsaved" then return end
	if WindowGetShowing(loadWindow, true) then
		WindowSetShowing(loadWindow, false) end
	TextEditBoxSetText(codeWindow, DevPad_Save[curSave].Code)
	DevPadWindow.Undo()
	DevPadWindow.SaveCheck()
end


------------------------------------------------------------------------------
-----------------------------------------------------------------------------


------------------------------------------------------------------------------
----------------------------DELETE PROJECT WINDOW-----------------------------
------------------------------------------------------------------------------
------------------------------SHOW DELETEWINDOW----------------------------------
function DevPadWindow.DeleteProject()
	local curSave=LabelGetText(windowName.."ProjectName")
	if WindowGetShowing(projectWindow, true) or WindowGetShowing(renameWindow, true) or WindowGetShowing(saveWindow, true) or WindowGetShowing(newWindow) then
		WindowSetShowing(newWindow, false)
		WindowSetShowing(renameWindow, false)
		WindowSetShowing(projectWindow, false)
		WindowSetShowing(saveWindow, false)
	 end
		LabelSetText( deleteWindow .. "DeleteConfirm", L"Are you sure you want to delete "..curSave..L"?")
		WindowSetShowing(deleteWindow, true)
end


------------------------------------------------------------------------------
------------------------------HIDE DEL WINDOW---------------------------------
function DevPadWindow.HideDeleteWindow()
	local visible=WindowGetShowing(windowName)==true
	local visible2=WindowGetShowing("DebugWindow")==true
	WindowSetShowing(deleteWindow, false)
	if visible==true then
		WindowAssignFocus(codeWindow, true)
	elseif visible==false and visible2==true then
		WindowAssignFocus("DebugWindowTextBox", true)
	end
end

------------------------------------------------------------------------------
--------------------------------CONFIRM DELETE--------------------------------

function DevPadWindow.DeleteFile()
	DevPad_FileCount=DevPad_FileCount-1
	local curSave=LabelGetText(windowName.."ProjectName")
	DevPad_Save[curSave]=nil
	pp("File "..tostring(curSave).." deleted.")
	WindowSetShowing(deleteWindow, false)
	if DevPad_FileCount==0 then
		DevPad_Settings.Selected=nil
		DevPad_Settings.SelectedText=nil
		DevPadWindow.InitCombBox()
		DevPadWindow.Clear()
		DevPadWindow.GetProjectName()
	else
		DevPad_Settings.Selected=DevPad_FileCount
		DevPadWindow.InitCombBox()
		DevPadWindow.LoadFile()
	end
end

function DevPad.TestPrint()
	local curSave=LabelGetText(windowName.."ProjectName")
 local numEntries =TextLogGetNumEntries( "UiLog")
    for i=numEntries-1, numEntries - 1 do
        local timestamp,filterId,texter = TextLogGetEntry( "UiLog", i)
		if string.match(tostring(texter), "EA_UiDebugTools") then
		--pp(texter)
	 local number=tostring(string.match(tostring(texter), "%d+.*"))

if nobuttontoggle then
	local windowName = SystemData.ActiveWindow.name
	local fileName = ButtonGetText( windowName )
	newCode=towstring(DevPad_Save[fileName].Code)
	nobuttontoggle=false;
elseif curSave==L"Unsaved" then
	newCode=DevPad_Settings.Code
else
	newCode = DevPad_Save[curSave].Code
end

lines = 1
 if wstring.match(newCode, L"\n") then
 newCode = wstring.gsub(newCode, L"\n", L"\r")
 end

local errortext=tostring("Error in line: "..number)
local text = "\n1    >   "..string.gsub(tostring(newCode),  "\r", function(s) lines = lines + 1 return s..lines.."    >   " end)
	pp(text.."\n\n"..errortext)
end
end
end




------------------------------------------------------------------------------
--------------------------WINDOW SEND FUNCTIONS---------------------------------
------CLEAR
function DevPadWindow.Clear()
	TextEditBoxSetText( codeWindow, L"" )
end
-------EXECUTE
function DevPadWindow.Execute()
	local newCode = TextEditBoxGetText( codeWindow )
	if TextEditBoxGetText(codeWindow)==L"" then pp("Code cannot be nil.") return end
	SendChatText(L"/script "..towstring(newCode), L"")
	DevPad.TestPrint()
end
-------LINE COUNT
function DevPadWindow.OnCodeChanged()
	DevPad_Settings.Code = TextEditBoxGetText( codeWindow )
	if wstring.match(DevPad_Settings.Code, L"\n") then
		DevPad_Settings.Code = wstring.gsub(DevPad_Settings.Code, L"\n", L"\r")
		TextEditBoxSetText( codeWindow, DevPad_Settings.Code )
	end
	DevPadWindow.GetProjectName()
	DevPadWindow.SaveCheck()
	DevPadWindow.Undo()
	DevPadWindow.LineCount()
end
------------------------------------------------------------------------------
-----------------------------------------------------------------------------
