warExtendedHealer = warExtended.Register("warExtended Healer")
local Healer = warExtendedHealer

Healer.Settings = {
  isEnabled = false;
}

local function onInteractShowHealer(penaltyCount, costToRemove)
  if Healer.Settings.isEnabled then
	local cost = MoneyFrame.FormatMoneyString(costToRemove * penaltyCount)
	Healer:Print("Automatically healed "..penaltyCount.. " penalties for a total cost of "..cost..".")
	
	EA_Window_InteractionHealer.HealAllPenalties()
  end
end

function Healer.OnInitialize()
  Healer:Hook(EA_Window_InteractionHealer.Show, onInteractShowHealer, true)
end