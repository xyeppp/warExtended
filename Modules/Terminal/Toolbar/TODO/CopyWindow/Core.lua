
---copy window
--get entries & filtername
function DebugWindow.GetEntries()
  entry            = {}
  local numEntries = TextLogGetNumEntries("UiLog")
  for i = 0, numEntries - 1 do
	local timestamp, filterId, text = TextLogGetEntry("UiLog", i)
	if filterId == 3 then
	  filterId = L "[Error]: "
	elseif filterId == 2 then
	  filterId = L "[Warning]: "
	elseif filterId == 4 then
	  filterId = L "[Debug]: "
	elseif filterId == 11 then
	  filterId = L "[Event]: "
	elseif filterId == 5 then
	  filterId = L "[Function]: "
	end
	if filterId == 9 or filterId == 10 then
	  table.insert(entry, text)
	else
	  table.insert(entry, filterId .. text)
	end
  end
  copyText = entry[1]
  for i = 2, #entry do
	copyText = copyText .. L "\n" .. entry[i]
  end
  TextEditBoxSetTextColor("DevPadCopyLog", 223, 185, 53)
  TextEditBoxSetText("DevPadCopyLog", copyText)
end

---prevent overwriting copy text
function DebugWindow.PreventType()
  TextEditBoxSetText("DevPadCopyLog", copyText)
  return
end
--press tab to show copylog
function DebugWindow.OnKeyTab()
  DebugWindow.CopyToggle()
end
--show behavior
function DebugWindow.OnShowCopy()
  DebugWindow.GetEntries()
  WindowSetShowing("DevPadCopy", true)
  WindowSetShowing("DebugWindowText", false)
  ButtonSetText("DebugWindowToggleCopy", L "Terminal")
end
--hide behavior
function DebugWindow.OnHideCopy()
  TextEditBoxSetText("DevPadCopyLog", L "")
  WindowSetShowing("DevPadCopy", false)
  WindowAssignFocus("DevPadCopyLog", false)
  WindowSetShowing("DebugWindowText", true)
  local showing = WindowGetShowing("DebugWindowTextBox") == true
  if showing then
	WindowAssignFocus("DebugWindowTextBox", true)
  end
  ButtonSetText("DebugWindowToggleCopy", L "Copy")
  entry = nil
end
---show/hide window toggle
function DebugWindow.CopyToggle()
  local showing = WindowGetShowing("DevPadCopy")
  if not showing then
	DebugWindow.OnShowCopy()
	WindowAssignFocus("DevPadCopyLog", true)
  else
	DebugWindow.OnHideCopy()
  end
end
------------------------