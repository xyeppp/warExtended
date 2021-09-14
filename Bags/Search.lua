local function filterValues(filterID, filterType) return filterID, filterType end
local function filterWeaponValues(filterID, filterType) return filterID, filterType end
local function filterArmorValues(filterID, filterType) return filterID, filterType end


local SearchNameMap={
  ["$tali"] = {filterValues(23,"itemType")},
  ["$arm"]={filterValues({6,18,19,20,35,22}, "armorTypes")},
  ["$weap"]={filterWeaponValues({1,2,3,5,7,8,9,11,12,13,14,15,16,17,21,24,25}, "weaponTypes")},
  ["$mount"]={filterValues({29,30},"itemType")},
  ["$pot"]={filterValues(31,"itemType")},
  ["$misc"]={filterValues(0,"itemType")},
  ["$craft"]={filterValues(34,"itemType")},
  ["$curr"]={filterValues(36,"itemType")},
  ["$dye"]={filterValues(27,"itemType")},
  ["$trophy"]={filterValues(24,"itemType")},
  ["$siege"]={filterValues(39,"itemType")},
  ["$salv"]={filterValues(32,"itemType")},
  ["$set"]={filterValues("itemSet", "itemSet")},
  ["$dps"]={filterValues("dpsCheck", "dpsCheck")},
  ["$ilvl"]={filterValues("iLevel", "iLevel")},
  ["$str"]={filterValues(1,"itemStat")},
  ["$will"]={filterValues(3,"itemStat")},
  ["$tough"]={filterValues(4,"itemStat")},
  ["$wound"]={filterValues(5,"itemStat")},
  ["$init"]={filterValues(6,"itemStat")},
  ["$wskill"]={filterValues(7,"itemStat")},
  ["$bal"]={filterValues(8, "itemStat")},
  ["$int"]={filterValues(9, "itemStat")},
  ["$block"]={filterValues({10,28,85},"itemStat")},
  ["$parry"]={filterValues({11,29,86}, "itemStat")},
  ["$evade"]={filterValues({12,30,87}, "itemStat")},
  ["$spiritres"]={filterValues(14,"itemStat")},
  ["$corpres"]={filterValues(16,"itemStat")},
  ["$eleres"]={filterValues(15,"itemStat")},
  ["$ap"]={filterValues(32,"itemStat")},
  ["$morale"]={filterValues(33,"itemStat")},
  ["$dodge"]={filterValues(30,"itemStat")},
  ["$disrupt"]={filterValues({13,31,88},"itemStat")},
  ["$incdmg"]={filterValues(22, "itemStat")},
  ["$outdmg"]={filterValues(24, "itemStat")},
  ["$armor"]={filterValues(26, "itemStat")},
  ["$speed"]={filterValues(27, "itemStat")},
  ["$cd"]={filterValues(34, "itemStat")},
  ["$buildtime"]={filterValues(35, "itemStat")},
  ["$critdmg"]={filterValues(36, "itemStat")},
  ["$range"]={filterValues(37, "itemStat")},
  ["$aaspeed"]={filterValues(38, "itemStat")},
  ["$radius"]={filterValues(39, "itemStat")},
  ["$aadmg"]={filterValues(40, "itemStat")},
  ["$apcost"]={filterValues(41, "itemStat")},
  ["$crithitrate"]={filterValues(42, "itemStat")},
  ["$critdmgtaken"]={filterValues(43, "itemStat")},
  ["$effectresist"]={filterValues(44, "itemStat")},
  ["$effectbuff"]={filterValues(45, "itemStat")},
  ["$minrange"]={filterValues(46, "itemStat")},
  ["$dmgabsorb"]={filterValues(47, "itemStat")},
  ["$setbackchance"]={filterValues(48, "itemStat")},
  ["$setbackvalue"]={filterValues(49, "itemStat")},
  ["$xpworth"]={filterValues(50, "itemStat")},
  ["$renownworth"]={filterValues(51, "itemStat")},
  ["$influenceworth"]={filterValues(52, "itemStat")},
  ["$moneyworth"]={filterValues(53, "itemStat")},
  ["$aggroradius"]={filterValues(54, "itemStat")},
  ["$tarduration"]={filterValues(55, "itemStat")},
  ["$butcher"]={filterValues(59, "itemStat")},
  ["$scav"]={filterValues(60, "itemStat")},
  ["$culti"]={filterValues(61, "itemStat")},
  ["$apo"]={filterValues(62, "itemStat")},
  --["$tali"]={filterValues(63, "itemStat")},
  --["$salv"]={filterValues(64, "itemStat")},
  ["$stealth"]={filterValues(65, "itemStat")},
  ["$stealthdetect"]={filterValues(66, "itemStat")},
  ["$hatecaused"]={filterValues(67, "itemStat")},
  ["$hatereceived"]={filterValues(68, "itemStat")},
  ["$offhandchance"]={filterValues(69, "itemStat")},
  ["$offhanddmg"]={filterValues(70, "itemStat")},
  ["$renownrecieved"]={filterValues(71, "itemStat")},
  ["$infreceived"]={filterValues(72, "itemStat")},
  ["$dismountchance"]={filterValues(73, "itemStat")},
  ["$meleecrit"]={filterValues(76, "itemStat")},
  ["$rangecrit"]={filterValues(77, "itemStat")},
  ["$magiccrit"]={filterValues(78, "itemStat")},
  ["$healthregen"]={filterValues(79, "itemStat")},
  ["$meleedmg"]={filterValues(80, "itemStat")},
  ["$rangedmg"]={filterValues(81, "itemStat")},
  ["$magicpower"]={filterValues(82, "itemStat")},
  ["$reducedarmpen"]={filterValues(83,"itemStat")},
  ["$reducedcrithit"]={filterValues(84, "itemStat")},
  ["$healcrit"]={filterValues(89,"itemStat")},
  ["$maxap"]={filterValues(90, "itemStat")},
  ["$master1"]={filterValues(91, "itemStat")},
  ["$mastery2"]={filterValues(92, "itemStat")},
  ["$mastery3"]={filterValues(93, "itemStat")},
  ["$healpower"]={filterValues(94,"itemStat")}}


