local Store = warExtendedInteraction


--[[local function Unregistrator( )
  if unregistered then return end
  for i = 1, 5 do
	WindowUnregisterCoreEventHandler( "EA_Window_InteractionStoreListRow"..i.."ItemAltCostGoldFrameImage", "OnMouseOver" )
	WindowUnregisterCoreEventHandler( "EA_Window_InteractionStoreListRow"..i.."ItemAltCostSilverFrameImage", "OnMouseOver" )
	WindowUnregisterCoreEventHandler( "EA_Window_InteractionStoreListRow"..i.."ItemAltCostBrassFrameImage", "OnMouseOver" )
	WindowRegisterCoreEventHandler( "EA_Window_InteractionStoreListRow"..i.."ItemAltCostGoldFrameImage", "OnMouseOver", "EA_Window_Backpack.JustTheTip" )
	WindowRegisterCoreEventHandler( "EA_Window_InteractionStoreListRow"..i.."ItemAltCostSilverFrameImage", "OnMouseOver", "EA_Window_Backpack.JustTheTip" )
	WindowRegisterCoreEventHandler( "EA_Window_InteractionStoreListRow"..i.."ItemAltCostBrassFrameImage", "OnMouseOver", "EA_Window_Backpack.JustTheTip" )
  end
  RegisterEventHandler(SystemData.Events.PLAYER_INVENTORY_SLOT_UPDATED,"EA_Window_Backpack.DisplayRefresh")
  RegisterEventHandler(SystemData.Events.PLAYER_CRAFTING_SLOT_UPDATED,"EA_Window_Backpack.DisplayRefresh")
  RegisterEventHandler(SystemData.Events.PLAYER_CURRENCY_SLOT_UPDATED,"EA_Window_Backpack.DisplayRefresh")

  RegisterEventHandler(SystemData.Events.INTERACT_DONE, "EA_Window_Backpack.ShopToggle")
  RegisterEventHandler(SystemData.Events.INTERACT_SHOW_STORE, "EA_Window_Backpack.ShopToggle")
  unregistered = true;
end

local function SetStoreCurrencyColor(row, currency, status)
  local altCurrencyFrame = "EA_Window_InteractionStoreListRow"..row.."ItemAltCost"
  local goldText = altCurrencyFrame.."GoldText"
  local silverText = altCurrencyFrame.."SilverText"
  local brassText = altCurrencyFrame.."BrassText"
  local goldImage = altCurrencyFrame.."GoldFrameImage"
  local silverImage = altCurrencyFrame.."SilverFrameImage"
  local brassImage = altCurrencyFrame.."BrassFrameImage"

  if status then
	if currency == 1 then
	  LabelSetTextColor( goldText, 255, 255, 255 )
	  WindowSetTintColor( goldImage, 255, 255, 255 )
	elseif currency == 2 then
	  LabelSetTextColor( silverText, 255, 255, 255 )
	  WindowSetTintColor( silverImage, 255, 255, 255 )
	elseif currency == 3 then
	  LabelSetTextColor( brassText, 255, 255, 255 )
	  WindowSetTintColor( brassImage, 255, 255, 255 )
	end
  elseif not status then
	if currency == 1 then
	  LabelSetTextColor( goldText, 125, 0, 0 )
	  WindowSetTintColor( goldImage, 255, 0, 0 )
	elseif currency == 2 then
	  LabelSetTextColor( silverText, 125, 0, 0 )
	  WindowSetTintColor( silverImage, 255, 0, 0 )
	elseif currency == 3 then
	  LabelSetTextColor( brassText, 125, 0, 0 )
	  WindowSetTintColor( brassImage, 255, 0, 0 )
	end
  end
  return
end

local function needCount( countHave, countNeed )
  local countNeed = tonumber( countNeed )
  local countHave = tonumber( countHave )
  local countReq = countNeed - countHave
  local status=false;
  if countHave < countNeed then
	countReq = towstring( "\nNeed: "..countReq )
	status=false;
	return countReq, status
  else
	status=true;
	countReq = L""
	return countReq, status
  end
end

local function statusCompare(row)
  for i=1,#bGrepper[row] do
	local countHave = (bGrepper[row][i]["have"])
	local countNeed = (bGrepper[row][i]["quantity"])
	if countHave~=nil then
	  local text,status = needCount(countHave,countNeed)
	  SetStoreCurrencyColor(row,i,status)
	end
  end
end

local function tooltipText( windowName )
  local tooltipText = L""
  for i=1,#bGrepper do
	local altCurrencyFrame = "EA_Window_InteractionStoreListRow"..i.."ItemAltCost"
	local goldImage = altCurrencyFrame.."GoldFrameImage"
	local silverImage = altCurrencyFrame.."SilverFrameImage"
	local brassImage = altCurrencyFrame.."BrassFrameImage"
	local gImage = windowName:match( goldImage )
	local sImage = windowName:match( silverImage )
	local bImage = windowName:match( brassImage )
	if gImage then
	  local itemName = bGrepper[i][1]["name"]
	  local countHave = towstring(bGrepper[i][1]["have"])
	  local countNeed = towstring(bGrepper[i][1]["quantity"])
	  tooltipText = itemName..L"\nHave: "..countHave..L"\nCost: "..countNeed..needCount(countHave,countNeed)
	  return tooltipText
	elseif sImage then
	  local itemName = bGrepper[i][2]["name"]
	  local countHave = towstring(bGrepper[i][2]["have"])
	  local countNeed = towstring(bGrepper[i][2]["quantity"])
	  tooltipText = itemName..L"\nHave: "..countHave..L"\nCost: "..countNeed..needCount(countHave,countNeed)
	  return tooltipText
	elseif bImage then
	  local itemName = bGrepper[i][3]["name"]
	  local countHave = towstring(bGrepper[i][3]["have"])
	  local countNeed = towstring(bGrepper[i][3]["quantity"])
	  tooltipText = itemName..L"\nHave: "..countHave..L"\nCost: "..countNeed..needCount(countHave,countNeed)
	  return tooltipText
	end
  end
end



local function windowSpawner(row,itemID)
  local pic="EA_Window_InteractionStoreListRow"..row.."ItemPic"
  local havePic="StoreHaveButton"..row
  local haveLabel="StoreHaveButton"..row.."Count"
  local donthavePic="StoreDontHaveButton"..row
  local found = AllEquipFinder(itemID)
  local exist=DoesWindowExist

  if found then
	if not exist(havePic) then
	  CreateWindowFromTemplate(havePic,"StoreHaveButton", pic)
	  DynamicImageSetTexture(havePic, GetIconData(159))
	end
	if exist(donthavePic) then
	  DestroyWindow(donthavePic)
	end
  elseif not found then
	if exist(havePic) then
	  DestroyWindow(havePic)
	end
	if not exist(donthavePic) then
	  CreateWindowFromTemplate(donthavePic,"StoreHaveButton", pic)
	  DynamicImageSetTexture(donthavePic, GetIconData(102))
	end
  end
end

local function checkCurrencyRequirements(row)
  for i=1,#bGrepper[row] do
	local needName  = bGrepper[row][i]["name"]
	local needID = bGrepper[row][i]["type"]
	local needCount = bGrepper[row][i]["quantity"]
	if needID~=0 then
	  local value = AllEquipFinder(needID)
	  local count = AllEquipCounter(needID)
	  if value==true then
		bGrepper[row][i]["have"]=count
	  else
		bGrepper[row][i]["have"]=0
	  end
	end
  end
end

local function altCurrencyCacher(row, data)
  bGrepper[row]=EA_Window_InteractionStore.displayData[ data ].altCurrency
end

local function StorePopulator()
  for row, data in ipairs ( EA_Window_InteractionStoreList.PopulatorIndices ) do
	local itemID=EA_Window_InteractionStore.displayData[ data ].uniqueID
	local cost=EA_Window_InteractionStore.displayData[ data ].altCurrency
	altCurrencyCacher(row, data)
	if cost ~= nil then
	  checkCurrencyRequirements(row)
	  statusCompare(row)
	end
	windowSpawner(row,itemID)
  end
end


function EA_Window_Backpack.JustTheTip( )
  local windowName = SystemData.MouseOverWindow.name
  local countText = tooltipText( windowName )
  Tooltips.CreateTextOnlyTooltip ( SystemData.ActiveWindow.name, countText )
  Tooltips.AnchorTooltip( nil )
end



function EA_Window_Backpack.PopulateStoreItemData( )
  EA_Window_Backpack.originalEA_Window_InteractionStorePopulateStoreItemData( )
  StorePopulator()
end


function EA_Window_Backpack.DisplayRefresh()
  local atStore=QNABackpacker.atStore
  local showing=WindowGetShowing("EA_Window_Backpack")
  local searchWin="BackpackSearcher"
  local searchText=TextEditBoxGetText(searchWin)
  local bankWindow = WindowGetShowing("BankWindow")

  if atStore then
	sellGrep=true;
	StorePopulator()
  end

  if showing then
	QNABackpacker.displayRefresh=true;
	AllCounterRefresh()
	CurrentBackpackSlots()
  end
end


function Store.StoreSearcher(text)
  local filteredDataIndices = EA_Window_InteractionStore.CreateFilteredList(text)

  EA_Window_InteractionStore.InitDataForSorting( filteredDataIndices )

  EA_Window_InteractionStore.DisplaySortedData()
end



function warExtended.CreateFilteredList(text)

  local itemShowFilter = ComboBoxGetSelectedMenuItem( "EA_Window_InteractionStoreFilterSelectBox" )

  --local shouldShowArmor = ButtonGetPressedFlag( "EA_Window_InteractionStoreFilterArmorButton" )
  -- local shouldShowWeapon = ButtonGetPressedFlag( "EA_Window_InteractionStoreFilterWeaponsButton" )
  -- local shouldShowMisc = ButtonGetPressedFlag( "EA_Window_InteractionStoreFilterMiscButton" )
  local itemName = text

  local displayOrder = {}

  --DEBUG(L"   EA_Window_InteractionStore.displayData = ")
  for index, itemData in ipairs(EA_Window_InteractionStore.displayData)
  do

	--DEBUG(L"      "..index..L" = "..itemData.name)
	if index > GameData.InteractStoreData.LastItemIndex then
	  DEBUG(L"EA_Window_InteractionStore.displayData has more entries than it's supposed to")
	  continue
	end

	if ( itemShowFilter == EA_Window_InteractionStore.SORT_FILTER_APPLICABLE ) and
			( not DataUtils.PlayerCanUseItem( itemData ) or
					not itemData.canbuy )
	then
	  continue
	end

	if ( itemShowFilter == EA_Window_InteractionStore.SORT_FILTER_ATTAINABLE ) and
			( not DataUtils.PlayerCanEventuallyUseItem( itemData ) )
	then
	  continue
	end

	local show = true

	-- ASSUMPTION: I'm assuming all filters are mutually exclusive item category and
	--             therefore we only have to check until one item category matches
	--

	if itemName then
	  show = false;
	  if wstring.match(itemData.name, itemName) then
		show = true
	  end]]
	--[[end

	if DataUtils.ItemIsArmor( itemData )
	then
	  show = shouldShowArmor
	elseif DataUtils.ItemIsWeapon( itemData )
	then
	  show = shouldShowWeapon
	else
	  show = shouldShowMisc
	end
	end

	if show
	then
	  table.insert( displayOrder, index )
	end
  end

  return displayOrder
end

oldEA_Window_InteractionStoreCreateFilteredList = EA_Window_InteractionStore.CreateFilteredList
EA_Window_InteractionStore.CreateFilteredList = warExtended.CreateFilteredList]]