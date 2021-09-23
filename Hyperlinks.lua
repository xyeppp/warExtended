local warExtended = warExtended
local ERASE = ""

local hyperlinkTexts = {}



local function addToHyperlinkList(hyperlinkText, hyperlinkFunction)

end

function warExtended:AddHyperlink(hyperlinkText, hyperlinkFunction)
  if not hyperlinkTexts[self.moduleInfo.moduleName] then
	hyperlinkTexts[self.moduleInfo.moduleName] = {}
  end

  hyperlinkTexts[self.moduleInfo.moduleName][hyperlinkText] = hyperlinkFunction
  p(hyperlinkTexts)
end

