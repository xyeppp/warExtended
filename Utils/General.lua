local warExtended = warExtended
local GameData = GameData
local GetGameTime = GetGameTime
local GetAbilityData = GetAbilityData
local ModulesGetData = ModulesGetData

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

function warExtended:GetMousePosition()
  local x,y = SystemData.MousePosition.x, SystemData.MousePosition.y
  return x,y
end

function math.percent(percent,maxvalue)
  if tonumber(percent) and tonumber(maxvalue) then
	return (maxvalue*percent)/100
  end
  return false
end

function warExtended:GetPlayerHPCurrent()
  local currentPlayerHP = GameData.Player.hitPoints.current
  return currentPlayerHP
end

function warExtended:GetPlayerHPMax()
  local maxPlayerHP = GameData.Player.hitPoints.maximum
  return maxPlayerHP
end

function warExtended:GetPlayerWorldObjNum()
local playerWorldObj = GameData.Player.worldObjNum
return playerWorldObj
end

function warExtended:IsPlayerWorldObjNum(worldObjNum)
  local isPlayerWorldObjNum = worldObjNum == warExtended:GetPlayerWorldObjNum()
  return isPlayerWorldObjNum
end

function warExtended:GetPlayerPetWorldObjNum()
  local playerPetWorldObjNum = GameData.Player.Pet.objNum
  return playerPetWorldObjNum
end

function warExtended:IsPlayerPetWorldObjNum(worldObjNum)
  local isPlayerPetWorldObjId = worldObjNum == warExtended:GetPlayerPetWorldObjNum()
  return isPlayerPetWorldObjId
end

function warExtended:GetGameTime()
  local gameTime = GetGameTime()
  return gameTime
end


--[[local Ratio = Value / MaxValue
--Ratio = math.floor(ratio * 100 + 0.5) -- Round to nearest whole number.

local function percentage(count,goal)
  local percents = ((count - 1) * 100) / (goal - 1)
  return percents
end



]]