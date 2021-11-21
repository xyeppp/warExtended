local warExtended = warExtended

function warExtended:IsAddonEnabled(addonToCheck)
  local AddonsData = ModulesGetData()
  local isEnabled = false;

  for _, Addon in ipairs(AddonsData) do
	if Addon.name == addonToCheck then
	  isEnabled = Addon.isEnabled
	  break
	end
  end

  return isEnabled
end

function warExtended:RoundTo(number, numberOfDecimalPlaces)
  local roundedNumber = tonumber(string.format("%." .. (numberOfDecimalPlaces or 0) .. "f", number))
  return roundedNumber
end

function warExtended:CompareString(stringToCompare, stringToCheck)
  local stringBoundary = '%f[%w%p]%'..stringToCompare..'%f[%A]'
  local isMatch = stringToCheck:match(stringBoundary)
  return isMatch
end

function warExtended:GetMouseOverWindow()
  local mouseoverWindow = SystemData.MouseOverWindow.name
  return mouseoverWindow
end

function warExtended:IsMouseOverWindow(windowName)
  local isMouseOverWindow = warExtended:GetMouseOverWindow() == windowName
  return isMouseOverWindow
end



function math.percent(percent,maxvalue)
  if tonumber(percent) and tonumber(maxvalue) then
	return (maxvalue*percent)/100
  end
  return false
end

--[[local Ratio = Value / MaxValue
--Ratio = math.floor(ratio * 100 + 0.5) -- Round to nearest whole number.

local function percentage(count,goal)
  local percents = ((count - 1) * 100) / (goal - 1)
  return percents
end



]]