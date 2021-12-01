--TODO:mgremix GATHERBUTTON buttonsetpresssedflag onupdate buttongetpressedflag


local function autoFinder(itemData)
  local isApothecaryItem = DataUtils.IsTradeSkillItem( itemData, GameData.TradeSkills.APOTHECARY )
  local isTalismanMakingItem = DataUtils.IsTradeSkillItem( itemData, GameData.TradeSkills.TALISMAN )
  local isCultivatingItem = DataUtils.IsTradeSkillItem( itemData, GameData.TradeSkills.CULTIVATION )
  local isApothecaryWindowOpen =  WindowGetShowing("ApothecaryWindow")
  local isTalismanMakingWindowOpen =  WindowGetShowing("TalismanMakingWindow")
  local isCultivatingWindowOpen =  WindowGetShowing("CultivationWindow")

  if isApothecaryItem then
	return ApothecaryWindow.WouldBePossibleToAdd( itemData), GameData.TradeSkills.APOTHECARY, isApothecaryWindowOpen
  elseif isTalismanMakingItem then
	return TalismanMakingWindow.WouldBePossibleToAdd( itemData ), GameData.TradeSkills.TALISMAN, isTalismanMakingWindowOpen
  elseif isCultivatingItem then
	return CultivationWindow.WouldBePossibleToAdd( itemData)  , GameData.TradeSkills.CULTIVATION, isCultivatingWindowOpen
  end
end


function EA_Window_Backpack.CraftRegistrator()
  local isApothecaryWindowOpen =  WindowGetShowing(apoWindow)
  local isTalismanMakingWindowOpen =  WindowGetShowing(taliWindow)
  local activeButton = SystemData.MouseOverWindow.name
  local apoButton  = activeButton:match(apoWindow)
  local taliButton = activeButton:match(taliWindow)
  p(apoButton)
  p(taliButton)
  if isApothecaryWindowOpen then
	QNABackpacker.magicalCrafter["status"]=true
	QNABackpacker.magicalCrafter["apo"]=true
	--add cache of current slots to stop execution when you run out of item from any slot
	--QNABackpacker.magicalCrafter["apoContainers"]=
	RegisterEventHandler(327697, "EA_Window_Backpack.MagicalCraftPerformer")
  elseif isTalismanMakingWindowOpen then
	QNABackpacker.magicalCrafter["status"]=true
	QNABackpacker.magicalCrafter["tali"]=true
	RegisterEventHandler(327697, "EA_Window_Backpack.MagicalCraftPerformer")
  else return end
end

local function MagicalPerformer(craftSkill, status)
  local taliSkill=GameData.TradeSkills.TALISMAN
  local apoSkill=GameData.TradeSkills.APOTHECARY

  if craftSkill==apoSkill then
	if not status then
	  PerformCrafting( craftSkill, 1 )
	else
	  QNABackpacker.magicalCrafter["apo"]=false;
	  QNABackpacker.magicalCrafter["status"]=false;
	  UnregisterEventHandler(327697, "EA_Window_Backpack.MagicalCraftPerformer")
	end
  elseif craftSkill==taliSkill then
	if not status then
	  PerformCrafting( taliSkill, 1 )
	else
	  QNABackpacker.magicalCrafter["tali"]=false;
	  QNABackpacker.magicalCrafter["status"]=false;
	  UnregisterEventHandler(327697, "EA_Window_Backpack.MagicalCraftPerformer")
	end
  end
end


function EA_Window_Backpack.MagicalCraftPerformer(timeElapsed)
  local craftStatus=QNABackpacker.magicalCrafter["status"]
  local apoStatus=QNABackpacker.magicalCrafter["apo"]
  local taliStatus= QNABackpacker.magicalCrafter["tali"]
  local taliSkill=GameData.TradeSkills.TALISMAN
  local apoSkill=GameData.TradeSkills.APOTHECARY

  if not craftStatus then return end

  craftCounter=craftCounter+timeElapsed
  if apoStatus then
	local apoButton=apoWindow.."CommitButton"
	local apoButtonStatus=ButtonGetDisabledFlag(apoButton)
	if craftCounter>craftDelay then
	  MagicalPerformer(apoSkill, apoButtonStatus)
	end
  elseif taliStatus then
	local taliButton=taliWindow.."CommitButton"
	local taliButtonStatus=ButtonGetDisabledFlag(taliButton)
	if craftCounter>craftDelay then
	  MagicalPerformer(taliSkill, taliButtonStatus)
	end
  end
end


function EA_Window_Backpack.DontFearTheReaper(timeElapsed)
  local reapLocation = QNABackpacker.FearTheReaper["inventory"]
  local reapSlot = QNABackpacker.FearTheReaper["slot"]
  local reapCount = QNABackpacker.FearTheReaper["count"]
  local reaperMan = QNABackpacker.FearTheReaper["status"]

  if not reaperMan then return end

  reapTimer=reapTimer+timeElapsed

  for i=1,reapCount do
	if reapTimer > reapDelay then
	  SendUseItem(reapLocation, reapSlot,0,0,0)
	  endTimer = endTimer+1
	  reapTimer=0
	end
  end
  if endTimer==reapCount then
	endTimer=0
	QNABackpacker.FearTheReaper["status"] = false;
	UnregisterEventHandler(327697, "EA_Window_Backpack.DontFearTheReaper")
  end
end


