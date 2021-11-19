function EA_Window_Backpack.FindInCounters(uniqueID)
  local counters=QNABackpacker.Counters
  local values=false;
  for i=1,#counters do
	if counters[i].itemID == uniqueID then
	  values=true;
	  break end
  end
  return values
end

local function countersCounter(uniqueID)
  local amount=0
  if inventoryCount==nil then
	inventoryCount=GetFreshBackpack()
  end
  for k = 1, #inventoryCount do local bags = inventoryCount[ k ];
	for z = 1, #bags do
	  if bags[ z ].uniqueID == uniqueID then
		amount = amount + bags[ z ].stackCount
	  end
	end
  end
  return towstring(amount)
end

local function counterDisplayRefresh(i, status)
  local counters=QNABackpacker.Counters
  local label="EA_Window_BackpackCounter"
  if status then
	local color=counters[i].color
	local amount=countersCounter(counters[i].itemID)
	LabelSetTextColor(label..i.."Label", color.r, color.g, color.b)
	DynamicImageSetTexture(label..i.."Icon",GetIconData(counters[i].icon),0,0)
	LabelSetText(label..i.."Label", amount)
	counterAdded=false;
  elseif not status then
	DynamicImageSetTexture(label..i.."Icon","",0,0)
	LabelSetText(label..i.."Label", L"")
  end
  EA_Window_Backpack.DynamicCounterViewSet()
  inventoryCount=nil
end

local function addToCounters(tracker, id, icon)
  local freeTrackers=QNABackpacker.Counters.freeTrackers
  local usedTrackers=QNABackpacker.Counters.usedTrackers
  local itemDATA=GetDatabaseItemData(id)
  local counterAdded=true;
  QNABackpacker.Counters[tracker].itemID = id
  QNABackpacker.Counters[tracker].icon = icon
  QNABackpacker.Counters.itemData[tracker]=itemDATA
  QNABackpacker.Counters[tracker].color=DataUtils.GetItemRarityColor(itemDATA)
  usedTrackers[tracker] = tracker
  freeTrackers[tracker] = nil
  counterDisplayRefresh(tracker,counterAdded)
end

local function removeFromCounters(ID)
  local freeTrackers=QNABackpacker.Counters.freeTrackers
  local usedTrackers=QNABackpacker.Counters.usedTrackers
  local itemData=QNABackpacker.Counters.itemData
  local counterAdded=false;
  QNABackpacker.Counters[ID].itemID = 0
  QNABackpacker.Counters[ID].icon = 005
  freeTrackers[ID]=ID
  usedTrackers[ID] = nil
  itemData[ID] = nil
  counterDisplayRefresh(ID,counterAdded)
end

local function TabSelector(viewNum)
  p(viewNum)
  p(EA_Window_Backpack.currentMode)
  if viewNum ~= EA_Window_Backpack.currentMode then
	EA_Window_Backpack.SetViewShowing( EA_Window_Backpack.currentMode, false )
	EA_Window_Backpack.SetViewShowing( viewNum, true )
  end
end




local function SearchTextSetter(text)
  local searchName=TextEditBoxGetText(searchWin)
  local empty=L""

  if searchName ~= text then
	TextEditBoxSetText(searchWin, text)
  else return
  TextEditBoxSetText(searchWin, empty)
  end
end

function table.removekey(typer, key)
  local keycut = typer[key]
  typer[key] = nil
  return keycut
end


function EA_Window_Backpack.OnCounterLButtonUp(flags)
  local ID=WindowGetId(SystemData.MouseOverWindow.name)
  local itemID=QNABackpacker.Counters[ID].itemID

  if itemID==0 then return end

  local itemData=QNABackpacker.Counters.itemData[ID]
  local itemName       = itemData.name
  local found, slot, bType = AllEquipFinder( itemID , 2 )
  local isCraftingItem = CraftingSystem.IsCraftingItem( itemData )
  local isCurrencyItem      = ( itemData.type == GameData.ItemTypes.CURRENCY )
  local canUseCrafting = CraftingSystem.PlayerMeetsCraftingRequirement( itemData )
  local canAdd, openType, isOpen = autoFinder(itemData)
  local showCrafting  = CraftingSystem.ToggleShowing

  -- adding one because I'm only looking through inventory, currency & crafting (quest inventory is index 1)
  local currentTab = EA_Window_Backpack.currentMode
  local tabNeeded  =  bType+1

  if not found then return end
  if flags==4 then
	if not isCraftingItem and not isCurrencyItem then
	  return EA_Window_Backpack.UseFirstInSlot(itemID)
	elseif isCraftingItem then
	  if not canUseCrafting and not canAdd then return end
	  if currentTab ~= tabNeeded then
		TabSelector(tabNeeded)
	  end
	  if not isOpen then
		showCrafting(openType)
	  end
	  return EA_Window_Backpack.AutoAddCraftingItemIfPossible( slot )
	end
  elseif ID~= nil then
	if currentTab ~= tabNeeded then
	  TabSelector(tabNeeded)
	end
	SearchTextSetter(itemName)
	p("text")
  end
