ObjectInspector = {}
ObjectInspector.Window = "ObjectInspector"
ObjectInspector.Version = 1.3
ObjectInspector.TemporaryObjectList = {}
ObjectInspector.history={}

if not ObjectInspector.Settings then
ObjectInspector.Settings = { ObjectList=L"", show=false}
end



function ObjectInspector.DisplayObject(obj, objName, targetDepth)
	-- Inititalise the object list
	ObjectInspector.TemporaryObjectList = {}
	local currentDepth = 0
	local contents = TextEditBoxGetText(ObjectInspector.Window.."ObjectEditBox")
	-- Call the recursive algorithm to traverse through the object
	local objDetails = ObjectInspector.GetObjectDetails(obj, objName, targetDepth, currentDepth)
	-- Clear out the Object List between uses to free up memory
	ObjectInspector.TemporaryObjectList = {}
	TextEditBoxSetText(ObjectInspector.Window.."ObjectEditBox",contents..towstring(objDetails))
	ObjectInspector.Settings.ObjectList = TextEditBoxGetText( ObjectInspector.Window.."ObjectEditBox" )
end

function ObjectInspector.GetObjectDetails(obj, objName, targetDepth, previousDepth)
	-- A recursive algorithm to traverse the object
	local contents = ""
	local currentDepth = previousDepth + 1
	-- Check the current depth against the targetDepth to see if we should continue traversing
	-- and if the object is a table and then begin the traversal of the table
	if type(obj) == "table" and (targetDepth == 0 or targetDepth >= currentDepth) then
		-- Check to see if we have already traversed this object and act accordingly
		if ObjectInspector.TemporaryObjectList[tostring(obj)] then
			return "Endless Loop detected on object ["..tostring(objName).."]\n"
		else
			ObjectInspector.TemporaryObjectList[tostring(obj)] = true
		end
		-- Retrieve the contents of the table via a recursive call.
		for k, a in pairs(obj) do
			contents = contents..ObjectInspector.GetObjectDetails(a, tostring(objName).."."..tostring(k), targetDepth, currentDepth)
		end
	else
		-- No more traversal required, add the value of the object to the name of the object
		contents = tostring(objName).." = "
		if type(obj) == "wstring" then
			contents = contents.."\""..tostring(obj).."\"\n"
		else
			contents = contents..tostring(obj).."\n"
		end
	end
	-- Return the obj value back to the parent call
	return contents
end


----------------------------------
---   Gui Specific Functions   ---
----------------------------------
function ObjectInspector.WindowInit()

	-- Create the window and then hide it.
	CreateWindow(ObjectInspector.Window, true)
	WindowSetShowing(ObjectInspector.Window,false)
	-- Apply text to the buttons so they are not blank.
	ButtonSetText(ObjectInspector.Window.."ClearButton", L"Clear")
	ButtonSetText(ObjectInspector.Window.."CloseButton", L"Close")
	ButtonSetText(ObjectInspector.Window.."InspectButton", L"Inspect")
	-- Apply text to the labels so they are not blank.
	LabelSetText(ObjectInspector.Window.."Name", L"Object Inspector")
	WindowSetShowing(ObjectInspector.Window.."ObjectScrollbar", false)
	TextEditBoxSetTextColor( ObjectInspector.Window.."ObjectEditBox", 225,225,225)
		TextEditBoxSetText( ObjectInspector.Window.."ObjectEditBox", ObjectInspector.Settings.ObjectList )
	if ObjectInspector.Settings.show then
		ObjectInspector.ShowWindow()
	end
	if(ObjectInspector.history) then
			TextEditBoxSetHistory(ObjectInspector.Window.."CommandEditBox", ObjectInspector.history )
		end
end

function ObjectInspector.ShowWindow()
	ObjectInspector.Settings.show=true
	--ObjectInspector.ClearObjects(nil,nil,nil)
	TextEditBoxSetText(ObjectInspector.Window.."DepthEditBox",towstring("0"))
	-- Show the window
	WindowSetShowing(ObjectInspector.Window,true)
end

function ObjectInspector.CloseWindow(flags, mouseX, mouseY)
	ObjectInspector.Settings.show=false
	-- When the button is clicked, hide the ObjectInspector window.
	WindowSetShowing(ObjectInspector.Window,false)
end

function ObjectInspector.OnShutdown()
	  ObjectInspector.history = TextEditBoxGetHistory("ObjectInspectorCommandEditBox")
end

function ObjectInspector.Toggle()
	if WindowGetShowing("ObjectInspector") then
		ObjectInspector.CloseWindow()
	else
		ObjectInspector.ShowWindow()
	end
end

function ObjectInspector.AddInputHistory()
	local object = TextEditBoxGetText(ObjectInspector.Window.."CommandEditBox")
  table.insert(ObjectInspector.history, object)
end


function ObjectInspector.ClearObjects(flags, mouseX, mouseY)
	TextEditBoxSetText(ObjectInspector.Window.."ObjectEditBox", L"")
	ObjectInspector.Settings.ObjectList=nil
end

function ObjectInspector.InspectObject(flags, mouseX, mouseY)

	local object = TextEditBoxGetText(ObjectInspector.Window.."CommandEditBox")
	if not object or object ==L"" then pp("Object name cannot be empty.")return end
	local targetDepth = tonumber(tostring(TextEditBoxGetText(ObjectInspector.Window.."DepthEditBox")))
	ObjectInspector.AddInputHistory()
	if not targetDepth then targetDepth = 0 end
	if string.len(tostring(object)) < 15 then
		SendChatText(L"/script ObjectInspector.DisplayObject("..object..L",\""..object..L"\","..towstring(targetDepth)..L")",L"")
	else
		SendChatText(L"/script ObjectInspector.DisplayObject("..object..L",\"O\","..towstring(targetDepth)..L")",L"")
	end
end

function ObjectInspector.DepthPlus(flags, mouseX, mouseY)
	local targetDepth = tonumber(tostring(TextEditBoxGetText(ObjectInspector.Window.."DepthEditBox")))
	if not targetDepth then targetDepth = 0 end
	TextEditBoxSetText(ObjectInspector.Window.."DepthEditBox",towstring(targetDepth + 1))
end

function ObjectInspector.DepthMinus(flags, mouseX, mouseY)
	local targetDepth = tonumber(tostring(TextEditBoxGetText(ObjectInspector.Window.."DepthEditBox")))
	if not targetDepth or targetDepth == 0 then targetDepth = 1 end
	TextEditBoxSetText(ObjectInspector.Window.."DepthEditBox",towstring(targetDepth - 1))
end

function ObjectInspector.OnResizeBegin()
  WindowUtils.BeginResize( "ObjectInspector", "topleft", 300, 200, nil)
end
