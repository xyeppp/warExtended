warExtendedBagBonus = warExtended.Register("warExtended Bag Bonus")
local BagBonus = warExtendedBagBonus
local BAG_BONUS_WINDOW = "BagBonusWindow"
local BAG_BONUS_TEMPLATE = "BagBonusTemplate"
local MAX_LINE_LENGTH = 138
local PROGRESS_BAR_HEIGHT = 2

local bagData = {
  [1] = {
    name = "Gold",
    maxbonuspoints = 1000,
    icon = 552,
    slice = "PQSackGold"
  },
  [2] = {
    name = "Purple",
    maxbonuspoints = 900,
    icon = 554,
    slice = "PQSackPurple"
  },
  [3] = {
    name = "Blue",
    maxbonuspoints = 800,
    icon = 551,
    slice = "PQSackBlue"
  },
  [4] = {
    name = "Green",
    maxbonuspoints = 700,
    icon = 553,
    slice = "PQSackGreen"
  },
  [5] = {
    name = "White",
    maxbonuspoints = 600,
    icon = 555,
    slice = "PQSackSilver"
  }
}

warExtendedBagBonus.isInitialBagBonusCached = false;
warExtendedBagBonus.BagBonuses = {
  Gold = "0",
  Purple = "0",
  Blue = "0",
  Green = "0",
  White = "0"
}

local function titleCase( first, rest )
  return first:upper()..rest:lower()
end

local function bagStringTitleCase(str)
  str = str:gsub("(%a)([%w_']*)", titleCase)
  return str
end

local function getAllBagBonuses()
  SendChatText(L".bag", L"")
end

local function getBagBonus(bagType)
  local bagBonus = BagBonus.BagBonuses[bagType]
  return bagBonus
end

local function getBagDataIndexNumberFromBagType(bagTypeToCheck)
  for bagType=1,#bagData do
    local bagInfo=bagData[bagType]
    local bagName = bagInfo.name
    local isMatch = bagTypeToCheck == bagName
    if isMatch then
      return bagType
    end
  end
end

local function getBagTypeFromBagDataIndexNumber(bagDataIndex)
  for bagType=1,#bagData do
    local bagInfo=bagData[bagType]
    local bagName = bagInfo.name
    local isMatch = bagDataIndex == bagType
    if isMatch then
      return bagName
    end
  end
end

local function getBagPointLimit(bagIndex)
  local bagPointLimit = bagData[bagIndex].maxbonuspoints
  return bagPointLimit
end

function getProgressBarDimensions(bagIndex)
  local bagPointLimit = getBagPointLimit(bagIndex)
  local bagName = getBagTypeFromBagDataIndexNumber(bagIndex)
  local bagBonus = tonumber(getBagBonus(bagName))
  local x = (MAX_LINE_LENGTH / bagPointLimit) * bagBonus
  local y = PROGRESS_BAR_HEIGHT
  return x, y
end


function setBagBonusProgressBar(bagType)
  local bagIndex = getBagDataIndexNumberFromBagType(bagType) or bagType
  local x,y= getProgressBarDimensions(bagIndex)
  local progressBarTemplate=BAG_BONUS_TEMPLATE..bagIndex.."CurrentProgressBar"
  WindowSetDimensions(progressBarTemplate, x,y)
end

function setBagBonusText(bagType)
  local bagIndex = getBagDataIndexNumberFromBagType(bagType) or bagType
  local bagName = getBagTypeFromBagDataIndexNumber(bagType) or bagType
  local bagBonus = BagBonus.BagBonuses[bagName]
  local bonusTemplateText = BAG_BONUS_TEMPLATE..bagIndex.."Bonus"
  LabelSetText(bonusTemplateText, towstring(bagBonus))
end

local function setNewBagBonus(bagType, bagBonus)
  warExtendedBagBonus.BagBonuses[bagType] = bagBonus
  setBagBonusText(bagType)
  setBagBonusProgressBar(bagType)
end


local function createBagBonusTemplates()
  for bagType=1,#bagData do
    local bagInfo = bagData[bagType]
    local texture, x,y = GetIconData(bagInfo.icon)
    CreateWindowFromTemplate(BAG_BONUS_TEMPLATE..bagType, BAG_BONUS_TEMPLATE, BAG_BONUS_WINDOW )
    DynamicImageSetTexture(BAG_BONUS_TEMPLATE..bagType.."Type", texture, x,y)
    DynamicImageSetTextureScale(BAG_BONUS_TEMPLATE..bagType.."Type",0.5)

    if bagType == 1 then
      WindowAddAnchor( BAG_BONUS_TEMPLATE..bagType, "topleft", BAG_BONUS_WINDOW, "center", 20, 50 )
    else
      WindowAddAnchor( BAG_BONUS_TEMPLATE..bagType, "topleft", BAG_BONUS_TEMPLATE..(bagType-1), "center", 0, 50 )
    end

  end
end

local function setWindowLabelAndHideSeparator()
  LabelSetText(BAG_BONUS_WINDOW.."Title", L"Bag Bonus")
  WindowSetShowing("BagBonusTemplate5Separator", false)
end

local function setBagBonusTextAndProgressBars()
  for bagType=1,#bagData do
    setBagBonusProgressBar(bagType)
    setBagBonusText(bagType)
  end
end


local function createBagBonusWindow()
  createBagBonusTemplates()
  setBagBonusTextAndProgressBars()
  setWindowLabelAndHideSeparator()
end

local function processBagBonusMessage(chatText)
  local bagType, bagIncrease = chatText:match("Your next roll for (%w+) bag will be increased by (%d+)")
  local isBagBonusConsumed = chatText:match("Your (%w+) bag bonus roll has been consumed.")
  local isBonusUpdated = getBagBonus(bagStringTitleCase(bagType)) ~= bagIncrease
  bagType = bagStringTitleCase(bagType)

  if bagIncrease then
    if isBonusUpdated then
      setNewBagBonus(bagType, bagIncrease)
    end
  elseif isBagBonusConsumed then
    setNewBagBonus(bagType, "0")
  end
end


local function isBagTypeBonusText(chatText)
  local isBagTypeBonusText = chatText:match("Your next roll for (%w+) bag will be increased") or chatText:match("Your (%w+) bag bonus roll has")
  return isBagTypeBonusText
end


function BagBonus.OnChatText()
  if BagBonus:IsChannel(3) then
    local chatText = tostring(GameData.ChatData.text)
    if isBagTypeBonusText(chatText) then
      processBagBonusMessage(chatText)
    end
  end

end


function BagBonus.GetInitialBagBonus()
  local isFirstInitialize = BagBonus.isInitialBagBonusCached == true
  if isFirstInitialize then
    return
  end
  getAllBagBonuses()
  BagBonus.isInitialBagBonusCached = true;
end

function BagBonus.ToggleBagBonusWindow()
  local isShowing = WindowGetShowing(BAG_BONUS_WINDOW)
  if isShowing then
    WindowSetShowing(BAG_BONUS_WINDOW, false)
    return
  end
  WindowSetShowing(BAG_BONUS_WINDOW, true)
end


local slashCommands = {
  bag = {
    func = BagBonus.ToggleBagBonusWindow,
    desc = "Toggle Bag Roll Bonus Window."
  }
}


function BagBonus.OnInitialize()
  createBagBonusWindow()
  BagBonus:RegisterChat("warExtendedBagBonus.OnChatText")
  BagBonus:RegisterSlash(slashCommands, "warext")
  WindowRegisterCoreEventHandler(BAG_BONUS_WINDOW, "OnShown", "warExtendedBagBonus.GetInitialBagBonus")
end
