warExtendedHealer = warExtended.Register("warExtended Healer")
local Healer = warExtendedHealer

Healer.Settings = {
  isEnabled = false;
}

function Healer.OnInitialize()
  Healer:RegisterEvent("interact show healer", "warExtendedHealer.OnInteractShowHealer")
end

function Healer.OnInteractShowHealer()
  if Healer.Settings.isEnabled then
	local cost = tostring(MoneyFrame.FormatMoneyString(EA_Window_InteractionHealer.costToRemoveSinglePenalty * EA_Window_InteractionHealer.penaltyCount))

	Healer:Print("Automatically healed "..EA_Window_InteractionHealer.penaltyCount.. " penalties for a total cost of "..cost..".")

	EA_Window_InteractionHealer.HealAllPenalties()
	return
  end

end
