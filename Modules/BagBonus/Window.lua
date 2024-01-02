local BagBonus                    = warExtendedBagBonus
local WINDOW_NAME                 = "warExtendedBagBonusWindow"
local MOUSE_OVER_STRING           = L"Your next roll for (%w+) bag will be increased by (%d+)"

local WINDOW                      = Frame:Subclass(WINDOW_NAME)
local GOLD_BAG                    = 1
local PURPLE_BAG                  = 2
local BLUE_BAG                    = 3
local GREEN_BAG                   = 4
local WHITE_BAG                   = 5
local TITLEBAR                    = 6

local BAG_FRAME                   = Frame:Subclass("BagBonusTemplate")
local BAG_ICON                    = 1
local BAG_BONUS_TEXT              = 2
local BAG_SEPARATOR               = 3
local BAG_PROGRESS_BAR            = 4
local STATUS_BAR_BACKGROUND_COLOR = { r=161, g=44,b=44 }
local STATUS_BAR_FOREGROUND_COLOR = { r=25, g=146, b=41 }

BAG_FRAME.bags                    = {
  [L"Gold"] = {
	id = 1,
	maxBonusPoints = 1000,
	icon = 552,
  },
  [L"Purple"] = {
	id = 2,
	maxBonusPoints = 900,
	icon = 554,
  },
  [L"Blue"] = {
	id = 3,
	maxBonusPoints = 800,
	icon = 551,
  },
  [L"Green"] = {
	id = 4,
	maxBonusPoints = 700,
	icon = 553,
  },
  [L"White"] = {
	id = 5,
	maxBonusPoints = 600,
	icon = 555,
  }
}

function BAG_FRAME:Create(bagName)
  local bagId   = self:GetBagId(bagName)
  local bag     = self:CreateFromTemplate(WINDOW_NAME .. "Bag" .. bagId)
  bag.bagName   = bagName

  bag.m_Windows = {
	[BAG_ICON] = DynamicImage:CreateFrameForExistingWindow(bag:GetName() .. "Icon"),
	[BAG_BONUS_TEXT] = Label:CreateFrameForExistingWindow(bag:GetName() .. "Bonus"),
	[BAG_SEPARATOR] = Frame:CreateFrameForExistingWindow(bag:GetName() .. "Separator"),
	[BAG_PROGRESS_BAR] = StatusBar:CreateFrameForExistingWindow(bag:GetName() .. "ProgressBar")
  }

  bag.m_Windows[BAG_ICON]:SetTexture(GetIconData(self.bags[bagName].icon))
  bag.m_Windows[BAG_ICON]:SetTextureScale(0.5)
  bag.m_Windows[BAG_PROGRESS_BAR]:SetMaximumValue(self.bags[bagName].maxBonusPoints)
  bag.m_Windows[BAG_PROGRESS_BAR]:SetForegroundTint(STATUS_BAR_FOREGROUND_COLOR)
  bag.m_Windows[BAG_PROGRESS_BAR]:SetBackgroundTint(STATUS_BAR_BACKGROUND_COLOR)
  bag.m_Windows[BAG_BONUS_TEXT]:SetText(bag:GetCurrentBonus())

  bag:SetId(bagId)
  bag:Show(true)
  bag:SetParent(WINDOW_NAME)

  if bagId == 5 then
	bag.m_Windows[BAG_SEPARATOR]:Show(false)
  end

  if bagId == 1 then
	bag:SetAnchor({ Point = "topleft", RelativeTo = WINDOW_NAME, RelativePoint = "topleft", XOffset = 18, YOffset = 26 })
  else
	bag:SetAnchor({ Point = "top", RelativeTo = WINDOW_NAME .. "Bag" .. bagId - 1, RelativePoint = "top", XOffset = 0, YOffset = 54 })
  end

  return bag
end

function BAG_FRAME:GetBagId(bagName)
  bagName = bagName or self.bagName
  return self.bags[bagName].id
end

function BAG_FRAME:GetCurrentBonus()
    local currentBonus = 0

    if warExtendedBagBonus.Settings.CurrentBonus ~= nil then
        currentBonus = BagBonus.Settings.CurrentBonus[self.bagName]
    end

  return currentBonus
end

function BAG_FRAME:SetCurrentBonus(bonus)
  BagBonus.Settings.CurrentBonus[self.bagName] = bonus

  self:SetProgressBar(bonus)
  self:SetBonusText(bonus)
end

function BAG_FRAME:SetProgressBar(value)
    self.m_Windows[BAG_PROGRESS_BAR]:SetCurrentValue(value)
end

function BAG_FRAME:SetBonusText(bonus)
  self.m_Windows[BAG_BONUS_TEXT]:SetText(bonus)
end

function BAG_FRAME:OnMouseOver()
    warExtended:CreateTextTooltip(self:GetName(), {
        [1]={{text = L"Your next roll for a "..self.bagName..L" bag will be increased by "..self:GetCurrentBonus(), color=Tooltips.COLOR_HEADING}},
    }, nil, Tooltips.ANCHOR_WINDOW_TOP, 1)
end

function WINDOW:Create()
  local frame = self:CreateFromTemplate(WINDOW_NAME)

    frame.m_Windows = {
	[GOLD_BAG] = BAG_FRAME:Create(L"Gold"),
	[PURPLE_BAG] = BAG_FRAME:Create(L"Purple"),
	[BLUE_BAG] = BAG_FRAME:Create(L"Blue"),
	[GREEN_BAG] = BAG_FRAME:Create(L"Green"),
	[WHITE_BAG] = BAG_FRAME:Create(L"White"),
	[TITLEBAR] = Label:CreateFrameForExistingWindow(WINDOW_NAME .. "TitleBarLabel"),
  }

    frame.m_Windows[TITLEBAR]:SetText(L"Bonus")
end

function WINDOW:OnShown()
  if not BagBonus.Settings.IsBonusCached then
	BagBonus:Send("]bag")
	BagBonus.Settings.IsBonusCached = true;
  end
end

function WINDOW:OnShutdown()
  BagBonus.Settings.IsBonusCached = false
end

function warExtendedBagBonus.GetBagFrame(bagName)
  local frameId = BAG_FRAME.bags[bagName].id
  local frame = GetFrame(WINDOW_NAME.."Bag"..frameId)
  return frame
end

WINDOW:Create()