local function filterCheck(input)
  local input=tostring(input)
  local match={}
  for k,v in pairs(SearchNameMap) do
	local inputMatch=input:match(k)
	if inputMatch then
	  return unpack(v)
	end
  end
end


local function operatorCompare(op, a, b)
  a=tonumber(a)
  b=tonumber(b)
  if op then
	if op:find('<') then
	  if op:find('=') then
		p("found correct<=")
		return a <= b
	  end

	  return a < b
	end

	if op:find('>')then
	  if op:find('=') then
		p("found correct>=")
		return a >= b
	  end

	  return a > b
	end
  end

  return a == b
end

local function filterCompare(visibleInventory, slot, filterID, filterType, compareOperator, compareValue)
  local match=false;
  local itemType = visibleInventory[slot]["type"]
  local itemSet = visibleInventory[slot]["itemSet"]
  local iLevel  = visibleInventory[slot]["iLevel"]
  local dps  = visibleInventory[slot]["dps"]

  if filterType=="iLevel" then
	if compareOperator == nil then return else
	  local operatorMatch=operatorCompare(compareOperator, iLevel, compareValue)
	  if operatorMatch then
		match=true;
	  end
	end
  elseif filterType=="dpsCheck" then
	if compareOperator == nil then return else
	  local operatorMatch=operatorCompare(compareOperator, dps, compareValue)
	  if operatorMatch then
		match=true;
	  end
	end
  elseif filterType=="armorTypes" then
	for i=1,#filterID do local armorIDs=filterID[i]
	  if armorIDs==itemType then
		match=true;
	  end
	end
  elseif filterType=="weaponTypes" then
	for z=1,#filterID do local weaponIDs=filterID[z]
	  if weaponIDs==itemType then
		match=true;
	  end
	end
  elseif filterType=="itemSet" then
	if itemSet~=0 then
	  match=true;
	end
  elseif filterType=="itemType" then
	if itemType==filterID then
	  match=true;
	end
  elseif filterType=="itemStat" then
	for i=1,#visibleInventory[slot]["bonus"] do
	  local itemStatType = visibleInventory[slot]["bonus"][i]["reference"]
	  local itemStatTypeValue = visibleInventory[slot]["bonus"][i]["value"]
	  if itemStatType==filterID then
		if compareOperator~= nil then
		  local operatorMatch=operatorCompare(compareOperator, itemStatTypeValue, compareValue)
		  if operatorMatch then
			match=true;
		  end
		else
		  match=true;
		end
	  end
	end
  end
  return match
