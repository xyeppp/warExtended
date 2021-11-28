warExtendedBagBonus = warExtended.Register("warExtended Bag Bonus")
local BagBonus = warExtendedBagBonus

local BAG_BONUS_INCREASED = "Your next roll for (%w+) bag will be increased by (%d+)"
local BAG_BONUS_CONSUMED1 = "Your (%w+) loot bag bonus roll has been consumed."
local BAG_BONUS_CONSUMED2 = "Your (%w+) bag bonus roll has been consumed."

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

local function getBagBonusIncreased(chatText)
  local isBagBonusIncrease, increaseAmount = chatText:match(BAG_BONUS_INCREASED)
  increaseAmount = tonumber(increaseAmount)
  return isBagBonusIncrease, increaseAmount
end


local function getBagBonusConsumed(chatText)
  local isBagBonusConsumed = chatText:match(BAG_BONUS_CONSUMED1) or chatText:match(BAG_BONUS_CONSUMED2)
  return isBagBonusConsumed, 0
end


local function isBagBonusMessage(chatText)
  local isBagBonusIncreased, bagBonusAmount  = getBagBonusIncreased(chatText)
  local isBagBonusConsumed, consumeAmount = getBagBonusConsumed(chatText)

  if isBagBonusIncreased then
	return isBagBonusIncreased, bagBonusAmount
  elseif isBagBonusConsumed then
	return isBagBonusConsumed, consumeAmount
  end
end


function BagBonus.OnChatText()
  if BagBonus:IsCorrectChannel(3) then
	local bagName, bonusAmount = isBagBonusMessage(BagBonus:GetChatText())

	if bagName then
	  bagName = BagBonus.GetBagTable(bagName)

	  if bagName:isBonusUpdated(bonusAmount) then
		bagName:updateCurrentBonus(bonusAmount)
	  end
	end
  end

end


function BagBonus.OnInitialize()
  BagBonus.CreateBagBonusWindow()
  BagBonus.RegisterSlashCommand()
  BagBonus:RegisterChat("warExtendedBagBonus.OnChatText")
end