end




function EA_Window_Backpack.OnCounterMouseOver()
  local activeWindow=SystemData.MouseOverWindow.name
  local ID=WindowGetId(activeWindow)
  local counters=QNABackpacker.Counters
  local trackerItemData=QNABackpacker.Counters.itemData[ID]

  if counters[ID].itemID == 0 then return end

  Tooltips.CreateItemTooltip( trackerItemData,
		  activeWindow,
		  Tooltips.ANCHOR_WINDOW_RIGHT,
		  Tooltips.ENABLE_COMPARISON,
		  actionText, textColor, false )

  local width,height = WindowGetDimensions("Root")
  local x,y = WindowGetScreenPosition(activeWindow)
  local anchor = nil
  if x*2 > width then
	anchor = { Point = "topleft",  RelativeTo = activeWindow, RelativePoint = "topright",   XOffset = -10, YOffset = 25 }
  else
	anchor = { Point = "topright",  RelativeTo = activeWindow, RelativePoint = "topleft",   XOffset = 10, YOffset = 25 }
  end
  Tooltips.AnchorTooltip( anchor )
end

if controlPressed then
  local text=TextEditBoxGetText(searchWin)
  if text~=itemData.name then
	TextEditBoxSetText(searchWin, itemData.name)
  elseif text==itemData.name then
	TextEditBoxSetText(searchWin, L"")
  end
  return
end




--[[local function FavoriteUpdate()
  for k,v in pairs(QNAItemSlots) do
  if not DoesWindowExist(k) then
    CreateWindowFromTemplate(favButton,"FavoriteBackpackButton", anchorName2)
    DynamicImageSetTexture(favButton, GetIconData(43))
    return end
end
end


function EA_Window_Backpack.FavoriteRefresher(itemName,favButton)
  p(itemName)
  p(favButton)
  if DataUtils.IsWorldLoading()==true then return end
  if next(QNAFavorites)==nil then return end
  --QNAItemSlots={}
  for k,v in pairs(QNAinventory) do
  for z,b in pairs(QNAFavorites) do
    if z~= nil then
      local slot=k
      local backpackType= EA_Window_Backpack.currentMode
      local pocket = EA_Window_Backpack.GetPocketNumberForSlot(backpackType, slot)
      local pocketName = EA_Window_Backpack.GetPocketName(pocket)
      local buttonIndex = slot - EA_Window_Backpack.pockets[pocket].firstSlotID  + 1
      local anchorName2 = pocketName.."ButtonsButton"..buttonIndex
      local favButton="FavoriteBackpackButton"..backpackType..slot
        if v.name==z and not DoesWindowExist(favButton) then
          CreateWindowFromTemplate(favButton,"FavoriteBackpackButton", anchorName2)
          DynamicImageSetTexture(favButton, GetIconData(43))
          QNAItemSlots[favButton]=tonumber(k)
        --  p("found")
         break
       elseif (v.name ~= z and DoesWindowExist(favButton)) then
          --  p(v.name)
          --  p(z)
            QNAItemSlots[favButton]=tonumber(k)
         break
          end
        end
      end
      end
      p(QNAItemSlots)
end


function EA_Window_Backpack.FavoriteButtons(favButton,slot,itemName,backpackType)
  local backpackType= EA_Window_Backpack.currentMode
  local pocket = EA_Window_Backpack.GetPocketNumberForSlot(backpackType, slot)
  local pocketName = EA_Window_Backpack.GetPocketName(pocket)
  local buttonIndex = slot - EA_Window_Backpack.pockets[pocket].firstSlotID  + 1
  local anchorName2 = pocketName.."ButtonsButton"..buttonIndex
  local favButton="FavoriteBackpackButton"..backpackType..slot

  if not DoesWindowExist(favButton) then
    if not QNAFavorites[itemName] then
      QNAFavorites[itemName]={["slot"]=slot,["type"]=backpackType}
      EA_Window_Backpack.FavoriteRefresher(itemName, favButton)
    else
      QNAFavorites[itemName]=nil
      EA_Window_Backpack.FavoriteRefresher(itemName, favButton)
  end
end
end]]






function EA_Window_Backpack.OnCounterRButtonUp()
  local ID=WindowGetId(SystemData.MouseOverWindow.name)
  if  QNABackpacker.Counters[ID].itemID ~= 0 then
	removeFromCounters(ID)
  end
end


