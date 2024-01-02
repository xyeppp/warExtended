local warExtended = warExtended
local Tooltips = Tooltips
local pairs       = pairs

function warExtended:CreateTextTooltip(windowName, tooltipDef, extraText, anchor, alpha, callback)
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
  
  if callback then
	Tooltips.SetUpdateCallback(callback)
  end

end

