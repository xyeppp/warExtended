--[[function warExtendedTerminal.OnUpdateWindow(timePassed)
  if (warExtendedTerminal.lastMouseX ~= SystemData.MousePosition.x or warExtendedTerminal.lastMouseY ~= SystemData.MousePosition.x) then
	local mousePoint = L"" .. SystemData.MousePosition.x .. L", " .. SystemData.MousePosition.y;
	LabelSetText("DebugWindowMousePointText", mousePoint);
	
	warExtendedTerminal.lastMouseX = SystemData.MousePosition.x;
	warExtendedTerminal.lastMouseY = SystemData.MousePosition.y;
  end
  
  
  
  -- Update the MouseoverWindow
  if (warExtendedTerminal.lastMouseOverWindow ~= SystemData.MouseOverWindow.name) then
	LabelSetText("DebugWindowMouseOverText", StringToWString(SystemData.MouseOverWindow.name))
	
	warExtendedTerminal.lastMouseOverWindow = SystemData.MouseOverWindow.name
  end
end

  LabelSetText("DebugWindowMouseOverLabel", L"Mouseover Window:")
  
  LabelSetText("DebugWindowMousePointLabel", L"Mouseover X,Y: ")
  LabelSetText("DebugWindowMousePointText", L"")
  LabelSetTextColor("DebugWindowMouseOverText", 255, 255, 0)
  LabelSetTextColor("DebugWindowMousePointText", 255, 255, 0)
]]---
---
---