if flags==12 then
  if not isTradeSkillItem then return end
  if backpackType==4 then
	location=GameData.ItemLocs.CRAFTING_ITEM
  elseif backpackType==2 then
	location=GameData.ItemLocs.INVENTORY
  end
  QNABackpacker.FearTheReaper["inventory"]=location;
  QNABackpacker.FearTheReaper["slot"]=slot;
  QNABackpacker.FearTheReaper["count"]=itemData.stackCount;
  QNABackpacker.FearTheReaper["status"] = true;
  RegisterEventHandler(327697, "EA_Window_Backpack.DontFearTheReaper")
  return
end

--[[ if flags==40 then
   local slotIsLocked, lockingWindow = EA_Window_Backpack.IsSlotLocked( slot, EA_Window_Backpack.currentMode )
   p(slotIsLocked)
   local windowName= EA_Window_Backpack.windowName
   local slotNum=slot
   if slotIsLocked then
	  EA_Window_Backpack.ReleaseLockForSlot(slotNum, backpackType, windowName)
	 p("locked")
   else
	 EA_Window_Backpack.RequestLockForSlot(slotNum, backpackType, windowName, highLightColor)
	 p("not locked")
   end
   return
 end]]

--[[if flags==36 then
  local itemName=itemData.name
  EA_Window_Backpack.FavoriteButtons(favButton,slot,itemName,backpackType)
  return
end]]

if( altPressed ) then
  local usedTrackers=QNABackpacker.Counters.usedTrackers
  local freeTrackers=QNABackpacker.Counters.freeTrackers

  if next(freeTrackers)== nil then return end
  if EA_Window_Backpack.FindInCounters(itemID) then return else
	local nextTracker=firstKey(freeTrackers)
	addToCounters(nextTracker, itemID, itemIcon)
  end
  return
end



if isBankOpen then
-- moveandstack (not EA)
BankWindow.moveandstack(itemData, slot, DataUtils.GetBankData (), cursorType, Cursor.SOURCE_BANK)
end
--RequestMoveItem( cursorType, slot, Cursor.SOURCE_BANK, GameData.Inventory.FIRST_AVAILABLE_BANK_SLOT, itemData.stackCount )
LabelSetFont("EA_Window_BackpackMoneyGoldText", "font_clear_small_bold",1)
LabelSetFont("EA_Window_BackpackMoneySilverText", "font_clear_small_bold",1)
LabelSetFont("EA_Window_BackpackMoneyBrassText", "font_clear_small_bold",1)
WindowSetShowing("EA_Window_BackpackTitleBar", false)


local function searchFocusToggleCallback()
  local focusStatus=QNABackpacker.FocusSearchByDefault
  if not focusStatus then
	QNABackpacker.FocusSearchByDefault=true;
  elseif focusStatus then
	QNABackpacker.FocusSearchByDefault=false;
  end
end


function EA_Window_Backpack.OnRButtonUp()
  local focusStatus=QNABackpacker.FocusSearchByDefault
  local craftText=L"Mass Craft\n(Warning: Will craft until main slot is empty.)"
  local isApothecaryWindowOpen =  WindowGetShowing(apoWindow)
  local isTalismanMakingWindowOpen =  WindowGetShowing(taliWindow)
  local buttonText=L"Search Focus: On"
  if not focusStatus then
	buttonText=L"Search Focus: Off"
  end
  EA_Window_ContextMenu.CreateDefaultContextMenu( EA_Window_Backpack.windowName )
  EA_Window_ContextMenu.AddMenuItem( buttonText, searchFocusToggleCallback, false, true, 1 )
  --[[  if isApothecaryWindowOpen or isTalismanMakingWindowOpen then
    EA_Window_ContextMenu.AddMenuItem( craftText, EA_Window_Backpack.CraftRegistrator, false, true, 1 )
    end]]
  EA_Window_ContextMenu.Finalize( 1 )
end



if not QNABackpacker then
  QNABackpacker={}
  QNABackpacker.Counters={[1]={["itemID"]=0,["icon"]=0,["color"]={}},
						  [2]={["itemID"]=0,["icon"]=0,["color"]={}},
						  [3]={["itemID"]=0,["icon"]=0,["color"]={}},
						  [4]={["itemID"]=0,["icon"]=0,["color"]={}},
						  [5]={["itemID"]=0,["icon"]=0,["color"]={}},
						  [6]={["itemID"]=0,["icon"]=0,["color"]={}},
						  [7]={["itemID"]=0,["icon"]=0,["color"]={}},
						  [8]={["itemID"]=0,["icon"]=0,["color"]={}},
						  [9]={["itemID"]=0,["icon"]=0,["color"]={}},
						  [10]={["itemID"]=0,["icon"]=0,["color"]={}}}
  QNABackpacker.Counters.usedTrackers={}
  QNABackpacker.Counters.freeTrackers={1,2,3,4,5,6,7,8,9,10}
  QNABackpacker.Counters.itemData={[1]=nil,[2]=nil,[3]=nil,[4]=nil,[5]=nil,[6]=nil,[7]=nil,[8]=nil,[9]=nil,[10]=nil}
  QNABackpacker.atStore=false;
  QNABackpacker.displayRefresh=false;
  QNABackpacker.FearTheReaper={["inventory"]=0, ["slot"]=0,["count"]=0}
  QNABackpacker.Favorites={}
  QNABackpacker.magicalCrafter={["status"]=false, ["apo"]=false,["tali"]=false}
  QNABackpacker.FocusSearchByDefault=false;
