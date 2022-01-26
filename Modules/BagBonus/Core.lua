warExtendedBagBonus = warExtended.Register("warExtended Bag Bonus")
local BagBonus = warExtendedBagBonus
local strmatch = wstring.match
local tonumber = tonumber

local BAG_BONUS_INCREASED = L"Your next roll for (%w+) bag will be increased by (%d+)"
local BAG_BONUS_CONSUMED1 = L"Your (%w+) loot bag bonus roll has been consumed."
local BAG_BONUS_CONSUMED2 = L"Your (%w+) bag bonus roll has been consumed."

BagBonus.Settings = {
  IsBonusCached = false;
  CurrentBonus = {
	Gold = 0,
	Purple = 0,
	Blue = 0,
	Green = 0,
	White = 0,
  }
}

local function isBonusIncreased(chatText)
  local isBagBonusIncrease, increaseAmount = strmatch(chatText, BAG_BONUS_INCREASED)
  return isBagBonusIncrease, increaseAmount
end

local function isBonusConsumed(chatText)
  local isBagBonusConsumed = strmatch(chatText, BAG_BONUS_CONSUMED1) or strmatch(chatText, BAG_BONUS_CONSUMED2)
  return isBagBonusConsumed, 0
end


local function isBagBonusMessage(chatText)
  local isBagBonusIncreased, bagBonusAmount  = isBonusIncreased(chatText)
  local isBagBonusConsumed, consumeAmount = isBonusConsumed(chatText)

  if isBagBonusIncreased then
	return isBagBonusIncreased, tonumber(bagBonusAmount)
  elseif isBagBonusConsumed then
	return isBagBonusConsumed, consumeAmount
  end
end

local function bagBonusOnChatText(chatType, from, text)
	local bagName, bonusAmount = isBagBonusMessage(text)
	
  	if not bagName then
	  return
	end
  
	  bagName = BagBonus.GetBagTable(bagName)
  	
	  if bagName:isBonusUpdated(bonusAmount) then
		bagName:updateCurrentBonus(bonusAmount)
	  end
end


function BagBonus.OnInitialize()
  BagBonus.CreateBagBonusWindow()
  BagBonus.RegisterSlashCommand()
  BagBonus:RegisterChat(bagBonusOnChatText, 3)
end