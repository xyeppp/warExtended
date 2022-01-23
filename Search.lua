local warExtended = warExtended

local function filterValues(a,b) return a,b end

local typeFilters = {
  tali = {23},
  armor = {6,18,19,20,35,22},
  weapon = {1,2,3,5,7,8,9,11,12,13,14,15,16,17,21,24,25},
  mount = {29,30},
  pot = {31},
  misc = {0},
  craft = {34},
  currency = {36},
  dye = {27},
  trophy = {24},
  siege = {39},
  salvage = {32},
}

local statFilters = {
  str = {1},
  will = {3},
  tough = {4},
  wounds = {5},
  ini = {6},
  wskill = {7},
  bal = {5},
  int = {9},
  block = {10,28,85},
  parry = {11,29,86},
  evade = {12,30,87},
  spiritres = {14},
  corpres = {16},
  eleres = {15},
  ap = {32},
  morale = {33},
  dodge = {30},
  disrupt = {13,31,88},
  incdmg = {22},
  outdmg = {24},
  armor = {26},
  speed = {27},
  cd = {34},
  buildtime ={35},
  critdmg = {36},
  range = {37},
  aaspeed = {38},
  radius = {39},
  aadmg = {40},
  apcost = {41},
}

 searchFilters={
   ["$set"]={
	 values = nil,
	 filterType = "itemSet",
	 operator = false;
   },
   ["$dps"]={
	 values = nil,
	 filterType = "dps",
	 operator = true;
   },
   
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

local Search = LibStub('CustomSearch-1.0')

local Lib = {}
Lib.Filters = {}

Lib.Filters.name = {
  tags = {'n', 'name'},
  
  canSearch = function(self, operator, search)
	return not operator and search
  end,
  
  match = function(self, item, _, search)
	local itemName = tostring(item.name)
	return Search:Find(search, itemName)
  end
}

Lib.Filters.level = {
  tags = {'l', 'level', 'lvl'},
  
  canSearch = function(self, _, search)
	return tonumber(search)
  end,
  
  match = function(self, itemData, operator, num)
	local lvl = itemData.iLevel
	if lvl then
	  return Search:Compare(operator, lvl, num)
	end
  end
}

Lib.Filters.dps = {
  tags = {'d', 'dps'},
  
  canSearch = function(self, _, search)
	return tonumber(search)
  end,
  
  match = function(self, itemData, operator, num)
	local dps = itemData.dps
	if dps then
	  return Search:Compare(operator, dps, num)
	end
  end
}

Lib.Filters.type = {
  tags = {'t', 'type'},
  
  canSearch = function(self, operator, search)
	return not operator and search
  end,
  
  match = function(self, item, _, search)
	local type = item.type
	local isMatch = false;
	
	if typeFilters[search] then
	  for _,v in pairs(typeFilters[search]) do
		if Search:Compare(nil, v, type) then
		  return Search:Compare(nil, v, type)
		end
	  end
	end
  end
}



Lib.Filters.stat = {
  tags = {'s', 'stat'},
  
  canSearch = function(self, operator, search)
	return operator and search
  end,
  
  match = function(self, item, _, search)
	local isMatch = false;
	p(_, search)
 
	if statFilters[search] then
	  local queryTypes = statFilters[search]
	  
	  for _,v in pairs(queryTypes) do
	  for i=1,#item.bonus do
		local statType = item.bonus[i]["reference"]
		local statValue = item.bonus[i]["value"]
		--p(statType.."< type | value >"..statValue)
		--p(v)
		
		  if statType == v then
			if Search:Compare(_, v, statValue) then
			  isMatch = true;
			  return isMatch
			end
		  end
		end
		
	  end
	  
	  return isMatch
	end
  end
}

local qualities = {
  [1] = "grey",
  [2] = "white",
  [3] = "green",
  [4] = "blue",
  [5] = "purple",
  [6] = "mythic",
}

Lib.Filters.quality = {
  tags = {'q', 'quality'},
  
  canSearch = function(self, _, search)
	for i, name in pairs(qualities) do
	  if name:find(search) or qualities[tonumber(search)] then
		return i
	  end
	end
  end,
  
  match = function(self, itemData, operator, num)
	local quality = itemData.rarity
	return Search:Compare(operator, quality, num)
  end,
}

function warExtended:MatchSearch(itemData, searchQuery)
  searchQuery = tostring(searchQuery)
  return Search:Matches(itemData, searchQuery, Lib.Filters)
  end

local searchFilters={
}

local searchMap = {
}

local filters2={}

function warExtended.OnSearchBoxTooltip(...)
  local filters=filters2[searchMap[warExtended:GetMouseOverWindow()]]
    --TODO:Get keymap from here
end

function warExtended.OnSearchBoxTextChanged(text)
  text = tostring(text)
  local activeWindow = warExtended:GetActiveWindow()
  local filters = filters2[searchMap[activeWindow]]
  local func = searchFilters[searchMap[activeWindow]][activeWindow]
  func(text, filters)
end

function warExtended:RegisterSearchBox(searchBoxName, func, filters)
  if not searchFilters[self.mInfo.name] then
	searchFilters[self.mInfo.name] = {}
  end
  
  searchMap[searchBoxName] = self.mInfo.name
  filters2[self.mInfo.name] = filters or {}
  searchFilters[self.mInfo.name][searchBoxName] = func
  LabelSetText(searchBoxName.."SearchLabel", L"Search:")
end

function warExtended.OnInitializeSearchBox()
  LabelSetText(warExtended:GetActiveWindow(), L"Search:")
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