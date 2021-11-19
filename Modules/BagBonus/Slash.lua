local BagBonus = warExtendedBagBonus

local slashCommands = {
  bag = {
	func = BagBonus.ToggleBagBonusWindow,
	desc = "Toggle Bag Roll Bonus Window."
  }
}

function BagBonus.RegisterSlashCommand()
  BagBonus:RegisterSlash(slashCommands, "warext")
end