end


local function textClean (s)
  s = tostring(s)
  s = string.gsub(s,'[%(%)%.%%%+%-%*%?%[%]%^%$]', function(c) return '%'..c end)
  s = string.gsub(s, "%a", function (c)
	return string.format("[%s%s]", string.lower(c),
			string.upper(c))
  end)
  s = s:gsub("%s", "(.*)")
  return s
end



local function NameShort(text)
  text = tostring(text)
  text = string.sub(text, 1, 3)
  text = string.upper(text)
  return towstring(text)
end

local function GetMinVisibleBankSlot()
  return (BankWindow.currentTabNumber-1) * NUM_SLOTS_PER_TAB + 1
end

local function GetMaxVisibleBankSlot()
  return BankWindow.currentTabNumber * NUM_SLOTS_PER_TAB
end

local function percentage(percent,maxvalue)
  local percentage=nil
  percentage = ((percent - 1) * 100) / (maxvalue - 1)
  return percentage
end

local function CurrentBackpackSlots()
  local currentTab = EA_Window_Backpack.currentMode
  local visibleInventory = EA_Window_Backpack.GetItemsFromBackpack( currentTab )
  local freeSlotsCounter=0

  for i=1,#visibleInventory do
	if visibleInventory[i]["name"]~=L"" then
	  freeSlotsCounter=freeSlotsCounter+1
	end
  end
  LabelSetText(countLabel,L""..towstring(freeSlotsCounter)..L"/"..towstring(#visibleInventory))
  if percentage(freeSlotsCounter, #visibleInventory) <= 70 then
	LabelSetTextColor(countLabel,40,200,40)
  elseif percentage(freeSlotsCounter, #visibleInventory) <= 90  and percentage(freeSlotsCounter, #visibleInventory) >= 70 then
	LabelSetTextColor(countLabel,221,117,56)
  else
	LabelSetTextColor(countLabel,200,20,20)
  end
end



local function countersCounter(uniqueID)
  local amount=0
  if inventoryCount==nil then
	inventoryCount=GetFreshBackpack()
  end
  for k = 1, #inventoryCount do local bags = inventoryCount[ k ];
	for z = 1, #bags do
	  if bags[ z ].uniqueID == uniqueID then
		amount = amount + bags[ z ].stackCount
	  end
	end
  end
  return towstring(amount)
end

local function AllCounterRefresh()
  local counters=QNABackpacker.Counters
  local label="EA_Window_BackpackCounter"
  for i=1,#counters do
	local color=counters[i].color
	local amount=countersCounter(counters[i].itemID)
	if counters[i].itemID ~= 0 then
	  LabelSetTextColor(label..i.."Label", color.r, color.g, color.b)
	  DynamicImageSetTexture(label..i.."Icon",GetIconData(counters[i].icon),0,0)
	  LabelSetText(label..i.."Label", towstring(amount))
	end
  end
  inventoryCount=nil
end



function EA_Window_Backpack.CountersRefresh()
  AllCounterRefresh()
end


function EA_Window_Backpack.SearchFocusExtend()
  local window="BackpackSearcher"
  WindowAssignFocus(window, true)
end

function EA_Window_Backpack.CurrentSlotsCounter()
  CurrentBackpackSlots()
end



function EA_Window_Backpack.BankToggler()
  if BankWindow.IsShowing()==false then
	BankWindow.OpenBank()
  else
	BankWindow.Hide()
  end
end


function EA_Window_Backpack.DynamicCounterViewSet()
  local usedTrackers=QNABackpacker.Counters.usedTrackers

  if next(usedTrackers) == nil then
	WindowSetOffsetFromParent("EA_Window_BackpackTabs", 25, 70)
	EA_Window_Backpack.SEE_THROUGH_BOTTOM_SPACING = -20
  elseif #usedTrackers >= 1 and #usedTrackers <= 5 then
	WindowSetOffsetFromParent("EA_Window_BackpackTabs", 25, 100)
	EA_Window_Backpack.SEE_THROUGH_BOTTOM_SPACING = 25
  elseif #usedTrackers >= 6 then
	WindowSetOffsetFromParent("EA_Window_BackpackTabs", 25, 140)
	EA_Window_Backpack.SEE_THROUGH_BOTTOM_SPACING = 50
  end
  --EA_Window_Backpack.DisplayOverflowItem()
end
