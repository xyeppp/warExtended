warExtendedBagBonus = warExtended.Register("warExtended Bag Bonus", "Bag Bonus")

local BagBonus = warExtendedBagBonus
local wstrmatch = wstring.match
local WINDOW_NAME = "warExtendedBagBonusWindow"
local BAG_BONUS_INCREASED = L"Your next roll for (%w+) bag will be increased by (%d+)"
local BAG_BONUS_CONSUMED1 = L"Your (%w+) loot bag bonus roll has been consumed."
local BAG_BONUS_CONSUMED2 = L"Your (%w+) bag bonus roll has been consumed."

if not warExtendedBagBonus.Settings then
  warExtendedBagBonus.Settings = {
	IsBonusCached = false,
	["CurrentBonus"] = {
	  [L"Gold"] = 0,
	  [L"Purple"] = 0,
	  [L"Blue"] = 0,
	  [L"Green"] = 0,
	  [L"White"] = 0,
	}
  }
end

local function isBagBonusMessage(chatText)
  local bagIncreased, increaseAmount  = wstrmatch(chatText, BAG_BONUS_INCREASED)
  local bagConsumed = wstrmatch(chatText, BAG_BONUS_CONSUMED1) or wstrmatch(chatText, BAG_BONUS_CONSUMED2)

  if bagIncreased then
	return bagIncreased, warExtended:toNumber(increaseAmount)
  elseif bagConsumed then
	return bagConsumed, 0
  end
end

local function bagBonusOnChatText(_, _, text)
  local bagName, bonusAmount = isBagBonusMessage(text)
  if bagName then
      local bag = BagBonus.GetBagFrame(BagBonus:Capitalize(bagName))
      bag:SetCurrentBonus(bonusAmount)
	end
  end

local slashCmd = {
  bag = {
	func = function ()
        local frame = GetFrame(WINDOW_NAME)
        frame:Show(not frame:IsShowing())
    end ,
	desc = "Toggle Bag Roll Bonus Window."
  }
}

function BagBonus.OnInitialize()
  BagBonus:RegisterChat(bagBonusOnChatText, 3)
  BagBonus:RegisterSlash(slashCmd, "bagbonus")
end