local warExtended = warExtended

local function GetFreshBackpack()
  local freshInventory=nil
  local inv=GetInventoryItemData()
  local curr=GetCurrencyItemData()
  local craft=GetCraftingItemData()
  freshInventory={inv,curr,craft}
  return freshInventory
end

local function GetFreshBackpackAndBank()
  local freshInventoryBank=nil
  local inv=GetInventoryItemData()
  local curr=GetCurrencyItemData()
  local craft=GetCraftingItemData()
  local bank=GetBankData()
  freshInventoryBank={inv,curr,craft,bank}
  return freshInventoryBank
end

local function GetAllInventory()
  local allInventory=nil
  local inv=GetInventoryItemData()
  local curr=GetCurrencyItemData()
  local craft=GetCraftingItemData()
  local bank=GetBankData()
  local equip=GetEquipmentData()
  allInventory={inv,curr,craft,bank,equip}
  return allInventory
end

local function firstKey(table)
  local firstKey = math.huge
  for key in pairs(table) do
	firstKey = math.min(key, firstKey)
  end
  return firstKey
end


local function AllEquipFinder( uniqueID , iType )
  local refresh = QNABackpacker.displayRefresh
  local values = false
  local bagType=0
  local slot=0
  local inventoryType=nil

  if iType==nil then
	return d("need to specify ID & inventoryType range")
  elseif iType==1 then
	if allInventory==nil or refresh then
	  inventoryType=GetAllInventory()
	  QNABackpacker.displayRefresh=false;
	end
  elseif iType==2 then
	if freshInventory==nil or refresh then
	  inventoryType=GetFreshBackpack()
	  QNABackpacker.displayRefresh=false;
	end
  elseif iType==3 then
	if freshInventoryBank==nil or refresh then
	  inventoryType=GetFreshBackpackAndBank()
	  QNABackpacker.displayRefresh=false;
	end
  end

  for k = 1, #inventoryType do local bags = inventoryType[ k ];
	for z = 1, #bags do
	  if bags[ z ].uniqueID == uniqueID then
		bagType=k
		slot=z
		values = true
		return values, slot, bagType
	  end
	end
  end
  return values, slot, bagType
end



local function AllEquipFinder( uniqueID , iType )
  local refresh = QNABackpacker.displayRefresh
  local values = false
  local bagType=0
  local slot=0
  local inventoryType=nil

  if iType==nil then
	return d("need to specify ID & inventoryType range")
  elseif iType==1 then
	if allInventory==nil or refresh then
	  inventoryType=GetAllInventory()
	  QNABackpacker.displayRefresh=false;
	end
  elseif iType==2 then
	if freshInventory==nil or refresh then
	  inventoryType=GetFreshBackpack()
	  QNABackpacker.displayRefresh=false;
	end
  elseif iType==3 then
	if freshInventoryBank==nil or refresh then
	  inventoryType=GetFreshBackpackAndBank()
	  QNABackpacker.displayRefresh=false;
	end
  end

  for k = 1, #inventoryType do local bags = inventoryType[ k ];
	for z = 1, #bags do
	  if bags[ z ].uniqueID == uniqueID then
		bagType=k
		slot=z
		values = true
		return values, slot, bagType
	  end
	end
  end
  return values, slot, bagType
end


function EA_Window_Backpack.AllEquipCounter( uniqueID , iType)
  local refresh=QNABackpacker.displayRefresh
  local amount=0
  local inventoryType=nil

  if iType==nil then
	return d("need to specify ID & inventoryType range")
  elseif iType==1 then
	if allInventory==nil or refresh then
	  inventoryType=GetAllInventory()
	  QNABackpacker.displayRefresh=false;
	end
  elseif iType==2 then
	if freshInventory==nil or refresh then
	  inventoryType=GetFreshBackpack()
	  QNABackpacker.displayRefresh=false;
	end
  elseif iType==3 then
	if freshInventoryBank==nil or refresh then
	  inventoryType=GetFreshBackpackAndBank()
	  QNABackpacker.displayRefresh=false;
	end
  end

  for k = 1, #inventoryType do local bags = inventoryType[ k ];
	for z = 1, #bags do
	  if bags[ z ].uniqueID == uniqueID then
		amount = amount + bags[ z ].stackCount
	  end
	end
  end
  return amount
end


function EA_Window_Backpack.ReportFreshBags(type)
  if type==1 then
	return GetAllInventory()
  elseif type==2 then
	return GetFreshBackpack()
  elseif type==3 then
	return GetFreshBackpackAndBank()
  end
end


function EA_Window_Backpack.UseFirstInSlot(uniqueID)
  local found, slot, bType = AllEquipFinder( uniqueID , 2 )
  if bType==1 then
	bType=3
  elseif bType==2 then
	bType=31
  elseif bType==3 then
	bType=30
  end
  return SendUseItem(bType,slot,0,0,0)
end
