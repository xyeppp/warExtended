local BagBonus = warExtendedBagBonus

local BAG_BONUS_WINDOW = "BagBonusWindow"
local TITLE_LABEL = "Title"
local TITLE_LABEL_TEXT = "Bonus"
local LAST_BAG_SEPARATOR = "BagBonusTemplate5Separator"

local bagOrder = {
  [1] = "Gold",
  [2] = "Purple",
  [3] = "Blue",
  [4] = "Green",
  [5] = "White"
}

function BagBonus.ToggleBagBonusWindow()
  local isShowing = WindowGetShowing(BAG_BONUS_WINDOW)
  WindowSetShowing(BAG_BONUS_WINDOW, not isShowing)
end

function BagBonus.CreateBagBonusWindow()
  for bagBonusIndex=1,#bagOrder do
    local bagName = bagOrder[bagBonusIndex]
    local bagTable = BagBonus.GetBagTable(bagName)
    bagTable = BagBonus.RegisterBagTable(bagTable, bagName, bagBonusIndex)
    bagTable:createSelfTemplate()
  end

  LabelSetText(BAG_BONUS_WINDOW..TITLE_LABEL, towstring(TITLE_LABEL_TEXT))
  WindowSetShowing(LAST_BAG_SEPARATOR, false)

  WindowRegisterCoreEventHandler(BAG_BONUS_WINDOW, "OnShown", "warExtendedBagBonus.GetInitialBagBonus")
end
