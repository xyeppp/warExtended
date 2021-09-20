local warExtended = warExtended
local ERASE = ""

local hyperlinkTexts = {}



local function addToHyperlinkList(hyperlinkText, hyperlinkFunction)

end

function warExtended:AddHyperlink(hyperlinkText, hyperlinkFunction)
  if not hyperlinkText[self] then
	hyperlinkText[self] = {}
  end
  hyperlinkTexts[self][hyperlinkText] = hyperlinkFunction
  p(hyperlinkTexts)
end