end



local function SearchInBags(input, visibleInventory, currentTab)
  if currentTab==1 then return end
  local atStore=QNABackpacker.atStore

  local compareFilter, compareOperator, compareValue = input:match('^(.*)(=*[<>]=*)(%d+)$')
  p(compareFilter)
  p(compareOperator)
  p(compareValue)
  local filterID, filterType=filterCheck(input)
  local input=textClean(input)
  local word = ("(.*)"..tostring(input).."(.*)")
  for slot=1,#visibleInventory do
	local pocket = EA_Window_Backpack.GetPocketNumberForSlot(currentTab, slot)
	local pocketName = EA_Window_Backpack.GetPocketName(pocket)
	local buttonIndex = slot - EA_Window_Backpack.pockets[pocket].firstSlotID  + 1
	local anchorName = pocketName.."Buttons"
	local itemName = tostring(visibleInventory[slot]["name"])
	local iLevel  = tostring(visibleInventory[slot]["iLevel"])
	local unsellable = visibleInventory[slot]["flags"][GameData.Item.EITEMFLAG_NO_SELL] or visibleInventory[slot]["sellPrice"] <= 0
	if atStore and input=="" and unsellable then
	  ActionButtonGroupSetTintColor(anchorName,buttonIndex,125,0,0)
	elseif filterID~= nil then
	  --if not operator then
	  local match=filterCompare(visibleInventory, slot, filterID, filterType, compareOperator, compareValue)
	  if match then
		ActionButtonGroupSetTintColor(anchorName,buttonIndex,255,255,255)
	  else
		ActionButtonGroupSetTintColor(anchorName,buttonIndex,50,50,50)
	  end
	  -- else
	  --   local operatorMatch=operatorCompare(operator, word, value)
	  -- end
	elseif itemName:match(word) then
	  ActionButtonGroupSetTintColor(anchorName,buttonIndex,255,255,255)
	else
	  ActionButtonGroupSetTintColor(anchorName,buttonIndex,50,50,50)
	end
  end
end



local function SearchInBank(input, bankData, visibleRange, maxRange, availableBankSlots)
  local word = ("(.*)"..tostring(input).."(.*)")
  for bankSlot=visibleRange,maxRange do

	if bankSlot<=availableBankSlots then
	  local slotName="BankWindowSlots"
	  local buttonIndex = BankWindow.GetButtonIndexForSlotNumber( bankSlot )
	  local slotNo = BankWindow.GetSlotNumberForButtonIndex( buttonIndex )
	  local itemName = tostring(bankData[bankSlot]["name"])

	  if itemName:match(word) then
		ActionButtonGroupSetTintColor(slotName,buttonIndex,255,255,255)
	  else
		ActionButtonGroupSetTintColor(slotName,buttonIndex,50,50,50)
	  end

	end
  end
end


function EA_Window_Backpack.BackpackSearcher()
  local currentTab = EA_Window_Backpack.currentMode
  local visibleInventory = EA_Window_Backpack.GetItemsFromBackpack( currentTab )
  local input =TextEditBoxGetText("BackpackSearcher")
  local isBankWindowOpen=WindowGetShowing("BankWindow")
  local input=tostring(input)

  SearchInBags(input, visibleInventory, currentTab)

  if isBankWindowOpen then
	local bankInventory = GetBankData()
	local range1,range2=GetMinVisibleBankSlot(),GetMaxVisibleBankSlot()
	local availableBankSlots=GameData.Player.numBankSlots
	SearchInBank(input, bankInventory, range1, range2, availableBankSlots)
  end

end

function EA_Window_Backpack.SearchFocus()
  local isSearchShowing=WindowGetShowing(searchWin)
  local isFocusByDefault=QNABackpacker.FocusSearchByDefault
  if isSearchShowing and isFocusByDefault then
	WindowAssignFocus(searchWin, true)
  end
end


function EA_Window_Backpack.OnHiddenText()
  local input=TextEditBoxGetText(searchWin)
  if input~=L"" then
	TextEditBoxSetText(searchWin, L"")
  end
  WindowAssignFocus("BackpackSearcher", false)
end