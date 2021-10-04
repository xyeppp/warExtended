local warExtended = warExtended
local ERASE = ""

local hyperlinkTexts = {}


local function getHyperlink(linkData)

  for modules,_ in pairs(hyperlinkTexts) do
	local moduleData = hyperlinkTexts[modules]
	for hyperlinkText, hyperlinkFunction in pairs(moduleData) do
	  local isHyperlink = linkData:match("^"..hyperlinkText)
	  if isHyperlink then
		return hyperlinkText, hyperlinkFunction
	  end
	end
  end

end


local function onHyperlinkText(linkData, flags, x, y )
  local linkData = tostring(linkData)
  local hyperlinkText, hyperlinkFunction = getHyperlink(linkData)

  if hyperlinkText then
	linkData = linkData:gsub(hyperlinkText, ERASE)
	hyperlinkFunction(linkData, flags, x, y)
	return
  end

end


function warExtended:AddHyperlink(hyperlinkText, hyperlinkFunction)
  if not hyperlinkTexts[self.moduleInfo.moduleName] then
	hyperlinkTexts[self.moduleInfo.moduleName] = {}
  end

  hyperlinkTexts[self.moduleInfo.moduleName][hyperlinkText] = hyperlinkFunction
end

warExtended:Hook(EA_ChatWindow.OnHyperLinkLButtonUp, onHyperlinkText, true)

