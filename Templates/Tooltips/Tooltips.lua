local warExtended = warExtended
local pairs       = pairs

function warExtended:CreateTextTooltip(windowName, tooltipDef, extraText, anchor, alpha)
  Tooltips.CreateTextOnlyTooltip(windowName)
  
  for row, columnData in pairs(tooltipDef) do
	for column, columnDef in pairs(columnData) do
	  Tooltips.SetTooltipText(row, column, columnDef.text)
	  
	  if columnDef.color then
		Tooltips.SetTooltipColorDef(row, column, columnDef.color)
	  end
	
	end
  end
  
  if extraText then
	Tooltips.SetTooltipActionText(extraText)
  end
  
  Tooltips.Finalize()
  
  if anchor then
	Tooltips.AnchorTooltip(anchor)
  end
  
  if alpha then
	Tooltips.SetTooltipAlpha(alpha)
  end

end

